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
            <p class="eyebrow">JOIN LOCKEDIN</p>

            <h1>Create account.</h1>

            <p class="subtitle">
                Start your next career opportunity.
            </p>
        </div>

        <%
            String error = (String) request.getAttribute("error");

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
                    <label for="first_name">First name</label>

                    <input type="text"
                           id="first_name"
                           name="first_name"
                           required>
                </div>

                <div class="form-group">
                    <label for="last_name">Last name</label>

                    <input type="text"
                           id="last_name"
                           name="last_name"
                           required>
                </div>

            </div>

            <div class="form-group">
                <label for="email">Email</label>

                <input type="email"
                       id="email"
                       name="email"
                       placeholder="you@example.com"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <input type="password"
                       id="password"
                       name="password"
                       required>
            </div>

            <div class="form-group">
                <label for="role">I am a:</label>

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
                    <label for="location">Location</label>

                    <input type="text"
                           id="location"
                           name="location"
                           placeholder="e.g. Fremont, CA">
                </div>

                <div class="form-group">
                    <label for="resume">Resume</label>

                    <textarea id="resume"
                              name="resume"
                              placeholder="Paste your resume information">
                    </textarea>
                </div>

                <div class="form-group">
                    <label for="experience">Experience</label>

                    <textarea id="experience"
                              name="experience"
                              placeholder="Describe your experience">
                    </textarea>
                </div>

                <div class="form-group">
                    <label for="education">Education</label>

                    <textarea id="education"
                              name="education"
                              placeholder="Describe your education">
                    </textarea>
                </div>

                <div class="form-group">
                    <label for="skills">Skills</label>

                    <select id="skills"
                            name="skill_ids"
                            multiple
                            size="8">

                        <option value="1">SQL</option>
                        <option value="2">Python</option>
                        <option value="3">Java</option>
                        <option value="4">JavaScript</option>
                        <option value="5">React</option>
                        <option value="6">AWS</option>
                        <option value="7">Docker</option>
                        <option value="8">Project Management</option>
                        <option value="9">Cybersecurity</option>
                        <option value="10">Data Visualization</option>
                        <option value="11">C++</option>
                        <option value="12">C#</option>
                        <option value="13">Go</option>
                        <option value="14">Ruby</option>
                        <option value="15">HTML</option>
                        <option value="16">CSS</option>
                        <option value="17">Node.js</option>
                        <option value="18">Angular</option>
                        <option value="19">Vue.js</option>
                        <option value="20">Spring Boot</option>
                        <option value="21">.NET</option>
                        <option value="22">Django</option>
                        <option value="23">Flask</option>
                        <option value="24">Git</option>
                        <option value="25">Linux</option>
                        <option value="26">Kubernetes</option>
                        <option value="27">Terraform</option>
                        <option value="28">Jenkins</option>
                        <option value="29">Azure</option>
                        <option value="30">
                            Google Cloud Platform
                        </option>
                        <option value="31">PostgreSQL</option>
                        <option value="32">MongoDB</option>
                        <option value="33">REST APIs</option>
                        <option value="34">GraphQL</option>
                        <option value="35">Tableau</option>
                        <option value="36">Power BI</option>
                        <option value="37">
                            Microsoft Excel
                        </option>
                        <option value="38">
                            Machine Learning
                        </option>
                        <option value="39">Deep Learning</option>
                        <option value="40">Data Analysis</option>
                        <option value="41">Statistics</option>
                        <option value="42">
                            Natural Language Processing
                        </option>
                        <option value="43">Computer Vision</option>
                        <option value="44">Unit Testing</option>
                        <option value="45">Agile</option>
                        <option value="46">Scrum</option>
                        <option value="47">Communication</option>
                        <option value="48">Leadership</option>
                        <option value="49">Problem Solving</option>
                        <option value="50">Teamwork</option>
                    </select>

                    <small>
                        Hold Ctrl or Command to select multiple skills.
                    </small>
                </div>
            </div>

            <!-- Recruiter fields -->
            <div id="recruiter-fields"
                 style="display: none;">

                <div class="form-group">
                    <label for="company">Company</label>

                    <input type="text"
                           id="company"
                           name="company">
                </div>

                <div class="form-group">
                    <label for="industry">Industry</label>

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