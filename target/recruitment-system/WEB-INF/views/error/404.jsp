<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Page Not Found (404)" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center my-5 text-center">
    <div class="col-md-6">
        <div class="card card-custom p-5">
            <h1 class="display-1 fw-bold text-primary mb-2">404</h1>
            <h4 class="fw-bold mb-3">Position or Page Not Found</h4>
            <p class="text-muted mb-4">The vacancy or page you are looking for might have been closed, deleted, or the URL might be invalid.</p>
            <div>
                <a href="${pageContext.request.contextPath}/vacancies" class="btn btn-primary-custom me-2">Browse Vacancies</a>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">Go to Homepage</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
