<%--
    Entry point for the web app. Redirects to /home.

    Author: Gianna
    TODO: Redirect to /home after HomeServlet is implemented.
--%>
<%
    request.getRequestDispatcher("/WEB-INF/views/home.jsp")
            .forward(request, response);
%>
<%--after HomeServlet is implemented:
    response.sendRedirect(request.getContextPath() + "/home");
--%>