-- ============================================================
-- WEB-BASED RECRUITMENT SYSTEM — Seed Data
-- For development and demonstration purposes
-- ============================================================

USE recruitment_system;

-- ============================================================
-- ADMIN ACCOUNT
-- Email: admin@system.com | Password: Admin@1234
-- ============================================================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, role, phone, account_status)
VALUES (1, 'System', 'Admin', 'admin@system.com',
        '$2a$12$brvbn3afeoXrpS1zldjGGOpN6TAlxuWtS6nBsDRuTqTuIM0f/A.Sy',
        'ADMIN', '+94771234567', 'ACTIVE')
ON DUPLICATE KEY UPDATE first_name = VALUES(first_name);

-- ============================================================
-- EMPLOYER ACCOUNTS
-- Password for both: Employer@123
-- ============================================================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, role, phone, account_status)
VALUES
(2, 'Amal', 'Perera', 'amal@techcorp.lk',
 '$2a$12$FBApNBax/XGPi0rojJwK.u0lM69yj5IZ2R2uTQs.vsXAgqEjTBWeO',
 'EMPLOYER', '+94772345678', 'ACTIVE'),
(3, 'Nimali', 'Fernando', 'nimali@globalbank.lk',
 '$2a$12$FBApNBax/XGPi0rojJwK.u0lM69yj5IZ2R2uTQs.vsXAgqEjTBWeO',
 'EMPLOYER', '+94773456789', 'ACTIVE')
ON DUPLICATE KEY UPDATE first_name = VALUES(first_name);

INSERT INTO employers (employer_id, user_id, company_name, company_email, company_phone, company_address, city, industry, company_description, website)
VALUES
(1, 2, 'TechCorp Lanka', 'careers@techcorp.lk', '+94112345678',
 '42 Galle Road, Colombo 03', 'Colombo', 'Information Technology',
 'TechCorp Lanka is a leading enterprise software development company specializing in cloud-native solutions, digital transformation, and AI-driven analytics for government and private sector clients across South Asia.',
 'https://techcorp.lk'),
(2, 3, 'Global Bank PLC', 'hr@globalbank.lk', '+94112987654',
 '100 Bank Street, Colombo 01', 'Colombo', 'Financial Services',
 'Global Bank PLC is one of Sri Lanka''s premier commercial banks, offering retail banking, corporate finance, and digital payment solutions to millions of customers.',
 'https://globalbank.lk')
ON DUPLICATE KEY UPDATE company_name = VALUES(company_name);

-- ============================================================
-- JOB SEEKER ACCOUNTS
-- Password for all: Seeker@123
-- ============================================================
INSERT INTO users (user_id, first_name, last_name, email, password_hash, role, phone, account_status)
VALUES
(4,  'Kavindu',  'Silva',      'kavindu@gmail.com',
 '$2a$12$rnvdfWeT7HLWg/quCRiF.O4GDjnSonDAvHrpyWkYdWkR9sWth.gY2',
 'JOB_SEEKER', '+94774567890', 'ACTIVE'),
(5,  'Sachini',  'Jayawardena','sachini@gmail.com',
 '$2a$12$rnvdfWeT7HLWg/quCRiF.O4GDjnSonDAvHrpyWkYdWkR9sWth.gY2',
 'JOB_SEEKER', '+94775678901', 'ACTIVE'),
(6,  'Tharindu', 'Bandara',    'tharindu@gmail.com',
 '$2a$12$rnvdfWeT7HLWg/quCRiF.O4GDjnSonDAvHrpyWkYdWkR9sWth.gY2',
 'JOB_SEEKER', '+94776789012', 'ACTIVE'),
(7,  'Dilini',   'Rathnayake', 'dilini@gmail.com',
 '$2a$12$rnvdfWeT7HLWg/quCRiF.O4GDjnSonDAvHrpyWkYdWkR9sWth.gY2',
 'JOB_SEEKER', '+94777890123', 'ACTIVE'),
(8,  'Nuwan',    'Kumara',     'nuwan@gmail.com',
 '$2a$12$rnvdfWeT7HLWg/quCRiF.O4GDjnSonDAvHrpyWkYdWkR9sWth.gY2',
 'JOB_SEEKER', '+94778901234', 'ACTIVE')
ON DUPLICATE KEY UPDATE first_name = VALUES(first_name);

INSERT INTO candidate_profiles (candidate_id, user_id, date_of_birth, gender, city, country, education, skills, experience, current_job_title, profile_summary)
VALUES
(1, 4, '1997-03-15', 'MALE', 'Colombo', 'Sri Lanka',
 'BSc Computer Science — University of Colombo (2019)',
 'Java, Spring Boot, MySQL, Docker, REST APIs, Git',
 '4 years as Software Engineer at ABC Solutions',
 'Software Engineer',
 'Passionate Java developer with 4 years of experience building enterprise web applications. Proficient in MVC architectures, JDBC, and MySQL database design.'),
(2, 5, '1998-07-22', 'FEMALE', 'Kandy', 'Sri Lanka',
 'BSc IT — University of Moratuwa (2020)',
 'Python, Data Analysis, SQL, Tableau, Machine Learning',
 '3 years as Data Analyst at DataVision Lanka',
 'Data Analyst',
 'Results-driven data analyst with experience in business intelligence and predictive modelling for financial and retail sectors.'),
(3, 6, '1996-11-05', 'MALE', 'Galle', 'Sri Lanka',
 'BEng Software Engineering — SLIIT (2018)',
 'Java, C#, .NET, Angular, PostgreSQL, AWS',
 '5 years as Senior Developer at XYZ Tech',
 'Senior Software Developer',
 'Experienced full-stack developer with strong skills in enterprise Java, cloud deployment, and agile methodologies.'),
(4, 7, '1999-01-30', 'FEMALE', 'Colombo', 'Sri Lanka',
 'BSc Business Management — University of Kelaniya (2021)',
 'Marketing, Social Media, Content Strategy, SEO, Google Analytics',
 '2 years as Marketing Executive at BrandWorks',
 'Marketing Executive',
 'Creative marketing professional with expertise in digital campaigns and content strategy for tech startups.'),
(5, 8, '1995-09-12', 'MALE', 'Negombo', 'Sri Lanka',
 'MSc Finance — University of Sri Jayewardenepura (2020)',
 'Financial Analysis, Excel, SAP, Risk Management, Accounting',
 '6 years as Finance Manager at Lanka Holdings',
 'Finance Manager',
 'Experienced finance professional specializing in corporate accounting, budgeting, and financial risk assessment.')
ON DUPLICATE KEY UPDATE user_id = VALUES(user_id);

-- ============================================================
-- SAMPLE VACANCIES (Employer 1: TechCorp Lanka)
-- ============================================================
INSERT INTO vacancies (vacancy_id, employer_id, job_title, job_code, description, requirements, responsibilities, qualifications, skills_required, employment_type, experience_level, work_mode, industry, location, salary_min, salary_max, salary_currency, vacancies_count, application_deadline, status, views_count, published_at)
VALUES
(1, 1, 'Senior Java Software Engineer', 'TC-SE-001',
 'We are seeking a talented Senior Java Software Engineer to lead the development of high-performance enterprise web applications. You will design and implement scalable backend services, optimize database queries, and collaborate with cross-functional teams.',
 'Minimum 4 years experience in Java (SE/EE). Strong knowledge of Servlets, JSP, JDBC, and MVC architecture. Experience with MySQL or PostgreSQL. Familiarity with version control (Git).',
 'Design and develop enterprise Java applications.\nWrite clean, well-tested code following MVC patterns.\nOptimize SQL queries and database schema.\nConduct code reviews and mentor junior developers.\nCollaborate with UI/UX team for frontend integration.',
 'BSc in Computer Science or Software Engineering.\nOracle Java certification is a plus.',
 'Java, Servlets, JSP, JDBC, MySQL, Git, REST APIs, MVC',
 'FULL_TIME', 'SENIOR', 'HYBRID', 'Information Technology', 'Colombo',
 250000.00, 400000.00, 'LKR', 2,
 DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'PUBLISHED', 45,
 CURRENT_TIMESTAMP),

(2, 1, 'DevOps Engineer', 'TC-DO-002',
 'Join our infrastructure team to automate deployment pipelines, manage containerized environments, and ensure high-availability of our production systems.',
 '3+ years experience with CI/CD tools, Docker, Kubernetes. Strong Linux administration skills. Knowledge of AWS or Azure cloud platforms.',
 'Build and maintain CI/CD pipelines.\nManage Docker and Kubernetes clusters.\nMonitor system performance and availability.\nImplement infrastructure as code using Terraform.\nCollaborate with development teams on deployment strategy.',
 'BSc in Computer Science, IT, or related field.',
 'Docker, Kubernetes, AWS, Terraform, Jenkins, Linux, Bash',
 'FULL_TIME', 'MID', 'REMOTE', 'Information Technology', 'Remote',
 200000.00, 350000.00, 'LKR', 1,
 DATE_ADD(CURDATE(), INTERVAL 45 DAY), 'PUBLISHED', 89,
 CURRENT_TIMESTAMP),

(3, 1, 'Junior Frontend Developer', 'TC-FE-003',
 'Entry-level opportunity to build responsive web interfaces for our enterprise portal. You will work closely with senior developers and the design team.',
 '0-2 years experience. Knowledge of HTML5, CSS3, JavaScript. Familiarity with Bootstrap or similar CSS framework.',
 'Implement responsive UI components.\nIntegrate with backend REST APIs.\nWrite clean, accessible HTML/CSS.\nParticipate in agile sprint planning.',
 'BSc in IT, Computer Science, or related field. Fresh graduates welcome.',
 'HTML5, CSS3, JavaScript, Bootstrap, jQuery',
 'FULL_TIME', 'ENTRY', 'ONSITE', 'Information Technology', 'Colombo',
 80000.00, 120000.00, 'LKR', 3,
 DATE_ADD(CURDATE(), INTERVAL 21 DAY), 'PUBLISHED', 23,
 CURRENT_TIMESTAMP),

(4, 1, 'QA Automation Engineer', 'TC-QA-004',
 'Lead automated testing for our enterprise products. Define test strategies and build comprehensive regression suites.',
 '3+ years experience with test automation. Proficiency in Selenium, JUnit, TestNG. Experience with API testing tools.',
 'Design and maintain automated test suites.\nCreate test plans and test cases.\nIntegrate tests into CI/CD pipeline.\nReport defects and track resolution.',
 'BSc in Computer Science, IT, or related field.',
 'Selenium, JUnit, TestNG, RestAssured, Jenkins',
 'FULL_TIME', 'MID', 'HYBRID', 'Information Technology', 'Colombo',
 180000.00, 280000.00, 'LKR', 1,
 DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'DRAFT', 0, NULL),

(5, 1, 'Technical Intern', 'TC-IN-005',
 'Six-month internship opportunity for final-year undergraduates interested in Java development and software engineering.',
 'Currently pursuing BSc in CS or SE. Basic knowledge of Java and SQL.',
 'Assist senior developers with coding tasks.\nLearn enterprise development practices.\nContribute to documentation.',
 'Final-year undergraduate in CS, SE, or IT.',
 'Java, SQL, Git',
 'INTERNSHIP', 'ENTRY', 'ONSITE', 'Information Technology', 'Colombo',
 35000.00, 50000.00, 'LKR', 5,
 DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'CLOSED', 156, CURRENT_TIMESTAMP);

-- Update closed_at for vacancy 5
UPDATE vacancies SET closed_at = CURRENT_TIMESTAMP WHERE vacancy_id = 5;

-- ============================================================
-- SAMPLE VACANCIES (Employer 2: Global Bank PLC)
-- ============================================================
INSERT INTO vacancies (vacancy_id, employer_id, job_title, job_code, description, requirements, responsibilities, qualifications, skills_required, employment_type, experience_level, work_mode, industry, location, salary_min, salary_max, salary_currency, vacancies_count, application_deadline, status, views_count, published_at)
VALUES
(6, 2, 'Financial Data Analyst', 'GB-DA-001',
 'Analyze banking transaction data and produce executive dashboards for senior management decision-making.',
 'Strong SQL skills. Experience with data visualization tools (Tableau, PowerBI). Knowledge of financial metrics.',
 'Build interactive dashboards for C-level executives.\nAnalyze transaction patterns and fraud indicators.\nProduce monthly financial reports.\nCollaborate with risk management team.',
 'BSc in Finance, Statistics, or IT. Chartered qualification is a plus.',
 'SQL, Python, Tableau, PowerBI, Excel, Financial Analysis',
 'FULL_TIME', 'MID', 'ONSITE', 'Financial Services', 'Colombo',
 200000.00, 320000.00, 'LKR', 1,
 DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'PUBLISHED', 34,
 CURRENT_TIMESTAMP),

(7, 2, 'Risk Management Officer', 'GB-RM-002',
 'Evaluate and mitigate financial risks across the bank portfolio. Work with compliance and audit teams.',
 '4+ years experience in risk management or compliance. Knowledge of Basel III regulations.',
 'Assess credit, market, and operational risks.\nDevelop risk mitigation strategies.\nPrepare regulatory reports.\nConduct internal risk audits.',
 'BSc in Finance or Accounting. Professional certification (FRM, PRM) preferred.',
 'Risk Analysis, Compliance, Basel III, Excel, SAP',
 'FULL_TIME', 'SENIOR', 'ONSITE', 'Financial Services', 'Colombo',
 300000.00, 500000.00, 'LKR', 1,
 DATE_ADD(CURDATE(), INTERVAL 20 DAY), 'PUBLISHED', 18,
 CURRENT_TIMESTAMP),

(8, 2, 'Marketing Coordinator (Contract)', 'GB-MK-003',
 'Support the digital marketing team in executing campaigns for new banking products.',
 '1-2 years marketing experience. Social media management skills.',
 'Coordinate digital marketing campaigns.\nManage social media accounts.\nTrack campaign metrics.\nLiaise with creative agencies.',
 'BSc in Marketing or Business. Fresh graduates may apply.',
 'Digital Marketing, Social Media, Content Creation, Google Analytics',
 'CONTRACT', 'JUNIOR', 'ONSITE', 'Financial Services', 'Colombo',
 100000.00, 150000.00, 'LKR', 2,
 DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'PUBLISHED', 67,
 CURRENT_TIMESTAMP);

-- Expired vacancy for testing
INSERT INTO vacancies (vacancy_id, employer_id, job_title, job_code, description, requirements, responsibilities, qualifications, skills_required, employment_type, experience_level, work_mode, industry, location, salary_min, salary_max, salary_currency, vacancies_count, application_deadline, status, views_count, published_at)
VALUES
(9, 1, 'Part-Time Data Entry Clerk', 'TC-DE-006',
 'Part-time data entry and records management position.',
 'Basic computer skills. Accuracy and attention to detail.',
 'Enter and verify data records.\nMaintain electronic filing system.',
 'O/L or A/L qualification.',
 'Data Entry, MS Office, Typing',
 'PART_TIME', 'ENTRY', 'ONSITE', 'Information Technology', 'Colombo',
 25000.00, 40000.00, 'LKR', 2,
 DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'EXPIRED', 203,
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 40 DAY))
ON DUPLICATE KEY UPDATE job_title = VALUES(job_title);

-- ============================================================
-- SAMPLE APPLICATIONS
-- ============================================================
INSERT INTO applications (application_id, vacancy_id, candidate_id, cover_letter, status, recruiter_notes)
VALUES
(1, 1, 1,
 'Dear Hiring Manager,\n\nI am excited to apply for the Senior Java Software Engineer position at TechCorp Lanka. With 4 years of hands-on experience in Java, Servlets, JSP, and MySQL, I am confident I can contribute meaningfully to your development team.\n\nBest regards,\nKavindu Silva',
 'SHORTLISTED',
 'Strong Java skills demonstrated. Good cultural fit. Schedule technical interview.'),
(2, 1, 3,
 'I wish to apply for the Senior Java role. My 5 years of experience in enterprise Java development makes me a strong candidate.',
 'UNDER_REVIEW', NULL),
(3, 6, 2,
 'I would like to apply for the Financial Data Analyst position. My data analysis background and SQL skills align well with this role.',
 'APPLIED', NULL),
(4, 3, 1,
 'I am also interested in the Junior Frontend Developer position to expand my skill set.',
 'REJECTED',
 'Overqualified for junior role. Recommended for senior position instead.'),
(5, 8, 4,
 'I am applying for the Marketing Coordinator contract position. My digital marketing experience at BrandWorks is directly relevant.',
 'APPLIED', NULL)
ON DUPLICATE KEY UPDATE status = VALUES(status);

-- ============================================================
-- SAMPLE APPLICATION STATUS HISTORY
-- ============================================================
INSERT INTO application_status_history (application_id, old_status, new_status, changed_by, remarks)
VALUES
(1, NULL,              'APPLIED',       4, 'Application submitted'),
(1, 'APPLIED',         'UNDER_REVIEW',  2, 'Resume reviewed — strong candidate'),
(1, 'UNDER_REVIEW',    'SHORTLISTED',   2, 'Shortlisted for technical interview'),
(2, NULL,              'APPLIED',       6, 'Application submitted'),
(2, 'APPLIED',         'UNDER_REVIEW',  2, 'Initial screening in progress'),
(3, NULL,              'APPLIED',       5, 'Application submitted'),
(4, NULL,              'APPLIED',       4, 'Application submitted'),
(4, 'APPLIED',         'REJECTED',      2, 'Candidate is overqualified for this junior role'),
(5, NULL,              'APPLIED',       7, 'Application submitted')
ON DUPLICATE KEY UPDATE new_status = VALUES(new_status);

-- ============================================================
-- SAMPLE AUDIT LOGS
-- ============================================================
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, description, ip_address)
VALUES
(2, 'CREATE_VACANCY',  'VACANCY', 1, 'Created vacancy: Senior Java Software Engineer',          '192.168.1.10'),
(2, 'PUBLISH_VACANCY', 'VACANCY', 1, 'Published vacancy: Senior Java Software Engineer',        '192.168.1.10'),
(2, 'CREATE_VACANCY',  'VACANCY', 2, 'Created vacancy: DevOps Engineer',                        '192.168.1.10'),
(2, 'PUBLISH_VACANCY', 'VACANCY', 2, 'Published vacancy: DevOps Engineer',                      '192.168.1.10'),
(4, 'APPLY_JOB',       'APPLICATION', 1, 'Applied for: Senior Java Software Engineer',           '192.168.1.20'),
(2, 'UPDATE_APPLICATION_STATUS', 'APPLICATION', 1, 'Status changed to SHORTLISTED',              '192.168.1.10'),
(3, 'CREATE_VACANCY',  'VACANCY', 6, 'Created vacancy: Financial Data Analyst',                  '192.168.1.15'),
(1, 'LOGIN',           'USER',    1, 'Admin login',                                              '192.168.1.1');

-- ============================================================
-- DEMO CREDENTIALS SUMMARY
-- ============================================================
-- +------------------+------------------------+--------------+
-- | Role             | Email                  | Password     |
-- +------------------+------------------------+--------------+
-- | ADMIN            | admin@system.com       | Admin@1234   |
-- | EMPLOYER         | amal@techcorp.lk       | Employer@123 |
-- | EMPLOYER         | nimali@globalbank.lk   | Employer@123 |
-- | JOB_SEEKER       | kavindu@gmail.com      | Seeker@123   |
-- | JOB_SEEKER       | sachini@gmail.com      | Seeker@123   |
-- | JOB_SEEKER       | tharindu@gmail.com     | Seeker@123   |
-- | JOB_SEEKER       | dilini@gmail.com       | Seeker@123   |
-- | JOB_SEEKER       | nuwan@gmail.com        | Seeker@123   |
-- +------------------+------------------------+--------------+
-- NOTE: All passwords use the same BCrypt hash for demo simplicity.
--       In production, each user would have a unique salt.
