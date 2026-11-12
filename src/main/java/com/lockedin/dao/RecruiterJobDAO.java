package com.lockedin.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.lockedin.util.DBConnection;

/**
 * SQL queries for job postings owned by one recruiter.
 * 
 * @author gianna
 */
public class RecruiterJobDAO {
    // define the there allowed statuses a job posting can have
    public static final String[] STATUSES = { "open", "closed", "pending" };
    public static final String[] LOCATIONS = { "San Jose, CA", "San Francisco, CA", "Oakland, CA",
            "Santa Clara, CA", "Austin, TX", "New York, NY", "Seattle, WA", "Los Angeles, CA",
            "Fremont, CA", "Remote" };

    /**
     * returns all the jobs owned by one recruiter.
     * 
     * @param recruiterId the ID of a recruiter
     * @return jobs owned by a recruiter
     * @throws SQLException if the queries fail
     */
    public List<Map<String, Object>> findByRecruiter(int recruiterId) throws SQLException {
        // query for jobs whose recruiter_id matches a specific recruiter
        String sql = "SELECT job_id, job_name, job_type, salary, job_location, deadline, job_status, description " +
                "FROM job_posting WHERE recruiter_id = ? ORDER BY job_id DESC";

        // list of jobs where jobs are maps with job_name and salary
        List<Map<String, Object>> jobs = new ArrayList<>();

        // open a database connection and prepare the SQL statement
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, recruiterId); // replace the first ? with the recruiter's ID
            try (ResultSet rs = s.executeQuery()) { // execute the query
                while (rs.next()) // move row-by-row through the returned jobs
                    jobs.add(mapJob(rs)); // convert every row into a map
            }
        }

        return jobs;
    }

    /**
     * find one job posting owned by a recruiter.
     * 
     * @param jobId       the ID of the job posting
     * @param recruiterId the ID of the recruiter
     * @return a job posting owned by the recruiter
     * @throws SQLException if the query fails
     */
    public Map<String, Object> findOwned(int jobId, int recruiterId) throws SQLException {
        // queries for a job with job_id owned by a recruiter with recruiter_id
        String sql = "SELECT jp.job_id, jp.job_name, jp.job_type, jp.salary, jp.job_location, " +
                "jp.deadline, jp.job_status, jp.description, r.company " +
                "FROM job_posting jp JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "WHERE jp.job_id = ? AND jp.recruiter_id = ?";
        
        // open a database connection and prepare the SQL statement
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, jobId); // replace the first ? with the job's
            s.setInt(2, recruiterId); // replace the second ? with the recruiter's ID
            try (ResultSet rs = s.executeQuery()) { // execute the query
                if (!rs.next()) return null; // return null if there is no matching row
                Map<String, Object> job = mapJob(rs); // convert the row into a map

                // load qualifications and skills from other tables
                job.put("qualifications", getQualifications(c, jobId));
                job.put("skills", getSkills(c, jobId));

                return job;
            }
        }
    }

    /** Returns an open posting for a job-seeker-facing detail page. */
    public Map<String, Object> findPublic(int jobId) throws SQLException {
        String sql = "SELECT jp.job_id, jp.job_name, jp.job_type, jp.salary, jp.job_location, " +
                "jp.deadline, jp.job_status, jp.description, r.company " +
                "FROM job_posting jp JOIN recruiter r ON r.user_id = jp.recruiter_id " +
                "WHERE jp.job_id = ? AND jp.job_status = 'open'";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, jobId);
            try (ResultSet rs = s.executeQuery()) {
                if (!rs.next()) return null;
                Map<String, Object> job = mapJob(rs);
                job.put("qualifications", getQualifications(c, jobId));
                job.put("skills", getSkills(c, jobId));
                return job;
            }
        }
    }

    public int create(int recruiterId, String title, BigDecimal pay, String location,
            String jobType, Date deadline, String description, String qualifications,
            String skills, String status)
            throws SQLException {
        validate(title, location, jobType, deadline, description, qualifications, skills, status);
        String sql = "INSERT INTO job_posting " +
                "(recruiter_id, job_status, is_open, description, job_name, job_type, " +
                "job_location, salary, post_date, deadline) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE, ?)";
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                int jobId;
                try (PreparedStatement s = c.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    s.setInt(1, recruiterId);
                    s.setString(2, status);
                    s.setBoolean(3, "open".equals(status));
                    s.setString(4, description);
                    s.setString(5, title);
                    s.setString(6, jobType);
                    s.setString(7, location);
                    setPay(s, 8, pay);
                    s.setDate(9, deadline);
                    s.executeUpdate();
                    try (ResultSet keys = s.getGeneratedKeys()) {
                        if (!keys.next())
                            throw new SQLException("The job ID was not created.");
                        jobId = keys.getInt(1);
                    }
                }
                replaceDetails(c, jobId, qualifications, skills);
                c.commit();
                return jobId;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    public boolean update(int jobId, int recruiterId, String title, BigDecimal pay, String location,
            String jobType, Date deadline, String description, String qualifications,
            String skills, String status)
            throws SQLException {
        validate(title, location, jobType, deadline, description, qualifications, skills, status);
        String sql = "UPDATE job_posting SET job_status = ?, is_open = ?, description = ?, " +
                "job_name = ?, job_type = ?, job_location = ?, salary = ?, deadline = ? " +
                "WHERE job_id = ? AND recruiter_id = ?";
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                int count;
                try (PreparedStatement s = c.prepareStatement(sql)) {
                    s.setString(1, status);
                    s.setBoolean(2, "open".equals(status));
                    s.setString(3, description);
                    s.setString(4, title);
                    s.setString(5, jobType);
                    s.setString(6, location);
                    setPay(s, 7, pay);
                    s.setDate(8, deadline);
                    s.setInt(9, jobId);
                    s.setInt(10, recruiterId);
                    count = s.executeUpdate();
                }
                if (count == 1)
                    replaceDetails(c, jobId, qualifications, skills);
                c.commit();
                return count == 1;
            } catch (SQLException e) {
                c.rollback();
                throw e;
            }
        }
    }

    public boolean delete(int jobId, int recruiterId) throws SQLException {
        String sql = "DELETE FROM job_posting WHERE job_id = ? AND recruiter_id = ?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, jobId);
            s.setInt(2, recruiterId);
            return s.executeUpdate() == 1;
        }
    }

    private void replaceDetails(Connection c, int jobId, String qualifications, String skills) throws SQLException {
        try (PreparedStatement s = c.prepareStatement("DELETE FROM job_requirement WHERE job_id = ?")) {
            s.setInt(1, jobId);
            s.executeUpdate();
        }
        if (qualifications != null && !qualifications.trim().isEmpty()) {
            int requirementNumber = 1;
            try (PreparedStatement s = c.prepareStatement(
                    "INSERT INTO job_requirement (job_id, requirement_number, description) VALUES (?, ?, ?)")) {
                for (String line : qualifications.split("\\R")) {
                    String requirement = line.trim();
                    if (requirement.isEmpty()) continue;
                    s.setInt(1, jobId);
                    s.setInt(2, requirementNumber++);
                    s.setString(3, requirement);
                    s.executeUpdate();
                }
            }
        }
        try (PreparedStatement s = c.prepareStatement("DELETE FROM job_posting_skill WHERE job_id = ?")) {
            s.setInt(1, jobId);
            s.executeUpdate();
        }
        if (skills == null)
            return;
        for (String raw : skills.split("[,\\n]")) {
            String name = raw.trim();
            if (name.isEmpty())
                continue;
            Integer skillId = findSkillId(c, name);
            if (skillId == null) {
                try (PreparedStatement s = c.prepareStatement("INSERT INTO skill (name) VALUES (?)")) {
                    s.setString(1, name);
                    s.executeUpdate();
                }
                skillId = findSkillId(c, name);
            }
            if (skillId != null) {
                try (PreparedStatement s = c
                        .prepareStatement("INSERT INTO job_posting_skill (job_id, skill_id) VALUES (?, ?)")) {
                    s.setInt(1, jobId);
                    s.setInt(2, skillId);
                    s.executeUpdate();
                }
            }
        }
    }

    private Integer findSkillId(Connection c, String name) throws SQLException {
        try (PreparedStatement s = c.prepareStatement("SELECT skill_id FROM skill WHERE name = ?")) {
            s.setString(1, name);
            try (ResultSet rs = s.executeQuery()) {
                return rs.next() ? rs.getInt("skill_id") : null;
            }
        }
    }

    private String getQualifications(Connection c, int jobId) throws SQLException {
        try (PreparedStatement s = c.prepareStatement(
                "SELECT description FROM job_requirement WHERE job_id = ? ORDER BY requirement_number")) {
            s.setInt(1, jobId);
            try (ResultSet rs = s.executeQuery()) {
                StringBuilder result = new StringBuilder();
                while (rs.next()) {
                    if (result.length() > 0)
                        result.append("\n");
                    result.append(rs.getString("description"));
                }
                return result.toString();
            }
        }
    }

    private String getSkills(Connection c, int jobId) throws SQLException {
        String sql = "SELECT s.name FROM skill s JOIN job_posting_skill j ON s.skill_id = j.skill_id WHERE j.job_id = ? ORDER BY s.name";
        try (PreparedStatement s = c.prepareStatement(sql)) {
            s.setInt(1, jobId);
            try (ResultSet rs = s.executeQuery()) {
                StringBuilder result = new StringBuilder();
                while (rs.next()) {
                    if (result.length() > 0)
                        result.append(", ");
                    result.append(rs.getString("name"));
                }
                return result.toString();
            }
        }
    }

    private Map<String, Object> mapJob(ResultSet rs) throws SQLException {
        Map<String, Object> job = new HashMap<>();
        job.put("job_id", rs.getInt("job_id"));
        job.put("job_name", rs.getString("job_name"));
        job.put("job_type", rs.getString("job_type"));
        job.put("salary", rs.getBigDecimal("salary"));
        job.put("job_location", rs.getString("job_location"));
        job.put("deadline", rs.getDate("deadline"));
        job.put("job_status", rs.getString("job_status"));
        job.put("description", rs.getString("description"));
        try { job.put("company", rs.getString("company")); } catch (SQLException ignored) { }
        return job;
    }

    private static void setPay(PreparedStatement s, int index, BigDecimal pay) throws SQLException {
        if (pay == null)
            s.setNull(index, java.sql.Types.DECIMAL);
        else
            s.setBigDecimal(index, pay);
    }

    private static void validate(String title, String location, String jobType, Date deadline,
            String description, String qualifications, String skills, String status) {
        if (title == null || title.trim().isEmpty())
            throw new IllegalArgumentException("Job title is required.");
        if (title.trim().length() > 150) throw new IllegalArgumentException("Job title must be 150 characters or fewer.");
        if (description == null || description.trim().isEmpty()) throw new IllegalArgumentException("Job description is required.");
        if (!isAllowedLocation(location))
            throw new IllegalArgumentException("Select a valid location from the list.");
        if (jobType == null || !(jobType.equals("Full-time") || jobType.equals("Part-time") || jobType.equals("Contract") || jobType.equals("Internship") || jobType.equals("Temporary")))
            throw new IllegalArgumentException("Select a valid job type.");
        if (deadline == null || deadline.toLocalDate().isBefore(LocalDate.now()))
            throw new IllegalArgumentException("Deadline must be today or a future date.");
        validateQualifications(qualifications);
        validateSkills(skills);
        if (!"open".equals(status) && !"closed".equals(status) && !"pending".equals(status))
            throw new IllegalArgumentException("Invalid job status.");
    }

    private static void validateQualifications(String qualifications) {
        if (qualifications == null || qualifications.trim().isEmpty())
            throw new IllegalArgumentException("Add at least one qualification, one per line.");
        for (String line : qualifications.split("\\R")) {
            if (!line.trim().isEmpty() && line.trim().length() > 500)
                throw new IllegalArgumentException("Each qualification must be 500 characters or fewer.");
        }
    }

    private static boolean isAllowedLocation(String location) {
        if (location == null) return false;
        for (String allowed : LOCATIONS) {
            if (allowed.equals(location.trim())) return true;
        }
        return false;
    }

    private static void validateSkills(String skills) {
        if (skills == null || skills.trim().isEmpty())
            throw new IllegalArgumentException("Add at least one desired skill.");
        Set<String> seen = new HashSet<>();
        for (String raw : skills.split(",")) {
            String skill = raw.trim();
            if (skill.isEmpty() || skill.length() > 100)
                throw new IllegalArgumentException("Skills must be non-empty comma-separated values of 100 characters or fewer.");
            if (!seen.add(skill.toLowerCase()))
                throw new IllegalArgumentException("Do not enter the same skill more than once.");
        }
    }
}
