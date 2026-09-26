-- Run once against MySQL (database placement_manager).
-- Existing tables are left unchanged (CREATE TABLE IF NOT EXISTS).

CREATE DATABASE IF NOT EXISTS placement_manager;
USE placement_manager;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'ADMIN'
);

CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    branch VARCHAR(50),
    cgpa DECIMAL(4,2) DEFAULT 0,
    backlogs INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    sector VARCHAR(100),
    hr_name VARCHAR(100),
    hr_email VARCHAR(100),
    hr_phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS drives (
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    job_role VARCHAR(150) NOT NULL,
    drive_date DATE,
    venue VARCHAR(150),
    min_cgpa DECIMAL(4,2) DEFAULT 0,
    max_backlogs INT DEFAULT 99,
    eligible_branches VARCHAR(255),
    status VARCHAR(20) DEFAULT 'UPCOMING',
    CONSTRAINT fk_drive_company
        FOREIGN KEY (company_id) REFERENCES companies(company_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    drive_id INT NOT NULL,
    applied_date DATE,
    status VARCHAR(20) DEFAULT 'APPLIED',
    UNIQUE KEY uk_student_drive (student_id, drive_id),
    CONSTRAINT fk_app_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_app_drive
        FOREIGN KEY (drive_id) REFERENCES drives(drive_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS interviews (
    interview_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT NOT NULL,
    round_name VARCHAR(100) NOT NULL,
    interview_datetime DATETIME,
    result VARCHAR(20) DEFAULT 'PENDING',
    CONSTRAINT fk_interview_app
        FOREIGN KEY (application_id) REFERENCES applications(application_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS selections (
    selection_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    drive_id INT NOT NULL,
    package_lpa DECIMAL(6,2),
    offer_status VARCHAR(20) DEFAULT 'OFFERED',
    UNIQUE KEY uk_selection (student_id, drive_id),
    CONSTRAINT fk_sel_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sel_drive
        FOREIGN KEY (drive_id) REFERENCES drives(drive_id)
        ON DELETE CASCADE
);
