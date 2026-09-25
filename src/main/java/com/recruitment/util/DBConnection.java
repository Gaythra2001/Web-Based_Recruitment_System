package com.recruitment.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Utility class for managing database connections using JDBC.
 * Reads connection settings from db.properties in the classpath.
 */
public class DBConnection {

    private static String url;
    private static String username;
    private static String password;
    private static String driver;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                url = props.getProperty("db.url");
                username = props.getProperty("db.username", "root");
                password = props.getProperty("db.password", "");
                driver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
            } else {
                url = "jdbc:mysql://localhost:3306/recruitment_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8";
                username = "root";
                password = "";
                driver = "com.mysql.cj.jdbc.Driver";
            }
            Class.forName(driver);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load database configuration or driver.", e);
        }
    }

    /**
     * Obtains a new database connection with automatic fallback for local root passwords.
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(url, username, password != null ? password : "");
        } catch (SQLException e) {
            // If authentication failed with password, try empty password fallback (common in XAMPP)
            if (password != null && !password.isEmpty()) {
                try {
                    return DriverManager.getConnection(url, username, "");
                } catch (SQLException ignored) {}
            }
            // If authentication failed with empty, try "root"
            if (password == null || password.isEmpty()) {
                try {
                    return DriverManager.getConnection(url, username, "root");
                } catch (SQLException ignored) {}
            }
            throw e;
        }
    }

    /**
     * Closes AutoCloseable resources safely.
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {}
            }
        }
    }
}
