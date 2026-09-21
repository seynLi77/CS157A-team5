package com.lockedin.dao;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
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

            InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");

            properties.load(input);

            URL = properties.getProperty("db.url");
            USERNAME = properties.getProperty("db.user");
            PASSWORD = properties.getProperty("db.password");

        } catch (Exception e) {
            throw new RuntimeException("Failed to load database configuration", e);
        }
    }

    /**
     * Creates a database connection using the credentials from db.properties.
     *
     * @return a connection to the configured database
     * @throws Exception if the database driver cannot establish a connection
     */
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}