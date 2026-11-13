package com.lockedin.servlets;

import com.lockedin.dao.InterviewDAO;
import com.lockedin.dao.ProfileDAO;
import com.lockedin.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.Map;
import java.util.UUID;

@WebServlet("/interviews")
public class InterviewServlet extends HttpServlet {

    private final InterviewDAO interviews = new InterviewDAO();
    private final ProfileDAO profiles = new ProfileDAO();

    private Map<String, Object> account(HttpServletRequest req)
            throws SQLException {

        String email = SessionUtil.getEmail(req);

        return email == null
            ? null
            : profiles.findProfileByEmail(email);
    }

    private boolean allowed(Map<String, Object> p) {
        return p != null
            && ("recruiter".equals(p.get("role"))
                || "job_seeker".equals(p.get("role")));
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Map<String, Object> p = account(req);

            if (p == null) {
                resp.sendRedirect(
                    req.getContextPath() + "/login"
                );
                return;
            }

            if (!allowed(p)) {
                resp.sendError(403);
                return;
            }

            boolean recruiter =
                "recruiter".equals(p.get("role"));

            int id = (Integer) p.get("user_id");
            HttpSession session = req.getSession();

            if (session.getAttribute("interviewToken") == null) {
                session.setAttribute(
                    "interviewToken",
                    UUID.randomUUID().toString()
                );
            }

            req.setAttribute("isRecruiter", recruiter);
            req.setAttribute(
                "invitations",
                interviews.invitations(id, recruiter)
            );

            if (recruiter) {
                req.setAttribute(
                    "applicants",
                    interviews.applicants(id)
                );
            }

            SessionUtil.moveFlashToRequest(req);

            req.getRequestDispatcher(
                "/WEB-INF/views/interviews.jsp"
            ).forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load interviews.", e
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            Map<String, Object> p = account(req);

            if (!allowed(p)) {
                resp.sendError(403);
                return;
            }

            Object token = req.getSession()
                .getAttribute("interviewToken");

            if (token == null
                    || !token.equals(req.getParameter("token"))) {
                resp.sendError(403);
                return;
            }

            int id = (Integer) p.get("user_id");
            String action = value(req, "action");

            if ("invite".equals(action)
                    && "recruiter".equals(p.get("role"))) {

                LocalDateTime when = LocalDateTime.parse(
                    value(req, "when")
                );

                if (!when.isAfter(LocalDateTime.now())) {
                    throw new IllegalArgumentException(
                        "Choose a future date and time."
                    );
                }

                String location = value(req, "location");
                String message = value(req, "message");

                if (location.isEmpty()
                        || location.length() > 150) {
                    throw new IllegalArgumentException(
                        "Enter a location of up to 150 characters."
                    );
                }

                if (message.length() > 5000) {
                    throw new IllegalArgumentException(
                        "Message must be 5,000 characters or fewer."
                    );
                }

                boolean sent = interviews.invite(
                    id,
                    Integer.parseInt(
                        value(req, "application_id")
                    ),
                    when,
                    location,
                    message
                );

                if (!sent) {
                    throw new IllegalArgumentException(
                        "Applicant not found for your job postings."
                    );
                }

                SessionUtil.setFlash(
                    req,
                    "Interview invitation sent.",
                    false
                );

            } else if ("respond".equals(action)
                    && "job_seeker".equals(p.get("role"))) {

                boolean saved = interviews.respond(
                    id,
                    Integer.parseInt(
                        value(req, "interview_id")
                    ),
                    value(req, "status")
                );

                if (!saved) {
                    throw new IllegalArgumentException(
                        "Invitation is unavailable, expired, " +
                        "or already answered."
                    );
                }

                SessionUtil.setFlash(
                    req,
                    "Your response has been saved.",
                    false
                );

            } else {
                resp.sendError(403);
                return;
            }

        } catch (DateTimeParseException e) {
            SessionUtil.setFlash(
                req,
                "Enter a valid interview date and time.",
                true
            );

        } catch (IllegalArgumentException e) {
            SessionUtil.setFlash(
                req,
                e instanceof NumberFormatException
                    ? "Invalid invitation or application ID."
                    : e.getMessage(),
                true
            );

        } catch (SQLException e) {
            log("Unable to save interview", e);

            SessionUtil.setFlash(
                req,
                "Unable to save the invitation. Please try again.",
                true
            );
        }

        resp.sendRedirect(
            req.getContextPath() + "/interviews"
        );
    }

    private static String value(
            HttpServletRequest req, String name) {

        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }
}
