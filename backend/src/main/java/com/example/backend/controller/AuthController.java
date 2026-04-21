package com.example.backend.controller;

import com.example.backend.dto.ApiResponse;
import com.example.backend.dto.AuthResponse;
import com.example.backend.dto.LoginRequest;
import com.example.backend.dto.RegisterRequest;
import com.example.backend.service.AuthService;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ApiResponse<String> register(@RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@RequestBody LoginRequest request) {
        return authService.login(request.getEmail(), request.getPassword());
    }
    @PostMapping("/refresh")
    public ApiResponse<AuthResponse> refresh(@RequestBody Map<String, String> request) {
        return authService.refresh(request.get("refreshToken"));
    }

    @PostMapping("/logout")
    public ApiResponse<String> logout(@RequestBody Map<String, String> request) {
        return authService.logout(request.get("accessToken"));
    }

}
