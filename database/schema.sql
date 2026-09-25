-- ============================================================
-- WEB-BASED RECRUITMENT SYSTEM — MySQL Database Schema
-- Engine: InnoDB | Charset: utf8mb4
-- Database: recruitment_system
-- ============================================================

CREATE DATABASE IF NOT EXISTS recruitment_system
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE recruitment_system;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- TABLE: users
-- Base user table for all roles (JOB_SEEKER, EMPLOYER, ADMIN)
-- ============================================================
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id         INT             NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(100)    NOT NULL,
    last_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    password_hash   VARCHAR(255)    NOT NULL,
    role            ENUM('JOB_SEEKER','EMPLOYER','ADMIN') NOT NULL,
    phone           VARCHAR(20),
    account_status  ENUM('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_users_email (email),
    INDEX idx_users_role (role),
    INDEX idx_users_status (account_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: candidate_profiles
-- Extended profile for JOB_SEEKER users
-- ============================================================
DROP TABLE IF EXISTS candidate_profiles;
CREATE TABLE candidate_profiles (
    candidate_id    INT             NOT NULL AUTO_INCREMENT,
    user_id         INT             NOT NULL,
    date_of_birth   DATE,
    gender          ENUM('MALE','FEMALE','OTHER','PREFER_NOT_TO_SAY'),
    address         VARCHAR(255),
    city            VARCHAR(100),
    country         VARCHAR(100)    DEFAULT 'Sri Lanka',
    education       TEXT,
    skills          TEXT,
    experience      TEXT,
    current_job_title VARCHAR(150),
    profile_summary TEXT,
    cv_file_name    VARCHAR(255),
    cv_file_path    VARCHAR(500),
    cv_uploaded_at  TIMESTAMP       NULL,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (candidate_id),
    UNIQUE KEY uq_candidate_user (user_id),
    CONSTRAINT fk_candidate_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: employers
-- Company/employer profile for EMPLOYER users
-- ============================================================
DROP TABLE IF EXISTS employers;
CREATE TABLE employers (
    employer_id     INT             NOT NULL AUTO_INCREMENT,
    user_id         INT             NOT NULL,
    company_name    VARCHAR(200)    NOT NULL,
    company_email   VARCHAR(255),
    company_phone   VARCHAR(20),
    company_address VARCHAR(255),
    city            VARCHAR(100),
    industry        VARCHAR(100),
    company_description TEXT,
    website         VARCHAR(255),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (employer_id),
    UNIQUE KEY uq_employer_user (user_id),
    CONSTRAINT fk_employer_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: vacancies  (MAIN MODULE)
-- The most important table in the system
-- ============================================================
DROP TABLE IF EXISTS vacancies;
CREATE TABLE vacancies (
    vacancy_id          INT             NOT NULL AUTO_INCREMENT,
    employer_id         INT             NOT NULL,
    job_title           VARCHAR(200)    NOT NULL,
    job_code            VARCHAR(50),
    description         TEXT            NOT NULL,
    requirements        TEXT,
    responsibilities    TEXT,
    qualifications      TEXT,
    skills_required     TEXT,
    employment_type     ENUM('FULL_TIME','PART_TIME','CONTRACT','INTERNSHIP','TEMPORARY')
                                        NOT NULL DEFAULT 'FULL_TIME',
    experience_level    ENUM('ENTRY','JUNIOR','MID','SENIOR')
                                        NOT NULL DEFAULT 'ENTRY',
    work_mode           ENUM('REMOTE','ONSITE','HYBRID') DEFAULT 'ONSITE',
    industry            VARCHAR(100),
    location            VARCHAR(150)    NOT NULL,
    salary_min          DECIMAL(12,2)   DEFAULT 0.00,
    salary_max          DECIMAL(12,2)   DEFAULT 0.00,
    salary_currency     VARCHAR(10)     DEFAULT 'LKR',
    vacancies_count     INT             NOT NULL DEFAULT 1,
    application_deadline DATE           NOT NULL,
    status              ENUM('DRAFT','PUBLISHED','CLOSED','EXPIRED')
                                        NOT NULL DEFAULT 'DRAFT',
    views_count         INT             NOT NULL DEFAULT 0,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    published_at        TIMESTAMP       NULL,
    closed_at           TIMESTAMP       NULL,
    PRIMARY KEY (vacancy_id),
    CONSTRAINT fk_vacancy_employer FOREIGN KEY (employer_id) REFERENCES employers(employer_id) ON DELETE CASCADE,
    INDEX idx_vacancy_employer (employer_id),
    INDEX idx_vacancy_status (status),
    INDEX idx_vacancy_deadline (application_deadline),
    INDEX idx_vacancy_title (job_title),
    INDEX idx_vacancy_location (location),
    INDEX idx_vacancy_industry (industry),
    INDEX idx_vacancy_employment_type (employment_type),
    INDEX idx_vacancy_experience (experience_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: applications
-- Job applications linking candidates to vacancies
-- ============================================================
DROP TABLE IF EXISTS applications;
CREATE TABLE applications (
    application_id  INT             NOT NULL AUTO_INCREMENT,
    vacancy_id      INT             NOT NULL,
    candidate_id    INT             NOT NULL,
    cover_letter    TEXT,
    cv_snapshot_path VARCHAR(500),
    status          ENUM('APPLIED','UNDER_REVIEW','SHORTLISTED','REJECTED','HIRED','WITHDRAWN')
                                    NOT NULL DEFAULT 'APPLIED',
    recruiter_notes TEXT,
    applied_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (application_id),
    UNIQUE KEY uq_application (vacancy_id, candidate_id),
    CONSTRAINT fk_app_vacancy    FOREIGN KEY (vacancy_id)   REFERENCES vacancies(vacancy_id)           ON DELETE CASCADE,
    CONSTRAINT fk_app_candidate  FOREIGN KEY (candidate_id) REFERENCES candidate_profiles(candidate_id) ON DELETE CASCADE,
    INDEX idx_app_vacancy (vacancy_id),
    INDEX idx_app_candidate (candidate_id),
    INDEX idx_app_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: application_status_history
-- Tracks every status change for full audit trail
-- ============================================================
DROP TABLE IF EXISTS application_status_history;
CREATE TABLE application_status_history (
    history_id      INT             NOT NULL AUTO_INCREMENT,
    application_id  INT             NOT NULL,
    old_status      VARCHAR(30),
    new_status      VARCHAR(30)     NOT NULL,
    changed_by      INT             NOT NULL,
    changed_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    remarks         TEXT,
    PRIMARY KEY (history_id),
    CONSTRAINT fk_history_app  FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE,
    CONSTRAINT fk_history_user FOREIGN KEY (changed_by)     REFERENCES users(user_id)               ON DELETE CASCADE,
    INDEX idx_history_app (application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE: audit_logs
-- Records important system actions for admin review
-- ============================================================
DROP TABLE IF EXISTS audit_logs;
CREATE TABLE audit_logs (
    audit_id        INT             NOT NULL AUTO_INCREMENT,
    user_id         INT,
    action          VARCHAR(50)     NOT NULL,
    entity_type     VARCHAR(50),
    entity_id       INT,
    description     TEXT,
    ip_address      VARCHAR(45),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (audit_id),
    CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_action (action),
    INDEX idx_audit_entity (entity_type, entity_id),
    INDEX idx_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- EVENT: Auto-expire vacancies past their deadline (nightly)
-- ============================================================
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS evt_expire_vacancies;
DELIMITER $$
CREATE EVENT evt_expire_vacancies
  ON SCHEDULE EVERY 1 DAY
  STARTS CURRENT_TIMESTAMP
  DO
BEGIN
    UPDATE vacancies
    SET    status = 'EXPIRED'
    WHERE  status = 'PUBLISHED'
      AND  application_deadline < CURDATE();
END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;
