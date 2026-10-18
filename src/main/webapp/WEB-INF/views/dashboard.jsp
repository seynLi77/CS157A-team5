<%--
    Displays the user's dashboard.

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