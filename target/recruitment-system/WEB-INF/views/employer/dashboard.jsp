<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Employer Dashboard" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">Employer Portal</h3>
        <p class="text-muted small mb-0"><c:out value="${employer.companyName}"/> &bull; Recruitment & Vacancy Management</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/employer/vacancies/new" class="btn btn-primary-custom">
            <i class="bi bi-plus-circle me-1"></i> Post New Vacancy
        </a>
    </div>
</div>

<!-- Metrics Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon stat-icon-purple">
                <i class="bi bi-briefcase"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0"><c:out value="${totalVacancies}"/></h4>
                <span class="text-muted small">Total Vacancies</span>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon stat-icon-green">
                <i class="bi bi-check-circle"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0"><c:out value="${activeVacancies}"/></h4>
                <span class="text-muted small">Active Published</span>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon stat-icon-amber">
                <i class="bi bi-pencil-square"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0"><c:out value="${draftVacancies}"/></h4>
                <span class="text-muted small">Drafts</span>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-icon stat-icon-blue">
                <i class="bi bi-people"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0"><c:out value="${totalApplications}"/></h4>
                <span class="text-muted small">Total Applicants</span>
            </div>
        </div>
    </div>
</div>

<!-- Vacancies Table -->
<div class="card card-custom p-4 mb-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0"><i class="bi bi-list-task text-primary me-2"></i> Your Recent Vacancies</h5>
        <a href="${pageContext.request.contextPath}/employer/vacancies" class="btn btn-sm btn-link">View All</a>
    </div>

    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Job Title</th>
                    <th>Status</th>
                    <th>Type</th>
                    <th>Deadline</th>
                    <th>Applicants</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty vacancies}">
                        <c:forEach var="v" items="${vacancies}" begin="0" end="4">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark"><c:out value="${v.jobTitle}"/></div>
                                    <div class="small text-muted"><c:out value="${v.location}"/> &bull; Code: <c:out value="${not empty v.jobCode ? v.jobCode : '—'}"/></div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 'PUBLISHED'}"><span class="badge badge-status badge-published">Published</span></c:when>
                                        <c:when test="${v.status == 'DRAFT'}"><span class="badge badge-status badge-draft">Draft</span></c:when>
                                        <c:when test="${v.status == 'CLOSED'}"><span class="badge badge-status badge-closed">Closed</span></c:when>
                                        <c:otherwise><span class="badge badge-status badge-expired"><c:out value="${v.status}"/></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="tag-pill"><c:out value="${v.employmentType}"/></span></td>
                                <td class="small"><c:out value="${v.applicationDeadline}"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/employer/vacancies/applications?id=${v.vacancyId}" class="badge bg-primary text-decoration-none">
                                        <c:out value="${v.applicationsCount}"/> Candidates
                                    </a>
                                </td>
                                <td class="text-end">
                                    <div class="btn-group btn-group-sm">
                                        <a href="${pageContext.request.contextPath}/employer/vacancies/applications?id=${v.vacancyId}" class="btn btn-outline-secondary" title="View Applicants">
                                            <i class="bi bi-people"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/employer/vacancies/edit?id=${v.vacancyId}" class="btn btn-outline-secondary" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">
                                No vacancies created yet. <a href="${pageContext.request.contextPath}/employer/vacancies/new">Create your first vacancy</a>.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
