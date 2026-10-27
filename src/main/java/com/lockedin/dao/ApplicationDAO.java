package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.lockedin.util.DBConnection;

public class ApplicationDAO {

    public static final String STATUS_SUBMITTED = "Submitted";

    /**
     * Submits an application to an open job. The UNIQUE (job_seeker_id, job_id)
     * constraint prevents duplicates. Returns null on success, else an error message.
     */
    public String apply(int jobSeekerId, int jobId, String resumeLink, String message) {

        String sql =
                "INSERT INTO application " +
                "(job_seeker_id, job_id, status, resume_link, " +
                "message, submission_date, last_updated) " +
                "SELECT ?, job_id, ?, ?, ?, CURDATE(), CURDATE() " +
                "FROM job_posting " +
                "WHERE job_id = ? AND is_open = TRUE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);
            statement.setString(2, STATUS_SUBMITTED);
            statement.setString(3, resumeLink);
            statement.setString(4, message);
            statement.setInt(5, jobId);

            if (statement.executeUpdate() == 0) {
                return "That job posting is no longer open.";
            }
            return null;

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                return "You have already applied to this job.";
            }
            e.printStackTrace();
            return "Could not submit your application. Please try again.";
        }
    }

    public boolean hasApplied(int jobSeekerId, int jobId) throws SQLException {

        String sql =
                "SELECT 1 FROM application " +
                "WHERE job_seeker_id = ? AND job_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);
            statement.setInt(2, jobId);

            try (ResultSet rs = statement.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Map<String, Object>> getApplications(int jobSeekerId)
            throws SQLException {

        String sql =
                "SELECT a.application_id, a.job_id, a.status, " +
                "a.submission_date, jp.job_name, r.company " +
                "FROM application a " +
                "JOIN job_posting jp ON jp.job_id = a.job_id " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "WHERE a.job_seeker_id = ? " +
                "ORDER BY a.submission_date DESC, a.application_id DESC";

        List<Map<String, Object>> applications = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> app = new HashMap<>();
                    app.put("application_id", rs.getInt("application_id"));
                    app.put("job_id", rs.getInt("job_id"));
                    app.put("status", rs.getString("status"));
                    app.put("submission_date", rs.getDate("submission_date"));
                    app.put("job_name", rs.getString("job_name"));
                    app.put("company", rs.getString("company"));
                    applications.add(app);
                }
            }
        }

        return applications;
    }
}
