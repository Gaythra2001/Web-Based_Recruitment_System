<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Applications" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-0">My Applications</h3>
        <p class="text-muted small mb-0">Monitor the live progress and status of your job applications</p>
    </div>
    <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-outline-custom btn-sm">
        <i class="bi bi-search me-1"></i> Browse More Vacancies
    </a>
</div>

<div class="card card-custom p-4 mb-5">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Job Title & Company</th>
                    <th>Location & Type</th>
                    <th>Date Applied</th>
                    <th>Current Status</th>
                    <th>Recruiter Notes</th>
                    <th class="text-end">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty applications}">
                        <c:forEach var="app" items="${applications}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">
                                        <a href="${pageContext.request.contextPath}/vacancies/view?id=${app.vacancyId}" class="text-decoration-none text-dark">
                                            <c:out value="${app.jobTitle}"/>
                                        </a>
                                    </div>
                                    <div class="small text-muted"><i class="bi bi-building me-1"></i> <c:out value="${app.companyName}"/></div>
                                </td>
                                <td>
                                    <div class="small"><c:out value="${app.vacancyLocation}"/></div>
                                    <span class="tag-pill"><c:out value="${app.employmentType.replace('_', ' ')}"/></span>
                                </td>
                                <td class="small text-muted"><c:out value="${app.appliedAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${app.status == 'APPLIED'}"><span class="badge badge-status badge-applied">Applied</span></c:when>
                                        <c:when test="${app.status == 'UNDER_REVIEW'}"><span class="badge badge-status badge-under_review">Under Review</span></c:when>
                                        <c:when test="${app.status == 'SHORTLISTED'}"><span class="badge badge-status badge-shortlisted">Shortlisted</span></c:when>
                                        <c:when test="${app.status == 'REJECTED'}"><span class="badge badge-status badge-rejected">Rejected</span></c:when>
                                        <c:when test="${app.status == 'HIRED'}"><span class="badge badge-status badge-hired">Hired</span></c:when>
                                        <c:when test="${app.status == 'WITHDRAWN'}"><span class="badge badge-status badge-withdrawn">Withdrawn</span></c:when>
                                        <c:otherwise><span class="badge badge-status"><c:out value="${app.status}"/></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-secondary">
                                    <c:out value="${not empty app.recruiterNotes ? app.recruiterNotes : '—'}"/>
                                </td>
                                <td class="text-end">
                                    <c:if test="${app.status != 'WITHDRAWN' and app.status != 'REJECTED' and app.status != 'HIRED'}">
                                        <form action="${pageContext.request.contextPath}/candidate/applications/withdraw" method="post" onsubmit="return confirm('Are you sure you want to withdraw this application?');">
                                            <input type="hidden" name="applicationId" value="${app.applicationId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                Withdraw
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-file-earmark-text fs-2 d-block mb-2"></i>
                                You haven't applied to any job vacancies yet.
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-primary-custom btn-sm">
                                        Find Vacancies Now
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

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
