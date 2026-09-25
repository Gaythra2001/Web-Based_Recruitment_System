<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'HireHub'}"/> | Recruitment System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom Style System -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-briefcase-fill text-primary"></i>
            <span>HireHub</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="bi bi-house me-1"></i> Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/vacancies"><i class="bi bi-search me-1"></i> Browse Jobs</a>
                </li>

                <c:if test="${sessionScope.currentUser != null}">
                    <!-- Job Seeker Navigation -->
                    <c:if test="${sessionScope.currentUser.role == 'JOB_SEEKER'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/candidate/applications"><i class="bi bi-file-earmark-check me-1"></i> My Applications</a>
                        </li>
                    </c:if>

                    <!-- Employer Navigation -->
                    <c:if test="${sessionScope.currentUser.role == 'EMPLOYER'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/employer/dashboard"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/employer/vacancies"><i class="bi bi-kanban me-1"></i> Manage Vacancies</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/employer/vacancies/new"><i class="bi bi-plus-circle me-1"></i> Post Vacancy</a>
                        </li>
                    </c:if>

                    <!-- Admin Navigation -->
                    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-shield-lock me-1"></i> Admin Panel</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/vacancies"><i class="bi bi-layers me-1"></i> Vacancies</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i> Users</a>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${sessionScope.currentUser == null}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-custom btn-sm">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-custom btn-sm">Register</a>
                    </c:when>
                    <c:otherwise>
                        <div class="dropdown">
                            <button class="btn btn-light dropdown-toggle d-flex align-items-center gap-2 border" type="button" data-bs-toggle="dropdown">
                                <span class="badge bg-primary text-white rounded-circle p-2">
                                    <c:out value="${sessionScope.currentUser.firstName.substring(0,1)}"/>
                                </span>
                                <span class="fw-semibold text-dark"><c:out value="${sessionScope.currentUser.firstName}"/></span>
                                <span class="badge bg-secondary" style="font-size: 0.7rem;"><c:out value="${sessionScope.currentUser.role}"/></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <c:if test="${sessionScope.currentUser.role == 'JOB_SEEKER'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/candidate/profile"><i class="bi bi-person me-2"></i> My Profile & CV</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/candidate/applications"><i class="bi bi-list-check me-2"></i> My Applications</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'EMPLOYER'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/employer/profile"><i class="bi bi-building me-2"></i> Company Profile</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/employer/dashboard"><i class="bi bi-graph-up me-2"></i> Recruitment Overview</a></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> System Metrics</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/audit"><i class="bi bi-journal-text me-2"></i> Audit Logs</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Sign Out</a></li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<main class="py-4">
    <div class="container">
        <%@ include file="/WEB-INF/views/common/alerts.jsp" %>
    </div>
