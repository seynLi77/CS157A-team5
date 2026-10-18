package com.lockedin.servlets;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.lockedin.dao.ProfileDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles requests for user profile page.
 *
 * @author Elaine
 */

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private ProfileDAO profileDAO;

    @Override
    public void init() {
        profileDAO = new ProfileDAO();
    }

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

        String email =
                (String) session.getAttribute("email");

        showProfilePage(
                request,
                response,
                email
        );
    }

    @Override
    protected void doPost(
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

        String email =
                (String) session.getAttribute("email");

        String firstName =
                request.getParameter("first_name");

        String lastName =
                request.getParameter("last_name");

        String password =
                request.getParameter("password");

        String location =
                request.getParameter("location");

        String resumeLink =
                request.getParameter("resume_link");

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

        String errorMessage =
                profileDAO.updateProfile(
                        email,
                        firstName,
                        lastName,
                        password,
                        location,
                        resumeLink,
                        experience,
                        education,
                        company,
                        industry,
                        skillIds
                );

        if (errorMessage == null) {

            request.setAttribute(
                    "success",
                    "Your profile has been updated."
            );

            showProfilePage(
                    request,
                    response,
                    email
            );

        } else {

            request.setAttribute(
                    "error",
                    errorMessage
            );

            showProfilePage(
                    request,
                    response,
                    email
            );
        }
    }

    private void showProfilePage(
            HttpServletRequest request,
            HttpServletResponse response,
            String email)
            throws ServletException, IOException {

        try {
            Map<String, Object> profile =
                    profileDAO.findProfileByEmail(email);

            if (profile == null) {
                response.sendRedirect(
                        request.getContextPath() + "/login"
                );

                return;
            }

            request.setAttribute(
                    "profile",
                    profile
            );

            String role =
                    (String) profile.get("role");

            if ("job_seeker".equals(role)) {

                int userId =
                        (Integer) profile.get("user_id");

                List<Map<String, Object>> skills =
                        profileDAO.getAllSkills();

                Set<Integer> selectedSkillIds =
                        profileDAO.getSelectedSkillIds(
                                userId
                        );

                request.setAttribute(
                        "skills",
                        skills
                );

                request.setAttribute(
                        "selectedSkillIds",
                        selectedSkillIds
                );
            }

            request.getRequestDispatcher(
                    "/WEB-INF/views/profile.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Could not load profile: "
                            + e.getMessage()
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/profile.jsp"
            ).forward(request, response);
        }
    }
}