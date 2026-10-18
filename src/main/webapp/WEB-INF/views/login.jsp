<%--
    Displays the login page.

    Author: Elaine
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Log in — LockedIn</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/login.css">
</head>

<body>

<nav class="navbar">
    <div class="wrap navbar-inner">

        <a class="logo"
           href="<%= request.getContextPath() %>/home">

            <span class="logo-mark">
                <svg width="26" height="26"
                     viewBox="0 0 24 24">

                    <defs>
                        <mask id="keyhole-mask">
                            <rect x="0" y="0"
                                  width="24" height="24"
                                  fill="#FFFFFF"/>

                            <circle cx="12" cy="16.4"
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

                    <rect x="3.5" y="11"
                          width="17"
                          height="12"
                          rx="4"
                          fill="#0A66C2"
                          mask="url(#keyhole-mask)"/>
                </svg>
            </span>

            LockedIn
        </a>

        <a class="back-home"
           href="<%= request.getContextPath() %>/home">
            Back to home
        </a>
    </div>
</nav>

<main class="login-page">
    <section class="login-card">

        <div class="login-heading">
            <p class="eyebrow">WELCOME BACK</p>

            <h1>Lock in.</h1>

            <p class="subtitle">
                Log in to continue your job search.
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
              action="<%= request.getContextPath() %>/login">

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
                       placeholder="Enter your password"
                       required>
            </div>

            <button type="submit"
                    class="login-button">
                Log in
            </button>
        </form>

       <p class="signup-text">
            Don't have an account?

            <a href="<%= request.getContextPath() %>/signup">
                Sign up
            </a>
        </p>

    </section>
</main>

<footer>
    <p>© 2026 LockedIn. A student project — CS157A Team 5.</p>
</footer>

</body>
</html>