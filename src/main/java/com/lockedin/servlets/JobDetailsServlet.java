package com.lockedin.servlets;

import com.lockedin.dao.ProfileDAO;
import com.lockedin.dao.RecruiterJobDAO;
import com.lockedin.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

/** Shows a complete job posting to its owner or to job seekers when open. */
@WebServlet("/job")
public class JobDetailsServlet extends HttpServlet {
    private final RecruiterJobDAO jobs = new RecruiterJobDAO();
    private final ProfileDAO profiles = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = SessionUtil.getEmail(request);
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int jobId;
        try {
            jobId = Integer.parseInt(request.getParameter("job_id"));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid job ID.");
            return;
        }

        try {
            Map<String, Object> profile = profiles.findProfileByEmail(email);
            Map<String, Object> job = null;
            boolean canApply = false;

            if (profile != null && "recruiter".equals(profile.get("role"))) {
                job = jobs.findOwned(jobId, (Integer) profile.get("user_id"));
            } else if (profile != null && "job_seeker".equals(profile.get("role"))) {
                job = jobs.findPublic(jobId);
                canApply = job != null;
            }

            if (job == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job posting not found.");
                return;
            }

            request.setAttribute("job", job);
            request.setAttribute("canApply", canApply);
            request.getRequestDispatcher("/WEB-INF/views/job-details.jsp")
                    .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Unable to load job posting.", e);
        }
    }
}
