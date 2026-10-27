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

/**
 * Provides data-access operations for job postings.
 *
 * @author Jumana
 */
public class JobDAO {

    /**
     * Returns the number of currently open job postings.
     *
     * @return number of open jobs
     * @throws SQLException if the database query fails
     */
    public int getOpenJobCount() throws SQLException {

        String sql = "SELECT COUNT(*) " +
                "FROM job_posting " +
                "WHERE is_open = TRUE";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                return resultSet.getInt(1);
            }

            return 0;
        }
    }

    private static final String JOB_COLUMNS =
            "jp.job_id, jp.job_name, jp.job_type, jp.job_location, " +
                    "jp.salary, jp.description, jp.deadline, jp.is_open, " +
                    "r.company ";

    private Map<String, Object> mapJob(ResultSet rs) throws SQLException {

        Map<String, Object> job = new HashMap<>();

        job.put("job_id", rs.getInt("job_id"));
        job.put("job_name", rs.getString("job_name"));
        job.put("job_type", rs.getString("job_type"));
        job.put("job_location", rs.getString("job_location"));
        job.put("salary", rs.getBigDecimal("salary"));
        job.put("description", rs.getString("description"));
        job.put("deadline", rs.getDate("deadline"));
        job.put("is_open", rs.getBoolean("is_open"));
        job.put("company", rs.getString("company"));

        return job;
    }

    /**
     * Returns every open job, newest first, flagged with whether the job
     * seeker saved it ("saved_priority", null if not) or applied ("applied").
     * Plain listing for now; match-based ordering (2.3.1) can replace the ORDER BY.
     */
    public List<Map<String, Object>> getOpenJobsForSeeker(int jobSeekerId)
            throws SQLException {

        String sql = "SELECT " + JOB_COLUMNS + ", " +
                "sj.priority AS saved_priority, " +
                "(a.application_id IS NOT NULL) AS applied " +
                "FROM job_posting jp " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "LEFT JOIN saved_job sj " +
                "ON sj.job_id = jp.job_id AND sj.job_seeker_id = ? " +
                "LEFT JOIN application a " +
                "ON a.job_id = jp.job_id AND a.job_seeker_id = ? " +
                "WHERE jp.is_open = TRUE " +
                "ORDER BY jp.post_date DESC, jp.job_id";

        List<Map<String, Object>> jobs = new ArrayList<>();

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobSeekerId);
            statement.setInt(2, jobSeekerId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> job = mapJob(rs);
                    job.put("saved_priority", rs.getString("saved_priority"));
                    job.put("applied", rs.getBoolean("applied"));
                    jobs.add(job);
                }
            }
        }

        return jobs;
    }

    /** Returns one job posting (open or closed), or null if it does not exist. */
    public Map<String, Object> getJobById(int jobId) throws SQLException {

        String sql = "SELECT " + JOB_COLUMNS +
                "FROM job_posting jp " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "WHERE jp.job_id = ?";

        try (
                Connection connection = DBConnection.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, jobId);

            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? mapJob(rs) : null;
            }
        }
    }
}
