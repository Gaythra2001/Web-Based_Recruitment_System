<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Account" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center my-4">
    <div class="col-md-9 col-lg-7">
        <div class="card card-custom p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="stat-icon stat-icon-blue mx-auto mb-3">
                    <i class="bi bi-person-plus"></i>
                </div>
                <h3 class="fw-bold mb-1">Create Your Account</h3>
                <p class="text-muted small">Choose your account type and start recruiting or applying</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                <!-- Role Selector -->
                <div class="mb-4 text-center">
                    <label class="form-label fw-bold small text-muted d-block mb-2">I want to:</label>
                    <div class="btn-group w-100" role="group">
                        <input type="radio" class="btn-check" name="role" id="roleSeeker" value="JOB_SEEKER" ${role == null or role == 'JOB_SEEKER' ? 'checked' : ''} onchange="toggleRoleFields()">
                        <label class="btn btn-outline-primary py-2 fw-semibold" for="roleSeeker">
                            <i class="bi bi-person me-1"></i> Apply for Jobs (Job Seeker)
                        </label>

                        <input type="radio" class="btn-check" name="role" id="roleEmployer" value="EMPLOYER" ${role == 'EMPLOYER' ? 'checked' : ''} onchange="toggleRoleFields()">
                        <label class="btn btn-outline-primary py-2 fw-semibold" for="roleEmployer">
                            <i class="bi bi-building me-1"></i> Post Jobs & Hire (Employer)
                        </label>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">First Name <span class="text-danger">*</span></label>
                        <input type="text" name="firstName" class="form-control" value="<c:out value='${firstName}'/>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Last Name <span class="text-danger">*</span></label>
                        <input type="text" name="lastName" class="form-control" value="<c:out value='${lastName}'/>" required>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Email Address <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" value="<c:out value='${email}'/>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="<c:out value='${phone}'/>" placeholder="+94 77 123 4567">
                    </div>
                </div>

                <!-- Employer Extra Fields -->
                <div id="employerFields" class="p-3 bg-light rounded-3 mb-3 ${role == 'EMPLOYER' ? '' : 'd-none'}">
                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-building-check me-2"></i> Company Information</h6>
                    <div class="mb-3">
                        <label class="form-label fw-semibold small">Company Name <span class="text-danger">*</span></label>
                        <input type="text" name="companyName" id="companyName" class="form-control" value="<c:out value='${companyName}'/>">
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">Industry</label>
                            <input type="text" name="industry" class="form-control" value="<c:out value='${industry}'/>" placeholder="e.g. Information Technology">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold small">City / Location</label>
                            <input type="text" name="city" class="form-control" value="<c:out value='${city}'/>" placeholder="e.g. Colombo">
                        </div>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Password <span class="text-danger">*</span></label>
                        <input type="password" name="password" class="form-control" placeholder="Min. 6 characters" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold small">Confirm Password <span class="text-danger">*</span></label>
                        <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 py-2 mb-3">
                    <i class="bi bi-check2-circle me-1"></i> Register Account
                </button>
            </form>

            <div class="text-center mt-3 small">
                <span class="text-muted">Already have an account? </span>
                <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold">Sign in</a>
            </div>
        </div>
    </div>
</div>

<script>
function toggleRoleFields() {
    var isEmployer = document.getElementById('roleEmployer').checked;
    var empBox = document.getElementById('employerFields');
    var companyNameInput = document.getElementById('companyName');
    if (isEmployer) {
        empBox.classList.remove('d-none');
        companyNameInput.setAttribute('required', 'required');
    } else {
        empBox.classList.add('d-none');
        companyNameInput.removeAttribute('required');
    }
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
