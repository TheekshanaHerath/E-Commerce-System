package com.example.backend.exception;

import com.example.backend.dto.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // 🔐 Custom AuthException
    @ExceptionHandler(AuthException.class)
    public ResponseEntity<ApiResponse<Object>> handleAuthException(AuthException ex) {

        HttpStatus status;

        switch (ex.getCode()) {

            case "EMAIL_EXISTS":
                status = HttpStatus.CONFLICT; // 409
                break;

            case "INVALID_CREDENTIALS":
                status = HttpStatus.UNAUTHORIZED; // 401
                break;

            case "TOKEN_EXPIRED":
                status = HttpStatus.UNAUTHORIZED; // 401
                break;

            case "INVALID_TOKEN":
                status = HttpStatus.UNAUTHORIZED; // 401
                break;

            case "FORBIDDEN":
                status = HttpStatus.FORBIDDEN; // 403
                break;

            default:
                status = HttpStatus.BAD_REQUEST; // 400
        }

        ApiResponse<Object> response = new ApiResponse<>(
                false,
                ex.getMessage(),
                ex.getCode(),
                null
        );

        return ResponseEntity.status(status).body(response);
    }

    // 🔒 Spring Security - Unauthorized (401)
    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiResponse<Object>> handleAuthenticationException(AuthenticationException ex) {

        ApiResponse<Object> response = new ApiResponse<>(
                false,
                "Unauthorized",
                "UNAUTHORIZED",
                null
        );

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
    }

    // 🔒 Spring Security - Forbidden (403)
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiResponse<Object>> handleAccessDeniedException(AccessDeniedException ex) {

        ApiResponse<Object> response = new ApiResponse<>(
                false,
                "Access Denied",
                "FORBIDDEN",
                null
        );

        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }

    // ⚠️ All other errors
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Object>> handleGeneralException(Exception ex) {

        ex.printStackTrace(); // later replace with logger

        ApiResponse<Object> response = new ApiResponse<>(
                false,
                "Internal Server Error",
                "INTERNAL_SERVER_ERROR",
                null
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}