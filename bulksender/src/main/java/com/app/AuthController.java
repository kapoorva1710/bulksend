package com.app;

import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class AuthController {

    @PostMapping("/login")
    public String login(@RequestBody User user) {
        if (user.getEmail().equals("admin@gmail.com") &&
            user.getPassword().equals("1234")) {
            return "Login successful";
        } else {
            return "Invalid credentials";
        }
    }
}
