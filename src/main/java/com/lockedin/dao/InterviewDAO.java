package com.lockedin.dao;

import com.lockedin.util.DBConnection;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class InterviewDAO {

    private List<Map<String, Object>> query(String sql, int userId)
            throws SQLException {

        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    for (int i = 1;
                         i <= rs.getMetaData().getColumnCount(); i++) {

                        row.put(
                            rs.getMetaData().getColumnLabel(i),
                            rs.getObject(i)
                        );
                    }

                    rows.add(row);
                }
            }
        }

        return rows;
    }

    public List<Map<String, Object>> applicants(int recruiterId)
            throws SQLException {

        return query(
            "SELECT a.application_id, u.first_name, u.last_name, " +
            "j.job_name " +
            "FROM application a " +
            "JOIN job_posting j ON j.job_id=a.job_id " +
            "JOIN `user` u ON u.user_id=a.job_seeker_id " +
            "WHERE j.recruiter_id=? " +
            "ORDER BY j.job_name, u.last_name, u.first_name, " +
            "a.application_id",
            recruiterId
        );
    }

    public List<Map<String, Object>> invitations(
            int userId, boolean recruiter) throws SQLException {

        return query(
            "SELECT i.*, j.job_name, r.company, " +
            "u.first_name, u.last_name " +
            "FROM interview i " +
            "JOIN application a " +
            "ON a.application_id=i.application_id " +
            "JOIN job_posting j ON j.job_id=a.job_id " +
            "JOIN recruiter r ON r.user_id=i.recruiter_id " +
            "JOIN `user` u ON u.user_id=a.job_seeker_id " +
            "WHERE i.recruiter_id=j.recruiter_id AND " +
            (recruiter
                ? "j.recruiter_id=? "
                : "a.job_seeker_id=? ") +
            "ORDER BY i.`date` DESC, i.`time` DESC, " +
            "i.interview_id DESC",
            userId
        );
    }

    public boolean invite(
            int recruiterId,
            int applicationId,
            LocalDateTime when,
            String location,
            String message) throws SQLException {

        String sql =
            "INSERT INTO interview " +
            "(application_id,recruiter_id,`date`,`time`," +
            "location,message,status) " +
            "SELECT a.application_id,j.recruiter_id," +
            "?,?,?,?, 'Pending' " +
            "FROM application a " +
            "JOIN job_posting j ON j.job_id=a.job_id " +
            "WHERE a.application_id=? AND j.recruiter_id=?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setDate(
                1, java.sql.Date.valueOf(when.toLocalDate())
            );
            ps.setTime(
                2, Time.valueOf(when.toLocalTime())
            );
            ps.setString(3, location);
            ps.setString(4, message);
            ps.setInt(5, applicationId);
            ps.setInt(6, recruiterId);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean respond(
            int seekerId,
            int interviewId,
            String status) throws SQLException {

        if (!"Accepted".equals(status)
                && !"Declined".equals(status)) {
            throw new IllegalArgumentException(
                "Invalid response."
            );
        }

        String sql =
            "UPDATE interview i " +
            "JOIN application a " +
            "ON a.application_id=i.application_id " +
            "JOIN job_posting j ON j.job_id=a.job_id " +
            "SET i.status=? " +
            "WHERE i.interview_id=? " +
            "AND a.job_seeker_id=? " +
            "AND i.recruiter_id=j.recruiter_id " +
            "AND i.status='Pending' " +
            "AND TIMESTAMP(i.`date`,i.`time`)>CURRENT_TIMESTAMP";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, interviewId);
            ps.setInt(3, seekerId);

            return ps.executeUpdate() == 1;
        }
    }
}
