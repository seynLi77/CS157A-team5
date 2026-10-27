package com.lockedin.servlets;

import java.io.IOException;
import java.sql.SQLException;

import com.lockedin.dao.JobDAO;
import com.lockedin.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/jobs")
public class JobsServlet extends HttpServlet {

    private final JobDAO jobDAO = new JobDAO();

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
                        "Only job seekers can browse and save jobs.");
                return;
            }

            request.setAttribute("jobs", jobDAO.getOpenJobsForSeeker(jobSeekerId));
            SessionUtil.moveFlashToRequest(request);

            request.getRequestDispatcher("/WEB-INF/views/jobs.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load jobs.", e);
        }
    }
}
