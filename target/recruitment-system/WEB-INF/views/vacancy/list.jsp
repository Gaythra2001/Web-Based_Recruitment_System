<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Explore Job Vacancies" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb small">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li class="breadcrumb-item active" aria-current="page">Vacancies</li>
    </ol>
</nav>

<!-- Search and Filter Bar -->
<div class="search-container">
    <form action="${pageContext.request.contextPath}/vacancies" method="get">
        <div class="row g-3">
            <div class="col-lg-4 col-md-6">
                <label class="form-label small fw-bold text-muted">Keyword or Title</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="bi bi-search text-muted"></i></span>
                    <input type="text" name="keyword" class="form-control" value="<c:out value='${keyword}'/>" placeholder="e.g. Java, Developer, Manager...">
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <label class="form-label small fw-bold text-muted">Location</label>
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="bi bi-geo-alt text-muted"></i></span>
                    <input type="text" name="location" class="form-control" value="<c:out value='${location}'/>" placeholder="City or Country">
                </div>
            </div>
            <div class="col-lg-2 col-md-4">
                <label class="form-label small fw-bold text-muted">Job Type</label>
                <select name="employmentType" class="form-select">
                    <option value="">All Types</option>
                    <option value="FULL_TIME" ${employmentType == 'FULL_TIME' ? 'selected' : ''}>Full Time</option>
                    <option value="PART_TIME" ${employmentType == 'PART_TIME' ? 'selected' : ''}>Part Time</option>
                    <option value="CONTRACT" ${employmentType == 'CONTRACT' ? 'selected' : ''}>Contract</option>
                    <option value="INTERNSHIP" ${employmentType == 'INTERNSHIP' ? 'selected' : ''}>Internship</option>
                </select>
            </div>
            <div class="col-lg-2 col-md-4">
                <label class="form-label small fw-bold text-muted">Work Mode</label>
                <select name="workMode" class="form-select">
                    <option value="">All Modes</option>
                    <option value="ONSITE" ${workMode == 'ONSITE' ? 'selected' : ''}>On-site</option>
                    <option value="HYBRID" ${workMode == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                    <option value="REMOTE" ${workMode == 'REMOTE' ? 'selected' : ''}>Remote</option>
                </select>
            </div>
            <div class="col-lg-1 col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary-custom w-100 py-2">
                    <i class="bi bi-filter"></i>
                </button>
            </div>
        </div>

        <div class="row g-3 mt-1">
            <div class="col-md-3">
                <select name="experienceLevel" class="form-select form-select-sm">
                    <option value="">All Experience Levels</option>
                    <option value="ENTRY" ${experienceLevel == 'ENTRY' ? 'selected' : ''}>Entry Level</option>
                    <option value="JUNIOR" ${experienceLevel == 'JUNIOR' ? 'selected' : ''}>Junior</option>
                    <option value="MID" ${experienceLevel == 'MID' ? 'selected' : ''}>Mid Level</option>
                    <option value="SENIOR" ${experienceLevel == 'SENIOR' ? 'selected' : ''}>Senior</option>
                </select>
            </div>
            <div class="col-md-3">
                <input type="text" name="industry" class="form-control form-control-sm" value="<c:out value='${industry}'/>" placeholder="Filter by Industry...">
            </div>
            <div class="col-md-6 text-end">
                <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-sm btn-link text-muted">Reset Filters</a>
            </div>
        </div>
    </form>
</div>

<!-- Results Header -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-0">Available Vacancies</h4>
        <span class="text-muted small">Showing <c:out value="${vacancies.size()}"/> of <c:out value="${totalResults}"/> openings</span>
    </div>
</div>

<!-- Vacancies Grid -->
<div class="row g-4 mb-5">
    <c:choose>
        <c:when test="${not empty vacancies}">
            <c:forEach var="v" items="${vacancies}">
                <div class="col-md-6 col-lg-4">
                    <div class="card card-custom h-100 p-4 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-light text-primary border">
                                    <c:out value="${v.employmentType.replace('_', ' ')}"/>
                                </span>
                                <span class="badge badge-status badge-published"><c:out value="${v.status}"/></span>
                            </div>

                            <h5 class="fw-bold mb-1">
                                <a href="${pageContext.request.contextPath}/vacancies/view?id=${v.vacancyId}" class="text-decoration-none text-dark">
                                    <c:out value="${v.jobTitle}"/>
                                </a>
                            </h5>

                            <div class="text-muted small mb-3">
                                <i class="bi bi-building me-1"></i> <c:out value="${v.companyName}"/>
                                <span class="mx-1">•</span>
                                <i class="bi bi-geo-alt me-1"></i> <c:out value="${v.location}"/>
                            </div>

                            <p class="text-secondary small mb-3">
                                <c:choose>
                                    <c:when test="${v.description.length() > 120}">
                                        <c:out value="${v.description.substring(0, 120)}"/>...
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${v.description}"/>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div>
                            <div class="d-flex flex-wrap gap-1 mb-3">
                                <span class="tag-pill"><i class="bi bi-laptop me-1"></i><c:out value="${v.workMode}"/></span>
                                <span class="tag-pill"><i class="bi bi-bar-chart me-1"></i><c:out value="${v.experienceLevel}"/></span>
                                <c:if test="${v.salaryMin > 0 or v.salaryMax > 0}">
                                    <span class="tag-pill text-success fw-bold">
                                        <c:out value="${v.salaryCurrency}"/> <fmt:formatNumber value="${v.salaryMin}" pattern="#,##0"/> - <fmt:formatNumber value="${v.salaryMax}" pattern="#,##0"/>
                                    </span>
                                </c:if>
                            </div>
                            <hr class="my-2 border-light">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-muted small">
                                    <i class="bi bi-clock me-1"></i> Deadline: <c:out value="${v.applicationDeadline}"/>
                                </div>
                                <a href="${pageContext.request.contextPath}/vacancies/view?id=${v.vacancyId}" class="btn btn-sm btn-primary-custom">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="col-12 text-center py-5">
                <i class="bi bi-search fs-1 text-muted d-block mb-3"></i>
                <h5>No Vacancies Found</h5>
                <p class="text-muted">Try adjusting your search criteria or resetting filters.</p>
                <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-outline-custom btn-sm">Clear Filters</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Pagination -->
<c:if test="${totalPages > 1}">
    <nav class="d-flex justify-content-center mb-5">
        <ul class="pagination">
            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&location=${location}&employmentType=${employmentType}&workMode=${workMode}&experienceLevel=${experienceLevel}&industry=${industry}">Previous</a>
            </li>
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}&keyword=${keyword}&location=${location}&employmentType=${employmentType}&workMode=${workMode}&experienceLevel=${experienceLevel}&industry=${industry}">${i}</a>
                </li>
            </c:forEach>
            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&location=${location}&employmentType=${employmentType}&workMode=${workMode}&experienceLevel=${experienceLevel}&industry=${industry}">Next</a>
            </li>
        </ul>
    </nav>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
