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

    private static final String URL      = "jdbc:mysql://localhost:3306/placement_manager";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "shubham@1234";

    /**
     * Returns a new JDBC connection.
     * Always use try-with-resources to ensure it is closed properly.
     */
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}