<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Company Profile" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center mb-5">
    <div class="col-lg-8">
        <div class="card card-custom p-4 p-md-5">
            <div class="d-flex align-items-center gap-3 mb-4">
                <div class="stat-icon stat-icon-blue">
                    <i class="bi bi-building"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-0">Company Profile</h3>
                    <p class="text-muted small mb-0">Update your company details visible on your job postings</p>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/employer/profile" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Company Name <span class="text-danger">*</span></label>
                    <input type="text" name="companyName" class="form-control" value="<c:out value='${employer.companyName}'/>" required>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Company Email</label>
                        <input type="email" name="companyEmail" class="form-control" value="<c:out value='${employer.companyEmail}'/>">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Company Phone</label>
                        <input type="text" name="companyPhone" class="form-control" value="<c:out value='${employer.companyPhone}'/>">
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Industry</label>
                        <input type="text" name="industry" class="form-control" value="<c:out value='${employer.industry}'/>" placeholder="e.g. Software Development">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">City / Headquarters</label>
                        <input type="text" name="city" class="form-control" value="<c:out value='${employer.city}'/>" placeholder="e.g. Colombo, Sri Lanka">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Company Address</label>
                    <input type="text" name="companyAddress" class="form-control" value="<c:out value='${employer.companyAddress}'/>">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold small">Website URL</label>
                    <input type="url" name="website" class="form-control" value="<c:out value='${employer.website}'/>" placeholder="https://example.com">
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small">Company Description</label>
                    <textarea name="companyDescription" class="form-control" rows="4" placeholder="About your business, mission, and work culture..."><c:out value="${employer.companyDescription}"/></textarea>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary-custom px-4">
                        <i class="bi bi-check2-circle me-1"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
