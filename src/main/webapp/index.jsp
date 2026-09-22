<%--
    Entry point for the web app.
    Redirects requests through HomeServlet.

    Author: Gianna
--%>

<%
    response.sendRedirect(request.getContextPath() + "/home");
%>
