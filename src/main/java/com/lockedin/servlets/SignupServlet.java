package com.lockedin.servlets;

import java.io.IOException;

import com.lockedin.dao.SignupDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles requests for signup page.
 *
 * @author Elaine
 */

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    private SignupDAO signupDAO;

    @Override
    public void init() {
        signupDAO = new SignupDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/signup.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String firstName =
                request.getParameter("first_name");

        String lastName =
                request.getParameter("last_name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String role =
                request.getParameter("role");

        String location =
                request.getParameter("location");

        String resume =
                request.getParameter("resume");

        String experience =
                request.getParameter("experience");

        String education =
                request.getParameter("education");

        String company =
                request.getParameter("company");

        String industry =
                request.getParameter("industry");

        String[] skillIds =
                request.getParameterValues("skill_ids");

        if (role == null || role.trim().isEmpty()) {
            showError(
                    request,
                    response,
                    "Please select a role."
            );

            return;
        }

        if (role.equals("recruiter")) {
            if (company == null ||
                    company.trim().isEmpty() ||
                    industry == null ||
                    industry.trim().isEmpty()) {

                showError(
                        request,
                        response,
                        "Recruiters must provide company and industry."
                );

                return;
            }
        }

        boolean created =
                signupDAO.createUser(
                        firstName,
                        lastName,
                        email,
                        password,
                        role,
                        location,
                        resume,
                        experience,
                        education,
                        company,
                        industry,
                        skillIds
                );

        if (created) {
            response.sendRedirect(
                    request.getContextPath() + "/login"
            );
        } else {
            showError(
                    request,
                    response,
                    "This email may already be registered."
            );
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);

        request.getRequestDispatcher(
                "/WEB-INF/views/signup.jsp"
        ).forward(request, response);
    }
}