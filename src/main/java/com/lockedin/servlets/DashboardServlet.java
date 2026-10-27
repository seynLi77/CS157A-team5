package com.lockedin.servlets;

import java.io.IOException;
import java.sql.SQLException;

import com.lockedin.dao.ApplicationDAO;
import com.lockedin.dao.SavedJobDAO;
import com.lockedin.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles requests for user dashboard.
 *
 * @author Elaine and Jumana
 */

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final SavedJobDAO savedJobDAO = new SavedJobDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
                session.getAttribute("email") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }

        try {
            Integer jobSeekerId = SessionUtil.getJobSeekerId(
                    (String) session.getAttribute("email"));

            if (jobSeekerId != null) {
                request.setAttribute(
                        "savedJobs",
                        savedJobDAO.getSavedJobs(jobSeekerId));

                request.setAttribute(
                        "applications",
                        applicationDAO.getApplications(jobSeekerId));
            }
        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load dashboard data.", e);
        }

        SessionUtil.moveFlashToRequest(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/dashboard.jsp"
        ).forward(request, response);
    }
}
