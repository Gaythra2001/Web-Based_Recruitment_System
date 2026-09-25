<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${vacancy.jobTitle}" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-4">
    <ol class="breadcrumb small">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/vacancies">Vacancies</a></li>
        <li class="breadcrumb-item active" aria-current="page"><c:out value="${vacancy.jobTitle}"/></li>
    </ol>
</nav>

<div class="row g-4 mb-5">
    <!-- Main Vacancy Details -->
    <div class="col-lg-8">
        <div class="card card-custom p-4 p-md-5 mb-4">
            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                <div>
                    <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-1 rounded-pill mb-2">
                        <c:out value="${vacancy.employmentType.replace('_', ' ')}"/>
                    </span>
                    <h2 class="fw-bold mb-1"><c:out value="${vacancy.jobTitle}"/></h2>
                    <h5 class="text-muted fw-semibold"><i class="bi bi-building me-1"></i> <c:out value="${vacancy.companyName}"/></h5>
                </div>
                <div>
                    <span class="badge badge-status badge-published fs-6"><c:out value="${vacancy.status}"/></span>
                </div>
            </div>

            <div class="d-flex flex-wrap gap-3 py-3 border-top border-bottom my-3 text-muted small">
                <div><i class="bi bi-geo-alt text-primary me-1"></i> <c:out value="${vacancy.location}"/></div>
                <div><i class="bi bi-laptop text-primary me-1"></i> <c:out value="${vacancy.workMode}"/></div>
                <div><i class="bi bi-bar-chart text-primary me-1"></i> <c:out value="${vacancy.experienceLevel}"/> Level</div>
                <div><i class="bi bi-people text-primary me-1"></i> <c:out value="${vacancy.vacanciesCount}"/> Open Position(s)</div>
                <div><i class="bi bi-eye text-primary me-1"></i> <c:out value="${vacancy.viewsCount}"/> Views</div>
            </div>

            <!-- Job Description -->
            <div class="mb-4">
                <h5 class="fw-bold text-dark mb-3"><i class="bi bi-file-text me-2 text-primary"></i> Job Overview</h5>
                <div class="text-secondary" style="white-space: pre-line; line-height: 1.7;">
                    <c:out value="${vacancy.description}"/>
                </div>
            </div>

            <!-- Responsibilities -->
            <c:if test="${not empty vacancy.responsibilities}">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-check2-square me-2 text-primary"></i> Key Responsibilities</h5>
                    <div class="text-secondary" style="white-space: pre-line; line-height: 1.7;">
                        <c:out value="${vacancy.responsibilities}"/>
                    </div>
                </div>
            </c:if>

            <!-- Requirements / Qualifications -->
            <c:if test="${not empty vacancy.requirements or not empty vacancy.qualifications}">
                <div class="mb-4">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-mortarboard me-2 text-primary"></i> Requirements & Qualifications</h5>
                    <div class="text-secondary" style="white-space: pre-line; line-height: 1.7;">
                        <c:out value="${not empty vacancy.requirements ? vacancy.requirements : vacancy.qualifications}"/>
                    </div>
                </div>
            </c:if>

            <!-- Skills -->
            <c:if test="${not empty vacancy.skillsRequired}">
                <div class="mb-2">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-award me-2 text-primary"></i> Skills Required</h5>
                    <div class="d-flex flex-wrap gap-2">
                        <c:forTokens items="${vacancy.skillsRequired}" delims="," var="skill">
                            <span class="badge bg-light text-dark border px-3 py-2 fs-6 fw-medium"><c:out value="${skill.trim()}"/></span>
                        </c:forTokens>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Sidebar / Action Card -->
    <div class="col-lg-4">
        <div class="card card-custom p-4 mb-4 sticky-top" style="top: 90px;">
            <h5 class="fw-bold mb-3">Vacancy Summary</h5>
            <ul class="list-unstyled mb-4 small">
                <li class="d-flex justify-content-between py-2 border-bottom">
                    <span class="text-muted">Job Code:</span>
                    <span class="fw-semibold"><c:out value="${not empty vacancy.jobCode ? vacancy.jobCode : 'N/A'}"/></span>
                </li>
                <li class="d-flex justify-content-between py-2 border-bottom">
                    <span class="text-muted">Industry:</span>
                    <span class="fw-semibold"><c:out value="${not empty vacancy.industry ? vacancy.industry : vacancy.companyIndustry}"/></span>
                </li>
                <li class="d-flex justify-content-between py-2 border-bottom">
                    <span class="text-muted">Salary Range:</span>
                    <span class="fw-semibold text-success">
                        <c:choose>
                            <c:when test="${vacancy.salaryMin > 0 or vacancy.salaryMax > 0}">
                                <c:out value="${vacancy.salaryCurrency}"/> <fmt:formatNumber value="${vacancy.salaryMin}" pattern="#,##0"/> - <fmt:formatNumber value="${vacancy.salaryMax}" pattern="#,##0"/>
                            </c:when>
                            <c:otherwise>Negotiable</c:otherwise>
                        </c:choose>
                    </span>
                </li>
                <li class="d-flex justify-content-between py-2 border-bottom">
                    <span class="text-muted">Deadline:</span>
                    <span class="fw-semibold text-danger"><c:out value="${vacancy.applicationDeadline}"/></span>
                </li>
                <li class="d-flex justify-content-between py-2 border-bottom">
                    <span class="text-muted">Total Applicants:</span>
                    <span class="fw-semibold"><c:out value="${vacancy.applicationsCount}"/> applied</span>
                </li>
            </ul>

            <!-- Apply Logic -->
            <c:choose>
                <c:when test="${sessionScope.currentUser == null}">
                    <div class="alert alert-light border text-center small mb-3">
                        <i class="bi bi-lock me-1"></i> Sign in as a Job Seeker to apply for this vacancy.
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-custom w-100 py-2">
                        Sign In to Apply
                    </a>
                </c:when>
                <c:when test="${sessionScope.currentUser.role == 'JOB_SEEKER'}">
                    <c:choose>
                        <c:when test="${alreadyApplied}">
                            <div class="alert alert-info d-flex align-items-center mb-0">
                                <i class="bi bi-check2-circle fs-4 me-2"></i>
                                <div>
                                    <strong>Application Submitted!</strong>
                                    <div class="small">You have already applied for this opening. <a href="${pageContext.request.contextPath}/candidate/applications" class="alert-link">View status</a></div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-primary-custom w-100 py-2" data-bs-toggle="modal" data-bs-target="#applyModal">
                                <i class="bi bi-send me-1"></i> Apply Now
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-secondary small text-center mb-0">
                        Logged in as <c:out value="${sessionScope.currentUser.role}"/>. Only Job Seekers can submit applications.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal: Candidate Application Form -->
<c:if test="${sessionScope.currentUser != null and sessionScope.currentUser.role == 'JOB_SEEKER'}">
    <div class="modal fade" id="applyModal" tabindex="-1" aria-labelledby="applyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <form action="${pageContext.request.contextPath}/apply" method="post">
                    <input type="hidden" name="vacancyId" value="${vacancy.vacancyId}">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title fw-bold" id="applyModalLabel">
                            Apply for <c:out value="${vacancy.jobTitle}"/>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <c:choose>
                            <c:when test="${hasCv}">
                                <div class="alert alert-success d-flex align-items-center small mb-3">
                                    <i class="bi bi-file-earmark-pdf fs-4 me-2"></i>
                                    <div>Your uploaded CV from your profile will be attached to this application.</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-warning d-flex align-items-center small mb-3">
                                    <i class="bi bi-exclamation-triangle fs-4 me-2"></i>
                                    <div>
                                        You have not uploaded a PDF CV yet. You can still apply, but we recommend <a href="${pageContext.request.contextPath}/candidate/profile" class="alert-link" target="_blank">uploading your CV</a>.
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Cover Letter / Note to Recruiter</label>
                            <textarea name="coverLetter" class="form-control" rows="5" placeholder="Highlight why you are the ideal fit for this vacancy..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary-custom">
                            <i class="bi bi-send me-1"></i> Submit Application
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
