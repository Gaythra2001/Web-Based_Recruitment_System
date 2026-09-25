<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Request / Session Flash Alerts -->
<c:if test="${not empty errorMessage or not empty sessionScope.flashError}">
    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill flex-shrink-0 me-2 fs-5"></i>
        <div>
            <c:out value="${not empty errorMessage ? errorMessage : sessionScope.flashError}"/>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="flashError" scope="session"/>
</c:if>

<c:if test="${not empty successMessage or not empty sessionScope.flashSuccess}">
    <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill flex-shrink-0 me-2 fs-5"></i>
        <div>
            <c:out value="${not empty successMessage ? successMessage : sessionScope.flashSuccess}"/>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="flashSuccess" scope="session"/>
</c:if>
