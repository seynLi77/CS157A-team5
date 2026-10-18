<%--
    Displays the profile page.

    Author: Elaine
--%>

<%@ page contentType="text/html;charset=UTF-8"
         language="java" %>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>

<%
    Map<String, Object> profile =
            (Map<String, Object>)
            request.getAttribute("profile");

    String role = "";

    if (profile != null &&
            profile.get("role") != null) {

        role = (String) profile.get("role");
    }

    String error =
            (String) request.getAttribute("error");

    String success =
            (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Profile — LockedIn</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/profile.css">
</head>

<body>

<nav class="navbar">
    <div class="nav-content">

        <a class="logo"
           href="<%= request.getContextPath() %>/dashboard">
            <span class="logo-mark">🔒</span>
            LockedIn
        </a>

        <div class="nav-actions">
            <a href="<%= request.getContextPath() %>/dashboard"
               class="back-link">
                Back to dashboard
            </a>
        </div>

    </div>
</nav>

<main class="profile-page">

    <section class="profile-card">

        <div class="profile-heading">
            <p class="eyebrow">ACCOUNT SETTINGS</p>

            <h1>My Profile</h1>

            <p>
                Update your personal information below.
            </p>
        </div>

        <% if (error != null) { %>

            <div class="message error-message">
                <%= error %>
            </div>

        <% } %>

        <% if (success != null) { %>

            <div class="message success-message">
                <%= success %>
            </div>

        <% } %>

        <% if (profile != null) { %>

        <form method="post"
              action="<%= request.getContextPath() %>/profile">

            <div class="form-section">
                <h2>Basic Information</h2>

                <div class="two-column">

                    <div class="form-group">
                        <label for="first_name">
                            First name
                        </label>

                        <input type="text"
                               id="first_name"
                               name="first_name"
                               value="<%= profile.get("first_name") %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="last_name">
                            Last name
                        </label>

                        <input type="text"
                               id="last_name"
                               name="last_name"
                               value="<%= profile.get("last_name") %>"
                               required>
                    </div>

                </div>

                <div class="form-group">
                    <label for="email">
                        Email
                    </label>

                    <input type="email"
                           id="email"
                           value="<%= profile.get("email") %>"
                           readonly>

                    <small>
                        Email cannot be changed here.
                    </small>
                </div>

                <div class="form-group">
                    <label for="password">
                        New password
                    </label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Leave blank to keep current password">

                    <small>
                        Leave this blank if you do not want to change it.
                    </small>
                </div>

                <div class="form-group">
                    <label>
                        Role
                    </label>

                    <input type="text"
                           value="<%= role %>"
                           readonly>
                </div>
            </div>

            <% if ("job_seeker".equals(role)) { %>

            <div class="form-section">
                <h2>Job Seeker Information</h2>

                <div class="form-group">
                    <label for="location">
                        Location
                    </label>

                    <input type="text"
                           id="location"
                           name="location"
                           value="<%= profile.get("location") == null
                                   ? ""
                                   : profile.get("location") %>">
                </div>

                <div class="form-group">
                    <label for="resume_link">
                        Resume link
                    </label>

                    <input type="text"
                           id="resume_link"
                           name="resume_link"
                           value="<%= profile.get("resume_link") == null
                                   ? ""
                                   : profile.get("resume_link") %>"
                           placeholder="Paste your resume link">
                </div>

                <div class="form-group">
                    <label for="experience">
                        Experience
                    </label>

                    <textarea id="experience"
                              name="experience"><%= profile.get("experience") == null
                                ? ""
                                : profile.get("experience") %></textarea>
                </div>

                <div class="form-group">
                    <label for="education">
                        Education
                    </label>

                    <textarea id="education"
                              name="education"><%= profile.get("education") == null
                                ? ""
                                : profile.get("education") %></textarea>
                </div>

                <div class="form-group">
                    <label for="skill_ids">
                        Skills
                    </label>

                    <%
                        List<Map<String, Object>> skills =
                                (List<Map<String, Object>>)
                                request.getAttribute("skills");

                        Set<Integer> selectedSkillIds =
                                (Set<Integer>)
                                request.getAttribute(
                                        "selectedSkillIds"
                                );
                    %>

                    <select id="skill_ids"
                            name="skill_ids"
                            multiple
                            size="8">

                        <% if (skills != null) {
                            for (Map<String, Object> skill : skills) {

                                int skillId =
                                        (Integer)
                                        skill.get("skill_id");

                                String skillName =
                                        (String)
                                        skill.get("name");

                                boolean selected =
                                        selectedSkillIds != null &&
                                        selectedSkillIds.contains(skillId);
                        %>

                            <option value="<%= skillId %>"
                                    <%= selected
                                            ? "selected"
                                            : "" %>>
                                <%= skillName %>
                            </option>

                        <%  }
                           }
                        %>
                    </select>

                    <small>
                        Hold Ctrl or Command to select multiple skills.
                    </small>
                </div>
            </div>

            <% } %>

            <% if ("recruiter".equals(role)) { %>

            <div class="form-section">
                <h2>Recruiter Information</h2>

                <div class="form-group">
                    <label for="company">
                        Company
                    </label>

                    <input type="text"
                           id="company"
                           name="company"
                           value="<%= profile.get("company") == null
                                   ? ""
                                   : profile.get("company") %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="industry">
                        Industry
                    </label>

                    <input type="text"
                           id="industry"
                           name="industry"
                           value="<%= profile.get("industry") == null
                                   ? ""
                                   : profile.get("industry") %>"
                           required>
                </div>
            </div>

            <% } %>

            <button type="submit"
                    class="save-button">
                Save changes
            </button>

        </form>

        <% } %>

    </section>

</main>

<footer>
    <p>
        © 2026 LockedIn.
        A student project — CS157A Team 5.
    </p>
</footer>

</body>
</html>