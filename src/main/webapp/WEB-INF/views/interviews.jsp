<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map,com.lockedin.util.HtmlUtil" %>
<%
String ctx = request.getContextPath();

boolean recruiter =
    Boolean.TRUE.equals(request.getAttribute("isRecruiter"));

List<Map<String,Object>> invitations =
    (List<Map<String,Object>>) request.getAttribute("invitations");

List<Map<String,Object>> applicants =
    (List<Map<String,Object>>) request.getAttribute("applicants");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">
    <title>Interviews | LockedIn</title>

    <link rel="stylesheet" href="<%=ctx%>/css/home.css">

    <style>
        main {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }

        article, form.invite {
            border: 1px solid #ccc;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
        }

        label {
            display: block;
            margin-top: 12px;
        }

        input, select, textarea {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 10px;
        }

        button {
            padding: 10px;
            margin-top: 12px;
            cursor: pointer;
        }

        .message {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .notice {
            padding: 12px;
            border: 1px solid #aaa;
        }
    </style>
</head>
<body>
<main>
    <nav>
        <a href="<%=ctx%>/dashboard">Dashboard</a>

        <% if (recruiter) { %>
            | <a href="<%=ctx%>/recruiter-jobs">Manage jobs</a>
        <% } %>
    </nav>

    <h1>Interview invitations</h1>

    <p>
        All interview times use the application's server time zone.
    </p>

    <%
    for (String key :
            new String[]{"flashSuccess", "flashError"}) {
        if (request.getAttribute(key) != null) {
    %>
        <p class="notice" role="status">
            <%=HtmlUtil.escape(request.getAttribute(key))%>
        </p>
    <% }} %>

    <% if (recruiter) { %>
        <h2>Send an invitation</h2>

        <% if (applicants.isEmpty()) { %>
            <p>
                No applicants yet. Candidates must apply
                to one of your jobs first.
            </p>
        <% } else { %>

            <form class="invite"
                  method="post"
                  action="<%=ctx%>/interviews">

                <input type="hidden"
                       name="token"
                       value="<%=HtmlUtil.escape(session.getAttribute("interviewToken"))%>">

                <input type="hidden"
                       name="action"
                       value="invite">

                <label for="applicant">Candidate and job</label>

                <select id="applicant"
                        name="application_id"
                        required>

                    <% for (Map<String,Object> a : applicants) { %>
                        <option value="<%=HtmlUtil.escape(a.get("application_id"))%>">
                            <%=HtmlUtil.escape(a.get("first_name"))%>
                            <%=HtmlUtil.escape(a.get("last_name"))%>
                            —
                            <%=HtmlUtil.escape(a.get("job_name"))%>
                        </option>
                    <% } %>
                </select>

                <label for="when">Interview date and time</label>
                <input id="when"
                       name="when"
                       type="datetime-local"
                       required>

                <label for="location">
                    Location or meeting details
                </label>
                <input id="location"
                       name="location"
                       maxlength="150"
                       required>

                <label for="message">Message (optional)</label>
                <textarea id="message"
                          name="message"
                          maxlength="5000"
                          rows="4"></textarea>

                <button type="submit">Send invitation</button>
            </form>

    <% }} %>

    <h2>
        <%=recruiter
            ? "Sent invitations and responses"
            : "Your invitations"%>
    </h2>

    <% if (invitations.isEmpty()) { %>
        <p>No interview invitations yet.</p>
    <% } %>

    <% for (Map<String,Object> i : invitations) { %>
        <article>
            <h3>
                <%=HtmlUtil.escape(i.get("job_name"))%>
                —
                <%=HtmlUtil.escape(i.get("company"))%>
            </h3>

            <% if (recruiter) { %>
                <p>
                    Candidate:
                    <%=HtmlUtil.escape(i.get("first_name"))%>
                    <%=HtmlUtil.escape(i.get("last_name"))%>
                </p>
            <% } %>

            <p>
                Date: <%=HtmlUtil.escape(i.get("date"))%>
                | Time: <%=HtmlUtil.escape(i.get("time"))%>
            </p>

            <p>
                Location: <%=HtmlUtil.escape(i.get("location"))%>
            </p>

            <p class="message"><%=HtmlUtil.escape(i.get("message"))%></p>

            <p>
                Status:
                <strong>
                    <%=HtmlUtil.escape(i.get("status"))%>
                </strong>
            </p>

            <% if (!recruiter
                    && "Pending".equals(i.get("status"))) { %>

                <form method="post"
                      action="<%=ctx%>/interviews">

                    <input type="hidden"
                           name="token"
                           value="<%=HtmlUtil.escape(session.getAttribute("interviewToken"))%>">

                    <input type="hidden"
                           name="action"
                           value="respond">

                    <input type="hidden"
                           name="interview_id"
                           value="<%=HtmlUtil.escape(i.get("interview_id"))%>">

                    <button name="status" value="Accepted">
                        Accept
                    </button>

                    <button name="status" value="Declined">
                        Decline
                    </button>
                </form>

            <% } %>
        </article>
    <% } %>
</main>
</body>
</html>
