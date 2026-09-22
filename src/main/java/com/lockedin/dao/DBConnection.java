package com.lockedin.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Loads database settings and creates connections to the application's
 * database.
 *
 * @author Elaine
 */
public class DBConnection {

    private static final String URL;
    private static final String USERNAME;
    private static final String PASSWORD;

    static {
        try {
            Properties properties = new Properties();

            try (InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties")) {

                if (input == null) {
                    throw new RuntimeException(
                            "db.properties was not found in src/main/resources");
                }

                properties.load(input);
            }

            URL = properties.getProperty("db.url");
            USERNAME = properties.getProperty("db.user");
            PASSWORD = properties.getProperty("db.password");

        } catch (Exception e) {
            throw new RuntimeException(
                    "Failed to load database configuration", e);
        }
    }

    /**
     * Opens a connection to the configured MySQL database.
     *
     * @return a new database connection
     * @throws SQLException if the JDBC driver cannot be loaded or the
     *                      connection cannot be established
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
