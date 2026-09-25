package com.recruitment.dao;

import com.recruitment.model.AuditLog;
import com.recruitment.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for system audit logging.
 */
public class AuditLogDAO {

    public void log(Integer userId, String action, String entityType, Integer entityId, String description, String ipAddress) {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, description, ip_address) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null && userId > 0) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, action);
            ps.setString(3, entityType);
            if (entityId != null && entityId > 0) {
                ps.setInt(4, entityId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, description);
            ps.setString(6, ipAddress);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<AuditLog> findRecent(int limit) throws SQLException {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.email, CONCAT(u.first_name, ' ', u.last_name) AS full_name " +
                     "FROM audit_logs al " +
                     "LEFT JOIN users u ON al.user_id = u.user_id " +
                     "ORDER BY al.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AuditLog log = new AuditLog();
                    log.setAuditId(rs.getInt("audit_id"));
                    int uid = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        log.setUserId(uid);
                    }
                    log.setAction(rs.getString("action"));
                    log.setEntityType(rs.getString("entity_type"));
                    int eid = rs.getInt("entity_id");
                    if (!rs.wasNull()) {
                        log.setEntityId(eid);
                    }
                    log.setDescription(rs.getString("description"));
                    log.setIpAddress(rs.getString("ip_address"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    log.setUserEmail(rs.getString("email"));
                    log.setUserName(rs.getString("full_name"));
                    list.add(log);
                }
            }
        }
        return list;
    }
}
