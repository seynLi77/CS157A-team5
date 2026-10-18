<%--
    Displays the signup page. Use login.css.

    Author: Elaine
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sign up — LockedIn</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/login.css">

    <style>
        .name-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        select,
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #d8e0e9;
            border-radius: 9px;
            color: #172033;
            background: #ffffff;
            font-size: 15px;
            font-family: inherit;
            outline: none;
        }

        select {
            height: 48px;
        }

        select[multiple] {
            height: auto;
            min-height: 180px;
        }

        select:focus,
        textarea:focus {
            border-color: #0A66C2;
            box-shadow: 0 0 0 3px rgba(10, 102, 194, 0.12);
        }

        textarea {
            min-height: 85px;
            resize: vertical;
        }

        small {
            display: block;
            margin-top: 6px;
            color: #718096;
            font-size: 12px;
        }

        /* Skill cards */
        .skill-select {
            display: none;
        }

        .skills-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 10px;
        }

        .skill-option {
            cursor: pointer;
        }

        .skill-option input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .skill-card {
            display: block;
            padding: 10px 12px;
            border: 1px solid #d8e0e9;
            border-radius: 9px;
            background: #ffffff;
            color: #172033;
            font-size: 13px;
            text-align: center;
            transition: all 0.2s ease;
        }

        .skill-card:hover {
            border-color: #70B5F9;
            color: #0A66C2;
        }

        .skill-option input:checked + .skill-card {
            background: #0A66C2;
            border-color: #0A66C2;
            color: #ffffff;
            font-weight: 600;
        }

        @media (max-width: 700px) {
            .skills-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .name-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="wrap navbar-inner">

        <a class="logo"
           href="<%= request.getContextPath() %>/home">

            <span class="logo-mark">🔒</span>

            LockedIn
        </a>

        <a class="back-home"
           href="<%= request.getContextPath() %>/login">
            Already have an account?
        </a>

    </div>
</nav>


<main class="login-page">

    <section class="login-card">

        <div class="login-heading">

            <p class="eyebrow">
                JOIN LOCKEDIN
            </p>

            <h1>
                Create account.
            </h1>

            <p class="subtitle">
                Start your next career opportunity.
            </p>

        </div>


        <%
            String error =
                    (String) request.getAttribute("error");

            if (error != null) {
        %>

            <div class="error-message">
                <%= error %>
            </div>

        <%
            }
        %>


        <form method="post"
              action="<%= request.getContextPath() %>/signup">

            <div class="name-row">

                <div class="form-group">

                    <label for="first_name">
                        First name
                    </label>

                    <input type="text"
                           id="first_name"
                           name="first_name"
                           required>

                </div>


                <div class="form-group">

                    <label for="last_name">
                        Last name
                    </label>

                    <input type="text"
                           id="last_name"
                           name="last_name"
                           required>

                </div>

            </div>


            <div class="form-group">

                <label for="email">
                    Email
                </label>

                <input type="email"
                       id="email"
                       name="email"
                       placeholder="you@example.com"
                       required>

            </div>


            <div class="form-group">

                <label for="password">
                    Password
                </label>

                <input type="password"
                       id="password"
                       name="password"
                       required>

            </div>


            <div class="form-group">

                <label for="role">
                    I am a:
                </label>

                <select id="role"
                        name="role"
                        required>

                    <option value="">
                        Select a role
                    </option>

                    <option value="job_seeker">
                        Job seeker
                    </option>

                    <option value="recruiter">
                        Recruiter
                    </option>

                    <option value="admin">
                        Admin
                    </option>

                </select>

            </div>


            <!-- Job seeker fields -->

            <div id="job-seeker-fields"
                 style="display: none;">

                <div class="form-group">

                    <label for="location">
                        Location
                    </label>

                    <input type="text"
                           id="location"
                           name="location"
                           placeholder="e.g. Fremont, CA">

                </div>


                <div class="form-group">

                    <label for="resume">
                        Resume
                    </label>

                    <textarea id="resume"
                              name="resume"
                              placeholder="Paste your resume information"></textarea>

                </div>


                <div class="form-group">

                    <label for="experience">
                        Experience
                    </label>

                    <textarea id="experience"
                              name="experience"
                              placeholder="Describe your experience"></textarea>

                </div>


                <div class="form-group">

                    <label for="education">
                        Education
                    </label>

                    <textarea id="education"
                              name="education"
                              placeholder="Describe your education"></textarea>

                </div>


                <div class="form-group">

                    <label for="skills">
                        Skills
                    </label>

                    <div class="skills-grid">

                        <%
                            String[][] skills = {
                                {"1", "SQL"},
                                {"2", "Python"},
                                {"3", "Java"},
                                {"4", "JavaScript"},
                                {"5", "React"},
                                {"6", "AWS"},
                                {"7", "Docker"},
                                {"8", "Project Management"},
                                {"9", "Cybersecurity"},
                                {"10", "Data Visualization"},
                                {"11", "C++"},
                                {"12", "C#"},
                                {"13", "Go"},
                                {"14", "Ruby"},
                                {"15", "HTML"},
                                {"16", "CSS"},
                                {"17", "Node.js"},
                                {"18", "Angular"},
                                {"19", "Vue.js"},
                                {"20", "Spring Boot"},
                                {"21", ".NET"},
                                {"22", "Django"},
                                {"23", "Flask"},
                                {"24", "Git"},
                                {"25", "Linux"},
                                {"26", "Kubernetes"},
                                {"27", "Terraform"},
                                {"28", "Jenkins"},
                                {"29", "Azure"},
                                {"30", "Google Cloud Platform"},
                                {"31", "PostgreSQL"},
                                {"32", "MongoDB"},
                                {"33", "REST APIs"},
                                {"34", "GraphQL"},
                                {"35", "Tableau"},
                                {"36", "Power BI"},
                                {"37", "Microsoft Excel"},
                                {"38", "Machine Learning"},
                                {"39", "Deep Learning"},
                                {"40", "Data Analysis"},
                                {"41", "Statistics"},
                                {"42", "Natural Language Processing"},
                                {"43", "Computer Vision"},
                                {"44", "Unit Testing"},
                                {"45", "Agile"},
                                {"46", "Scrum"},
                                {"47", "Communication"},
                                {"48", "Leadership"},
                                {"49", "Problem Solving"},
                                {"50", "Teamwork"}
                            };

                            for (String[] skill : skills) {
                        %>

                            <label class="skill-option">

                                <input type="checkbox"
                                       name="skill_ids"
                                       value="<%= skill[0] %>">

                                <span class="skill-card">
                                    <%= skill[1] %>
                                </span>

                            </label>

                        <%
                            }
                        %>

                    </div>

                </div>

            </div>


            <!-- Recruiter fields -->

            <div id="recruiter-fields"
                 style="display: none;">

                <div class="form-group">

                    <label for="company">
                        Company
                    </label>

                    <input type="text"
                           id="company"
                           name="company">

                </div>


                <div class="form-group">

                    <label for="industry">
                        Industry
                    </label>

                    <input type="text"
                           id="industry"
                           name="industry">

                </div>

            </div>


            <button type="submit"
                    class="login-button">
                Create account
            </button>

        </form>


        <p class="signup-text">

            Already have an account?

            <a href="<%= request.getContextPath() %>/login">
                Log in
            </a>

        </p>

    </section>

</main>


<footer>

    <p>
        © 2026 LockedIn.
        A student project — CS157A Team 5.
    </p>

</footer>


<script>
    const roleSelect =
        document.getElementById("role");

    const jobSeekerFields =
        document.getElementById("job-seeker-fields");

    const recruiterFields =
        document.getElementById("recruiter-fields");

    roleSelect.addEventListener("change", function () {

        jobSeekerFields.style.display = "none";
        recruiterFields.style.display = "none";

        if (this.value === "job_seeker") {
            jobSeekerFields.style.display = "block";
        }

        if (this.value === "recruiter") {
            recruiterFields.style.display = "block";
        }

    });
</script>

</body>
</html>