-- ============================================================
-- COMPLETE SCHEMA REBUILD
-- Drops old tables and creates them with exact column names
-- matching the Java DAO code.
-- Run this ONCE in MySQL Workbench.
-- ============================================================

USE placement_manager;

-- ── 1. Drop all old tables (order matters for FK constraints) ─
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS selections;
DROP TABLE IF EXISTS interview_results;
DROP TABLE IF EXISTS interview_rounds;
DROP TABLE IF EXISTS interviews;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS eligibility_criteria;
DROP TABLE IF EXISTS placement_drives;
DROP TABLE IF EXISTS drives;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS students;

SET FOREIGN_KEY_CHECKS = 1;

-- ── 2. Create tables with EXACT column names the DAOs expect ──

CREATE TABLE students (
    student_id  INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE,
    phone       VARCHAR(20),
    branch      VARCHAR(50),
    cgpa        DECIMAL(4,2) DEFAULT 0.00,
    backlogs    INT          DEFAULT 0
);

CREATE TABLE companies (
    company_id  INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    sector      VARCHAR(100),
    hr_name     VARCHAR(100),
    hr_email    VARCHAR(100),
    hr_phone    VARCHAR(20)
);

CREATE TABLE drives (
    drive_id           INT          AUTO_INCREMENT PRIMARY KEY,
    company_id         INT          NOT NULL,
    job_role           VARCHAR(100),
    drive_date         DATE,
    venue              VARCHAR(255),
    min_cgpa           DECIMAL(4,2) DEFAULT 0.00,
    max_backlogs       INT          DEFAULT 0,
    eligible_branches  VARCHAR(255) DEFAULT 'ALL',
    status             VARCHAR(20)  DEFAULT 'UPCOMING',
    CONSTRAINT fk_drives_company FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE
);

CREATE TABLE applications (
    application_id  INT         AUTO_INCREMENT PRIMARY KEY,
    student_id      INT         NOT NULL,
    drive_id        INT         NOT NULL,
    applied_date    DATE,
    status          VARCHAR(20) DEFAULT 'APPLIED',
    CONSTRAINT fk_app_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_app_drive   FOREIGN KEY (drive_id)   REFERENCES drives(drive_id)   ON DELETE CASCADE,
    CONSTRAINT uq_app         UNIQUE (student_id, drive_id)
);

CREATE TABLE interviews (
    interview_id        INT          AUTO_INCREMENT PRIMARY KEY,
    application_id      INT          NOT NULL,
    round_name          VARCHAR(100),
    interview_datetime  TIMESTAMP    NULL,
    result              VARCHAR(20)  DEFAULT 'PENDING',
    CONSTRAINT fk_interview_app FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE
);

CREATE TABLE selections (
    selection_id  INT            AUTO_INCREMENT PRIMARY KEY,
    student_id    INT            NOT NULL,
    drive_id      INT            NOT NULL,
    package_lpa   DECIMAL(10,2)  DEFAULT 0.00,
    offer_status  VARCHAR(20)    DEFAULT 'OFFERED',
    CONSTRAINT fk_sel_student FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_sel_drive   FOREIGN KEY (drive_id)   REFERENCES drives(drive_id)   ON DELETE CASCADE,
    CONSTRAINT uq_selection   UNIQUE (student_id, drive_id)
);

-- Keep users table as-is (it already works)
-- Ensure admin user exists
INSERT IGNORE INTO users (username, password, role)
VALUES ('admin', 'admin123', 'ADMIN');

-- ── 3. Verify ─────────────────────────────────────────────────
SHOW TABLES;
SELECT 'Schema rebuilt successfully!' AS status;
