package com.lockedin.servlets;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import com.lockedin.dao.ApplicationDAO;
import com.lockedin.dao.JobDAO;
import com.lockedin.dao.ProfileDAO;
import com.lockedin.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/apply")
public class ApplyServlet extends HttpServlet {

    private static final int MAX_RESUME_LENGTH = 255;
    private static final int MAX_MESSAGE_LENGTH = 5000;

    private final JobDAO jobDAO = new JobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = SessionUtil.getEmail(request);

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Integer jobSeekerId = SessionUtil.getJobSeekerId(email);

            if (jobSeekerId == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Only job seekers can apply to jobs.");
                return;
            }

            Integer jobId = parseJobId(request);
            Map<String, Object> job = jobId == null ? null : jobDAO.getJobById(jobId);

            if (job == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Job posting not found.");
                return;
            }

            request.setAttribute("job", job);
            request.setAttribute("alreadyApplied",
                    applicationDAO.hasApplied(jobSeekerId, jobId));

            // Pre-fill the resume from the user's profile
            if (request.getAttribute("resumeLink") == null) {
                Map<String, Object> profile = profileDAO.findProfileByEmail(email);
                request.setAttribute("resumeLink", profile.get("resume_link"));
            }

            SessionUtil.moveFlashToRequest(request);

            request.getRequestDispatcher("/WEB-INF/views/apply.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load application form.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = SessionUtil.getEmail(request);

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Integer jobSeekerId = SessionUtil.getJobSeekerId(email);

            if (jobSeekerId == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Only job seekers can apply to jobs.");
                return;
            }

            Integer jobId = parseJobId(request);

            if (jobId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid job.");
                return;
            }

            String resume = trim(request.getParameter("resume_link"));
            String message = trim(request.getParameter("message"));

            String error;

            if (resume.isEmpty()) {
                error = "Please provide a resume.";
            } else if (resume.length() > MAX_RESUME_LENGTH) {
                error = "Resume link must be at most " + MAX_RESUME_LENGTH + " characters.";
            } else if (message.length() > MAX_MESSAGE_LENGTH) {
                error = "Message must be at most " + MAX_MESSAGE_LENGTH + " characters.";
            } else {
                error = applicationDAO.apply(jobSeekerId, jobId, resume, message);
            }

            if (error != null) {
                // Re-show the form with what the user typed
                SessionUtil.setFlash(request, error, true);
                request.setAttribute("resumeLink", resume);
                request.setAttribute("message", message);
                doGet(request, response);
                return;
            }

            SessionUtil.setFlash(request, "Your application was submitted.", false);
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (SQLException e) {
            throw new ServletException("Unable to submit application.", e);
        }
    }

    private Integer parseJobId(HttpServletRequest request) {
        try {
            return Integer.valueOf(request.getParameter("job_id"));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
