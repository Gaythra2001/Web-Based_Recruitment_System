<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="User Management" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">User Management</h3>
        <p class="text-muted small mb-0">Review system accounts and manage access permissions</p>
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
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Registered At</th>
                    <th class="text-end">Account Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td class="small text-muted">#${u.userId}</td>
                        <td class="fw-semibold text-dark"><c:out value="${u.firstName}"/> <c:out value="${u.lastName}"/></td>
                        <td class="small"><c:out value="${u.email}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == 'ADMIN'}"><span class="badge bg-danger">ADMIN</span></c:when>
                                <c:when test="${u.role == 'EMPLOYER'}"><span class="badge bg-primary">EMPLOYER</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">JOB_SEEKER</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.accountStatus == 'ACTIVE'}"><span class="badge badge-status badge-active">Active</span></c:when>
                                <c:otherwise><span class="badge badge-status badge-suspended"><c:out value="${u.accountStatus}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small text-muted"><c:out value="${u.createdAt}"/></td>
                        <td class="text-end">
                            <c:if test="${u.role != 'ADMIN'}">
                                <form action="${pageContext.request.contextPath}/admin/users/status" method="post" class="d-inline">
                                    <input type="hidden" name="userId" value="${u.userId}">
                                    <c:choose>
                                        <c:when test="${u.accountStatus == 'ACTIVE'}">
                                            <input type="hidden" name="status" value="SUSPENDED">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Suspend this user account?');">
                                                <i class="bi bi-slash-circle me-1"></i> Suspend
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="status" value="ACTIVE">
                                            <button type="submit" class="btn btn-sm btn-outline-success" onclick="return confirm('Activate this user account?');">
                                                <i class="bi bi-check-circle me-1"></i> Activate
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
