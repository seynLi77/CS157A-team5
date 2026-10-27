package com.lockedin.util;

import java.sql.SQLException;
import java.util.Map;

import com.lockedin.dao.ProfileDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    private static final ProfileDAO PROFILE_DAO = new ProfileDAO();

    private SessionUtil() {
    }

    /** Logged-in user's email, or null if nobody is logged in. */
    public static String getEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("email");
    }

    /** User ID if the user is a job seeker, otherwise null. */
    public static Integer getJobSeekerId(String email) throws SQLException {
        Map<String, Object> profile = PROFILE_DAO.findProfileByEmail(email);
        if (profile == null || !"job_seeker".equals(profile.get("role"))) {
            return null;
        }
        return (Integer) profile.get("user_id");
    }

    /** One-time message that survives a redirect. */
    public static void setFlash(HttpServletRequest request, String message, boolean isError) {
        HttpSession session = request.getSession();
        session.setAttribute(isError ? "flashError" : "flashSuccess", message);
    }

    /** Moves one-time messages from the session to the request for the JSP. */
    public static void moveFlashToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        for (String key : new String[] {"flashSuccess", "flashError"}) {
            Object value = session.getAttribute(key);
            if (value != null) {
                request.setAttribute(key, value);
                session.removeAttribute(key);
            }
        }
    }
}
