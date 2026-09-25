<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Vacancies Moderation" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">System Vacancies Moderation</h3>
        <p class="text-muted small mb-0">Review all vacancies across employers and moderate postings</p>
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
                    <th>ID</th>
                    <th>Job Title & Company</th>
                    <th>Location / Type</th>
                    <th>Status</th>
                    <th>Deadline</th>
                    <th>Applicants</th>
                    <th class="text-end">Moderation Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="v" items="${vacancies}">
                    <tr>
                        <td class="small text-muted">#${v.vacancyId}</td>
                        <td>
                            <div class="fw-bold text-dark"><c:out value="${v.jobTitle}"/></div>
                            <div class="small text-muted"><i class="bi bi-building me-1"></i> <c:out value="${v.companyName}"/></div>
                        </td>
                        <td>
                            <div class="small"><c:out value="${v.location}"/></div>
                            <span class="tag-pill"><c:out value="${v.employmentType.replace('_', ' ')}"/></span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${v.status == 'PUBLISHED'}"><span class="badge badge-status badge-published">Published</span></c:when>
                                <c:when test="${v.status == 'DRAFT'}"><span class="badge badge-status badge-draft">Draft</span></c:when>
                                <c:when test="${v.status == 'CLOSED'}"><span class="badge badge-status badge-closed">Closed</span></c:when>
                                <c:otherwise><span class="badge badge-status badge-expired"><c:out value="${v.status}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small"><c:out value="${v.applicationDeadline}"/></td>
                        <td><span class="badge bg-light text-dark border"><c:out value="${v.applicationsCount}"/></span></td>
                        <td class="text-end">
                            <div class="btn-group btn-group-sm">
                                <a href="${pageContext.request.contextPath}/vacancies/view?id=${v.vacancyId}" target="_blank" class="btn btn-outline-secondary" title="View Live">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/admin/vacancies/delete" method="post" class="d-inline" onsubmit="return confirm('Permanently remove this vacancy? This cannot be undone.');">
                                    <input type="hidden" name="vacancyId" value="${v.vacancyId}">
                                    <button type="submit" class="btn btn-outline-danger" title="Delete Vacancy">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
