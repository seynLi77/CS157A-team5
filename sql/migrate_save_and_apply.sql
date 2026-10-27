USE lockedin_db;

ALTER TABLE application
    ADD COLUMN resume_link VARCHAR(255) NOT NULL DEFAULT '' AFTER status,
    ADD COLUMN message TEXT NULL AFTER resume_link;

UPDATE application a
JOIN job_seeker js ON js.user_id = a.job_seeker_id
SET a.resume_link = COALESCE(js.resume_link, '')
WHERE a.resume_link = '';

ALTER TABLE application
    ADD CONSTRAINT uq_application_seeker_job
    UNIQUE (job_seeker_id, job_id);

CREATE TABLE IF NOT EXISTS saved_job (
    job_seeker_id INT NOT NULL,
    job_id INT NOT NULL,
    priority VARCHAR(10) NOT NULL DEFAULT 'Medium',
    saved_date DATE NOT NULL,

    PRIMARY KEY (job_seeker_id, job_id),

    CONSTRAINT chk_saved_job_priority
        CHECK (priority IN ('High', 'Medium', 'Low')),

    FOREIGN KEY (job_seeker_id) REFERENCES job_seeker(user_id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES job_posting(job_id) ON DELETE CASCADE
) ENGINE = InnoDB;
