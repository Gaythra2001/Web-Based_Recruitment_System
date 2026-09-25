# Web-Based Recruitment System (HireHub)

> **Academic SE Individual Project — Java MVC Web Application**  
> **Core Focus:** Production-Grade **Vacancy Management Module** and Connected Recruitment Workflow.

---

## 1. Project Overview

The **Web-Based Recruitment System (HireHub)** is a robust, production-ready enterprise recruitment platform designed following the strict Java **Model-View-Controller (MVC)** architectural pattern. The system leverages **Java Servlets, JSP (JavaServer Pages), JSTL, JDBC, and MySQL**.

### Primary Business Function: Vacancy Management Module
The system's core business module is **Vacancy Management**, allowing employers to define, classify, publish, edit, close, and monitor job vacancies with full lifecycle tracking. It connects seamlessly to the talent application and status management workflows.

```
Employer → Create Vacancy → Publish Vacancy → Job Seeker Searches & Filters 
          → Job Seeker Applies (with PDF CV) → Employer Reviews Candidate 
          → Status Update (Shortlist/Reject/Hire) → Status History Audit Trail
```

---

## 2. Technology Stack & Architecture

| Architectural Layer | Technologies Employed |
|---|---|
| **Presentation Layer** | HTML5, CSS3 (Modern Glassmorphism & Custom Design Tokens), Bootstrap 5, Bootstrap Icons, JSP 2.3, JSTL 1.2 |
| **Controller Layer** | Java Servlets 4.0 (`@WebServlet`), Filters (`@WebFilter` for Auth Guards & UTF-8 Encoding), Multipart Uploads (`@MultipartConfig`) |
| **Model / DAO Layer** | POJOs (Plain Old Java Objects), Data Access Object (DAO) Pattern, JDBC (`PreparedStatement`) |
| **Security & Utilities** | BCrypt Password Hashing (`jbcrypt`), Input Validation & Sanitization, Audit Logging |
| **Database** | MySQL 8.0+ (InnoDB Engine, Foreign Keys, Referential Cascades, Scheduled Events) |
| **Build & Packaging** | Apache Maven 3.x / Native WAR distribution (`recruitment-system.war`) |

---

## 3. System Roles & Capabilities

### 🧑‍💼 1. Job Seeker (Candidate)
- **Account Management:** Registration and secure authentication.
- **Profile & CV:** Comprehensive career profile (education, experience, skills, contact) and verified **PDF CV upload**.
- **Vacancy Discovery:** Keyword search, multi-criteria filtering (location, industry, job type, work mode, experience level), and detailed job views.
- **Application Submission:** Apply with a single click, submit custom cover letter, attach CV snapshot.
- **Application Tracking:** Live status dashboard (`APPLIED`, `UNDER_REVIEW`, `SHORTLISTED`, `REJECTED`, `HIRED`, `WITHDRAWN`) with recruiter notes and withdrawal options.

### 🏢 2. Employer (Recruiter)
- **Company Profile:** Maintain company brand, headquarters, industry, contact, and website.
- **Vacancy Management (Main Module):**
  - **Create Vacancy:** Job title, unique code, requirements, qualifications, responsibilities, skills, salary range, vacancies count, and deadline.
  - **Publication Lifecycle:** Save as `DRAFT`, instantly `PUBLISH`, or manually `CLOSE` vacancies.
  - **Edit & Update:** Full editing controls over job specifications.
  - **Delete:** Safe removal of postings with cascade protections.
- **Applicant Review Pipeline:**
  - View all applicants per vacancy.
  - Inspect candidate profile, contact information, and download uploaded PDF CVs.
  - Read applicant cover letters.
  - Transition application status (`UNDER_REVIEW` ➔ `SHORTLISTED` ➔ `REJECTED` / `HIRED`) with audit justifications and private recruiter notes.

### 🛡️ 3. System Administrator
- **Platform Analytics:** Real-time metrics on total registered users, active vacancies, and total applications.
- **User Governance:** Inspect all user accounts across all roles; toggle account status between `ACTIVE` and `SUSPENDED`.
- **Vacancy Moderation:** Review all employer postings across the platform; delete abusive or duplicate vacancies.
- **System Audit Trail:** View persistent `audit_logs` capturing user actions, IP addresses, entity mutations, and timestamps.

---

## 4. Database Architecture & Schema

The relational database (`recruitment_system`) is defined in [`database/schema.sql`](file:///c:/Users/User/Downloads/SE%20submition/Web-Based_Recruitment_System/database/schema.sql) with comprehensive demonstration seed data in [`database/seed.sql`](file:///c:/Users/User/Downloads/SE%20submition/Web-Based_Recruitment_System/database/seed.sql).

### Normalized Tables
1. **`users`**: Base authentication table storing user credentials, role (`JOB_SEEKER`, `EMPLOYER`, `ADMIN`), phone, and account status (`ACTIVE`, `SUSPENDED`).
2. **`candidate_profiles`**: One-to-one extension for candidates containing birthdate, gender, location, education, experience, skills, and CV storage metadata.
3. **`employers`**: One-to-one extension for employers containing company name, email, phone, address, industry, description, and website.
4. **`vacancies`** *(Main Module)*: Primary entity recording job title, code, description, responsibilities, requirements, qualifications, skills, employment type, experience level, work mode, salary bounds, open positions count, deadline, views counter, and status (`DRAFT`, `PUBLISHED`, `CLOSED`, `EXPIRED`).
5. **`applications`**: Links candidates to vacancies with cover letter, CV snapshot path, current status, and recruiter notes. Prevents duplicate submissions via composite unique key `(vacancy_id, candidate_id)`.
6. **`application_status_history`**: Audit trail recording old status, new status, reviewer ID, timestamp, and justification remarks.
7. **`audit_logs`**: System security trail capturing login, logout, profile edits, vacancy creations, and admin actions.
8. **`evt_expire_vacancies`**: Automated nightly MySQL event that automatically shifts published vacancies past their deadline to `EXPIRED`.

---

## 5. Pre-Configured Demo Credentials

The seed data provides pre-configured testing accounts with hashed passwords:

| Role | Email Address | Plain Password | Sample Data Description |
|---|---|---|---|
| **System Admin** | `admin@system.com` | `Admin@1234` | Full admin privileges & moderation rights |
| **Employer 1** | `amal@techcorp.lk` | `Employer@123` | TechCorp Lanka (Has 5 posted vacancies) |
| **Employer 2** | `nimali@globalbank.lk` | `Employer@123` | Global Bank PLC (Has 3 posted vacancies) |
| **Job Seeker 1** | `kavindu@gmail.com` | `Seeker@123` | Senior Software Engineer Profile |
| **Job Seeker 2** | `sachini@gmail.com` | `Seeker@123` | Data Analyst Profile |
| **Job Seeker 3** | `tharindu@gmail.com` | `Seeker@123` | Senior Software Developer Profile |

---

## 6. How to Set Up & Run the Project

### Prerequisites
- **JDK 11 or higher** (Tested on JDK 11, 17, 21+)
- **MySQL Server 8.0+**
- **Apache Tomcat 9.0 or 10.x** (or embedded container / IDE)

### Step 1: Set Up MySQL Database
1. Open MySQL Command Line Client, MySQL Workbench, or phpMyAdmin:
   ```bash
   mysql -u root -p
   ```
2. Execute the schema script:
   ```sql
   SOURCE database/schema.sql;
   ```
3. Import the rich seed data:
   ```sql
   SOURCE database/seed.sql;
   ```

### Step 2: Configure Database Credentials
Edit [`src/main/resources/db.properties`](file:///c:/Users/User/Downloads/SE%20submition/Web-Based_Recruitment_System/src/main/resources/db.properties):
```properties
db.url=jdbc:mysql://localhost:3306/recruitment_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&characterEncoding=UTF-8
db.username=root
db.password=your_mysql_password
db.driver=com.mysql.cj.jdbc.Driver
```

### Step 3: Run the Application

#### Option A: Deploy Pre-built WAR to Apache Tomcat
1. Copy `target/recruitment-system.war` into your Tomcat `webapps/` folder.
2. Start Tomcat (`bin/startup.bat` on Windows or `bin/catalina.sh run` on Linux/macOS).
3. Access in browser:
   ```
   http://localhost:8080/recruitment-system/
   ```

#### Option B: Run in Eclipse IDE / IntelliJ IDEA
1. Import project as an **Existing Maven Project** or Web Project.
2. Right-click the project ➔ **Run As** ➔ **Run on Server** (select Apache Tomcat 9/10).

#### Option C: Build and Package with Maven
```bash
mvn clean package
```
The compiled deployable WAR is produced at `target/recruitment-system.war`.

---

## 7. Security & Non-Functional Highlights

- **SQL Injection Prevention:** 100% of database queries are executed via JDBC `PreparedStatement` with typed parameter binding.
- **BCrypt Password Security:** Passwords are never stored in plaintext; salted and hashed with `jbcrypt` (work factor 12).
- **Filter-based Authorization:** `AuthenticationFilter` dynamically restricts access to `/employer/*`, `/admin/*`, and `/candidate/*` endpoints based on verified session claims.
- **Audit Compliance:** Changes to vacancy statuses and applicant progressions record an immutable audit history entry with operator ID and remarks.
- **Clean Responsive UX:** Responsive CSS design system crafted with Bootstrap 5, semantic color hierarchies, accessible form validation, and glassmorphic elevated surfaces.
