package com.example.backend.service;

import com.example.backend.dto.ApiResponse;
import com.example.backend.dto.AuthResponse;
import com.example.backend.dto.RegisterRequest;
import com.example.backend.entity.RefreshToken;
import com.example.backend.entity.Role;
import com.example.backend.entity.User;
import com.example.backend.exception.AuthException;
import com.example.backend.repository.RefreshTokenRepository;
import com.example.backend.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private RefreshTokenRepository refreshTokenRepository;

    @InjectMocks
    private AuthService authService;

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    // =========================
    // 1. REGISTER SUCCESS
    // =========================
    @Test
    void register_success() {

        RegisterRequest request = new RegisterRequest();
        request.setEmail("test@gmail.com");
        request.setName("Test");
        request.setPassword("123456");

        when(userRepository.findByEmail("test@gmail.com"))
                .thenReturn(Optional.empty());

        ApiResponse<String> response = authService.register(request);

        assertTrue(response.isSuccess());
        assertEquals("AUTH_REGISTER_SUCCESS", response.getCode());
    }

    // =========================
    // 2. REGISTER FAIL
    // =========================
    @Test
    void register_should_fail_when_email_exists() {

        RegisterRequest request = new RegisterRequest();
        request.setEmail("test@gmail.com");
        request.setName("Test");
        request.setPassword("123456");

        User existingUser = new User();
        existingUser.setEmail("test@gmail.com");

        when(userRepository.findByEmail("test@gmail.com"))
                .thenReturn(Optional.of(existingUser));

        assertThrows(AuthException.class, () -> authService.register(request));
    }

    // =========================
    // 3. LOGIN SUCCESS
    // =========================
    @Test
    void login_success() {

        User user = new User();
        user.setUserId(1);
        user.setEmail("test@gmail.com");
        user.setPassword(encoder.encode("123456"));
        user.setRole(Role.USER);

        when(userRepository.findByEmail("test@gmail.com"))
                .thenReturn(Optional.of(user));

        ApiResponse<AuthResponse> response =
                authService.login("test@gmail.com", "123456");

        assertTrue(response.isSuccess());
        assertEquals("AUTH_LOGIN_SUCCESS", response.getCode());
        assertNotNull(response.getData().getAccessToken());
    }

    // =========================
    // 4. LOGIN FAIL
    // =========================
    @Test
    void login_should_fail_wrong_password() {

        User user = new User();
        user.setEmail("test@gmail.com");
        user.setPassword(encoder.encode("123456"));
        user.setRole(Role.USER);

        when(userRepository.findByEmail("test@gmail.com"))
                .thenReturn(Optional.of(user));

        assertThrows(AuthException.class,
                () -> authService.login("test@gmail.com", "wrong"));
    }

    // =========================
    // 5. REFRESH SUCCESS
    // =========================
    @Test
    void refresh_success() {

        String token = "valid_token";

        User user = new User();
        user.setEmail("test@gmail.com");
        user.setRole(Role.USER);

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setToken(token);
        refreshToken.setEmail("test@gmail.com");
        refreshToken.setExpiryDate(LocalDateTime.now().plusDays(1));

        // ✅ FIX 1: mock refresh token lookup
        when(refreshTokenRepository.findByToken(token))
                .thenReturn(Optional.of(refreshToken));

        // ✅ FIX 2: mock user lookup (THIS WAS MISSING)
        when(userRepository.findByEmail("test@gmail.com"))
                .thenReturn(Optional.of(user));

        ApiResponse<AuthResponse> response =
                authService.refresh(token);

        assertTrue(response.isSuccess());
        assertEquals("TOKEN_REFRESH_SUCCESS", response.getCode());
        assertNotNull(response.getData().getAccessToken());
    }

    // =========================
    // 6. REFRESH FAIL
    // =========================
    @Test
    void refresh_should_fail_invalid_token() {

        when(refreshTokenRepository.findByToken("invalid_token"))
                .thenReturn(Optional.empty());

        assertThrows(AuthException.class,
                () -> authService.refresh("invalid_token"));
    }
}