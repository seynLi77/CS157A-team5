package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.lockedin.util.DBConnection;

/**
 * Provides data-access operations for profile page.
 *
 * @author Elaine
 */

public class ProfileDAO {

    public Map<String, Object> findProfileByEmail(
            String email)
            throws SQLException {

        String sql =
                "SELECT " +
                "u.user_id, " +
                "u.first_name, " +
                "u.last_name, " +
                "u.email, " +
                "CASE " +
                "WHEN js.user_id IS NOT NULL " +
                "THEN 'job_seeker' " +
                "WHEN r.user_id IS NOT NULL " +
                "THEN 'recruiter' " +
                "WHEN a.user_id IS NOT NULL " +
                "THEN 'admin' " +
                "END AS role, " +
                "js.location, " +
                "js.resume_link, " +
                "js.experience, " +
                "js.education, " +
                "r.company, " +
                "r.industry " +
                "FROM `user` u " +
                "LEFT JOIN job_seeker js " +
                "ON u.user_id = js.user_id " +
                "LEFT JOIN recruiter r " +
                "ON u.user_id = r.user_id " +
                "LEFT JOIN admin a " +
                "ON u.user_id = a.user_id " +
                "WHERE u.email = ?";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(1, email);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                if (!resultSet.next()) {
                    return null;
                }

                Map<String, Object> profile =
                        new HashMap<>();

                profile.put(
                        "user_id",
                        resultSet.getInt("user_id")
                );

                profile.put(
                        "first_name",
                        resultSet.getString("first_name")
                );

                profile.put(
                        "last_name",
                        resultSet.getString("last_name")
                );

                profile.put(
                        "email",
                        resultSet.getString("email")
                );

                profile.put(
                        "role",
                        resultSet.getString("role")
                );

                profile.put(
                        "location",
                        resultSet.getString("location")
                );

                profile.put(
                        "resume_link",
                        resultSet.getString("resume_link")
                );

                profile.put(
                        "experience",
                        resultSet.getString("experience")
                );

                profile.put(
                        "education",
                        resultSet.getString("education")
                );

                profile.put(
                        "company",
                        resultSet.getString("company")
                );

                profile.put(
                        "industry",
                        resultSet.getString("industry")
                );

                return profile;
            }
        }
    }

    public List<Map<String, Object>> getAllSkills()
            throws SQLException {

        String sql =
                "SELECT skill_id, name " +
                "FROM skill " +
                "ORDER BY name";

        List<Map<String, Object>> skills =
                new ArrayList<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql);

            ResultSet resultSet =
                    statement.executeQuery()
        ) {
            while (resultSet.next()) {

                Map<String, Object> skill =
                        new HashMap<>();

                skill.put(
                        "skill_id",
                        resultSet.getInt("skill_id")
                );

                skill.put(
                        "name",
                        resultSet.getString("name")
                );

                skills.add(skill);
            }
        }

        return skills;
    }

    public Set<Integer> getSelectedSkillIds(
            int userId)
            throws SQLException {

        String sql =
                "SELECT skill_id " +
                "FROM job_seeker_skill " +
                "WHERE job_seeker_id = ?";

        Set<Integer> selectedSkillIds =
                new HashSet<>();

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setInt(1, userId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {
                    selectedSkillIds.add(
                            resultSet.getInt("skill_id")
                    );
                }
            }
        }

        return selectedSkillIds;
    }

    public String updateProfile(
            String email,
            String firstName,
            String lastName,
            String password,
            String location,
            String resumeLink,
            String experience,
            String education,
            String company,
            String industry,
            String[] skillIds) {

        try {
            Map<String, Object> profile =
                    findProfileByEmail(email);

            if (profile == null) {
                return "User profile was not found.";
            }

            int userId =
                    (Integer) profile.get("user_id");

            String role =
                    (String) profile.get("role");

            try (Connection connection =
                         DBConnection.getConnection()) {

                connection.setAutoCommit(false);

                try {
                    updateBasicUserInformation(
                            connection,
                            email,
                            firstName,
                            lastName
                    );

                    if (password != null &&
                            !password.trim().isEmpty()) {

                        updatePassword(
                                connection,
                                email,
                                password
                        );
                    }

                    if ("job_seeker".equals(role)) {

                        updateJobSeeker(
                                connection,
                                userId,
                                location,
                                resumeLink,
                                experience,
                                education
                        );

                        updateJobSeekerSkills(
                                connection,
                                userId,
                                skillIds
                        );

                    } else if ("recruiter".equals(role)) {

                        updateRecruiter(
                                connection,
                                userId,
                                company,
                                industry
                        );
                    }

                    connection.commit();

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
            }

        } catch (Exception e) {
            e.printStackTrace();
            return getErrorMessage(e);
        }
    }

    private void updateBasicUserInformation(
            Connection connection,
            String email,
            String firstName,
            String lastName)
            throws SQLException {

        String sql =
                "UPDATE `user` " +
                "SET first_name = ?, " +
                "last_name = ? " +
                "WHERE email = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, firstName);
            statement.setString(2, lastName);
            statement.setString(3, email);

            statement.executeUpdate();
        }
    }

    private void updatePassword(
            Connection connection,
            String email,
            String password)
            throws SQLException {

        String sql =
                "UPDATE `user` " +
                "SET password = ? " +
                "WHERE email = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, password);
            statement.setString(2, email);

            statement.executeUpdate();
        }
    }

    private void updateJobSeeker(
            Connection connection,
            int userId,
            String location,
            String resumeLink,
            String experience,
            String education)
            throws SQLException {

        String sql =
                "UPDATE job_seeker " +
                "SET location = ?, " +
                "resume_link = ?, " +
                "experience = ?, " +
                "education = ? " +
                "WHERE user_id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, location);
            statement.setString(2, resumeLink);
            statement.setString(3, experience);
            statement.setString(4, education);
            statement.setInt(5, userId);

            statement.executeUpdate();
        }
    }

    private void updateRecruiter(
            Connection connection,
            int userId,
            String company,
            String industry)
            throws SQLException {

        String sql =
                "UPDATE recruiter " +
                "SET company = ?, " +
                "industry = ? " +
                "WHERE user_id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, company);
            statement.setString(2, industry);
            statement.setInt(3, userId);

            statement.executeUpdate();
        }
    }

    private void updateJobSeekerSkills(
            Connection connection,
            int userId,
            String[] skillIds)
            throws SQLException {

        String deleteSql =
                "DELETE FROM job_seeker_skill " +
                "WHERE job_seeker_id = ?";

        try (PreparedStatement deleteStatement =
                     connection.prepareStatement(deleteSql)) {

            deleteStatement.setInt(1, userId);
            deleteStatement.executeUpdate();
        }

        if (skillIds == null ||
                skillIds.length == 0) {

            return;
        }

        String insertSql =
                "INSERT INTO job_seeker_skill " +
                "(job_seeker_id, skill_id) " +
                "VALUES (?, ?)";

        try (PreparedStatement insertStatement =
                     connection.prepareStatement(insertSql)) {

            for (String skillId : skillIds) {

                insertStatement.setInt(1, userId);

                insertStatement.setInt(
                        2,
                        Integer.parseInt(skillId)
                );

                insertStatement.addBatch();
            }

            insertStatement.executeBatch();
        }
    }

    private String getErrorMessage(Exception e) {

        Throwable cause = e;

        while (cause != null) {

            if (cause instanceof SQLException) {

                SQLException sqlException =
                        (SQLException) cause;

                if (sqlException.getErrorCode() == 1062) {
                    return "A duplicate value already exists.";
                }

                if (sqlException.getErrorCode() == 1054) {
                    return "Unknown database column: "
                            + sqlException.getMessage();
                }

                if (sqlException.getErrorCode() == 1146) {
                    return "Database table does not exist: "
                            + sqlException.getMessage();
                }

                if (sqlException.getErrorCode() == 1452) {
                    return "Foreign key constraint failed: "
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