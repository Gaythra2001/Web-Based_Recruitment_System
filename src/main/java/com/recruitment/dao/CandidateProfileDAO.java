package com.recruitment.dao;

import com.recruitment.model.CandidateProfile;
import com.recruitment.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Candidate profiles.
 */
public class CandidateProfileDAO {

    public CandidateProfile findById(int candidateId) throws SQLException {
        String sql = "SELECT cp.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM candidate_profiles cp " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE cp.candidate_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidateId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCandidate(rs);
                }
            }
        }
        return null;
    }

    public CandidateProfile findByUserId(int userId) throws SQLException {
        String sql = "SELECT cp.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM candidate_profiles cp " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "WHERE cp.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCandidate(rs);
                }
            }
        }
        return null;
    }

    public int createProfile(CandidateProfile cp) throws SQLException {
        String sql = "INSERT INTO candidate_profiles (user_id, date_of_birth, gender, address, city, country, education, skills, experience, current_job_title, profile_summary) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, cp.getUserId());
            ps.setDate(2, cp.getDateOfBirth());
            ps.setString(3, cp.getGender());
            ps.setString(4, cp.getAddress());
            ps.setString(5, cp.getCity());
            ps.setString(6, cp.getCountry() != null ? cp.getCountry() : "Sri Lanka");
            ps.setString(7, cp.getEducation());
            ps.setString(8, cp.getSkills());
            ps.setString(9, cp.getExperience());
            ps.setString(10, cp.getCurrentJobTitle());
            ps.setString(11, cp.getProfileSummary());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        cp.setCandidateId(rs.getInt(1));
                        return cp.getCandidateId();
                    }
                }
            }
        }
        return -1;
    }

    public boolean updateProfile(CandidateProfile cp) throws SQLException {
        String sql = "UPDATE candidate_profiles SET date_of_birth = ?, gender = ?, address = ?, city = ?, country = ?, " +
                     "education = ?, skills = ?, experience = ?, current_job_title = ?, profile_summary = ? " +
                     "WHERE candidate_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, cp.getDateOfBirth());
            ps.setString(2, cp.getGender());
            ps.setString(3, cp.getAddress());
            ps.setString(4, cp.getCity());
            ps.setString(5, cp.getCountry());
            ps.setString(6, cp.getEducation());
            ps.setString(7, cp.getSkills());
            ps.setString(8, cp.getExperience());
            ps.setString(9, cp.getCurrentJobTitle());
            ps.setString(10, cp.getProfileSummary());
            ps.setInt(11, cp.getCandidateId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateCv(int candidateId, String fileName, String filePath) throws SQLException {
        String sql = "UPDATE candidate_profiles SET cv_file_name = ?, cv_file_path = ?, cv_uploaded_at = NOW() WHERE candidate_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setString(2, filePath);
            ps.setInt(3, candidateId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<CandidateProfile> findAll() throws SQLException {
        List<CandidateProfile> list = new ArrayList<>();
        String sql = "SELECT cp.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM candidate_profiles cp " +
                     "JOIN users u ON cp.user_id = u.user_id " +
                     "ORDER BY cp.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCandidate(rs));
            }
        }
        return list;
    }

    private CandidateProfile mapCandidate(ResultSet rs) throws SQLException {
        CandidateProfile cp = new CandidateProfile();
        cp.setCandidateId(rs.getInt("candidate_id"));
        cp.setUserId(rs.getInt("user_id"));
        cp.setDateOfBirth(rs.getDate("date_of_birth"));
        cp.setGender(rs.getString("gender"));
        cp.setAddress(rs.getString("address"));
        cp.setCity(rs.getString("city"));
        cp.setCountry(rs.getString("country"));
        cp.setEducation(rs.getString("education"));
        cp.setSkills(rs.getString("skills"));
        cp.setExperience(rs.getString("experience"));
        cp.setCurrentJobTitle(rs.getString("current_job_title"));
        cp.setProfileSummary(rs.getString("profile_summary"));
        cp.setCvFileName(rs.getString("cv_file_name"));
        cp.setCvFilePath(rs.getString("cv_file_path"));
        cp.setCvUploadedAt(rs.getTimestamp("cv_uploaded_at"));
        cp.setCreatedAt(rs.getTimestamp("created_at"));
        cp.setUpdatedAt(rs.getTimestamp("updated_at"));
        cp.setFirstName(rs.getString("first_name"));
        cp.setLastName(rs.getString("last_name"));
        cp.setEmail(rs.getString("email"));
        cp.setPhone(rs.getString("phone"));
        return cp;
    }
}
