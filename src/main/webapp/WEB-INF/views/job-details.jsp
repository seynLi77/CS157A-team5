<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map,com.lockedin.util.HtmlUtil" %>
<%
    Map<String,Object> job = (Map<String,Object>) request.getAttribute("job");
    boolean canApply = Boolean.TRUE.equals(request.getAttribute("canApply"));
    String ctx = request.getContextPath();
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%=HtmlUtil.escape(job.get("job_name"))%> — LockedIn</title>
    <link rel="stylesheet" href="<%=ctx%>/css/home.css?v=3"><link rel="stylesheet" href="<%=ctx%>/css/jobs.css?v=3"><link rel="stylesheet" href="<%=ctx%>/css/recruiter-jobs.css?v=3">
</head>
<body class="recruiter-page">
<nav class="navbar"><div class="wrap"><div class="logo"><span class="logo-mark">LI</span> LockedIn</div><div class="nav-actions"><a class="btn btn-ghost" href="<%=ctx%>/dashboard">Dashboard</a><a class="btn btn-ghost" href="<%=ctx%>/jobs">Browse jobs</a><a class="btn btn-primary" href="<%=ctx%>/logout">Sign out</a></div></div></nav>
<main class="page recruiter-content"><div class="wrap narrow">
    <a class="back-link" href="<%=ctx%>/recruiter-jobs">← Back to postings</a>
    <article class="job-detail-card">
        <div class="detail-top"><div><p class="eyebrow">JOB POSTING</p><h1><%=HtmlUtil.escape(job.get("job_name"))%></h1><p class="company-name"><%=HtmlUtil.escape(job.get("company"))%></p></div><span class="pill status-<%=job.get("job_status")%>"><%=HtmlUtil.escape(job.get("job_status"))%></span></div>
        <div class="detail-meta"><span><%=HtmlUtil.escape(job.get("job_type"))%></span><span><%=HtmlUtil.escape(job.get("job_location"))%></span><span><%=job.get("salary") == null ? "Pay not listed" : "$" + job.get("salary")%></span><span>Apply by <%=job.get("deadline")%></span></div>
        <section class="detail-section"><h2>About the role</h2><p class="detail-copy"><%=HtmlUtil.escape(job.get("description"))%></p></section>
        <section class="detail-section"><h2>Desired skills</h2><div class="skill-list"><% for(String skill : String.valueOf(job.get("skills")).split(",")) { if(!skill.trim().isEmpty()) { %><span class="skill-chip"><%=HtmlUtil.escape(skill.trim())%></span><% }} %></div></section>
        <section class="detail-section"><h2>Qualifications</h2><ul><% for(String requirement : String.valueOf(job.get("qualifications")).split("\\R")) { if(!requirement.trim().isEmpty()) { %><li><%=HtmlUtil.escape(requirement.trim())%></li><% }} %></ul></section>
        <% if(canApply) { %><div class="detail-actions"><a class="btn btn-primary" href="<%=ctx%>/apply?job_id=<%=job.get("job_id")%>">Apply to this job</a></div><% } %>
    </article>
</div></main><footer><div class="wrap"><p>© 2026 LockedIn. A student project — CS157A Team 5.</p></div></footer>
</body></html>
