package com.lockedin.servlets;

import java.io.IOException;
import java.sql.SQLException;

import com.lockedin.dao.SavedJobDAO;
import com.lockedin.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/** POST params: action (save | priority | remove), job_id, priority, return_to (jobs | dashboard). */
@WebServlet("/saved-jobs")
public class SavedJobServlet extends HttpServlet {

    private final SavedJobDAO savedJobDAO = new SavedJobDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = SessionUtil.getEmail(request);

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer jobSeekerId;

        try {
            jobSeekerId = SessionUtil.getJobSeekerId(email);
        } catch (SQLException e) {
            throw new ServletException("Unable to look up user.", e);
        }

        if (jobSeekerId == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Only job seekers can save jobs.");
            return;
        }

        String action = request.getParameter("action");
        String target = "jobs".equals(request.getParameter("return_to"))
                ? "/jobs" : "/dashboard";

        int jobId;

        try {
            jobId = Integer.parseInt(request.getParameter("job_id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid job.");
            return;
        }

        String error;
        String success;

        if ("save".equals(action)) {
            error = savedJobDAO.saveJob(jobSeekerId, jobId);
            success = "Job saved to your dashboard.";

        } else if ("priority".equals(action)) {
            error = savedJobDAO.updatePriority(
                    jobSeekerId, jobId, request.getParameter("priority"));
            success = "Priority updated.";

        } else if ("remove".equals(action)) {
            error = savedJobDAO.removeSavedJob(jobSeekerId, jobId);
            success = "Job removed from your saved jobs.";

        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action.");
            return;
        }

        if (error != null) {
            SessionUtil.setFlash(request, error, true);
        } else {
            SessionUtil.setFlash(request, success, false);
        }

        response.sendRedirect(request.getContextPath() + target);
    }
}
