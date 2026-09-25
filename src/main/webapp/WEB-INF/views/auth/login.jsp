<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign In" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center my-4">
    <div class="col-md-7 col-lg-5">
        <div class="card card-custom p-4 p-md-5">
            <div class="text-center mb-4">
                <div class="stat-icon stat-icon-purple mx-auto mb-3">
                    <i class="bi bi-person-lock"></i>
                </div>
                <h3 class="fw-bold mb-1">Welcome Back</h3>
                <p class="text-muted small">Sign in to your HireHub account</p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control" value="<c:out value='${email}'/>" placeholder="name@example.com" required autofocus>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold small">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-shield-lock text-muted"></i></span>
                        <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary-custom w-100 py-2 mb-3">
                    <i class="bi bi-box-arrow-in-right me-2"></i> Sign In
                </button>
            </form>

            <div class="text-center mt-3 small">
                <span class="text-muted">Don't have an account yet? </span>
                <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold">Create an account</a>
            </div>

            <hr class="my-4">

            <!-- Demo Credentials Helper for Academic Testing -->
            <div class="bg-light p-3 rounded-3 small">
                <div class="fw-bold text-dark mb-2"><i class="bi bi-info-circle me-1 text-primary"></i> University Demo Accounts:</div>
                <div class="d-flex flex-column gap-1 text-muted" style="font-size: 0.82rem;">
                    <div><strong>Admin:</strong> admin@system.com / <code>Admin@1234</code></div>
                    <div><strong>Employer:</strong> amal@techcorp.lk / <code>Employer@123</code></div>
                    <div><strong>Job Seeker:</strong> kavindu@gmail.com / <code>Seeker@123</code></div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
