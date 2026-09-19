USE lockedin_db;

CREATE TABLE Sample_Jobs (
    job_id INT PRIMARY KEY,
    company_name VARCHAR(50),
    job_name VARCHAR(50),
    job_location VARCHAR(50),
    job_skill VARCHAR(50)
);

INSERT INTO Sample_Jobs (job_id, company_name, job_name, job_location, job_skill) VALUES
(001, 'Apple', 'Software Engineer', 'Cupertino', 'Programming'),
(002,'Google', 'Data Engineer', 'Sunnyvale', 'SQL'),
(003, 'SJSU', 'Instructor', 'San Jose', 'Teaching');