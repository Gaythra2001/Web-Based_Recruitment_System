<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Audit Trail" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">System Audit Trail</h3>
        <p class="text-muted small mb-0">Comprehensive event history tracking logins, vacancy modifications, and application submissions</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm">
        <i class="bi bi-arrow-left me-1"></i> Dashboard
    </a>
</div>

<div class="card card-custom p-4 mb-5">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Audit ID</th>
                    <th>Timestamp</th>
                    <th>User</th>
                    <th>Action</th>
                    <th>Entity Type & ID</th>
                    <th>Description</th>
                    <th>IP Address</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty logs}">
                        <c:forEach var="log" items="${logs}">
                            <tr>
                                <td class="small text-muted font-monospace">#${log.auditId}</td>
                                <td class="small text-muted"><c:out value="${log.createdAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.userEmail}">
                                            <div class="fw-semibold small"><c:out value="${log.userName}"/></div>
                                            <div class="small text-muted"><c:out value="${log.userEmail}"/></div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">Guest / System</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border"><c:out value="${log.action}"/></span>
                                </td>
                                <td class="small">
                                    <c:out value="${not empty log.entityType ? log.entityType : '—'}"/>
                                    <c:if test="${not empty log.entityId}">
                                        <span class="text-muted">#${log.entityId}</span>
                                    </c:if>
                                </td>
                                <td class="small text-secondary"><c:out value="${log.description}"/></td>
                                <td class="small text-muted font-monospace"><c:out value="${log.ipAddress}"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-4 text-muted">No audit logs found.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
