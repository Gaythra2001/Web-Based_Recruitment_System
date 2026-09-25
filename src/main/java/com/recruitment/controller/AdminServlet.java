package com.recruitment.controller;

import com.recruitment.dao.ApplicationDAO;
import com.recruitment.dao.AuditLogDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.UserDAO;
import com.recruitment.dao.VacancyDAO;
import com.recruitment.model.AuditLog;
import com.recruitment.model.User;
import com.recruitment.model.Vacancy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for System Administrators.
 */
@WebServlet(name = "AdminServlet", urlPatterns = {
    "/admin/dashboard",
    "/admin/users",
    "/admin/users/status",
    "/admin/vacancies",
    "/admin/vacancies/delete",
    "/admin/audit"
})
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private VacancyDAO vacancyDAO;
    private ApplicationDAO applicationDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        vacancyDAO = new VacancyDAO();
        applicationDAO = new ApplicationDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            switch (path) {
                case "/admin/dashboard":
                    showDashboard(request, response);
                    break;
                case "/admin/users":
                    showUsers(request, response);
                    break;
                case "/admin/vacancies":
                    showVacancies(request, response);
                    break;
                case "/admin/audit":
                    showAuditLogs(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error handling admin request.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User adminUser = (User) session.getAttribute("currentUser");

        try {
            if ("/admin/users/status".equals(path)) {
                int targetUserId = Integer.parseInt(request.getParameter("userId"));
                String newStatus = request.getParameter("status");

                // Don't suspend own self
                if (targetUserId == adminUser.getUserId()) {
                    session.setAttribute("flashError", "Cannot change status of your own account.");
                } else {
                    userDAO.updateAccountStatus(targetUserId, newStatus);
                    auditLogDAO.log(adminUser.getUserId(), "CHANGE_USER_STATUS", "User", targetUserId,
                            "Admin set user " + targetUserId + " status to " + newStatus, request.getRemoteAddr());
                    session.setAttribute("flashSuccess", "User account status updated.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else if ("/admin/vacancies/delete".equals(path)) {
                int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
                vacancyDAO.adminDeleteVacancy(vacancyId);
                auditLogDAO.log(adminUser.getUserId(), "ADMIN_DELETE_VACANCY", "Vacancy", vacancyId,
                        "Admin deleted vacancy ID " + vacancyId, request.getRemoteAddr());
                session.setAttribute("flashSuccess", "Vacancy removed by admin moderation.");
                response.sendRedirect(request.getContextPath() + "/admin/vacancies");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Failed to perform admin operation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int totalUsers = userDAO.countTotalUsers();
        int totalVacancies = vacancyDAO.countTotal();
        int totalApplications = applicationDAO.countTotal();
        List<AuditLog> recentLogs = auditLogDAO.findRecent(8);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalVacancies", totalVacancies);
        request.setAttribute("totalApplications", totalApplications);
        request.setAttribute("recentLogs", recentLogs);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void showVacancies(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Vacancy> vacancies = vacancyDAO.findAll();
        request.setAttribute("vacancies", vacancies);
        request.getRequestDispatcher("/WEB-INF/views/admin/vacancies.jsp").forward(request, response);
    }

    private void showAuditLogs(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<AuditLog> logs = auditLogDAO.findRecent(50);
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/WEB-INF/views/admin/audit.jsp").forward(request, response);
    }
}
