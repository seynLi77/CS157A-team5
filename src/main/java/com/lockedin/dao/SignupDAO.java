package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.lockedin.util.DBConnection;

/**
 * Provides data-access operations for sign up.
 *
 * @author Elaine
 */
public class SignupDAO {

    /*
     * Returns:
     * null = signup successful
     * String = error message
     */
    public String createUser(
            String firstName,
            String lastName,
            String email,
            String password,
            String role,
            String location,
            String resume,
            String experience,
            String education,
            String company,
            String industry,
            String[] skillIds) {

        String userSql =
                "INSERT INTO `user` " +
                "(first_name, last_name, email, password) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection connection =
                     DBConnection.getConnection()) {

            connection.setAutoCommit(false);

            try {
                int userId;

                /*
                 * Insert basic user information.
                 */
                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     userSql,
                                     Statement.RETURN_GENERATED_KEYS)) {

                    statement.setString(1, firstName);
                    statement.setString(2, lastName);
                    statement.setString(3, email);
                    statement.setString(4, password);

                    statement.executeUpdate();

                    try (ResultSet keys =
                                 statement.getGeneratedKeys()) {

                        if (!keys.next()) {
                            connection.rollback();
                            return "Could not generate user ID.";
                        }

                        userId = keys.getInt(1);
                    }
                }

                /*
                 * Insert role-specific information.
                 */
                if ("job_seeker".equals(role)) {

                    insertJobSeeker(
                            connection,
                            userId,
                            location,
                            resume,
                            experience,
                            education
                    );

                    insertSkills(
                            connection,
                            userId,
                            skillIds
                    );

                } else if ("recruiter".equals(role)) {

                    insertRecruiter(
                            connection,
                            userId,
                            company,
                            industry
                    );

                } else if ("admin".equals(role)) {

                    insertAdmin(
                            connection,
                            userId
                    );

                } else {
                    connection.rollback();
                    return "Invalid role selected: " + role;
                }

                connection.commit();

                // null means successful signup
                return null;

            } catch (Exception e) {

                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }

                e.printStackTrace();

                return getErrorMessage(e);
            }

        } catch (SQLException e) {

            e.printStackTrace();

            return getErrorMessage(e);
        }
    }

    private void insertJobSeeker(
            Connection connection,
            int userId,
            String location,
            String resume,
            String experience,
            String education)
            throws SQLException {

        String sql =
                "INSERT INTO job_seeker " +
                "(user_id, location, resume_link, " +
                "experience, education) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setString(2, location);
            statement.setString(3, resume);
            statement.setString(4, experience);
            statement.setString(5, education);

            statement.executeUpdate();
        }
    }

    private void insertRecruiter(
            Connection connection,
            int userId,
            String company,
            String industry)
            throws SQLException {

        String sql =
                "INSERT INTO recruiter " +
                "(user_id, company, industry) " +
                "VALUES (?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setString(2, company);
            statement.setString(3, industry);

            statement.executeUpdate();
        }
    }

    private void insertAdmin(
            Connection connection,
            int userId)
            throws SQLException {

        String sql =
                "INSERT INTO admin (user_id) " +
                "VALUES (?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            statement.executeUpdate();
        }
    }

    private void insertSkills(
            Connection connection,
            int userId,
            String[] skillIds)
            throws SQLException {

        if (skillIds == null || skillIds.length == 0) {
            return;
        }

        String sql =
                "INSERT INTO job_seeker_skill " +
                "(job_seeker_id, skill_id) " +
                "VALUES (?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            for (String skillId : skillIds) {

                statement.setInt(
                        1,
                        userId
                );

                statement.setInt(
                        2,
                        Integer.parseInt(skillId)
                );

                statement.addBatch();
            }

            statement.executeBatch();
        }
    }

    private String getErrorMessage(Exception e) {

        Throwable cause = e;

        while (cause != null) {

            if (cause instanceof SQLException) {

                SQLException sqlException =
                        (SQLException) cause;

                int errorCode =
                        sqlException.getErrorCode();

                if (errorCode == 1062) {
                    return "This email is already registered.";
                }

                if (errorCode == 1054) {
                    return "Unknown column: "
                            + sqlException.getMessage();
                }

                if (errorCode == 1146) {
                    return "Table does not exist: "
                            + sqlException.getMessage();
                }

                if (errorCode == 1452) {
                    return "Foreign key constraint failed: "
                            + sqlException.getMessage();
                }

                if (errorCode == 1364) {
                    return "A required field is missing: "
                            + sqlException.getMessage();
                }

                return "SQL error: "
                        + sqlException.getMessage();
            }

            cause = cause.getCause();
        }

        return "Unexpected error: " + e.getMessage();
    }
}