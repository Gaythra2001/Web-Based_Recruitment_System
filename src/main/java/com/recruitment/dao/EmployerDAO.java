package com.recruitment.dao;

import com.recruitment.model.Employer;
import com.recruitment.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Employer profiles.
 */
public class EmployerDAO {

    public Employer findById(int employerId) throws SQLException {
        String sql = "SELECT e.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM employers e " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "WHERE e.employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapEmployer(rs);
                }
            }
        }
        return null;
    }

    public Employer findByUserId(int userId) throws SQLException {
        String sql = "SELECT e.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM employers e " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "WHERE e.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapEmployer(rs);
                }
            }
        }
        return null;
    }

    public int createEmployer(Employer emp) throws SQLException {
        String sql = "INSERT INTO employers (user_id, company_name, company_email, company_phone, company_address, city, industry, company_description, website) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, emp.getUserId());
            ps.setString(2, emp.getCompanyName());
            ps.setString(3, emp.getCompanyEmail());
            ps.setString(4, emp.getCompanyPhone());
            ps.setString(5, emp.getCompanyAddress());
            ps.setString(6, emp.getCity());
            ps.setString(7, emp.getIndustry());
            ps.setString(8, emp.getCompanyDescription());
            ps.setString(9, emp.getWebsite());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        emp.setEmployerId(rs.getInt(1));
                        return emp.getEmployerId();
                    }
                }
            }
        }
        return -1;
    }

    public boolean updateEmployer(Employer emp) throws SQLException {
        String sql = "UPDATE employers SET company_name = ?, company_email = ?, company_phone = ?, " +
                     "company_address = ?, city = ?, industry = ?, company_description = ?, website = ? " +
                     "WHERE employer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, emp.getCompanyName());
            ps.setString(2, emp.getCompanyEmail());
            ps.setString(3, emp.getCompanyPhone());
            ps.setString(4, emp.getCompanyAddress());
            ps.setString(5, emp.getCity());
            ps.setString(6, emp.getIndustry());
            ps.setString(7, emp.getCompanyDescription());
            ps.setString(8, emp.getWebsite());
            ps.setInt(9, emp.getEmployerId());
            return ps.executeUpdate() > 0;
        }
    }

    public List<Employer> findAll() throws SQLException {
        List<Employer> list = new ArrayList<>();
        String sql = "SELECT e.*, u.first_name, u.last_name, u.email, u.phone " +
                     "FROM employers e " +
                     "JOIN users u ON e.user_id = u.user_id " +
                     "ORDER BY e.company_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapEmployer(rs));
            }
        }
        return list;
    }

    private Employer mapEmployer(ResultSet rs) throws SQLException {
        Employer e = new Employer();
        e.setEmployerId(rs.getInt("employer_id"));
        e.setUserId(rs.getInt("user_id"));
        e.setCompanyName(rs.getString("company_name"));
        e.setCompanyEmail(rs.getString("company_email"));
        e.setCompanyPhone(rs.getString("company_phone"));
        e.setCompanyAddress(rs.getString("company_address"));
        e.setCity(rs.getString("city"));
        e.setIndustry(rs.getString("industry"));
        e.setCompanyDescription(rs.getString("company_description"));
        e.setWebsite(rs.getString("website"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        e.setUpdatedAt(rs.getTimestamp("updated_at"));
        e.setUserEmail(rs.getString("email"));
        e.setContactPerson(rs.getString("first_name") + " " + rs.getString("last_name"));
        return e;
    }
}
