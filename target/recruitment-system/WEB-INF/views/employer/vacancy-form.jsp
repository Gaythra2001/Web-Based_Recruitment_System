<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="isEdit" value="${vacancy != null && vacancy.vacancyId > 0}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Vacancy' : 'Create New Vacancy'}" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- Breadcrumb -->
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb small">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employer/dashboard">Dashboard</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employer/vacancies">Vacancies</a></li>
        <li class="breadcrumb-item active" aria-current="page">${isEdit ? 'Edit Vacancy' : 'New Vacancy'}</li>
    </ol>
</nav>

<div class="row justify-content-center mb-5">
    <div class="col-lg-10">
        <div class="card card-custom p-4 p-md-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1">${isEdit ? 'Edit Vacancy Posting' : 'Create New Vacancy'}</h3>
                    <p class="text-muted small mb-0">Fill in the comprehensive vacancy specifications</p>
                </div>
                <a href="${pageContext.request.contextPath}/employer/vacancies" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-arrow-left me-1"></i> Back to Vacancies
                </a>
            </div>

            <form action="${pageContext.request.contextPath}/employer/vacancies/${isEdit ? 'edit' : 'new'}" method="post">
                <c:if test="${isEdit}">
                    <input type="hidden" name="vacancyId" value="${vacancy.vacancyId}">
                </c:if>

                <!-- Basic Job Info -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-card-heading me-2"></i> 1. Core Position Details</h5>
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold small">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="jobTitle" class="form-control" value="<c:out value='${vacancy.jobTitle}'/>" placeholder="e.g. Senior Full Stack Java Developer" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Job Code</label>
                            <input type="text" name="jobCode" class="form-control" value="<c:out value='${vacancy.jobCode}'/>" placeholder="e.g. DEV-2026-01">
                        </div>
                    </div>
                </div>

                <!-- Classification & Location -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-sliders me-2"></i> 2. Categorization & Logistics</h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Employment Type</label>
                            <select name="employmentType" class="form-select">
                                <option value="FULL_TIME" ${vacancy.employmentType == 'FULL_TIME' ? 'selected' : ''}>Full Time</option>
                                <option value="PART_TIME" ${vacancy.employmentType == 'PART_TIME' ? 'selected' : ''}>Part Time</option>
                                <option value="CONTRACT" ${vacancy.employmentType == 'CONTRACT' ? 'selected' : ''}>Contract</option>
                                <option value="INTERNSHIP" ${vacancy.employmentType == 'INTERNSHIP' ? 'selected' : ''}>Internship</option>
                                <option value="TEMPORARY" ${vacancy.employmentType == 'TEMPORARY' ? 'selected' : ''}>Temporary</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Experience Level</label>
                            <select name="experienceLevel" class="form-select">
                                <option value="ENTRY" ${vacancy.experienceLevel == 'ENTRY' ? 'selected' : ''}>Entry Level</option>
                                <option value="JUNIOR" ${vacancy.experienceLevel == 'JUNIOR' ? 'selected' : ''}>Junior Level</option>
                                <option value="MID" ${vacancy.experienceLevel == 'MID' ? 'selected' : ''}>Mid Level</option>
                                <option value="SENIOR" ${vacancy.experienceLevel == 'SENIOR' ? 'selected' : ''}>Senior Level</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Work Mode</label>
                            <select name="workMode" class="form-select">
                                <option value="ONSITE" ${vacancy.workMode == 'ONSITE' ? 'selected' : ''}>On-site</option>
                                <option value="HYBRID" ${vacancy.workMode == 'HYBRID' ? 'selected' : ''}>Hybrid</option>
                                <option value="REMOTE" ${vacancy.workMode == 'REMOTE' ? 'selected' : ''}>Remote</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Open Positions</label>
                            <input type="number" name="vacanciesCount" class="form-control" value="${vacancy != null ? vacancy.vacanciesCount : 1}" min="1" required>
                        </div>
                    </div>

                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Job Location / City <span class="text-danger">*</span></label>
                            <input type="text" name="location" class="form-control" value="<c:out value='${vacancy.location}'/>" placeholder="e.g. Colombo 03, Sri Lanka" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Industry Domain</label>
                            <input type="text" name="industry" class="form-control" value="<c:out value='${vacancy.industry}'/>" placeholder="e.g. Information Technology / Fintech">
                        </div>
                    </div>
                </div>

                <!-- Compensation & Deadline -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-cash-stack me-2"></i> 3. Compensation & Deadline</h5>
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Currency</label>
                            <input type="text" name="salaryCurrency" class="form-control" value="<c:out value='${vacancy.salaryCurrency != null ? vacancy.salaryCurrency : \"LKR\"}'/>">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Min Salary</label>
                            <input type="number" step="1000" name="salaryMin" class="form-control" value="${vacancy.salaryMin}" placeholder="0.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Max Salary</label>
                            <input type="number" step="1000" name="salaryMax" class="form-control" value="${vacancy.salaryMax}" placeholder="0.00">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Application Deadline <span class="text-danger">*</span></label>
                            <input type="date" name="applicationDeadline" class="form-control" value="${vacancy.applicationDeadline}" required>
                        </div>
                    </div>
                </div>

                <!-- Text Descriptions -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-file-text me-2"></i> 4. Description & Requirements</h5>
                    
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Job Description <span class="text-danger">*</span></label>
                        <textarea name="description" class="form-control" rows="4" required placeholder="General role overview and purpose..."><c:out value="${vacancy.description}"/></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Key Responsibilities</label>
                        <textarea name="responsibilities" class="form-control" rows="4" placeholder="Day-to-day duties and deliverables..."><c:out value="${vacancy.responsibilities}"/></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Candidate Requirements & Qualifications</label>
                        <textarea name="requirements" class="form-control" rows="4" placeholder="Degree, years of experience, certifications..."><c:out value="${vacancy.requirements}"/></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Skills Required (Comma separated)</label>
                        <input type="text" name="skillsRequired" class="form-control" value="<c:out value='${vacancy.skillsRequired}'/>" placeholder="e.g. Java, Spring Boot, MySQL, REST API, Git">
                    </div>
                </div>

                <!-- Publishing Status (Only on creation) -->
                <c:if test="${!isEdit}">
                    <div class="mb-4 p-3 bg-light rounded-3">
                        <label class="form-label fw-bold small text-muted d-block">Publication Option:</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status" id="statusPublish" value="PUBLISHED" checked>
                            <label class="form-check-label fw-semibold" for="statusPublish">
                                <span class="text-success"><i class="bi bi-send-check me-1"></i> Publish Immediately</span>
                            </label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="status" id="statusDraft" value="DRAFT">
                            <label class="form-check-label fw-semibold" for="statusDraft">
                                <span class="text-muted"><i class="bi bi-file-earmark me-1"></i> Save as Draft</span>
                            </label>
                        </div>
                    </div>
                </c:if>

                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/employer/vacancies" class="btn btn-light px-4">Cancel</a>
                    <button type="submit" class="btn btn-primary-custom px-5">
                        <i class="bi bi-check2-circle me-1"></i> ${isEdit ? 'Save Changes' : 'Create Vacancy'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
