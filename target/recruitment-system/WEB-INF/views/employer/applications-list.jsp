<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Applicants — ${vacancy.jobTitle}" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb small">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employer/dashboard">Dashboard</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employer/vacancies">Vacancies</a></li>
        <li class="breadcrumb-item active" aria-current="page">Applicants</li>
    </ol>
</nav>

<div class="card card-custom p-4 mb-4">
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <span class="badge bg-light text-primary border mb-1"><c:out value="${vacancy.employmentType.replace('_', ' ')}"/></span>
            <h4 class="fw-bold mb-0"><c:out value="${vacancy.jobTitle}"/></h4>
            <span class="text-muted small">Total Candidates Applied: <strong><c:out value="${applications.size()}"/></strong></span>
        </div>
        <a href="${pageContext.request.contextPath}/employer/vacancies" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back to Vacancies
        </a>
    </div>
</div>

<!-- Applicants Table -->
<div class="card card-custom p-4 mb-5">
    <div class="table-responsive">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Candidate</th>
                    <th>Contact Details</th>
                    <th>Applied Date</th>
                    <th>CV / Resume</th>
                    <th>Status</th>
                    <th class="text-end">Review & Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty applications}">
                        <c:forEach var="app" items="${applications}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark"><c:out value="${app.candidateName}"/></div>
                                    <c:if test="${not empty app.coverLetter}">
                                        <button class="btn btn-link btn-sm p-0 text-decoration-none small text-muted" type="button" data-bs-toggle="collapse" data-bs-target="#cl_${app.applicationId}">
                                            <i class="bi bi-chat-text me-1"></i> View Cover Letter
                                        </button>
                                        <div class="collapse mt-2" id="cl_${app.applicationId}">
                                            <div class="p-3 bg-light rounded small border">
                                                <strong>Cover Letter:</strong>
                                                <div class="mt-1" style="white-space: pre-line;"><c:out value="${app.coverLetter}"/></div>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="small"><i class="bi bi-envelope me-1 text-muted"></i> <c:out value="${app.candidateEmail}"/></div>
                                    <c:if test="${not empty app.candidatePhone}">
                                        <div class="small text-muted"><i class="bi bi-telephone me-1"></i> <c:out value="${app.candidatePhone}"/></div>
                                    </c:if>
                                </td>
                                <td class="small text-muted"><c:out value="${app.appliedAt}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty app.candidateCvPath}">
                                            <a href="${pageContext.request.contextPath}/${app.candidateCvPath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-file-earmark-pdf me-1"></i> View PDF CV
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">No CV attached</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
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
                                <td class="text-end">
                                    <c:if test="${app.status != 'WITHDRAWN'}">
                                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#statusModal_${app.applicationId}">
                                            <i class="bi bi-pencil-square me-1"></i> Change Status
                                        </button>

                                        <!-- Update Status Modal -->
                                        <div class="modal fade text-start" id="statusModal_${app.applicationId}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow">
                                                    <form action="${pageContext.request.contextPath}/employer/application/update-status" method="post">
                                                        <input type="hidden" name="applicationId" value="${app.applicationId}">
                                                        <input type="hidden" name="vacancyId" value="${vacancy.vacancyId}">

                                                        <div class="modal-header">
                                                            <h5 class="modal-title fw-bold">Update Application Status</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body p-4">
                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold small">Candidate:</label>
                                                                <div class="fw-bold"><c:out value="${app.candidateName}"/></div>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold small">New Recruitment Status</label>
                                                                <select name="status" class="form-select" required>
                                                                    <option value="UNDER_REVIEW" ${app.status == 'UNDER_REVIEW' ? 'selected' : ''}>Under Review</option>
                                                                    <option value="SHORTLISTED" ${app.status == 'SHORTLISTED' ? 'selected' : ''}>Shortlisted</option>
                                                                    <option value="REJECTED" ${app.status == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                                                    <option value="HIRED" ${app.status == 'HIRED' ? 'selected' : ''}>Hired</option>
                                                                </select>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold small">Audit Remarks / Justification</label>
                                                                <input type="text" name="remarks" class="form-control" placeholder="e.g. Cleared technical interview stage 1" required>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold small">Internal Recruiter Notes</label>
                                                                <textarea name="recruiterNotes" class="form-control" rows="3" placeholder="Private internal notes..."><c:out value="${app.recruiterNotes}"/></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary-custom">Save Status</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                No candidates have applied for this vacancy yet.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
