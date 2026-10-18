-- Initializes the job-posting table with sample data.
-- Author: Elaine

USE lockedin_db;

CREATE TABLE IF NOT EXISTS `user` (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS admin (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS recruiter (
    user_id INT PRIMARY KEY,
    company VARCHAR(150) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS job_seeker (
    user_id INT PRIMARY KEY,
    location VARCHAR(150),
    resume VARCHAR(255),
    experience TEXT,
    education VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES `user`(user_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS job_postings (
    job_id INT PRIMARY KEY,
    recruiter_id INT NOT NULL,
    is_open BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT NOT NULL,
    job_name VARCHAR(150) NOT NULL,
    job_type VARCHAR(50) NOT NULL,
    job_location VARCHAR(150) NOT NULL,
    salary DECIMAL(12, 2),
    post_date DATE NOT NULL,
    deadline DATE NOT NULL,
    FOREIGN KEY (recruiter_id) REFERENCES recruiter(user_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS job_requirement (
    job_id INT NOT NULL,
    requirement_number INT NOT NULL,
    description TEXT NOT NULL,
    PRIMARY KEY (job_id, requirement_number),
    FOREIGN KEY (job_id) REFERENCES job_posting(job_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS skill (
    skill_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS job_seeker_skill (
    job_seeker_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_seeker_id, skill_id),
    FOREIGN KEY (job_seeker_id) REFERENCES job_seeker(user_id),
    FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS job_posting_skill (
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_posting(job_id),
    FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS application (
    application_id INT PRIMARY KEY,
    job_seeker_id INT NOT NULL,
    job_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    submission_date DATE NOT NULL,
    last_updated DATE NOT NULL,
    FOREIGN KEY (job_seeker_id) REFERENCES job_seeker(user_id),
    FOREIGN KEY (job_id) REFERENCES job_posting(job_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS interview (
    interview_id INT PRIMARY KEY,
    application_id INT NOT NULL,
    recruiter_id INT NOT NULL,
    `date` DATE NOT NULL,
    `time` TIME NOT NULL,
    location VARCHAR(150) NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (application_id) REFERENCES application(application_id),
    FOREIGN KEY (recruiter_id) REFERENCES recruiter(user_id)
) ENGINE = InnoDB;

INSERT INTO `user`
    (user_id, first_name, last_name, email, password)
VALUES
    (1, 'Maya', 'Chen', 'maya.chen@example.com', 'DemoPass_001'),
    (2, 'Daniel', 'Garcia', 'daniel.garcia@example.com', 'DemoPass_002'),
    (3, 'Sophia', 'Kim', 'sophia.kim@example.com', 'DemoPass_003'),
    (4, 'Ethan', 'Patel', 'ethan.patel@example.com', 'DemoPass_004'),
    (5, 'Olivia', 'Brown', 'olivia.brown@example.com', 'DemoPass_005'),
    (6, 'Noah', 'Wilson', 'noah.wilson@example.com', 'DemoPass_006'),
    (7, 'Ava', 'Davis', 'ava.davis@example.com', 'DemoPass_007'),
    (8, 'Liam', 'Martinez', 'liam.martinez@example.com', 'DemoPass_008'),
    (9, 'Isabella', 'Lee', 'isabella.lee@example.com', 'DemoPass_009'),
    (10, 'James', 'Taylor', 'james.taylor@example.com', 'DemoPass_010'),
    (101, 'Emma', 'Anderson', 'emma.anderson@example.com', 'DemoPass_101'),
    (102, 'Lucas', 'Thomas', 'lucas.thomas@example.com', 'DemoPass_102'),
    (103, 'Mia', 'Jackson', 'mia.jackson@example.com', 'DemoPass_103'),
    (104, 'Henry', 'White', 'henry.white@example.com', 'DemoPass_104'),
    (105, 'Sofia', 'Harris', 'sofia.harris@example.com', 'DemoPass_105'),
    (106, 'Benjamin', 'Martin', 'benjamin.martin@example.com', 'DemoPass_106'),
    (107, 'Charlotte', 'Thompson', 'charlotte.thompson@example.com', 'DemoPass_107'),
    (108, 'Alexander', 'Moore', 'alexander.moore@example.com', 'DemoPass_108'),
    (109, 'Amelia', 'Young', 'amelia.young@example.com', 'DemoPass_109'),
    (110, 'Michael', 'King', 'michael.king@example.com', 'DemoPass_110'),
    (201, 'Grace', 'Hall', 'grace.hall@example.com', 'DemoPass_201'),
    (202, 'Jack', 'Allen', 'jack.allen@example.com', 'DemoPass_202'),
    (203, 'Lily', 'Wright', 'lily.wright@example.com', 'DemoPass_203'),
    (204, 'William', 'Scott', 'william.scott@example.com', 'DemoPass_204'),
    (205, 'Chloe', 'Green', 'chloe.green@example.com', 'DemoPass_205'),
    (206, 'Daniel', 'Baker', 'daniel.baker@example.com', 'DemoPass_206'),
    (207, 'Ella', 'Adams', 'ella.adams@example.com', 'DemoPass_207'),
    (208, 'Matthew', 'Nelson', 'matthew.nelson@example.com', 'DemoPass_208'),
    (209, 'Harper', 'Carter', 'harper.carter@example.com', 'DemoPass_209'),
    (210, 'Sebastian', 'Mitchell', 'sebastian.mitchell@example.com', 'DemoPass_210');

INSERT INTO admin
    (user_id)
VALUES
    (201), (202), (203), (204), (205),
    (206), (207), (208), (209), (210);

INSERT INTO recruiter
    (user_id, company, industry)
VALUES
    (1, 'TechNova', 'Software'),
    (2, 'DataBridge', 'Analytics'),
    (3, 'DesignWorks', 'Design'),
    (4, 'CloudPeak', 'Cloud Computing'),
    (5, 'QualityFirst', 'Software Testing'),
    (6, 'ProjectHub', 'Technology Consulting'),
    (7, 'SecureNet', 'Cybersecurity'),
    (8, 'ApiWorks', 'Software'),
    (9, 'DatabasePro', 'Information Technology'),
    (10, 'InsightLabs', 'Business Intelligence');

INSERT INTO job_seeker
    (user_id, location, resume, experience, education)
VALUES
    (101, 'San Jose, CA', 'emma_anderson_resume.pdf', '1 year internship experience', 'B.S. Computer Science'),
    (102, 'San Francisco, CA', 'lucas_thomas_resume.pdf', '2 years data analysis experience', 'B.S. Statistics'),
    (103, 'Oakland, CA', 'mia_jackson_resume.pdf', '3 years UX design experience', 'B.A. Design'),
    (104, 'Santa Clara, CA', 'henry_white_resume.pdf', '2 years cloud engineering experience', 'B.S. Information Systems'),
    (105, 'Austin, TX', 'sofia_harris_resume.pdf', '1 year QA experience', 'B.S. Computer Engineering'),
    (106, 'New York, NY', 'benjamin_martin_resume.pdf', '4 years project management experience', 'M.S. Technology Management'),
    (107, 'Remote', 'charlotte_thompson_resume.pdf', '2 years security operations experience', 'B.S. Cybersecurity'),
    (108, 'Seattle, WA', 'alexander_moore_resume.pdf', '3 years backend development experience', 'B.S. Software Engineering'),
    (109, 'Los Angeles, CA', 'amelia_young_resume.pdf', '5 years database administration experience', 'B.S. Computer Science'),
    (110, 'Fremont, CA', 'michael_king_resume.pdf', '2 years business intelligence experience', 'B.S. Business Analytics');

INSERT INTO job_posting
    (job_id, recruiter_id, is_open, description, job_name, job_type,
     job_location, salary, post_date, deadline)
VALUES
    (1001, 1, TRUE, 'Develop and maintain web applications.', 'Junior Software Engineer', 'Full-time', 'San Jose, CA', 92000.00, '2026-09-01', '2026-10-15'),
    (1002, 2, TRUE, 'Analyze business data and create reports.', 'Data Analyst', 'Full-time', 'San Francisco, CA', 88000.00, '2026-09-02', '2026-10-20'),
    (1003, 3, TRUE, 'Design user interfaces for mobile products.', 'UX Designer', 'Full-time', 'Remote', 95000.00, '2026-09-03', '2026-10-18'),
    (1004, 4, TRUE, 'Build scalable cloud infrastructure.', 'Cloud Engineer', 'Full-time', 'Santa Clara, CA', 120000.00, '2026-09-04', '2026-10-25'),
    (1005, 5, TRUE, 'Test software and automate quality checks.', 'QA Automation Engineer', 'Full-time', 'Austin, TX', 90000.00, '2026-09-05', '2026-10-22'),
    (1006, 6, TRUE, 'Coordinate software development projects.', 'Technical Project Manager', 'Full-time', 'New York, NY', 110000.00, '2026-09-06', '2026-10-30'),
    (1007, 7, TRUE, 'Protect company systems and investigate threats.', 'Cybersecurity Analyst', 'Full-time', 'Remote', 105000.00, '2026-09-07', '2026-10-28'),
    (1008, 8, TRUE, 'Create APIs and maintain backend services.', 'Backend Developer', 'Full-time', 'Seattle, WA', 115000.00, '2026-09-08', '2026-11-01'),
    (1009, 9, TRUE, 'Support database design and optimization.', 'Database Administrator', 'Full-time', 'Los Angeles, CA', 98000.00, '2026-09-09', '2026-10-27'),
    (1010, 10, FALSE, 'Develop dashboards for operational teams.', 'Business Intelligence Developer', 'Contract', 'Remote', 75000.00, '2026-09-10', '2026-09-30');

INSERT INTO job_requirement
    (job_id, requirement_number, description)
VALUES
    (1001, 1, 'Bachelor degree in Computer Science or a related field.'),
    (1002, 1, 'Experience with SQL and data visualization tools.'),
    (1003, 1, 'Portfolio demonstrating user-centered design work.'),
    (1004, 1, 'Experience with AWS, Azure, or Google Cloud.'),
    (1005, 1, 'Experience writing automated software tests.'),
    (1006, 1, 'Experience managing Agile software projects.'),
    (1007, 1, 'Knowledge of network security and incident response.'),
    (1008, 1, 'Experience developing REST APIs.'),
    (1009, 1, 'Experience with database backup and recovery.'),
    (1010, 1, 'Experience building dashboards with Power BI or Tableau.');

INSERT INTO skill
    (skill_id, name)
VALUES
    (1, 'SQL'),
    (2, 'Python'),
    (3, 'Java'),
    (4, 'JavaScript'),
    (5, 'React'),
    (6, 'AWS'),
    (7, 'Docker'),
    (8, 'Project Management'),
    (9, 'Cybersecurity'),
    (10, 'Data Visualization');

INSERT INTO job_seeker_skill
    (job_seeker_id, skill_id)
VALUES
    (101, 1),
    (101, 2),
    (102, 3),
    (102, 4),
    (103, 5),
    (103, 10),
    (104, 6),
    (104, 7),
    (105, 1),
    (105, 4),
    (106, 8),
    (106, 2),
    (107, 9),
    (107, 1),
    (108, 2),
    (108, 6),
    (109, 3),
    (109, 7),
    (110, 10),
    (110, 1);

INSERT INTO job_posting_skill
    (job_id, skill_id)
VALUES
    (1001, 2),
    (1001, 4),
    (1002, 1),
    (1002, 10),
    (1003, 4),
    (1003, 5),
    (1004, 6),
    (1004, 7),
    (1005, 2),
    (1005, 4),
    (1006, 8),
    (1006, 2),
    (1007, 9),
    (1007, 1),
    (1008, 2),
    (1008, 4),
    (1009, 1),
    (1009, 3),
    (1010, 1),
    (1010, 10);

INSERT INTO application
    (application_id, job_seeker_id, job_id, status, submission_date, last_updated)
VALUES
    (5001, 101, 1001, 'Submitted', '2026-09-11', '2026-09-11'),
    (5002, 102, 1002, 'Under Review', '2026-09-12', '2026-09-14'),
    (5003, 103, 1003, 'Interview', '2026-09-13', '2026-09-18'),
    (5004, 104, 1004, 'Submitted', '2026-09-14', '2026-09-14'),
    (5005, 105, 1005, 'Rejected', '2026-09-15', '2026-09-20'),
    (5006, 106, 1006, 'Interview', '2026-09-16', '2026-09-22'),
    (5007, 107, 1007, 'Under Review', '2026-09-17', '2026-09-19'),
    (5008, 108, 1008, 'Submitted', '2026-09-18', '2026-09-18'),
    (5009, 109, 1009, 'Accepted', '2026-09-19', '2026-09-25'),
    (5010, 110, 1010, 'Rejected', '2026-09-20', '2026-09-29');

INSERT INTO interview
    (interview_id, application_id, recruiter_id, `date`, `time`, location, status)
VALUES
    (7001, 5001, 1, '2026-09-21', '09:00:00', 'Zoom', 'Scheduled'),
    (7002, 5002, 2, '2026-09-22', '10:30:00', 'Zoom', 'Completed'),
    (7003, 5003, 3, '2026-09-23', '13:00:00', 'San Francisco Office', 'Completed'),
    (7004, 5004, 4, '2026-09-24', '11:00:00', 'Zoom', 'Scheduled'),
    (7005, 5005, 5, '2026-09-25', '14:00:00', 'Austin Office', 'Cancelled'),
    (7006, 5006, 6, '2026-09-26', '09:30:00', 'New York Office', 'Completed'),
    (7007, 5007, 7, '2026-09-27', '15:00:00', 'Zoom', 'Scheduled'),
    (7008, 5008, 8, '2026-09-28', '10:00:00', 'Seattle Office', 'Scheduled'),
    (7009, 5009, 9, '2026-09-29', '16:00:00', 'Los Angeles Office', 'Completed'),
    (7010, 5010, 10, '2026-09-30', '12:00:00', 'Zoom', 'Cancelled');