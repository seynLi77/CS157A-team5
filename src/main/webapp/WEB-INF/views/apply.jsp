<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.lockedin.util.HtmlUtil" %>

<%
    Map<String, Object> job =
            (Map<String, Object>) request.getAttribute("job");

    boolean alreadyApplied =
            Boolean.TRUE.equals(request.getAttribute("alreadyApplied"));

    boolean isOpen = (Boolean) job.get("is_open");

    String resumeLink = (String) request.getAttribute("resumeLink");
    String message = (String) request.getAttribute("message");

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply — LockedIn</title>
    <link rel="stylesheet" href="<%= ctx %>/css/home.css">
    <link rel="stylesheet" href="<%= ctx %>/css/jobs.css">
</head>

<body>

<nav class="navbar">
    <div class="wrap">
        <div class="logo">
            <span class="logo-mark">
                <svg width="26" height="26" viewBox="0 0 24 24">
                    <defs>
                        <mask id="apply-keyhole-mask">
                            <rect x="0" y="0" width="24" height="24" fill="#FFFFFF"/>
                            <circle cx="12" cy="16.4" r="1.6" fill="#000000"/>
                            <path d="M10.9 19.2H13.1L12.6 22.0C12.6 22.5 11.4 22.5 11.4 22.0Z" fill="#000000"/>
                        </mask>
                    </defs>
                    <path d="M7 9V8C7 4.5 9.5 2 12 2C14.5 2 17 4.5 17 8V9"
                          stroke="#0A66C2" stroke-width="4" stroke-linecap="round" fill="none"/>
                    <rect x="3.5" y="11" width="17" height="12" rx="4"
                          fill="#0A66C2" mask="url(#apply-keyhole-mask)"/>
                </svg>
            </span>
            LockedIn
        </div>

        <div class="nav-actions">
            <a href="<%= ctx %>/jobs" class="btn btn-ghost">Browse jobs</a>
            <a href="<%= ctx %>/dashboard" class="btn btn-ghost">Dashboard</a>
            <a href="<%= ctx %>/logout" class="btn btn-primary">Sign out</a>
        </div>
    </div>
</nav>

<main class="page">
    <div class="wrap narrow">

        <h1 class="page-title">
            Apply: <%= HtmlUtil.escape(job.get("job_name")) %>
        </h1>

        <div class="job-meta">
            <%= HtmlUtil.escape(job.get("company")) %>
            · <%= HtmlUtil.escape(job.get("job_location")) %>
            · <%= HtmlUtil.escape(job.get("job_type")) %>
        </div>

        <% if (request.getAttribute("flashError") != null) { %>
            <div class="flash flash-error">
                <%= HtmlUtil.escape(request.getAttribute("flashError")) %>
            </div>
        <% } %>

        <% if (alreadyApplied) { %>

            <div class="flash flash-success">
                You have already applied to this job.
            </div>

        <% } else if (!isOpen) { %>

            <div class="flash flash-error">
                This job posting is no longer open.
            </div>

        <% } else { %>

        <form method="post" action="<%= ctx %>/apply" class="form-card">

            <input type="hidden" name="job_id" value="<%= job.get("job_id") %>">

            <label for="resume_link">Resume</label>
            <input type="text" id="resume_link" name="resume_link"
                   maxlength="255" required
                   placeholder="Link or file name of your resume"
                   value="<%= HtmlUtil.escape(resumeLink) %>">
            <small>Pre-filled from your profile; change it for this application if you like.</small>

            <label for="message">Message to the recruiter (optional)</label>
            <textarea id="message" name="message" rows="7"
                      maxlength="5000"><%= HtmlUtil.escape(message) %></textarea>

            <div class="form-actions">
                <a class="btn btn-ghost" href="<%= ctx %>/jobs">Cancel</a>
                <button type="submit" class="btn btn-primary">Submit application</button>
            </div>

        </form>

        <% } %>

    </div>
</main>

<footer>
    <div class="wrap">
        <p>© 2026 LockedIn. A student project — CS157A Team 5.</p>
    </div>
</footer>

</body>
</html>
