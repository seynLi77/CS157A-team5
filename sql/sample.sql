USE lockedin_db;

CREATE TABLE job_postings (
    job_id INT PRIMARY KEY,
    is_open BOOLEAN,
    company_name VARCHAR(50),
    job_name VARCHAR(50),
    job_location VARCHAR(50),
    job_skill VARCHAR(50)
);

INSERT INTO job_postings (job_id, is_open, company_name, job_name, job_location, job_skill) VALUES
(001, TRUE, 'Apple', 'Software Engineer', 'Cupertino', 'Programming'),
(002,FALSE, 'Google', 'Data Engineer', 'Sunnyvale', 'SQL'),
(003, TRUE, 'SJSU', 'Instructor', 'San Jose', 'Teaching');