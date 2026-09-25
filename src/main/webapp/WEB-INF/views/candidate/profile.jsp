<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="My Profile & CV" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center mb-5">
    <div class="col-lg-10">
        <div class="card card-custom p-4 p-md-5">
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="stat-icon stat-icon-purple">
                    <i class="bi bi-person-badge"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-0">Job Seeker Profile & CV</h3>
                    <p class="text-muted small mb-0">Maintain your professional resume and credentials for instant applications</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/candidate/profile" method="post" enctype="multipart/form-data">
                <!-- Personal Details -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-person me-2"></i> 1. Personal Information</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">First Name <span class="text-danger">*</span></label>
                            <input type="text" name="firstName" class="form-control" value="<c:out value='${sessionScope.currentUser.firstName}'/>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Last Name <span class="text-danger">*</span></label>
                            <input type="text" name="lastName" class="form-control" value="<c:out value='${sessionScope.currentUser.lastName}'/>" required>
                        </div>
                    </div>
                    <div class="row g-3 mt-1">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Phone Number</label>
                            <input type="text" name="phone" class="form-control" value="<c:out value='${sessionScope.currentUser.phone}'/>">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Date of Birth</label>
                            <input type="date" name="dateOfBirth" class="form-control" value="${profile.dateOfBirth}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold small">Gender</label>
                            <select name="gender" class="form-select">
                                <option value="">Select Gender</option>
                                <option value="MALE" ${profile.gender == 'MALE' ? 'selected' : ''}>Male</option>
                                <option value="FEMALE" ${profile.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                                <option value="OTHER" ${profile.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                                <option value="PREFER_NOT_TO_SAY" ${profile.gender == 'PREFER_NOT_TO_SAY' ? 'selected' : ''}>Prefer not to say</option>
                            </select>
                        </div>
                    </div>
                    <div class="row g-3 mt-1">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">City / Location</label>
                            <input type="text" name="city" class="form-control" value="<c:out value='${profile.city}'/>" placeholder="e.g. Colombo">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Address</label>
                            <input type="text" name="address" class="form-control" value="<c:out value='${profile.address}'/>">
                        </div>
                    </div>
                </div>

                <!-- Professional Overview -->
                <div class="mb-4">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-briefcase me-2"></i> 2. Professional Qualifications</h5>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Current Job Title</label>
                        <input type="text" name="currentJobTitle" class="form-control" value="<c:out value='${profile.currentJobTitle}'/>" placeholder="e.g. Associate Software Engineer">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Profile Summary</label>
                        <textarea name="profileSummary" class="form-control" rows="3" placeholder="Brief elevator pitch of your experience and career objectives..."><c:out value="${profile.profileSummary}"/></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Skills (Comma separated)</label>
                        <input type="text" name="skills" class="form-control" value="<c:out value='${profile.skills}'/>" placeholder="e.g. Java, Spring Boot, MySQL, JavaScript, Git">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Education Details</label>
                        <textarea name="education" class="form-control" rows="3" placeholder="Degree, University, Graduation Year..."><c:out value="${profile.education}"/></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Work Experience</label>
                        <textarea name="experience" class="form-control" rows="3" placeholder="Past companies, roles, and accomplishments..."><c:out value="${profile.experience}"/></textarea>
                    </div>
                </div>

                <!-- CV Upload Box -->
                <div class="mb-4 p-4 bg-light rounded-3 border">
                    <h5 class="fw-bold text-dark mb-2"><i class="bi bi-file-earmark-pdf me-2 text-danger"></i> PDF CV / Resume</h5>
                    <p class="text-muted small mb-3">Attach your latest Curriculum Vitae in PDF format (Max 10MB).</p>

                    <c:if test="${not empty profile.cvFilePath}">
                        <div class="alert alert-success d-flex align-items-center justify-content-between p-3 mb-3">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-file-earmark-check fs-4"></i>
                                <div>
                                    <div class="fw-bold"><c:out value="${profile.cvFileName != null ? profile.cvFileName : 'Curriculum Vitae'}"/></div>
                                    <span class="small text-muted">Uploaded on: <c:out value="${profile.cvUploadedAt}"/></span>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/${profile.cvFilePath}" target="_blank" class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-box-arrow-up-right me-1"></i> View Uploaded CV
                            </a>
                        </div>
                    </c:if>

                    <label class="form-label fw-semibold small">${not empty profile.cvFilePath ? 'Upload New / Replace CV:' : 'Select PDF CV:'}</label>
                    <input type="file" name="cvFile" class="form-control" accept=".pdf">
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary-custom px-5 py-2">
                        <i class="bi bi-check2-circle me-1"></i> Save Profile & CV
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
