package com.lockedin.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Loads database settings and creates connections to the application's database.
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
                            "db.properties was not found in src/main/resources"
                    );
                }

                properties.load(input);
            }

            URL = properties.getProperty("db.url");
            USERNAME = properties.getProperty("db.user");
            PASSWORD = properties.getProperty("db.password");

        } catch (Exception e) {
            throw new RuntimeException(
                    "Failed to load database configuration", e
            );
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
