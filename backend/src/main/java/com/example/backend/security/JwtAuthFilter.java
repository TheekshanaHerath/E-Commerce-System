package com.example.backend.security;

import com.example.backend.entity.TokenBlacklist;
import com.example.backend.exception.AuthException;
import com.example.backend.repository.TokenBlacklistRepository;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final TokenBlacklistRepository blacklistRepository;

    public JwtAuthFilter(TokenBlacklistRepository blacklistRepository) {
        this.blacklistRepository = blacklistRepository;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {

            // ❌ BLOCK BLACKLISTED TOKEN (DO NOT THROW EXCEPTION)
            if (blacklistRepository.existsByToken(token)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("""
                        {
                          "success": false,
                          "message": "Token revoked",
                          "code": "TOKEN_REVOKED",
                          "data": null
                        }
                        """);
                return;
            }

            Claims claims = JwtUtil.validateAndGetClaims(token);

            String email = claims.getSubject();
            String role = claims.get("role", String.class);

            var authorities = List.of(
                    new SimpleGrantedAuthority("ROLE_" + role)
            );

            var auth = new UsernamePasswordAuthenticationToken(
                    email,
                    null,
                    authorities
            );

            SecurityContextHolder.getContext().setAuthentication(auth);

        } catch (Exception e) {
            SecurityContextHolder.clearContext();
            // DO NOT throw → just continue (unauthenticated request)
        }

        filterChain.doFilter(request, response);
    }
}