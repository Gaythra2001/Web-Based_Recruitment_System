<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</main>

<footer>
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white fw-bold mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-briefcase-fill text-primary"></i> HireHub
                </h5>
                <p class="small text-secondary">
                    Production-grade Web-Based Recruitment System supporting seamless vacancy management, talent acquisition, and end-to-end applicant tracking.
                </p>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white fw-semibold mb-3">For Candidates</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/vacancies">Browse Vacancies</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/candidate/profile">Build Profile & CV</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/candidate/applications">Track Applications</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white fw-semibold mb-3">For Employers</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/employer/vacancies/new">Post a Vacancy</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/employer/vacancies">Vacancy Management</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/employer/dashboard">Recruiter Dashboard</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white fw-semibold mb-3">System Scope</h6>
                <p class="small text-secondary mb-2">
                    Academic SE Final Project: Java MVC, Servlets, JSP, JDBC, MySQL.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-dark border border-secondary text-secondary">MVC</span>
                    <span class="badge bg-dark border border-secondary text-secondary">Tomcat</span>
                    <span class="badge bg-dark border border-secondary text-secondary">MySQL</span>
                </div>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="row align-items-center small text-secondary">
            <div class="col-md-6 text-center text-md-start">
                &copy; <%= java.time.Year.now().getValue() %> HireHub Recruitment System. All rights reserved.
            </div>
            <div class="col-md-6 text-center text-md-end mt-2 mt-md-0">
                <span>Designed with Java Servlets, JSP & Bootstrap 5</span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
