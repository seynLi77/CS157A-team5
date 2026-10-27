package com.lockedin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.lockedin.util.DBConnection;

public class SavedJobDAO {

    public static final List<String> PRIORITIES =
            Arrays.asList("High", "Medium", "Low");

    public List<Map<String, Object>> getSavedJobs(int jobSeekerId)
            throws SQLException {

        String sql =
                "SELECT sj.job_id, sj.priority, sj.saved_date, " +
                "jp.job_name, jp.job_type, jp.job_location, " +
                "jp.salary, jp.deadline, jp.is_open, " +
                "r.company, " +
                "(a.application_id IS NOT NULL) AS applied " +
                "FROM saved_job sj " +
                "JOIN job_posting jp ON jp.job_id = sj.job_id " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "LEFT JOIN application a " +
                "ON a.job_id = sj.job_id " +
                "AND a.job_seeker_id = sj.job_seeker_id " +
                "WHERE sj.job_seeker_id = ? " +
                "ORDER BY FIELD(sj.priority, 'High', 'Medium', 'Low'), " +
                "sj.saved_date DESC, sj.job_id";

        List<Map<String, Object>> jobs = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> job = new HashMap<>();
                    job.put("job_id", rs.getInt("job_id"));
                    job.put("priority", rs.getString("priority"));
                    job.put("saved_date", rs.getDate("saved_date"));
                    job.put("job_name", rs.getString("job_name"));
                    job.put("job_type", rs.getString("job_type"));
                    job.put("job_location", rs.getString("job_location"));
                    job.put("salary", rs.getBigDecimal("salary"));
                    job.put("deadline", rs.getDate("deadline"));
                    job.put("is_open", rs.getBoolean("is_open"));
                    job.put("company", rs.getString("company"));
                    job.put("applied", rs.getBoolean("applied"));
                    jobs.add(job);
                }
            }
        }

        return jobs;
    }

    /** Saves an open job with Medium priority. Returns null on success, else an error message. */
    public String saveJob(int jobSeekerId, int jobId) {

        String sql =
                "INSERT INTO saved_job " +
                "(job_seeker_id, job_id, priority, saved_date) " +
                "SELECT ?, job_id, 'Medium', CURDATE() " +
                "FROM job_posting " +
                "WHERE job_id = ? AND is_open = TRUE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);
            statement.setInt(2, jobId);

            if (statement.executeUpdate() == 0) {
                return "That job is not available to save.";
            }
            return null;

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                return "You have already saved that job.";
            }
            e.printStackTrace();
            return "Could not save the job. Please try again.";
        }
    }

    public String updatePriority(int jobSeekerId, int jobId, String priority) {

        if (!PRIORITIES.contains(priority)) {
            return "Priority must be High, Medium, or Low.";
        }

        String sql =
                "UPDATE saved_job SET priority = ? " +
                "WHERE job_seeker_id = ? AND job_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, priority);
            statement.setInt(2, jobSeekerId);
            statement.setInt(3, jobId);

            // Connector/J reports matched rows, so 0 = not in this user's saved list
            if (statement.executeUpdate() == 0) {
                return "That job is not in your saved jobs.";
            }
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return "Could not update the priority. Please try again.";
        }
    }

    public String removeSavedJob(int jobSeekerId, int jobId) {

        String sql =
                "DELETE FROM saved_job " +
                "WHERE job_seeker_id = ? AND job_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);
            statement.setInt(2, jobId);
            statement.executeUpdate();
            return null;

        } catch (SQLException e) {
            e.printStackTrace();
            return "Could not remove the job. Please try again.";
        }
    }
}
