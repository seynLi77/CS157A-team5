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
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/recruiter-jobs")
public class RecruiterJobsServlet extends HttpServlet {
    private final RecruiterJobDAO jobs = new RecruiterJobDAO();
    private final ProfileDAO profiles = new ProfileDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer recruiterId = recruiterId(req);
        if (recruiterId == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        try {
            req.setAttribute("recruiterJobs", jobs.findByRecruiter(recruiterId));
            String id = req.getParameter("edit");
            if (id != null && !id.isBlank()) req.setAttribute("editJob", jobs.findOwned(Integer.parseInt(id), recruiterId));
            SessionUtil.moveFlashToRequest(req);
            req.getRequestDispatcher("/WEB-INF/views/recruiter-jobs.jsp").forward(req, resp);
        } catch (NumberFormatException e) { resp.sendError(400, "Invalid job ID."); }
          catch (SQLException e) { throw new ServletException("Unable to load recruiter jobs.", e); }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer recruiterId = recruiterId(req);
        if (recruiterId == null) { resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Recruiter access required."); return; }
        try {
            String action = value(req, "action");
            int id = 0;
            if ("delete".equals(action) || "update".equals(action)) {
                id = parseId(req.getParameter("job_id"));
            }
            if ("delete".equals(action)) { if (!jobs.delete(id, recruiterId)) throw new IllegalArgumentException("Posting not found or not owned by you."); }
            else if ("update".equals(action)) { if (!jobs.update(id, recruiterId, value(req,"title"), pay(req.getParameter("pay")), value(req,"location"), value(req,"job_type"), deadline(req.getParameter("deadline")), value(req,"description"), value(req,"qualifications"), value(req,"skills"), value(req,"status"))) throw new IllegalArgumentException("Posting not found or not owned by you."); }
            else if ("create".equals(action)) jobs.create(recruiterId, value(req,"title"), pay(req.getParameter("pay")), value(req,"location"), value(req,"job_type"), deadline(req.getParameter("deadline")), value(req,"description"), value(req,"qualifications"), value(req,"skills"), "open");
            else throw new IllegalArgumentException("Unknown action.");
            SessionUtil.setFlash(req, "Job posting saved.", false);
        } catch (IllegalArgumentException | SQLException e) { SessionUtil.setFlash(req, e.getMessage(), true); }
        resp.sendRedirect(req.getContextPath() + "/recruiter-jobs");
    }

    private Integer recruiterId(HttpServletRequest req) throws ServletException { try { String email = SessionUtil.getEmail(req); if (email == null) return null; java.util.Map<String,Object> p = profiles.findProfileByEmail(email); if (p == null || !"recruiter".equals(p.get("role"))) return null; return (Integer)p.get("user_id"); } catch (SQLException e) { throw new ServletException("Unable to verify recruiter account.", e); } }
    private static String value(HttpServletRequest r, String name) { String v = r.getParameter(name); return v == null ? "" : v.trim(); }
    private static int parseId(String v) { try { return Integer.parseInt(v); } catch (Exception e) { throw new IllegalArgumentException("Invalid job ID."); } }
    private static BigDecimal pay(String v) { if (v == null || v.trim().isEmpty()) return null; try { BigDecimal n = new BigDecimal(v.trim()); if (n.signum() < 0 || n.compareTo(new BigDecimal("999999999.99")) > 0) throw new NumberFormatException(); return n; } catch (NumberFormatException e) { throw new IllegalArgumentException("Pay must be between 0 and 999,999,999.99."); } }
    private static Date deadline(String v) { if (v == null || v.trim().isEmpty()) throw new IllegalArgumentException("Deadline is required."); try { Date date = Date.valueOf(v); if (date.toLocalDate().isBefore(LocalDate.now())) throw new IllegalArgumentException("Deadline must be today or a future date."); return date; } catch (IllegalArgumentException e) { if ("Deadline must be today or a future date.".equals(e.getMessage())) throw e; throw new IllegalArgumentException("Enter a valid deadline."); } }
}
