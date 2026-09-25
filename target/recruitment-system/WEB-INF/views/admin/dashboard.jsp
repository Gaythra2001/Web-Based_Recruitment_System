<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Admin Dashboard" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">System Administration</h3>
        <p class="text-muted small mb-0">Platform overview, security audit log, and moderation controls</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-custom btn-sm">
            <i class="bi bi-people me-1"></i> Manage Users
        </a>
        <a href="${pageContext.request.contextPath}/admin/vacancies" class="btn btn-primary-custom btn-sm">
            <i class="bi bi-layers me-1"></i> Moderate Vacancies
        </a>
    </div>
</div>

<!-- Metrics Cards -->
<div class="row g-4 mb-4">
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-blue">
                <i class="bi bi-people"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0"><c:out value="${totalUsers}"/></h3>
                <span class="text-muted small">Total Registered Users</span>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-purple">
                <i class="bi bi-briefcase"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0"><c:out value="${totalVacancies}"/></h3>
                <span class="text-muted small">Total System Vacancies</span>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="stat-card">
            <div class="stat-icon stat-icon-green">
                <i class="bi bi-file-earmark-check"></i>
            </div>
            <div>
                <h3 class="fw-bold mb-0"><c:out value="${totalApplications}"/></h3>
                <span class="text-muted small">Total Applications Processed</span>
            </div>
        </div>
    </div>
</div>

<!-- Recent Audit Activity -->
<div class="card card-custom p-4 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><i class="bi bi-journal-text text-primary me-2"></i> Recent System Activity Logs</h5>
        <a href="${pageContext.request.contextPath}/admin/audit" class="btn btn-sm btn-link">View Full Log</a>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Timestamp</th>
                    <th>User</th>
                    <th>Action</th>
                    <th>Entity</th>
                    <th>Description</th>
                    <th>IP Address</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty recentLogs}">
                        <c:forEach var="log" items="${recentLogs}">
                            <tr>
                                <td class="small text-muted"><c:out value="${log.createdAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.userEmail}">
                                            <div class="small fw-semibold"><c:out value="${log.userName}"/></div>
                                            <div class="small text-muted"><c:out value="${log.userEmail}"/></div>
                                        </c:when>
                                        <c:otherwise><span class="text-muted small">System</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge bg-light text-dark border"><c:out value="${log.action}"/></span></td>
                                <td class="small text-muted"><c:out value="${log.entityType}"/> #${log.entityId}</td>
                                <td class="small text-secondary"><c:out value="${log.description}"/></td>
                                <td class="small text-muted font-monospace"><c:out value="${log.ipAddress}"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">No audit logs recorded yet.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
