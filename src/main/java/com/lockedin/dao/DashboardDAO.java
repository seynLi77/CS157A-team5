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
 * Loads the combined saved-job and application rows for a job seeker.
 *  @author Elaine
 */
public class DashboardDAO {

    /** Number of days without an update before an application becomes stale. */
    private static final int DEFAULT_STALE_DAYS = 14;

    public List<Map<String, Object>> getJobSeekerDashboard(int jobSeekerId)
            throws SQLException {
        return getJobSeekerDashboard(jobSeekerId, DEFAULT_STALE_DAYS);
    }

    public List<Map<String, Object>> getJobSeekerDashboard(
            int jobSeekerId, int staleDays) throws SQLException {

        String sql =
                "SELECT jp.job_id, jp.job_name, jp.job_location, jp.salary, " +
                "r.company, " +
                "sj.priority, sj.saved_date, " +
                "a.application_id, a.status AS application_status, " +
                "a.submission_date, a.last_updated, " +
                "CASE " +
                "  WHEN a.application_id IS NULL THEN 'Bookmarked' " +
                "  WHEN a.status IN ('Submitted', 'Under Review') " +
                "       AND DATEDIFF(CURDATE(), " +
                "           COALESCE(a.last_updated, a.submission_date)) >= ? " +
                "    THEN 'Stale' " +
                "  ELSE a.status " +
                "END AS display_status, " +
                "(a.application_id IS NOT NULL) AS applied, " +
                "(sj.job_id IS NOT NULL) AS bookmarked, " +
                "(SELECT i.`date` FROM interview i " +
                "   WHERE i.application_id = a.application_id " +
                "   ORDER BY i.`date`, i.`time` LIMIT 1) AS interview_date, " +
                "(SELECT i.`time` FROM interview i " +
                "   WHERE i.application_id = a.application_id " +
                "   ORDER BY i.`date`, i.`time` LIMIT 1) AS interview_time, " +
                "(SELECT i.location FROM interview i " +
                "   WHERE i.application_id = a.application_id " +
                "   ORDER BY i.`date`, i.`time` LIMIT 1) AS interview_location, " +
                "(SELECT i.status FROM interview i " +
                "   WHERE i.application_id = a.application_id " +
                "   ORDER BY i.`date`, i.`time` LIMIT 1) AS interview_status " +
                "FROM job_posting jp " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "LEFT JOIN saved_job sj " +
                "  ON sj.job_id = jp.job_id " +
                " AND sj.job_seeker_id = ? " +
                "LEFT JOIN application a " +
                "  ON a.job_id = jp.job_id " +
                " AND a.job_seeker_id = ? " +
                "WHERE a.application_id IS NOT NULL " +
                "ORDER BY COALESCE(a.last_updated, sj.saved_date) DESC, " +
                "         jp.job_id DESC";

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, staleDays);
            statement.setInt(2, jobSeekerId);
            statement.setInt(3, jobSeekerId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put("job_id", rs.getInt("job_id"));
                    row.put("job_name", rs.getString("job_name"));
                    row.put("company", rs.getString("company"));
                    row.put("job_location", rs.getString("job_location"));
                    row.put("salary", rs.getBigDecimal("salary"));

                    row.put("priority", rs.getString("priority"));
                    row.put("saved_date", rs.getDate("saved_date"));
                    row.put("bookmarked", rs.getBoolean("bookmarked"));

                    row.put("application_id", rs.getObject("application_id"));
                    row.put("application_status",
                            rs.getString("application_status"));
                    row.put("display_status", rs.getString("display_status"));
                    row.put("submission_date",
                            rs.getDate("submission_date"));
                    row.put("last_updated", rs.getDate("last_updated"));
                    row.put("applied", rs.getBoolean("applied"));

                    row.put("interview_date",
                            rs.getDate("interview_date"));
                    row.put("interview_time",
                            rs.getTime("interview_time"));
                    row.put("interview_location",
                            rs.getString("interview_location"));
                    row.put("interview_status",
                            rs.getString("interview_status"));

                    rows.add(row);
                }
            }
        }

        return rows;
    }
}