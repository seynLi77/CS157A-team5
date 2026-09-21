<%--
    Displays the application's home page.

    Author: Gianna
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LockedIn — Lock in. Find a job.</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>

<!-- ============================================================ -->
<!-- NAV                                                           -->
<!-- ============================================================ -->
<nav class="navbar">
  <div class="wrap">
    <div class="logo">
      <span class="logo-mark">
        <svg width="26" height="26" viewBox="0 0 24 24">
          <defs>
            <mask id="lockedin-keyhole-mask">
              <rect x="0" y="0" width="24" height="24" fill="#FFFFFF"/>
              <circle cx="12" cy="16.4" r="1.6" fill="#000000"/>
              <path d="M10.9 19.2H13.1L12.6 22.0C12.6 22.5 11.4 22.5 11.4 22.0L10.9 19.2Z" fill="#000000"/>
            </mask>
          </defs>
          <!-- shackle, symmetric arch matching reference -->
          <path d="M7 9V8C7 4.5 9.5 2 12 2C14.5 2 17 4.5 17 8V9"
                stroke="#0A66C2" stroke-width="4" stroke-linecap="round" fill="none"/>
          <!-- body, gapped below the shackle, keyhole cut through as transparent, dot separated from stem -> reads as "i" -->
          <rect x="3.5" y="11" width="17" height="12" rx="4" fill="#0A66C2" mask="url(#lockedin-keyhole-mask)"/>
        </svg>
      </span>
      LockedIn
    </div>
    <div class="nav-links">
      <a href="#" data-dummy-link>About us</a>
      <a href="#" data-dummy-link>Job seekers</a>
      <a href="#" data-dummy-link>Employers</a>
    </div>
    <div class="nav-actions">
      <a href="#" class="btn btn-ghost" data-dummy-link>Log in</a>
      <a href="#" class="btn btn-primary" data-dummy-link>Sign up</a>
      <button class="hamburger" id="hamburger-btn" aria-label="Menu" aria-expanded="false">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
          <line x1="3" y1="6" x2="21" y2="6"></line>
          <line x1="3" y1="12" x2="21" y2="12"></line>
          <line x1="3" y1="18" x2="21" y2="18"></line>
        </svg>
      </button>
    </div>
  </div>
  <div class="mobile-menu" id="mobile-menu">
    <a href="#" data-dummy-link>About us</a>
    <a href="#" data-dummy-link>Job seekers</a>
    <a href="#" data-dummy-link>Employers</a>
  </div>
</nav>

<!-- ============================================================ -->
<!-- HERO                                                          -->
<!-- ============================================================ -->
<section class="hero">
  <div class="wrap">
    <h1>Lock in.<br><span class="accent">Find a job.</span></h1>
    <p class="stat-line"><strong>${openJobCount}</strong> jobs ready to be found.</p>

    <form id="dummy-search-form" class="search-bar">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="11" cy="11" r="8"></circle>
        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
      </svg>
      <div class="search-input-wrap">
        <input type="text" id="search-input" autocomplete="off">
        <span class="search-placeholder-anim" id="search-placeholder-anim"></span>
      </div>
      <button type="submit" class="search-submit" aria-label="Search">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <line x1="12" y1="19" x2="12" y2="5"></line>
          <polyline points="5 12 12 5 19 12"></polyline>
        </svg>
      </button>
    </form>

    <div class="tag-row">
      <button class="tag-btn">Software Engineering</button>
      <button class="tag-btn">Remote</button>
      <button class="tag-btn">Internship</button>
      <button class="tag-btn">Full-time</button>
    </div>
  </div>
</section>

<!-- ============================================================ -->
<!-- DASHBOARD PREVIEW                                             -->
<!-- ============================================================ -->
<section class="section dashboard-section">
  <div class="wrap">
    <div class="dashboard-copy">
      <h2>Stop tracking applications by hand.</h2>
      <p>Every job you've saved or applied to, in one dashboard — status, company, and how long it's been sitting there. No more spreadsheets.</p>
      <a href="#" class="btn btn-primary" data-dummy-link>See your dashboard</a>
    </div>
    <div class="dashboard-mock">
      <div class="dashboard-mock-header">
        <span></span><span></span><span></span>
      </div>
      <div class="mock-row">
        <div>
          <div class="title">Backend Engineer Intern</div>
          <div class="company">Meridian Labs</div>
        </div>
        <div><span class="mock-pill interviewing">Interviewing</span></div>
        <div class="mock-days">14d ago</div>
      </div>
      <div class="mock-row">
        <div>
          <div class="title">Frontend Developer, New Grad</div>
          <div class="company">Harbor &amp; Finch</div>
        </div>
        <div><span class="mock-pill review">Under review</span></div>
        <div class="mock-days">6d ago</div>
      </div>
      <div class="mock-row">
        <div>
          <div class="title">Software Engineer I</div>
          <div class="company">Pinehaven Systems</div>
        </div>
        <div><span class="mock-pill stale">Stale · 21d</span></div>
        <div class="mock-days">31d ago</div>
      </div>
      <div class="mock-row">
        <div>
          <div class="title">Full Stack Developer</div>
          <div class="company">Coastline Digital</div>
        </div>
        <div><span class="mock-pill accepted">Accepted</span></div>
        <div class="mock-days">42d ago</div>
      </div>
    </div>
  </div>
</section>

<!-- ============================================================ -->
<!-- RECOMMENDER PREVIEW (flipped layout from dashboard section)  -->
<!-- ============================================================ -->
<section class="section dashboard-section recommender-section">
  <div class="wrap">
    <div class="recommender-mock">
      <div class="match-row">
        <div>
          <div class="title">Backend Engineer Intern</div>
          <div class="company">Meridian Labs · Remote</div>
        </div>
        <div class="match-score"><span class="ring" style="--pct:94" data-pct="94"></span></div>
      </div>
      <div class="match-row">
        <div>
          <div class="title">Software Engineer</div>
          <div class="company">Apple · Cupertino</div>
        </div>
        <div class="match-score"><span class="ring" style="--pct:88" data-pct="88"></span></div>
      </div>
      <div class="match-row">
        <div>
          <div class="title">Full Stack Developer</div>
          <div class="company">Coastline Digital · Remote</div>
        </div>
        <div class="match-score"><span class="ring" style="--pct:81" data-pct="81"></span></div>
      </div>
      <div class="match-row">
        <div>
          <div class="title">Data Engineer</div>
          <div class="company">Google · Sunnyvale</div>
        </div>
        <div class="match-score"><span class="ring" style="--pct:76" data-pct="76"></span></div>
      </div>
    </div>
    <div class="dashboard-copy">
      <h2>Stop searching. Start matching.</h2>
      <p>LockedIn ranks open roles against your skills and location, so the jobs at the top of your feed are ones you're actually qualified for — not just the newest postings.</p>
      <a href="#" class="btn btn-primary" data-dummy-link>See your matches</a>
    </div>
  </div>
</section>

<!-- ============================================================ -->
<!-- JOB LIST (dummy, highest-wage examples, vertical marquee)    -->
<!-- ============================================================ -->
<section class="section">
  <div class="wrap">
    <div class="section-head">
      <h2>Top-paying roles open right now</h2>
      <p>A few of the highest-paying openings on LockedIn this week.</p>
    </div>
    <div class="job-marquee-outer">
      <div class="job-marquee-track">
        <div class="job-card">
          <div>
            <div class="job-title">Software Engineer</div>
            <div class="job-quals">Apple · Cupertino · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $85/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Data Engineer</div>
            <div class="job-quals">Google · Sunnyvale · Bachelor's · Master's</div>
          </div>
          <div class="job-wage">Up to $78/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Backend Developer</div>
            <div class="job-quals">Coastline Digital · Remote · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $70/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Product Designer</div>
            <div class="job-quals">Harbor &amp; Finch · San Jose · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $65/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">QA Analyst</div>
            <div class="job-quals">Pinehaven Systems · Remote · Associate's</div>
          </div>
          <div class="job-wage">Up to $52/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Instructor</div>
            <div class="job-quals">SJSU · San Jose · Master's · Ph.D.</div>
          </div>
          <div class="job-wage">Up to $60/hr</div>
        </div>
        <!-- duplicated for seamless vertical loop -->
        <div class="job-card">
          <div>
            <div class="job-title">Software Engineer</div>
            <div class="job-quals">Apple · Cupertino · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $85/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Data Engineer</div>
            <div class="job-quals">Google · Sunnyvale · Bachelor's · Master's</div>
          </div>
          <div class="job-wage">Up to $78/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Backend Developer</div>
            <div class="job-quals">Coastline Digital · Remote · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $70/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Product Designer</div>
            <div class="job-quals">Harbor &amp; Finch · San Jose · Bachelor's</div>
          </div>
          <div class="job-wage">Up to $65/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">QA Analyst</div>
            <div class="job-quals">Pinehaven Systems · Remote · Associate's</div>
          </div>
          <div class="job-wage">Up to $52/hr</div>
        </div>
        <div class="job-card">
          <div>
            <div class="job-title">Instructor</div>
            <div class="job-quals">SJSU · San Jose · Master's · Ph.D.</div>
          </div>
          <div class="job-wage">Up to $60/hr</div>
        </div>
      </div>
    </div>
    <div class="job-list-cta">
      <a href="#" class="btn btn-ghost" data-dummy-link>Explore all opportunities</a>
    </div>
  </div>
</section>

<!-- ============================================================ -->
<!-- EMPLOYER CAROUSEL                                             -->
<!-- ============================================================ -->
<section class="section">
  <div class="wrap">
    <div class="carousel-label">Employers hiring on LockedIn</div>
  </div>
  <div class="carousel-track-outer">
    <div class="carousel-track">
      <div class="employer-badge"><span class="badge-mark">A</span></div>
      <div class="employer-badge"><span class="badge-mark">G</span></div>
      <div class="employer-badge"><span class="badge-mark">S</span></div>
      <div class="employer-badge"><span class="badge-mark">M</span></div>
      <div class="employer-badge"><span class="badge-mark">H</span></div>
      <div class="employer-badge"><span class="badge-mark">P</span></div>
      <div class="employer-badge"><span class="badge-mark">C</span></div>
      <!-- duplicated for seamless scroll loop -->
      <div class="employer-badge"><span class="badge-mark">A</span></div>
      <div class="employer-badge"><span class="badge-mark">G</span></div>
      <div class="employer-badge"><span class="badge-mark">S</span></div>
      <div class="employer-badge"><span class="badge-mark">M</span></div>
      <div class="employer-badge"><span class="badge-mark">H</span></div>
      <div class="employer-badge"><span class="badge-mark">P</span></div>
      <div class="employer-badge"><span class="badge-mark">C</span></div>
    </div>
  </div>
</section>

<!-- ============================================================ -->
<!-- FOOTER                                                        -->
<!-- ============================================================ -->
<footer>
  <div class="wrap">
    <div class="footer-columns">
      <div class="footer-tagline">
        <h3>The career platform for the job hunt.</h3>
      </div>
      <div class="footer-col">
        <h4>Job Seekers</h4>
        <a href="#" data-dummy-link>Browse jobs</a>
        <a href="#" data-dummy-link>Your dashboard</a>
        <a href="#" data-dummy-link>Career tips</a>
      </div>
      <div class="footer-col">
        <h4>Employers</h4>
        <a href="#" data-dummy-link>Post a job</a>
        <a href="#" data-dummy-link>Manage applicants</a>
        <a href="#" data-dummy-link>Pricing</a>
      </div>
      <div class="footer-col">
        <h4>Company</h4>
        <a href="#" data-dummy-link>About us</a>
        <a href="#" data-dummy-link>Contact</a>
        <a href="#" data-dummy-link>Help center</a>
      </div>
    </div>
    <div class="footer-wordmark">LockedIn</div>
    <div class="footer-bottom">
      <div>&copy; 2026 LockedIn. A student project — CS157A Team 5.</div>
      <div class="footer-social">
        <a href="#" data-dummy-link aria-label="LinkedIn">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M4.98 3.5C4.98 4.88 3.87 6 2.5 6S0 4.88 0 3.5 1.11 1 2.5 1s2.48 1.12 2.48 2.5zM.5 8h4V23h-4V8zM8.5 8h3.8v2.05h.05c.53-1 1.83-2.05 3.77-2.05 4.03 0 4.78 2.65 4.78 6.1V23h-4v-6.8c0-1.62-.03-3.7-2.26-3.7-2.27 0-2.62 1.77-2.62 3.6V23h-4V8z"/></svg>
        </a>
        <a href="#" data-dummy-link aria-label="GitHub">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 .5C5.7.5.5 5.7.5 12c0 5 3.3 9.3 7.9 10.8.6.1.8-.3.8-.6v-2c-3.2.7-3.9-1.5-3.9-1.5-.5-1.3-1.3-1.7-1.3-1.7-1-.7.1-.7.1-.7 1.2.1 1.8 1.2 1.8 1.2 1 1.8 2.7 1.3 3.4 1 .1-.8.4-1.3.7-1.6-2.6-.3-5.3-1.3-5.3-5.7 0-1.3.4-2.3 1.2-3.1-.1-.3-.5-1.5.1-3.1 0 0 1-.3 3.3 1.2a11 11 0 0 1 6 0c2.3-1.5 3.3-1.2 3.3-1.2.6 1.6.2 2.8.1 3.1.8.8 1.2 1.9 1.2 3.1 0 4.4-2.7 5.4-5.3 5.7.4.4.8 1.1.8 2.2v3.3c0 .3.2.7.8.6 4.6-1.5 7.9-5.8 7.9-10.8C23.5 5.7 18.3.5 12 .5z"/></svg>
        </a>
      </div>
    </div>
  </div>
</footer>

<script src="<%= request.getContextPath() %>/js/home.js"></script>
</body>
</html>
