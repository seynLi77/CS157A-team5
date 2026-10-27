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
     * Returns open jobs ranked for this job seeker by shared skills and location.
     * Existing saved/applied flags are preserved for the Save and Apply controls.
     *
     * Score: +2 for each shared skill, +3 for an exact location match,
     * +1 for a remote posting if the locations are not identical.
     * Newer postings break ties. The scoring weights are a simple initial policy.
     */
    public List<Map<String, Object>> getOpenJobsForSeeker(int jobSeekerId)
            throws SQLException {
        return getOpenJobsForSeeker(jobSeekerId, "");
    }

    /** Search by title, company, description, job type, location, or skill. */
    public List<Map<String, Object>> getOpenJobsForSeeker(int jobSeekerId, String query)
            throws SQLException {

        String search = query == null ? "" : query.trim();
        if (search.length() > 100) {
            search = search.substring(0, 100);
        }

        String locationPoints =
                "CASE " +
                "WHEN LOWER(TRIM(jp.job_location)) = LOWER(TRIM(js.location)) THEN 3 " +
                "WHEN LOWER(TRIM(jp.job_location)) LIKE '%remote%' THEN 1 " +
                "ELSE 0 END";

        String matchedSkills = "COALESCE(matches.matched_skills, 0)";

        StringBuilder sql = new StringBuilder(
                "SELECT " + JOB_COLUMNS + ", " +
                "sj.priority AS saved_priority, " +
                "(a.application_id IS NOT NULL) AS applied, " +
                matchedSkills + " AS matched_skills, " +
                locationPoints + " AS location_points, " +
                "(" + matchedSkills + " * 2 + " + locationPoints + ") AS match_score " +
                "FROM job_posting jp " +
                "JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "JOIN job_seeker js ON js.user_id = ? " +
                "LEFT JOIN ( " +
                "    SELECT jps.job_id, COUNT(*) AS matched_skills " +
                "    FROM job_posting_skill jps " +
                "    JOIN job_seeker_skill jss ON jss.skill_id = jps.skill_id " +
                "    WHERE jss.job_seeker_id = ? " +
                "    GROUP BY jps.job_id " +
                ") matches ON matches.job_id = jp.job_id " +
                "LEFT JOIN saved_job sj " +
                "    ON sj.job_id = jp.job_id AND sj.job_seeker_id = ? " +
                "LEFT JOIN application a " +
                "    ON a.job_id = jp.job_id AND a.job_seeker_id = ? " +
                "WHERE jp.is_open = TRUE ");

        if (!search.isEmpty()) {
            sql.append(
                    "AND (LOWER(jp.job_name) LIKE ? ESCAPE '!' " +
                    "OR LOWER(jp.description) LIKE ? ESCAPE '!' " +
                    "OR LOWER(r.company) LIKE ? ESCAPE '!' " +
                    "OR LOWER(jp.job_location) LIKE ? ESCAPE '!' " +
                    "OR LOWER(jp.job_type) LIKE ? ESCAPE '!' " +
                    "OR EXISTS ( " +
                    "    SELECT 1 FROM job_posting_skill jps2 " +
                    "    JOIN skill s ON s.skill_id = jps2.skill_id " +
                    "    WHERE jps2.job_id = jp.job_id " +
                    "    AND LOWER(s.name) LIKE ? ESCAPE '!' " +
                    ")) ");
        }

        sql.append("ORDER BY match_score DESC, jp.post_date DESC, jp.job_id DESC");

        List<Map<String, Object>> jobs = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {

            statement.setInt(1, jobSeekerId);
            statement.setInt(2, jobSeekerId);
            statement.setInt(3, jobSeekerId);
            statement.setInt(4, jobSeekerId);

            if (!search.isEmpty()) {
                // Treat percent and underscore in user input literally, not as LIKE wildcards.
                String escaped = search.toLowerCase(java.util.Locale.ROOT)
                        .replace("!", "!!")
                        .replace("%", "!%")
                        .replace("_", "!_");
                String pattern = "%" + escaped + "%";
                for (int index = 5; index <= 10; index++) {
                    statement.setString(index, pattern);
                }
            }

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> job = mapJob(rs);
                    job.put("saved_priority", rs.getString("saved_priority"));
                    job.put("applied", rs.getBoolean("applied"));
                    job.put("matched_skills", rs.getInt("matched_skills"));
                    job.put("location_points", rs.getInt("location_points"));
                    job.put("match_score", rs.getInt("match_score"));
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
