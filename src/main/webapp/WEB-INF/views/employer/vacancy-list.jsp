<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Manage Job Vacancies" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">Vacancy Management</h3>
        <p class="text-muted small mb-0">Create, edit, publish, close, and monitor applications for your positions</p>
    </div>
    <a href="${pageContext.request.contextPath}/employer/vacancies/new" class="btn btn-primary-custom">
        <i class="bi bi-plus-circle me-1"></i> Post New Vacancy
    </a>
</div>

<div class="card card-custom p-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Job Title & Details</th>
                    <th>Status</th>
                    <th>Type / Mode</th>
                    <th>Deadline</th>
                    <th>Applicants</th>
                    <th>Views</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty vacancies}">
                        <c:forEach var="v" items="${vacancies}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark"><c:out value="${v.jobTitle}"/></div>
                                    <div class="small text-muted">
                                        <i class="bi bi-geo-alt me-1"></i><c:out value="${v.location}"/>
                                        &bull; Code: <c:out value="${not empty v.jobCode ? v.jobCode : '—'}"/>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 'PUBLISHED'}"><span class="badge badge-status badge-published">Published</span></c:when>
                                        <c:when test="${v.status == 'DRAFT'}"><span class="badge badge-status badge-draft">Draft</span></c:when>
                                        <c:when test="${v.status == 'CLOSED'}"><span class="badge badge-status badge-closed">Closed</span></c:when>
                                        <c:otherwise><span class="badge badge-status badge-expired"><c:out value="${v.status}"/></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="small fw-semibold"><c:out value="${v.employmentType.replace('_', ' ')}"/></div>
                                    <div class="text-muted small"><c:out value="${v.workMode}"/></div>
                                </td>
                                <td class="small"><c:out value="${v.applicationDeadline}"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/employer/vacancies/applications?id=${v.vacancyId}" class="badge bg-primary text-decoration-none px-2 py-1">
                                        <i class="bi bi-people me-1"></i> <c:out value="${v.applicationsCount}"/>
                                    </a>
                                </td>
                                <td class="small text-muted"><c:out value="${v.viewsCount}"/></td>
                                <td class="text-end">
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-light border dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                            Actions
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/employer/vacancies/applications?id=${v.vacancyId}">
                                                    <i class="bi bi-people me-2 text-primary"></i> View Applicants (${v.applicationsCount})
                                                </a>
                                            </li>
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/employer/vacancies/edit?id=${v.vacancyId}">
                                                    <i class="bi bi-pencil me-2 text-secondary"></i> Edit Details
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                            
                                            <!-- Status Quick Toggles -->
                                            <c:if test="${v.status != 'PUBLISHED'}">
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/employer/vacancies/status" method="post">
                                                        <input type="hidden" name="vacancyId" value="${v.vacancyId}">
                                                        <input type="hidden" name="status" value="PUBLISHED">
                                                        <button type="submit" class="dropdown-item text-success">
                                                            <i class="bi bi-check-circle me-2"></i> Publish Vacancy
                                                        </button>
                                                    </form>
                                                </li>
                                            </c:if>
                                            <c:if test="${v.status == 'PUBLISHED'}">
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/employer/vacancies/status" method="post">
                                                        <input type="hidden" name="vacancyId" value="${v.vacancyId}">
                                                        <input type="hidden" name="status" value="CLOSED">
                                                        <button type="submit" class="dropdown-item text-warning">
                                                            <i class="bi bi-x-circle me-2"></i> Close Vacancy
                                                        </button>
                                                    </form>
                                                </li>
                                            </c:if>

                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <button type="button" class="dropdown-item text-danger"
                                                        onclick="deleteVacancy('${v.vacancyId}')">
                                                    <i class="bi bi-trash me-2"></i> Delete Vacancy
                                                </button>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-briefcase fs-2 d-block mb-2"></i>
                                You haven't posted any vacancies yet.
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/employer/vacancies/new" class="btn btn-primary-custom btn-sm">
                                        Post a Vacancy Now
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script>
function deleteVacancy(vacancyId) {
    if (confirm('Are you sure you want to delete this vacancy? All related applications will also be deleted.')) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/employer/vacancies/delete';
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'vacancyId';
        input.value = vacancyId;
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
