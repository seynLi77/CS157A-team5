package com.lockedin.servlets;

import java.io.IOException;

import com.lockedin.dao.LoginDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles requests for login page.
 *
 * @author Elaine
 */

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private LoginDAO loginDAO;

    @Override
    public void init() {
        loginDAO = new LoginDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean valid =
                loginDAO.validateUser(email, password);

        if (valid) {
            HttpSession session =
                    request.getSession();

            session.setAttribute("email", email);

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute(
                    "error",
                    "Invalid email or password"
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/login.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/login.jsp"
        ).forward(request, response);
    }
}
