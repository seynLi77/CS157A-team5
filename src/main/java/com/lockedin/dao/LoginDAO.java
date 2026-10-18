package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.lockedin.util.DBConnection;

/**
 * Provides data-access operations for log in.
 *
 * @author Elaine
 */
public class LoginDAO {

    public boolean validateUser(String email, String password) {

		String sql =
				"SELECT * " +
				"FROM user " +
				"WHERE email = ? " +
				"AND password = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(1, email);
            statement.setString(2, password);

            ResultSet resultSet = statement.executeQuery();

            return resultSet.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
