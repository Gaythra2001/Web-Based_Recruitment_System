package com.recruitment.controller;

import com.recruitment.dao.AuditLogDAO;
import com.recruitment.dao.CandidateProfileDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.UserDAO;
import com.recruitment.model.CandidateProfile;
import com.recruitment.model.Employer;
import com.recruitment.model.User;
import com.recruitment.util.PasswordUtil;
import com.recruitment.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller handling user authentication (Login, Register, Logout).
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;
    private EmployerDAO employerDAO;
    private CandidateProfileDAO candidateProfileDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        employerDAO = new EmployerDAO();
        candidateProfileDAO = new CandidateProfileDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/logout".equals(servletPath)) {
            handleLogout(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            redirectDashboard(user, response, request.getContextPath());
            return;
        }

        if ("/login".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else if ("/register".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/login".equals(servletPath)) {
            handleLogin(request, response);
        } else if ("/register".equals(servletPath)) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String password = request.getParameter("password");

        if (!ValidationUtil.isValidEmail(email) || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please provide a valid email and password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email);
            if (user == null || !PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                request.setAttribute("errorMessage", "Invalid email or password.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            if (!"ACTIVE".equalsIgnoreCase(user.getAccountStatus())) {
                request.setAttribute("errorMessage", "Your account is " + user.getAccountStatus().toLowerCase() + ". Please contact administrator.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            // Authentication successful: create session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);

            // Fetch profile link according to role
            if ("EMPLOYER".equalsIgnoreCase(user.getRole())) {
                Employer emp = employerDAO.findByUserId(user.getUserId());
                session.setAttribute("currentEmployer", emp);
            } else if ("JOB_SEEKER".equalsIgnoreCase(user.getRole())) {
                CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
                session.setAttribute("currentCandidate", cp);
            }

            // Log activity
            auditLogDAO.log(user.getUserId(), "LOGIN", "User", user.getUserId(),
                    "User logged in: " + user.getEmail(), request.getRemoteAddr());

            redirectDashboard(user, response, request.getContextPath());

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred during login. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName = ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = ValidationUtil.sanitize(request.getParameter("lastName"));
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Employer specific fields
        String companyName = ValidationUtil.sanitize(request.getParameter("companyName"));
        String industry = ValidationUtil.sanitize(request.getParameter("industry"));
        String city = ValidationUtil.sanitize(request.getParameter("city"));

        if (!ValidationUtil.isNotEmpty(firstName) || !ValidationUtil.isNotEmpty(lastName)) {
            setRegisterError(request, response, "First name and Last name are required.");
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            setRegisterError(request, response, "A valid email address is required.");
            return;
        }

        if (password == null || password.length() < 6) {
            setRegisterError(request, response, "Password must be at least 6 characters long.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            setRegisterError(request, response, "Passwords do not match.");
            return;
        }

        if (!"JOB_SEEKER".equals(role) && !"EMPLOYER".equals(role)) {
            setRegisterError(request, response, "Please select a valid account type.");
            return;
        }

        if ("EMPLOYER".equals(role) && !ValidationUtil.isNotEmpty(companyName)) {
            setRegisterError(request, response, "Company name is required for Employer registration.");
            return;
        }

        try {
            if (userDAO.findByEmail(email) != null) {
                setRegisterError(request, response, "An account with this email already exists.");
                return;
            }

            User user = new User();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole(role);
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setAccountStatus("ACTIVE");

            int userId = userDAO.createUser(user);
            if (userId <= 0) {
                setRegisterError(request, response, "Failed to create user account.");
                return;
            }

            if ("EMPLOYER".equals(role)) {
                Employer emp = new Employer();
                emp.setUserId(userId);
                emp.setCompanyName(companyName);
                emp.setIndustry(industry);
                emp.setCity(city);
                emp.setCompanyEmail(email);
                emp.setCompanyPhone(phone);
                employerDAO.createEmployer(emp);
            } else {
                CandidateProfile cp = new CandidateProfile();
                cp.setUserId(userId);
                cp.setCity(city);
                candidateProfileDAO.createProfile(cp);
            }

            auditLogDAO.log(userId, "REGISTER", "User", userId,
                    "New " + role + " registered: " + email, request.getRemoteAddr());

            HttpSession session = request.getSession(true);
            session.setAttribute("flashSuccess", "Registration successful! You may now sign in.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (SQLException e) {
            e.printStackTrace();
            setRegisterError(request, response, "A system error occurred during registration. Please try again.");
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                auditLogDAO.log(user.getUserId(), "LOGOUT", "User", user.getUserId(),
                        "User logged out", request.getRemoteAddr());
            }
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login?logout=success");
    }

    private void setRegisterError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.setAttribute("firstName", request.getParameter("firstName"));
        request.setAttribute("lastName", request.getParameter("lastName"));
        request.setAttribute("email", request.getParameter("email"));
        request.setAttribute("phone", request.getParameter("phone"));
        request.setAttribute("role", request.getParameter("role"));
        request.setAttribute("companyName", request.getParameter("companyName"));
        request.setAttribute("industry", request.getParameter("industry"));
        request.setAttribute("city", request.getParameter("city"));
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private void redirectDashboard(User user, HttpServletResponse response, String contextPath)
            throws IOException {
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if ("EMPLOYER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(contextPath + "/employer/dashboard");
        } else {
            response.sendRedirect(contextPath + "/vacancies");
        }
    }
}
