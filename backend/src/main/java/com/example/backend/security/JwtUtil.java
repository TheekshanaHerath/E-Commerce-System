package com.example.backend.security;

import com.example.backend.exception.AuthException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

public class JwtUtil {

    private static final String SECRET = "my-super-secret-key-change-in-env-my-super-secret-key";

    private static final Key key = Keys.hmacShaKeyFor(SECRET.getBytes());

    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000;

    public static String generateToken(String email, String role) {
        return Jwts.builder()
                .setSubject(email)
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public static String generateRefreshToken(String email) {
        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 7L * 24 * 60 * 60 * 1000))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public static Claims validateAndGetClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

        } catch (ExpiredJwtException e) {
            throw new AuthException("Token expired", "TOKEN_EXPIRED");

        } catch (MalformedJwtException e) {
            throw new AuthException("Invalid token", "INVALID_TOKEN");

        } catch (Exception e) {
            throw new AuthException("Token error", "TOKEN_ERROR");
        }
    }
}