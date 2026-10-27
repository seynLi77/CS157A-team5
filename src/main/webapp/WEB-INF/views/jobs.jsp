<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.lockedin.util.HtmlUtil" %>

<%
    List<Map<String, Object>> jobs =
            (List<Map<String, Object>>) request.getAttribute("jobs");

    String ctx = request.getContextPath();
    String query = (String) request.getAttribute("query");
    if (query == null) query = "";
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse jobs — LockedIn</title>
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
                        <mask id="jobs-keyhole-mask">
                            <rect x="0" y="0" width="24" height="24" fill="#FFFFFF"/>
                            <circle cx="12" cy="16.4" r="1.6" fill="#000000"/>
                            <path d="M10.9 19.2H13.1L12.6 22.0C12.6 22.5 11.4 22.5 11.4 22.0Z" fill="#000000"/>
                        </mask>
                    </defs>
                    <path d="M7 9V8C7 4.5 9.5 2 12 2C14.5 2 17 4.5 17 8V9"
                          stroke="#0A66C2" stroke-width="4" stroke-linecap="round" fill="none"/>
                    <rect x="3.5" y="11" width="17" height="12" rx="4"
                          fill="#0A66C2" mask="url(#jobs-keyhole-mask)"/>
                </svg>
            </span>
            LockedIn
        </div>

        <div class="nav-actions">
            <a href="<%= ctx %>/dashboard" class="btn btn-ghost">Dashboard</a>
            <a href="<%= ctx %>/profile" class="btn btn-ghost">My Profile</a>
            <a href="<%= ctx %>/logout" class="btn btn-primary">Sign out</a>
        </div>
    </div>
</nav>

<main class="page">
    <div class="wrap">

        <h1 class="page-title">Open jobs</h1>

        <form class="job-search" method="get" action="<%= ctx %>/jobs" role="search">
            <label for="job-query" class="visually-hidden">Search open jobs</label>
            <input id="job-query" name="q" type="search" maxlength="100"
                   placeholder="Search titles, companies, locations, or skills"
                   value="<%= HtmlUtil.escape(query) %>">
            <button type="submit" class="btn btn-primary">Search</button>
            <% if (!query.isEmpty()) { %>
                <a href="<%= ctx %>/jobs" class="btn btn-ghost">Clear</a>
            <% } %>
        </form>

        <p class="job-results-summary" aria-live="polite">
            <%= jobs == null ? 0 : jobs.size() %> open
            <%= jobs != null && jobs.size() == 1 ? "job" : "jobs" %>
            <% if (!query.isEmpty()) { %>
                matching “<%= HtmlUtil.escape(query) %>”
            <% } else { %>
                ranked by your skills and location
            <% } %>
        </p>

        <% if (request.getAttribute("flashSuccess") != null) { %>
            <div class="flash flash-success">
                <%= HtmlUtil.escape(request.getAttribute("flashSuccess")) %>
            </div>
        <% } %>

        <% if (request.getAttribute("flashError") != null) { %>
            <div class="flash flash-error">
                <%= HtmlUtil.escape(request.getAttribute("flashError")) %>
            </div>
        <% } %>

        <% if (jobs == null || jobs.isEmpty()) { %>
            <p class="empty">
                <%= query.isEmpty() ? "There are no open jobs right now."
                        : "No open jobs match your search. Try a different keyword." %>
            </p>
        <% } else {
               for (Map<String, Object> job : jobs) {
                   Object salary = job.get("salary");
                   String savedPriority = (String) job.get("saved_priority");
                   boolean applied = (Boolean) job.get("applied");
                   int matchedSkills = ((Number) job.get("matched_skills")).intValue();
                   int locationPoints = ((Number) job.get("location_points")).intValue();
        %>

        <article class="job-row">

            <div class="job-main">
                <h2><%= HtmlUtil.escape(job.get("job_name")) %></h2>

                <div class="job-meta">
                    <%= HtmlUtil.escape(job.get("company")) %>
                    · <%= HtmlUtil.escape(job.get("job_location")) %>
                    · <%= HtmlUtil.escape(job.get("job_type")) %>
                    <% if (salary != null) { %>
                        · <%= String.format("$%,.0f", salary) %>
                    <% } %>
                    · Apply by <%= job.get("deadline") %>
                </div>

                <div class="job-match-details" aria-label="Job match details">
                    <span class="match-chip"><%= matchedSkills %> matching
                        <%= matchedSkills == 1 ? "skill" : "skills" %></span>
                    <% if (locationPoints == 3) { %>
                        <span class="match-chip">Location match</span>
                    <% } else if (locationPoints == 1) { %>
                        <span class="match-chip">Remote option</span>
                    <% } %>
                </div>

                <p><%= HtmlUtil.escape(job.get("description")) %></p>
            </div>

            <div class="job-actions">

                <% if (savedPriority != null) { %>

                    <span class="pill pill-saved">
                        Saved · <%= HtmlUtil.escape(savedPriority) %>
                    </span>

                <% } else { %>

                    <form method="post" action="<%= ctx %>/saved-jobs">
                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="return_to" value="jobs">
                        <input type="hidden" name="job_id" value="<%= job.get("job_id") %>">
                        <button type="submit" class="btn btn-ghost">Save</button>
                    </form>

                <% } %>

                <% if (applied) { %>

                    <span class="pill pill-applied">Applied</span>

                <% } else { %>

                    <a class="btn btn-primary"
                       href="<%= ctx %>/apply?job_id=<%= job.get("job_id") %>">Apply</a>

                <% } %>

            </div>

        </article>

        <% } } %>

    </div>
</main>

<footer>
    <div class="wrap">
        <p>© 2026 LockedIn. A student project — CS157A Team 5.</p>
    </div>
</footer>

</body>
</html>
