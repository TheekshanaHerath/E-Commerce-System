package com.example.backend.dto;

public class AuthResponse {
    private String accessToken;
    private String refreshToken;
    private UserInfo user;



    public AuthResponse(String accessToken, String refreshToken, UserInfo user) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.user = user;
    }

    public static class UserInfo{
        private int id;
        private String email;
        private String name;

        public UserInfo(int id, String email, String name) {
            this.id = id;
            this.email = email;
            this.name = name;
        }
        //getters & setters


        public int getId() {
            return id;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }
    }
    //getters


    public String getAccessToken() {
        return accessToken;
    }
    public String getRefreshToken() {
        return refreshToken;
    }

    public UserInfo getUser() {
        return user;
    }
}
