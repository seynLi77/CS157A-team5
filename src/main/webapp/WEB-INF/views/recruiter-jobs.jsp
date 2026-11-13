<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="com.lockedin.util.HtmlUtil" %>
<%
    List<Map<String,Object>> jobs = (List<Map<String,Object>>) request.getAttribute("recruiterJobs");
    Map<String,Object> edit = (Map<String,Object>) request.getAttribute("editJob");
    String ctx = request.getContextPath();
    String today = LocalDate.now().toString();
    String currentType = edit == null ? "Full-time" : String.valueOf(edit.get("job_type"));
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Manage job postings — LockedIn</title>
    <link rel="stylesheet" href="<%=ctx%>/css/home.css?v=4">
    <link rel="stylesheet" href="<%=ctx%>/css/jobs.css?v=4">
    <link rel="stylesheet" href="<%=ctx%>/css/recruiter-jobs.css?v=5">
</head>
<body class="recruiter-page">
<nav class="navbar">
    <div class="wrap">
        <div class="logo">
            <span class="logo-mark">
                <svg width="26" height="26" viewBox="0 0 24 24" aria-hidden="true">
                    <defs><mask id="recruiter-keyhole-mask"><rect width="24" height="24" fill="#FFFFFF"/><circle cx="12" cy="16.4" r="1.6" fill="#000000"/><path d="M10.9 19.2H13.1L12.6 22C12.6 22.5 11.4 22.5 11.4 22Z" fill="#000000"/></mask></defs>
                    <path d="M7 9V8C7 4.5 9.5 2 12 2C14.5 2 17 4.5 17 8V9" stroke="#0A66C2" stroke-width="4" stroke-linecap="round" fill="none"/>
                    <rect x="3.5" y="11" width="17" height="12" rx="4" fill="#0A66C2" mask="url(#recruiter-keyhole-mask)"/>
                </svg>
            </span>
            LockedIn
        </div>
        <div class="nav-actions">
            <a class="btn btn-ghost"
               href="<%=request.getContextPath()%>/interviews">
                Interviews
            </a>
            <a class="btn btn-ghost" href="<%=ctx%>/dashboard">Dashboard</a>
            <a class="btn btn-ghost" href="<%=ctx%>/profile">My Profile</a>
            <a class="btn btn-primary" href="<%=ctx%>/logout">Sign out</a>
        </div>
    </div>
</nav>

<main class="page recruiter-content">
    <div class="wrap">
        <div class="recruiter-heading">
            <div>
                <p class="eyebrow">RECRUITER WORKSPACE</p>
                <h1 class="page-title">Manage job postings</h1>
                <p class="page-subtitle">Create clear, searchable roles that candidates can act on.</p>
            </div>
        </div>

        <% if (request.getAttribute("flashSuccess") != null) { %>
            <div class="flash flash-success"><%=HtmlUtil.escape(request.getAttribute("flashSuccess"))%></div>
        <% } %>
        <% if (request.getAttribute("flashError") != null) { %>
            <div class="flash flash-error"><%=HtmlUtil.escape(request.getAttribute("flashError"))%></div>
        <% } %>

        <section class="form-card recruiter-form-card">
            <div class="card-heading">
                <div>
                    <h2><%=edit == null ? "Post a job" : "Edit job posting"%></h2>
                    <p>Fields marked <span class="required-mark">*</span> are required.</p>
                </div>
            </div>
            <form id="job-form" method="post" action="<%=ctx%>/recruiter-jobs" novalidate>
                <input type="hidden" name="action" value="<%=edit == null ? "create" : "update"%>">
                <% if(edit != null){ %><input type="hidden" name="job_id" value="<%=edit.get("job_id")%>"><% } %>

                <div class="form-grid">
                    <div class="field field-wide">
                        <label for="title">Job title <span class="required-mark">*</span></label>
                        <input id="title" name="title" required maxlength="150" autocomplete="off"
                               value="<%=edit == null ? "" : HtmlUtil.escape(edit.get("job_name"))%>">
                        <small class="field-help">Use a specific title, such as “Java Backend Developer.”</small>
                    </div>
                    <div class="field">
                        <label for="job_type">Job type <span class="required-mark">*</span></label>
                        <select id="job_type" name="job_type" required>
                            <% for (String type : new String[]{"Full-time","Part-time","Contract","Internship","Temporary"}) { %>
                                <option value="<%=type%>" <%=type.equals(currentType) ? "selected" : ""%>><%=type%></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="field">
                        <label for="pay">Salary</label>
                        <div class="money-input"><span>$</span><input id="pay_display" type="text" inputmode="decimal" autocomplete="off" placeholder="0.00" value="<%=edit == null || edit.get("salary") == null ? "" : edit.get("salary")%>"></div>
                        <input id="pay" name="pay" type="hidden" value="<%=edit == null || edit.get("salary") == null ? "" : edit.get("salary")%>">
                        <small class="field-help">Enter an annual salary or hourly amount.</small>
                    </div>
                    <div class="field">
                        <label for="location">Location <span class="required-mark">*</span></label>
                        <select id="location" name="location" required>
                            <option value="">Select a location</option>
                            <% for (String location : new String[]{"San Jose, CA","San Francisco, CA","Oakland, CA","Santa Clara, CA","Austin, TX","New York, NY","Seattle, WA","Los Angeles, CA","Fremont, CA","Remote"}) { %>
                                <option value="<%=location%>" <%=edit != null && location.equals(String.valueOf(edit.get("job_location"))) ? "selected" : ""%>><%=location%></option>
                            <% } %>
                        </select>
                        <span id="location-feedback" class="validation-message" aria-live="polite"></span>
                    </div>
                    <div class="field">
                        <label for="deadline">Application deadline <span class="required-mark">*</span></label>
                        <div id="date-picker" class="date-picker">
                            <input id="deadline_display" type="text" inputmode="numeric" autocomplete="off" placeholder="MM / DD / YYYY">
                            <input id="deadline" name="deadline" type="hidden" required data-min="<%=today%>"
                                   value="<%=edit == null || edit.get("deadline") == null ? "" : edit.get("deadline")%>">
                            <button id="deadline-toggle" class="date-toggle" type="button" aria-label="Open deadline calendar">
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <rect x="3" y="5" width="18" height="16" rx="3"></rect>
                                    <path d="M7 3v4M17 3v4M3 10h18"></path>
                                </svg>
                            </button>
                            <div id="deadline-calendar" class="calendar-popover" hidden></div>
                        </div>
                        <span id="deadline-feedback" class="validation-message" aria-live="polite"></span>
                    </div>
                    <% if (edit != null) { %>
                        <div class="field">
                            <label for="status">Status <span class="required-mark">*</span></label>
                            <select id="status" name="status" required>
                                <% for(String status : new String[]{"open","closed","pending"}) { String current = String.valueOf(edit.get("job_status")); %>
                                    <option value="<%=status%>" <%=status.equals(current) ? "selected" : ""%>><%=status.substring(0,1).toUpperCase()+status.substring(1)%></option>
                                <% } %>
                            </select>
                        </div>
                    <% } else { %>
                        <input type="hidden" name="status" value="open">
                    <% } %>
                    <div class="field field-wide">
                        <label for="skills">Desired skills <span class="required-mark">*</span></label>
                        <div id="skills-editor" class="skills-editor" data-initial-skills="<%=edit == null ? "" : HtmlUtil.escape(edit.get("skills"))%>">
                            <input id="skill-entry" type="text" maxlength="100" placeholder="Type a skill and press Enter">
                        </div>
                        <input id="skills" name="skills" type="hidden" required value="<%=edit == null ? "" : HtmlUtil.escape(edit.get("skills"))%>">
                        <small class="field-help">Press Enter or comma to create a skill badge. Click × to remove one.</small>
                        <span id="skills-feedback" class="validation-message" aria-live="polite"></span>
                    </div>
                    <div class="field field-wide">
                        <label for="qualifications">Qualifications <span class="required-mark">*</span></label>
                        <textarea id="qualifications" name="qualifications" required rows="5" maxlength="5000"
                                  placeholder="Bachelor’s degree in Computer Science&#10;1+ years of Java experience&#10;Strong communication skills"><%=edit == null ? "" : HtmlUtil.escape(edit.get("qualifications"))%></textarea>
                        <small class="field-help">Enter one qualification per line. Each line becomes a separate requirement.</small>
                        <span id="qualifications-feedback" class="validation-message" aria-live="polite"></span>
                    </div>
                    <div class="field field-wide">
                        <label for="description">Job description <span class="required-mark">*</span></label>
                        <textarea id="description" name="description" required rows="6" maxlength="5000"
                                  placeholder="Describe the role, responsibilities, and team."><%=edit == null ? "" : HtmlUtil.escape(edit.get("description"))%></textarea>
                    </div>
                </div>
                <div id="form-feedback" class="form-feedback" role="alert" aria-live="polite"></div>
                <div class="form-actions">
                    <% if(edit != null){ %><a class="btn btn-ghost" href="<%=ctx%>/recruiter-jobs">Cancel</a><% } %>
                    <button class="btn btn-primary" type="submit"><%=edit == null ? "Post job" : "Save changes"%></button>
                </div>
            </form>
        </section>

        <section class="postings-section">
            <div class="section-heading-row"><div><p class="eyebrow">YOUR ROLES</p><h2 class="section-title">Your postings</h2></div><span class="posting-count"><%=jobs == null ? 0 : jobs.size()%></span></div>
            <% if(jobs == null || jobs.isEmpty()){ %>
                <div class="empty-postings"><p>You have not posted any jobs yet.</p><p class="muted">Your published roles will appear here.</p></div>
            <% } else { %>
                <div class="table-scroll"><table class="data-table recruiter-table"><thead><tr><th>Title</th><th>Type</th><th>Location</th><th>Pay</th><th>Deadline</th><th>Status</th><th></th></tr></thead><tbody>
                <% for(Map<String,Object> job : jobs){ %>
                    <tr>
                        <td><strong><%=HtmlUtil.escape(job.get("job_name"))%></strong></td>
                        <td><%=HtmlUtil.escape(job.get("job_type"))%></td>
                        <td><%=HtmlUtil.escape(job.get("job_location"))%></td>
                        <td><%=job.get("salary") == null ? "—" : job.get("salary")%></td>
                        <td><%=job.get("deadline") == null ? "—" : job.get("deadline")%></td>
                        <td><span class="pill pill-status status-<%=job.get("job_status")%>"><%=HtmlUtil.escape(job.get("job_status"))%></span></td>
                        <td class="row-actions">
                            <a class="btn btn-ghost btn-small" href="<%=ctx%>/job?job_id=<%=job.get("job_id")%>">View</a>
                            <a class="btn btn-ghost btn-small" href="<%=ctx%>/recruiter-jobs?edit=<%=job.get("job_id")%>">Edit</a>
                            <form method="post" action="<%=ctx%>/recruiter-jobs" class="inline-form" onsubmit="return confirm('Delete this job posting?');"><input type="hidden" name="action" value="delete"><input type="hidden" name="job_id" value="<%=job.get("job_id")%>"><button class="btn btn-ghost btn-small btn-danger" type="submit">Remove</button></form>
                        </td>
                    </tr>
                <% } %>
                </tbody></table></div>
            <% } %>
        </section>
    </div>
</main>
<footer><div class="wrap"><p>© 2026 LockedIn. A student project — CS157A Team 5.</p></div></footer>
<script src="<%=ctx%>/js/recruiter-jobs.js?v=5"></script>
</body>
</html>
