package com.example.backend.service;

import com.example.backend.dto.ApiResponse;
import com.example.backend.dto.AuthResponse;
import com.example.backend.dto.RegisterRequest;
import com.example.backend.entity.RefreshToken;
import com.example.backend.entity.Role;
import com.example.backend.entity.TokenBlacklist;
import com.example.backend.entity.User;
import com.example.backend.exception.AuthException;
import com.example.backend.repository.RefreshTokenRepository;
import com.example.backend.repository.TokenBlacklistRepository;
import com.example.backend.repository.UserRepository;
import com.example.backend.security.JwtUtil;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private final TokenBlacklistRepository blacklistRepository;
    private final TokenBlacklistRepository tokenBlacklistRepository;

    public AuthService(UserRepository userRepository,
                       RefreshTokenRepository refreshTokenRepository,
                       TokenBlacklistRepository tokenBlacklistRepository, TokenBlacklistRepository blacklistRepository, TokenBlacklistRepository tokenBlacklistRepository1) {
        this.userRepository = userRepository;
        this.refreshTokenRepository = refreshTokenRepository;
        this.blacklistRepository = blacklistRepository;
        this.tokenBlacklistRepository = tokenBlacklistRepository1;
    }

    // =========================
    // REGISTER
    // =========================
    public ApiResponse<String> register(RegisterRequest request) {

        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            throw new AuthException("Email already registered", "EMAIL_EXISTS");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(Role.USER);

        userRepository.save(user);

        return new ApiResponse<>(
                true,
                "User registered successfully",
                "AUTH_REGISTER_SUCCESS",
                null
        );
    }

    // =========================
    // LOGIN
    // =========================
    public ApiResponse<AuthResponse> login(String email, String password) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new AuthException("Invalid credentials", "INVALID_CREDENTIALS"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new AuthException("Invalid credentials", "INVALID_CREDENTIALS");
        }

        // 🔐 ACCESS TOKEN
        String accessToken = JwtUtil.generateToken(
                user.getEmail(),
                user.getRole().name()
        );

        // 🔐 REFRESH TOKEN
        String refreshToken = JwtUtil.generateRefreshToken(user.getEmail());

        // 💾 SAVE REFRESH TOKEN (IMPORTANT - REAL WORLD)
        RefreshToken refreshTokenEntity = new RefreshToken();
        refreshTokenEntity.setToken(refreshToken);
        refreshTokenEntity.setEmail(user.getEmail());
        refreshTokenEntity.setExpiryDate(LocalDateTime.now().plusDays(7));

        refreshTokenRepository.save(refreshTokenEntity);

        AuthResponse.UserInfo userInfo =
                new AuthResponse.UserInfo(
                        user.getUserId(),
                        user.getEmail(),
                        user.getName()
                );

        AuthResponse authResponse =
                new AuthResponse(accessToken, refreshToken, userInfo);

        return new ApiResponse<>(
                true,
                "Login successful",
                "AUTH_LOGIN_SUCCESS",
                authResponse
        );
    }

    // =========================
    // REFRESH TOKEN
    // =========================
    public ApiResponse<AuthResponse> refresh(String refreshToken) {

        if (refreshToken == null || refreshToken.isEmpty()) {
            throw new AuthException("Refresh token is required", "REFRESH_REQUIRED");
        }


        RefreshToken storedToken = refreshTokenRepository.findByToken(refreshToken)
                .orElseThrow(() ->
                        new AuthException("Invalid refresh token", "INVALID_TOKEN")
                );


        if (storedToken.getExpiryDate().isBefore(LocalDateTime.now())) {
            throw new AuthException("Refresh token expired", "TOKEN_EXPIRED");
        }


        User user = userRepository.findByEmail(storedToken.getEmail())
                .orElseThrow(() -> new AuthException("User not found", "USER_NOT_FOUND"));


        String newAccessToken = JwtUtil.generateToken(
                user.getEmail(),
                user.getRole().name()
        );

        AuthResponse response =
                new AuthResponse(newAccessToken, refreshToken, null);

        return new ApiResponse<>(
                true,
                "Token refreshed",
                "TOKEN_REFRESH_SUCCESS",
                response
        );
    }
    public ApiResponse<String> logout(String accessToken) {

        if (accessToken == null || accessToken.isEmpty()) {
            throw new AuthException("Token required", "TOKEN_REQUIRED");
        }

        TokenBlacklist blacklist = new TokenBlacklist();
        blacklist.setToken(accessToken);
        blacklist.setExpiredAt(LocalDateTime.now());

        tokenBlacklistRepository.save(blacklist);

        return new ApiResponse<>(
                true,
                "Logged out successfully",
                "LOGOUT_SUCCESS",
                null
        );
    }

}