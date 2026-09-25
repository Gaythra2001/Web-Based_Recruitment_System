package com.recruitment.dao;

import com.recruitment.model.Application;
import com.recruitment.model.ApplicationStatusHistory;
import com.recruitment.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Applications and Status tracking.
 */
public class ApplicationDAO {

    public boolean hasCandidateApplied(int vacancyId, int candidateId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications WHERE vacancy_id = ? AND candidate_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            ps.setInt(2, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int submitApplication(Application app, int userId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String sqlApp = "INSERT INTO applications (vacancy_id, candidate_id, cover_letter, cv_snapshot_path, status) " +
                            "VALUES (?, ?, ?, ?, 'APPLIED')";
            int appId = -1;
            try (PreparedStatement ps = conn.prepareStatement(sqlApp, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, app.getVacancyId());
                ps.setInt(2, app.getCandidateId());
                ps.setString(3, app.getCoverLetter());
                ps.setString(4, app.getCvSnapshotPath());
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        appId = rs.getInt(1);
                    }
                }
            }

            if (appId > 0) {
                String sqlHist = "INSERT INTO application_status_history (application_id, old_status, new_status, changed_by, remarks) " +
                                 "VALUES (?, NULL, 'APPLIED', ?, 'Initial application submitted.')";
                try (PreparedStatement psHist = conn.prepareStatement(sqlHist)) {
                    psHist.setInt(1, appId);
                    psHist.setInt(2, userId);
                    psHist.executeUpdate();
                }
            }

            conn.commit();
            return appId;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public Application findById(int applicationId) throws SQLException {
        String sql = "SELECT a.*, v.job_title, v.location AS vacancy_location, v.employment_type, " +
                     "e.company_name, u.first_name, u.last_name, u.email AS candidate_email, u.phone AS candidate_phone, " +
                     "cp.cv_file_path AS candidate_cv_path " +
                     "FROM applications a " +
                     "JOIN vacancies v ON a.vacancy_id = v.vacancy_id " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "JOIN candidate_profiles cp ON a.candidate_id = cp.candidate_id " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE a.application_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapApplication(rs);
                }
            }
        }
        return null;
    }

    public List<Application> findByCandidateId(int candidateId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, v.job_title, v.location AS vacancy_location, v.employment_type, " +
                     "e.company_name, u.first_name, u.last_name, u.email AS candidate_email, u.phone AS candidate_phone, " +
                     "cp.cv_file_path AS candidate_cv_path " +
                     "FROM applications a " +
                     "JOIN vacancies v ON a.vacancy_id = v.vacancy_id " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "JOIN candidate_profiles cp ON a.candidate_id = cp.candidate_id " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE a.candidate_id = ? " +
                     "ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapApplication(rs));
                }
            }
        }
        return list;
    }

    public List<Application> findByVacancyId(int vacancyId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, v.job_title, v.location AS vacancy_location, v.employment_type, " +
                     "e.company_name, u.first_name, u.last_name, u.email AS candidate_email, u.phone AS candidate_phone, " +
                     "cp.cv_file_path AS candidate_cv_path " +
                     "FROM applications a " +
                     "JOIN vacancies v ON a.vacancy_id = v.vacancy_id " +
                     "JOIN employers e ON v.employer_id = e.employer_id " +
                     "JOIN candidate_profiles cp ON a.candidate_id = cp.candidate_id " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE a.vacancy_id = ? " +
                     "ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vacancyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapApplication(rs));
                }
            }
        }
        return list;
    }

    public boolean updateStatus(int applicationId, String newStatus, int changedByUserId, String remarks, String recruiterNotes) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String oldStatus = null;
            String checkSql = "SELECT status FROM applications WHERE application_id = ?";
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, applicationId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        oldStatus = rs.getString(1);
                    }
                }
            }

            if (oldStatus == null) {
                conn.rollback();
                return false;
            }

            String updateSql = "UPDATE applications SET status = ?, recruiter_notes = ? WHERE application_id = ?";
            try (PreparedStatement psUp = conn.prepareStatement(updateSql)) {
                psUp.setString(1, newStatus);
                psUp.setString(2, recruiterNotes);
                psUp.setInt(3, applicationId);
                psUp.executeUpdate();
            }

            String histSql = "INSERT INTO application_status_history (application_id, old_status, new_status, changed_by, remarks) " +
                             "VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psHist = conn.prepareStatement(histSql)) {
                psHist.setInt(1, applicationId);
                psHist.setString(2, oldStatus);
                psHist.setString(3, newStatus);
                psHist.setInt(4, changedByUserId);
                psHist.setString(5, remarks);
                psHist.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public boolean withdrawApplication(int applicationId, int candidateId, int userId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String updateSql = "UPDATE applications SET status = 'WITHDRAWN' WHERE application_id = ? AND candidate_id = ? AND status != 'WITHDRAWN'";
            int affected;
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setInt(1, applicationId);
                ps.setInt(2, candidateId);
                affected = ps.executeUpdate();
            }

            if (affected > 0) {
                String histSql = "INSERT INTO application_status_history (application_id, old_status, new_status, changed_by, remarks) " +
                                 "VALUES (?, 'APPLIED', 'WITHDRAWN', ?, 'Application withdrawn by candidate.')";
                try (PreparedStatement psHist = conn.prepareStatement(histSql)) {
                    psHist.setInt(1, applicationId);
                    psHist.setInt(2, userId);
                    psHist.executeUpdate();
                }
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            throw e;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    public List<ApplicationStatusHistory> getStatusHistory(int applicationId) throws SQLException {
        List<ApplicationStatusHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, u.first_name, u.last_name, u.role " +
                     "FROM application_status_history h " +
                     "JOIN users u ON h.changed_by = u.user_id " +
                     "WHERE h.application_id = ? " +
                     "ORDER BY h.changed_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ApplicationStatusHistory h = new ApplicationStatusHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setApplicationId(rs.getInt("application_id"));
                    h.setOldStatus(rs.getString("old_status"));
                    h.setNewStatus(rs.getString("new_status"));
                    h.setChangedBy(rs.getInt("changed_by"));
                    h.setChangedAt(rs.getTimestamp("changed_at"));
                    h.setRemarks(rs.getString("remarks"));
                    h.setChangedByName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    h.setChangedByRole(rs.getString("role"));
                    list.add(h);
                }
            }
        }
        return list;
    }

    public int countTotal() throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private Application mapApplication(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setVacancyId(rs.getInt("vacancy_id"));
        a.setCandidateId(rs.getInt("candidate_id"));
        a.setCoverLetter(rs.getString("cover_letter"));
        a.setCvSnapshotPath(rs.getString("cv_snapshot_path"));
        a.setStatus(rs.getString("status"));
        a.setRecruiterNotes(rs.getString("recruiter_notes"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));

        a.setJobTitle(rs.getString("job_title"));
        a.setCompanyName(rs.getString("company_name"));
        a.setCandidateName(rs.getString("first_name") + " " + rs.getString("last_name"));
        a.setCandidateEmail(rs.getString("candidate_email"));
        a.setCandidatePhone(rs.getString("candidate_phone"));
        a.setCandidateCvPath(rs.getString("candidate_cv_path"));
        a.setVacancyLocation(rs.getString("vacancy_location"));
        a.setEmploymentType(rs.getString("employment_type"));
        return a;
    }
}
