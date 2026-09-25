<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="System Error (500)" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="row justify-content-center my-5 text-center">
    <div class="col-md-6">
        <div class="card card-custom p-5">
            <h1 class="display-1 fw-bold text-danger mb-2">500</h1>
            <h4 class="fw-bold mb-3">Internal Server Error</h4>
            <p class="text-muted mb-4">Something went wrong while processing your request. Please try again or return to the homepage.</p>
            <div>
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary-custom">Return to Safety</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
