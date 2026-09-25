package com.recruitment.dao;

import com.recruitment.model.Vacancy;
import com.recruitment.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Vacancy operations.
 * Heart of the Vacancy Management Module.
 */
public class VacancyDAO {

    public Vacancy findById(int vacancyId) throws SQLException {
        String sql = "SELECT v.*, e.company_name, e.city AS company_city, e.industry AS company_industry, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.vacancy_id = v.vacancy_id) AS applications_count " +
                     "FROM vacancies v " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "WHERE v.vacancy_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVacancy(rs);
                }
            }
        }
        return null;
    }

    public int createVacancy(Vacancy v) throws SQLException {
        String sql = "INSERT INTO vacancies (employer_id, job_title, job_code, description, requirements, " +
                     "responsibilities, qualifications, skills_required, employment_type, experience_level, " +
                     "work_mode, industry, location, salary_min, salary_max, salary_currency, vacancies_count, " +
                     "application_deadline, status, published_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, v.getEmployerId());
            ps.setString(2, v.getJobTitle());
            ps.setString(3, v.getJobCode());
            ps.setString(4, v.getDescription());
            ps.setString(5, v.getRequirements());
            ps.setString(6, v.getResponsibilities());
            ps.setString(7, v.getQualifications());
            ps.setString(8, v.getSkillsRequired());
            ps.setString(9, v.getEmploymentType() != null ? v.getEmploymentType() : "FULL_TIME");
            ps.setString(10, v.getExperienceLevel() != null ? v.getExperienceLevel() : "ENTRY");
            ps.setString(11, v.getWorkMode() != null ? v.getWorkMode() : "ONSITE");
            ps.setString(12, v.getIndustry());
            ps.setString(13, v.getLocation());
            ps.setBigDecimal(14, v.getSalaryMin());
            ps.setBigDecimal(15, v.getSalaryMax());
            ps.setString(16, v.getSalaryCurrency() != null ? v.getSalaryCurrency() : "LKR");
            ps.setInt(17, v.getVacanciesCount() > 0 ? v.getVacanciesCount() : 1);
            ps.setDate(18, v.getApplicationDeadline());
            
            String status = v.getStatus() != null ? v.getStatus() : "DRAFT";
            ps.setString(19, status);
            if ("PUBLISHED".equals(status)) {
                ps.setTimestamp(20, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(20, Types.TIMESTAMP);
            }

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        v.setVacancyId(rs.getInt(1));
                        return v.getVacancyId();
                    }
                }
            }
        }
        return -1;
    }

    public boolean updateVacancy(Vacancy v) throws SQLException {
        String sql = "UPDATE vacancies SET job_title = ?, job_code = ?, description = ?, requirements = ?, " +
                     "responsibilities = ?, qualifications = ?, skills_required = ?, employment_type = ?, " +
                     "experience_level = ?, work_mode = ?, industry = ?, location = ?, salary_min = ?, " +
                     "salary_max = ?, salary_currency = ?, vacancies_count = ?, application_deadline = ? " +
                     "WHERE vacancy_id = ? AND employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getJobTitle());
            ps.setString(2, v.getJobCode());
            ps.setString(3, v.getDescription());
            ps.setString(4, v.getRequirements());
            ps.setString(5, v.getResponsibilities());
            ps.setString(6, v.getQualifications());
            ps.setString(7, v.getSkillsRequired());
            ps.setString(8, v.getEmploymentType());
            ps.setString(9, v.getExperienceLevel());
            ps.setString(10, v.getWorkMode());
            ps.setString(11, v.getIndustry());
            ps.setString(12, v.getLocation());
            ps.setBigDecimal(13, v.getSalaryMin());
            ps.setBigDecimal(14, v.getSalaryMax());
            ps.setString(15, v.getSalaryCurrency());
            ps.setInt(16, v.getVacanciesCount());
            ps.setDate(17, v.getApplicationDeadline());
            ps.setInt(18, v.getVacancyId());
            ps.setInt(19, v.getEmployerId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int vacancyId, String status) throws SQLException {
        String sql;
        if ("PUBLISHED".equals(status)) {
            sql = "UPDATE vacancies SET status = ?, published_at = NOW(), closed_at = NULL WHERE vacancy_id = ?";
        } else if ("CLOSED".equals(status)) {
            sql = "UPDATE vacancies SET status = ?, closed_at = NOW() WHERE vacancy_id = ?";
        } else {
            sql = "UPDATE vacancies SET status = ? WHERE vacancy_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, vacancyId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteVacancy(int vacancyId, int employerId) throws SQLException {
        String sql = "DELETE FROM vacancies WHERE vacancy_id = ? AND employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            ps.setInt(2, employerId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean adminDeleteVacancy(int vacancyId) throws SQLException {
        String sql = "DELETE FROM vacancies WHERE vacancy_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            return ps.executeUpdate() > 0;
        }
    }

    public void incrementViews(int vacancyId) {
        String sql = "UPDATE vacancies SET views_count = views_count + 1 WHERE vacancy_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            ps.executeUpdate();
        } catch (SQLException ignored) {
        }
    }

    public List<Vacancy> findByEmployerId(int employerId) throws SQLException {
        List<Vacancy> list = new ArrayList<>();
        String sql = "SELECT v.*, e.company_name, e.city AS company_city, e.industry AS company_industry, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.vacancy_id = v.vacancy_id) AS applications_count " +
                     "FROM vacancies v " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "WHERE v.employer_id = ? " +
                     "ORDER BY v.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVacancy(rs));
                }
            }
        }
        return list;
    }

    public List<Vacancy> searchAndFilter(String keyword, String location, String industry,
                                        String employmentType, String experienceLevel, String workMode,
                                        int offset, int limit) throws SQLException {
        List<Vacancy> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT v.*, e.company_name, e.city AS company_city, e.industry AS company_industry, ")
           .append("(SELECT COUNT(*) FROM applications a WHERE a.vacancy_id = v.vacancy_id) AS applications_count ")
           .append("FROM vacancies v ")
           .append("JOIN employers e ON v.employer_id = e.employer_id ")
           .append("WHERE v.status = 'PUBLISHED' AND v.application_deadline >= CURDATE() ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (v.job_title LIKE ? OR v.description LIKE ? OR v.skills_required LIKE ? OR e.company_name LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND v.location LIKE ? ");
            params.add("%" + location.trim() + "%");
        }
        if (industry != null && !industry.trim().isEmpty()) {
            sql.append("AND (v.industry = ? OR e.industry = ?) ");
            params.add(industry.trim());
            params.add(industry.trim());
        }
        if (employmentType != null && !employmentType.trim().isEmpty()) {
            sql.append("AND v.employment_type = ? ");
            params.add(employmentType.trim());
        }
        if (experienceLevel != null && !experienceLevel.trim().isEmpty()) {
            sql.append("AND v.experience_level = ? ");
            params.add(experienceLevel.trim());
        }
        if (workMode != null && !workMode.trim().isEmpty()) {
            sql.append("AND v.work_mode = ? ");
            params.add(workMode.trim());
        }

        sql.append("ORDER BY v.published_at DESC, v.created_at DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVacancy(rs));
                }
            }
        }
        return list;
    }

    public int countSearchResults(String keyword, String location, String industry,
                                  String employmentType, String experienceLevel, String workMode) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM vacancies v ")
           .append("JOIN employers e ON v.employer_id = e.employer_id ")
           .append("WHERE v.status = 'PUBLISHED' AND v.application_deadline >= CURDATE() ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (v.job_title LIKE ? OR v.description LIKE ? OR v.skills_required LIKE ? OR e.company_name LIKE ?) ");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND v.location LIKE ? ");
            params.add("%" + location.trim() + "%");
        }
        if (industry != null && !industry.trim().isEmpty()) {
            sql.append("AND (v.industry = ? OR e.industry = ?) ");
            params.add(industry.trim());
            params.add(industry.trim());
        }
        if (employmentType != null && !employmentType.trim().isEmpty()) {
            sql.append("AND v.employment_type = ? ");
            params.add(employmentType.trim());
        }
        if (experienceLevel != null && !experienceLevel.trim().isEmpty()) {
            sql.append("AND v.experience_level = ? ");
            params.add(experienceLevel.trim());
        }
        if (workMode != null && !workMode.trim().isEmpty()) {
            sql.append("AND v.work_mode = ? ");
            params.add(workMode.trim());
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<Vacancy> findAll() throws SQLException {
        List<Vacancy> list = new ArrayList<>();
        String sql = "SELECT v.*, e.company_name, e.city AS company_city, e.industry AS company_industry, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.vacancy_id = v.vacancy_id) AS applications_count " +
                     "FROM vacancies v " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "ORDER BY v.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapVacancy(rs));
            }
        }
        return list;
    }

    public int countTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vacancies";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public int countPublished() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vacancies WHERE status = 'PUBLISHED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public void autoExpirePastDeadlines() {
        String sql = "UPDATE vacancies SET status = 'EXPIRED' WHERE status = 'PUBLISHED' AND application_deadline < CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException ignored) {
        }
    }

    private Vacancy mapVacancy(ResultSet rs) throws SQLException {
        Vacancy v = new Vacancy();
        v.setVacancyId(rs.getInt("vacancy_id"));
        v.setEmployerId(rs.getInt("employer_id"));
        v.setJobTitle(rs.getString("job_title"));
        v.setJobCode(rs.getString("job_code"));
        v.setDescription(rs.getString("description"));
        v.setRequirements(rs.getString("requirements"));
        v.setResponsibilities(rs.getString("responsibilities"));
        v.setQualifications(rs.getString("qualifications"));
        v.setSkillsRequired(rs.getString("skills_required"));
        v.setEmploymentType(rs.getString("employment_type"));
        v.setExperienceLevel(rs.getString("experience_level"));
        v.setWorkMode(rs.getString("work_mode"));
        v.setIndustry(rs.getString("industry"));
        v.setLocation(rs.getString("location"));
        v.setSalaryMin(rs.getBigDecimal("salary_min"));
        v.setSalaryMax(rs.getBigDecimal("salary_max"));
        v.setSalaryCurrency(rs.getString("salary_currency"));
        v.setVacanciesCount(rs.getInt("vacancies_count"));
        v.setApplicationDeadline(rs.getDate("application_deadline"));
        v.setStatus(rs.getString("status"));
        v.setViewsCount(rs.getInt("views_count"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        v.setUpdatedAt(rs.getTimestamp("updated_at"));
        v.setPublishedAt(rs.getTimestamp("published_at"));
        v.setClosedAt(rs.getTimestamp("closed_at"));

        v.setCompanyName(rs.getString("company_name"));
        v.setCompanyCity(rs.getString("company_city"));
        v.setCompanyIndustry(rs.getString("company_industry"));
        v.setApplicationsCount(rs.getInt("applications_count"));
        return v;
    }
}
