<%--
    Displays the user's dashboard.

    Author: Elaine and Jumana
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.lockedin.dao.SavedJobDAO" %>
<%@ page import="com.lockedin.util.HtmlUtil" %>

<%
    List<Map<String, Object>> savedJobs =
            (List<Map<String, Object>>) request.getAttribute("savedJobs");

    List<Map<String, Object>> applications =
            (List<Map<String, Object>>) request.getAttribute("applications");

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard — LockedIn</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/home.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/jobs.css">
</head>

<body>

<nav class="navbar">

    <div class="wrap">

        <div class="logo">

            <span class="logo-mark">

                <svg width="26"
                     height="26"
                     viewBox="0 0 24 24">

                    <defs>
                        <mask id="dashboard-keyhole-mask">

                            <rect x="0"
                                  y="0"
                                  width="24"
                                  height="24"
                                  fill="#FFFFFF"/>

                            <circle cx="12"
                                    cy="16.4"
                                    r="1.6"
                                    fill="#000000"/>

                            <path d="M10.9 19.2H13.1L12.6 22.0
                                     C12.6 22.5 11.4 22.5 11.4 22.0Z"
                                  fill="#000000"/>

                        </mask>
                    </defs>

                    <path d="M7 9V8C7 4.5 9.5 2 12 2
                             C14.5 2 17 4.5 17 8V9"
                          stroke="#0A66C2"
                          stroke-width="4"
                          stroke-linecap="round"
                          fill="none"/>

                    <rect x="3.5"
                          y="11"
                          width="17"
                          height="12"
                          rx="4"
                          fill="#0A66C2"
                          mask="url(#dashboard-keyhole-mask)"/>

                </svg>

            </span>

            LockedIn

        </div>


        <div class="nav-actions">

            <% if (savedJobs != null) { %>
            <a href="<%= request.getContextPath() %>/jobs"
               class="btn btn-ghost">
                Browse jobs
            </a>
            <% } %>

            <a href="<%= request.getContextPath() %>/profile"
               class="btn btn-ghost">
                My Profile
            </a>

            <a href="<%= request.getContextPath() %>/logout"
               class="btn btn-primary">
                Sign out
            </a>

        </div>

    </div>

</nav>


<% if (savedJobs != null) { %>

<main class="page">

    <div class="wrap">

        <h1 class="page-title">Your dashboard</h1>

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

        <h2 class="section-title">Saved jobs</h2>

        <% if (savedJobs.isEmpty()) { %>

            <p class="empty">
                You haven't saved any jobs yet.
                <a class="inline-link" href="<%= ctx %>/jobs">Browse open jobs</a>
            </p>

        <% } else { %>

        <div class="table-scroll">
        <table class="data-table">

            <thead>
                <tr>
                    <th>Job</th>
                    <th>Company</th>
                    <th>Location</th>
                    <th>Priority</th>
                    <th></th>
                </tr>
            </thead>

            <tbody>

            <% for (Map<String, Object> job : savedJobs) {
                   String priority = (String) job.get("priority");
                   boolean applied = (Boolean) job.get("applied");
                   boolean open = (Boolean) job.get("is_open");
            %>

                <tr>
                    <td>
                        <strong><%= HtmlUtil.escape(job.get("job_name")) %></strong>
                        <% if (!open) { %>
                            <span class="pill pill-closed">Closed</span>
                        <% } %>
                    </td>

                    <td><%= HtmlUtil.escape(job.get("company")) %></td>

                    <td><%= HtmlUtil.escape(job.get("job_location")) %></td>

                    <td>
                        <form method="post" action="<%= ctx %>/saved-jobs"
                              class="inline-form">
                            <input type="hidden" name="action" value="priority">
                            <input type="hidden" name="job_id"
                                   value="<%= job.get("job_id") %>">

                            <select name="priority"
                                    class="priority-select priority-<%= priority.toLowerCase() %>"
                                    aria-label="Priority"
                                    onchange="this.form.submit()">
                                <% for (String p : SavedJobDAO.PRIORITIES) { %>
                                    <option value="<%= p %>"
                                        <%= p.equals(priority) ? "selected" : "" %>>
                                        <%= p %>
                                    </option>
                                <% } %>
                            </select>

                            <noscript>
                                <button type="submit" class="btn btn-ghost btn-small">
                                    Update
                                </button>
                            </noscript>
                        </form>
                    </td>

                    <td class="row-actions">

                        <% if (applied) { %>
                            <span class="pill pill-applied">Applied</span>
                        <% } else if (open) { %>
                            <a class="btn btn-primary btn-small"
                               href="<%= ctx %>/apply?job_id=<%= job.get("job_id") %>">
                                Apply
                            </a>
                        <% } %>

                        <form method="post" action="<%= ctx %>/saved-jobs"
                              class="inline-form">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="job_id"
                                   value="<%= job.get("job_id") %>">
                            <button type="submit"
                                    class="btn btn-ghost btn-small">
                                Remove
                            </button>
                        </form>

                    </td>
                </tr>

            <% } %>

            </tbody>
        </table>
        </div>

        <% } %>


        <h2 class="section-title">Your applications</h2>

        <% if (applications == null || applications.isEmpty()) { %>

            <p class="empty">You haven't applied to any jobs yet.</p>

        <% } else { %>

        <div class="table-scroll">
        <table class="data-table">

            <thead>
                <tr>
                    <th>Job</th>
                    <th>Company</th>
                    <th>Applied on</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
            <% for (Map<String, Object> app : applications) { %>
                <tr>
                    <td><strong><%= HtmlUtil.escape(app.get("job_name")) %></strong></td>
                    <td><%= HtmlUtil.escape(app.get("company")) %></td>
                    <td><%= app.get("submission_date") %></td>
                    <td><span class="pill pill-status"><%= HtmlUtil.escape(app.get("status")) %></span></td>
                </tr>
            <% } %>
            </tbody>
        </table>
        </div>

        <% } %>

    </div>

</main>

<% } else { %>

<main>

    <section class="section dashboard-section">

        <div class="wrap">

            <div class="dashboard-copy">

                <h2>
                    Your dashboard
                </h2>

                <p>
                    Track your applications, discover new opportunities,
                    and manage your job search in one place.
                </p>

                <a href="<%= request.getContextPath() %>/profile"
                   class="btn btn-primary">
                    View your profile
                </a>

            </div>


            <div class="dashboard-mock">

                <div class="dashboard-mock-header">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>


                <div class="mock-row">

                    <div>
                        <div class="title">
                            Dashboard content
                        </div>

                        <div class="company">
                            Your applications and job recommendations
                            will appear here.
                        </div>
                    </div>

                    <div>
                        <span class="mock-pill interviewing">
                            Coming soon
                        </span>
                    </div>

                    <div class="mock-days">
                        LockedIn
                    </div>

                </div>


                <div class="mock-row">

                    <div>
                        <div class="title">
                            Keep your profile updated
                        </div>

                        <div class="company">
                            Complete your profile to improve your
                            job search experience.
                        </div>
                    </div>

                    <div>
                        <span class="mock-pill review">
                            Profile
                        </span>
                    </div>

                    <div class="mock-days">

                        <a href="<%= request.getContextPath() %>/profile">
                            View
                        </a>

                    </div>

                </div>

            </div>

        </div>

    </section>

</main>

<% } %>


<footer>

    <div class="wrap">

        <p>
            © 2026 LockedIn.
            A student project — CS157A Team 5.
        </p>

    </div>

</footer>

</body>
</html>
