<%--
    Displays the dashboard.

    Author: Elaine
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Dashboard — LockedIn</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/home.css">
</head>

<body>

<nav class="navbar">
    <div class="wrap">

        <div class="logo">
            <span class="logo-mark">🔒</span>
            LockedIn
        </div>

        <div class="nav-actions">

            <a href="<%= request.getContextPath() %>/profile"
               class="btn btn-ghost">
                My Profile
            </a>

            <a href="<%= request.getContextPath() %>/logout"
               class="btn btn-primary">
                Log out
            </a>

        </div>
    </div>
</nav>

<main class="dashboard-empty">
    <div class="wrap">

        <h1>Welcome to your dashboard</h1>

        <p>
            Your dashboard content will appear here.
        </p>

    </div>
</main>

</body>
</html>