<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Home — Web-Based Recruitment System" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Hero Banner -->
</div> <!-- Close container opened by header to allow full-width hero -->
<section class="hero-section">
    <div class="container position-relative">
        <div class="row align-items-center justify-content-between">
            <div class="col-lg-7 mb-4 mb-lg-0">
                <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill fw-semibold mb-3">
                    <i class="bi bi-stars me-1"></i> Smart Recruitment & Vacancy Management
                </span>
                <h1 class="hero-title mb-3">
                    Connecting Top Talent with Leading Organizations
                </h1>
                <p class="hero-subtitle mb-4">
                    Discover career opportunities, manage vacancies in real time, and experience transparent, automated recruitment workflows.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-primary-custom btn-lg">
                        <i class="bi bi-search me-2"></i> Browse Vacancies
                    </a>
                    <c:if test="${sessionScope.currentUser == null}">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg">
                            <i class="bi bi-person-plus me-2"></i> Post Jobs as Employer
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card bg-white text-dark p-4 shadow-lg border-0 rounded-4">
                    <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-search text-primary me-2"></i> Quick Vacancy Search</h5>
                    <form action="${pageContext.request.contextPath}/vacancies" method="get">
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Job Title or Keyword</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-briefcase text-muted"></i></span>
                                <input type="text" name="keyword" class="form-control border-start-0" placeholder="e.g. Software Engineer, Marketing...">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Location / City</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-geo-alt text-muted"></i></span>
                                <input type="text" name="location" class="form-control border-start-0" placeholder="e.g. Colombo, Kandy, Remote...">
                            </div>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label small fw-semibold text-muted">Employment Type</label>
                                <select name="employmentType" class="form-select">
                                    <option value="">All Types</option>
                                    <option value="FULL_TIME">Full Time</option>
                                    <option value="PART_TIME">Part Time</option>
                                    <option value="CONTRACT">Contract</option>
                                    <option value="INTERNSHIP">Internship</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-semibold text-muted">Work Mode</label>
                                <select name="workMode" class="form-select">
                                    <option value="">All Modes</option>
                                    <option value="ONSITE">On-site</option>
                                    <option value="HYBRID">Hybrid</option>
                                    <option value="REMOTE">Remote</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary-custom w-100 py-2">
                            <i class="bi bi-funnel-fill me-1"></i> Search Vacancies
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<div class="container my-5">
    <!-- Live Platform Statistics -->
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon stat-icon-purple">
                    <i class="bi bi-briefcase"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-0"><c:out value="${totalVacancies}"/></h3>
                    <span class="text-muted small">Live Published Vacancies</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon stat-icon-blue">
                    <i class="bi bi-buildings"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-0"><c:out value="${totalEmployers}"/></h3>
                    <span class="text-muted small">Registered Employers</span>
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
                    <span class="text-muted small">Applications Tracked</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Featured Vacancies -->
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <span class="text-primary fw-bold text-uppercase small letter-spacing-1">Latest Openings</span>
            <h2 class="fw-bold mb-0">Featured Job Vacancies</h2>
        </div>
        <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-outline-custom btn-sm">
            View All Vacancies <i class="bi bi-arrow-right ms-1"></i>
        </a>
    </div>

    <div class="row g-4 mb-5">
        <c:choose>
            <c:when test="${not empty featuredVacancies}">
                <c:forEach var="vac" items="${featuredVacancies}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card card-custom h-100 p-4 d-flex flex-column justify-content-between">
                            <div>
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-light text-primary border fw-semibold">
                                        <c:out value="${vac.employmentType.replace('_', ' ')}"/>
                                    </span>
                                    <span class="badge badge-status badge-published">
                                        <c:out value="${vac.status}"/>
                                    </span>
                                </div>
                                <h5 class="fw-bold mb-1 text-dark">
                                    <a href="${pageContext.request.contextPath}/vacancies/view?id=${vac.vacancyId}" class="text-decoration-none text-dark">
                                        <c:out value="${vac.jobTitle}"/>
                                    </a>
                                </h5>
                                <div class="text-muted small mb-3">
                                    <i class="bi bi-building me-1"></i> <c:out value="${vac.companyName}"/>
                                    <span class="mx-1">•</span>
                                    <i class="bi bi-geo-alt me-1"></i> <c:out value="${vac.location}"/>
                                </div>

                                <p class="text-secondary small mb-3">
                                    <c:choose>
                                        <c:when test="${vac.description.length() > 110}">
                                            <c:out value="${vac.description.substring(0, 110)}"/>...
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${vac.description}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <div>
                                <div class="d-flex flex-wrap gap-1 mb-3">
                                    <span class="tag-pill"><i class="bi bi-laptop me-1"></i><c:out value="${vac.workMode}"/></span>
                                    <span class="tag-pill"><i class="bi bi-bar-chart me-1"></i><c:out value="${vac.experienceLevel}"/></span>
                                </div>
                                <hr class="my-2 border-light">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div class="text-muted small">
                                        <i class="bi bi-clock me-1"></i> Deadline: <c:out value="${vac.applicationDeadline}"/>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/vacancies/view?id=${vac.vacancyId}" class="btn btn-sm btn-primary-custom">
                                        Apply
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5">
                    <p class="text-muted">No vacancies currently published. Employers can post jobs anytime.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Recruitment Flow Diagram Card -->
    <div class="card card-custom p-5 bg-white border-0 shadow-sm rounded-4 mb-5">
        <div class="text-center mb-4">
            <span class="text-primary fw-bold text-uppercase small">End-to-End Recruitment Workflow</span>
            <h3 class="fw-bold mt-1">How The Vacancy Management Workflow Operates</h3>
        </div>

        <div class="row g-4 text-center mt-2">
            <div class="col-md-3">
                <div class="p-3">
                    <div class="stat-icon stat-icon-purple mx-auto mb-3">1</div>
                    <h6 class="fw-bold">Create Vacancy</h6>
                    <p class="small text-muted">Employer drafts job requirements, qualifications, and deadline.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3">
                    <div class="stat-icon stat-icon-blue mx-auto mb-3">2</div>
                    <h6 class="fw-bold">Publish to Talent</h6>
                    <p class="small text-muted">Vacancy becomes instantly searchable with advanced filtering.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3">
                    <div class="stat-icon stat-icon-green mx-auto mb-3">3</div>
                    <h6 class="fw-bold">Candidate Applies</h6>
                    <p class="small text-muted">Job seekers apply with structured profile and verified PDF CV snapshot.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-3">
                    <div class="stat-icon stat-icon-amber mx-auto mb-3">4</div>
                    <h6 class="fw-bold">Review & Status Tracking</h6>
                    <p class="small text-muted">Employer shortlists or rejects with full audit trail history.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
