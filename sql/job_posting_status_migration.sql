-- updates the database to account for newly added job statuses

-- note: run this only once
-- author: gianna

USE lockedin_db;

-- adds a job_status column to the job_posting table (open, closed, pending)
-- jobs have an open status by default
ALTER TABLE job_posting
    ADD job_status VARCHAR(10) NOT NULL DEFAULT 'open';

-- updates existing jobs with their new statuses
-- since every job is initially open, close jobs where is_open is false
UPDATE job_posting
    SET job_status = 'closed'
    WHERE is_open = FALSE
      AND job_id > 0;
