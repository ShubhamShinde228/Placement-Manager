package com.placement.util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Provides a JDBC connection to the local MySQL database.
 * 
 * Database: placement_manager (local MySQL)
 * Host:     localhost:3306
 */
public class DBConnection {

    private static String getDbUrl() {
        String env = System.getenv("DB_URL");
        return (env != null && !env.isBlank()) ? env : "jdbc:mysql://localhost:3306/placement_manager";
    }

    private static String getDbUsername() {
        String env = System.getenv("DB_USERNAME");
        return (env != null && !env.isBlank()) ? env : "root";
    }

    private static String getDbPassword() {
        String env = System.getenv("DB_PASSWORD");
        return (env != null && !env.isBlank()) ? env : "shubham@1234";
    }

    /**
     * Returns a new JDBC connection.
     * Always use try-with-resources to ensure it is closed properly.
     */
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(getDbUrl(), getDbUsername(), getDbPassword());
    }
}