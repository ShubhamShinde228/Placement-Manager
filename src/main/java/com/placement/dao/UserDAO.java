package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.placement.model.User;
import com.placement.util.DBConnection;

public class UserDAO {

    public User login(String username, String password) {

        User user = null;

        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                user = new User();

                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }

        } catch (Exception e) {
            // Print full cause so Tomcat logs show the real error
            System.err.println("=== LOGIN ERROR ===");
            System.err.println("Cause: " + e.getClass().getSimpleName() + " — " + e.getMessage());
            e.printStackTrace();
        }

        return user;
    }
}