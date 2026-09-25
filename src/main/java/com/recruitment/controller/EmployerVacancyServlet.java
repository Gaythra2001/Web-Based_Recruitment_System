package com.recruitment.controller;

import com.recruitment.dao.ApplicationDAO;
import com.recruitment.dao.AuditLogDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.VacancyDAO;
import com.recruitment.model.Application;
import com.recruitment.model.Employer;
import com.recruitment.model.User;
import com.recruitment.model.Vacancy;
import com.recruitment.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for Employers to manage their job vacancies (Core of Vacancy Management Module).
 */
@WebServlet(name = "EmployerVacancyServlet", urlPatterns = {
    "/employer/dashboard",
    "/employer/vacancies",
    "/employer/vacancies/new",
    "/employer/vacancies/edit",
    "/employer/vacancies/status",
    "/employer/vacancies/delete",
    "/employer/vacancies/applications"
})
public class EmployerVacancyServlet extends HttpServlet {

    private VacancyDAO vacancyDAO;
    private EmployerDAO employerDAO;
    private ApplicationDAO applicationDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        vacancyDAO = new VacancyDAO();
        employerDAO = new EmployerDAO();
        applicationDAO = new ApplicationDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        Employer employer = getEmployerFromSession(request);

        if (employer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (path) {
                case "/employer/dashboard":
                    showDashboard(request, response, employer);
                    break;
                case "/employer/vacancies":
                    showVacanciesList(request, response, employer);
                    break;
                case "/employer/vacancies/new":
                    showCreateForm(request, response);
                    break;
                case "/employer/vacancies/edit":
                    showEditForm(request, response, employer);
                    break;
                case "/employer/vacancies/applications":
                    showVacancyApplications(request, response, employer);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/employer/dashboard");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error handling request.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        Employer employer = getEmployerFromSession(request);

        if (employer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (path) {
                case "/employer/vacancies/new":
                    handleCreateVacancy(request, response, employer);
                    break;
                case "/employer/vacancies/edit":
                    handleUpdateVacancy(request, response, employer);
                    break;
                case "/employer/vacancies/status":
                    handleStatusChange(request, response, employer);
                    break;
                case "/employer/vacancies/delete":
                    handleDeleteVacancy(request, response, employer);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/employer/vacancies");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashError", "Failed to process request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employer/vacancies");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, ServletException, IOException {
        List<Vacancy> vacancies = vacancyDAO.findByEmployerId(employer.getEmployerId());

        int totalVacancies = vacancies.size();
        int activeVacancies = 0;
        int draftVacancies = 0;
        int closedVacancies = 0;
        int totalApplications = 0;

        for (Vacancy v : vacancies) {
            if ("PUBLISHED".equals(v.getStatus())) activeVacancies++;
            else if ("DRAFT".equals(v.getStatus())) draftVacancies++;
            else if ("CLOSED".equals(v.getStatus()) || "EXPIRED".equals(v.getStatus())) closedVacancies++;
            totalApplications += v.getApplicationsCount();
        }

        request.setAttribute("employer", employer);
        request.setAttribute("vacancies", vacancies);
        request.setAttribute("totalVacancies", totalVacancies);
        request.setAttribute("activeVacancies", activeVacancies);
        request.setAttribute("draftVacancies", draftVacancies);
        request.setAttribute("closedVacancies", closedVacancies);
        request.setAttribute("totalApplications", totalApplications);

        request.getRequestDispatcher("/WEB-INF/views/employer/dashboard.jsp").forward(request, response);
    }

    private void showVacanciesList(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, ServletException, IOException {
        List<Vacancy> vacancies = vacancyDAO.findByEmployerId(employer.getEmployerId());
        request.setAttribute("vacancies", vacancies);
        request.getRequestDispatcher("/WEB-INF/views/employer/vacancy-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/employer/vacancy-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employer/vacancies");
            return;
        }

        int vacancyId = Integer.parseInt(idParam);
        Vacancy vacancy = vacancyDAO.findById(vacancyId);

        if (vacancy == null || vacancy.getEmployerId() != employer.getEmployerId()) {
            request.getSession().setAttribute("flashError", "Vacancy not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/employer/vacancies");
            return;
        }

        request.setAttribute("vacancy", vacancy);
        request.getRequestDispatcher("/WEB-INF/views/employer/vacancy-form.jsp").forward(request, response);
    }

    private void showVacancyApplications(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employer/vacancies");
            return;
        }

        int vacancyId = Integer.parseInt(idParam);
        Vacancy vacancy = vacancyDAO.findById(vacancyId);

        if (vacancy == null || vacancy.getEmployerId() != employer.getEmployerId()) {
            request.getSession().setAttribute("flashError", "Vacancy not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/employer/vacancies");
            return;
        }

        List<Application> applications = applicationDAO.findByVacancyId(vacancyId);

        request.setAttribute("vacancy", vacancy);
        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/WEB-INF/views/employer/applications-list.jsp").forward(request, response);
    }

    private void handleCreateVacancy(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, IOException, ServletException {
        Vacancy v = extractVacancyFromRequest(request);
        v.setEmployerId(employer.getEmployerId());

        String error = validateVacancy(v);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.setAttribute("vacancy", v);
            request.getRequestDispatcher("/WEB-INF/views/employer/vacancy-form.jsp").forward(request, response);
            return;
        }

        int id = vacancyDAO.createVacancy(v);
        if (id > 0) {
            auditLogDAO.log(employer.getUserId(), "CREATE_VACANCY", "Vacancy", id,
                    "Created vacancy: " + v.getJobTitle() + " (" + v.getStatus() + ")", request.getRemoteAddr());
            request.getSession().setAttribute("flashSuccess", "Vacancy created successfully as " + v.getStatus() + "!");
        } else {
            request.getSession().setAttribute("flashError", "Failed to create vacancy.");
        }
        response.sendRedirect(request.getContextPath() + "/employer/vacancies");
    }

    private void handleUpdateVacancy(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, IOException, ServletException {
        int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
        Vacancy existing = vacancyDAO.findById(vacancyId);

        if (existing == null || existing.getEmployerId() != employer.getEmployerId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized action.");
            return;
        }

        Vacancy v = extractVacancyFromRequest(request);
        v.setVacancyId(vacancyId);
        v.setEmployerId(employer.getEmployerId());

        String error = validateVacancy(v);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.setAttribute("vacancy", v);
            request.getRequestDispatcher("/WEB-INF/views/employer/vacancy-form.jsp").forward(request, response);
            return;
        }

        boolean updated = vacancyDAO.updateVacancy(v);
        if (updated) {
            auditLogDAO.log(employer.getUserId(), "UPDATE_VACANCY", "Vacancy", vacancyId,
                    "Updated vacancy details for ID: " + vacancyId, request.getRemoteAddr());
            request.getSession().setAttribute("flashSuccess", "Vacancy details updated successfully.");
        } else {
            request.getSession().setAttribute("flashError", "Failed to update vacancy.");
        }
        response.sendRedirect(request.getContextPath() + "/employer/vacancies");
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, IOException {
        int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
        String newStatus = request.getParameter("status");

        Vacancy v = vacancyDAO.findById(vacancyId);
        if (v == null || v.getEmployerId() != employer.getEmployerId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized.");
            return;
        }

        boolean ok = vacancyDAO.updateStatus(vacancyId, newStatus);
        if (ok) {
            auditLogDAO.log(employer.getUserId(), "CHANGE_VACANCY_STATUS", "Vacancy", vacancyId,
                    "Changed status to " + newStatus, request.getRemoteAddr());
            request.getSession().setAttribute("flashSuccess", "Vacancy status updated to " + newStatus);
        } else {
            request.getSession().setAttribute("flashError", "Could not change vacancy status.");
        }
        response.sendRedirect(request.getContextPath() + "/employer/vacancies");
    }

    private void handleDeleteVacancy(HttpServletRequest request, HttpServletResponse response, Employer employer)
            throws SQLException, IOException {
        int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
        boolean deleted = vacancyDAO.deleteVacancy(vacancyId, employer.getEmployerId());

        if (deleted) {
            auditLogDAO.log(employer.getUserId(), "DELETE_VACANCY", "Vacancy", vacancyId,
                    "Deleted vacancy ID " + vacancyId, request.getRemoteAddr());
            request.getSession().setAttribute("flashSuccess", "Vacancy deleted successfully.");
        } else {
            request.getSession().setAttribute("flashError", "Failed to delete vacancy.");
        }
        response.sendRedirect(request.getContextPath() + "/employer/vacancies");
    }

    private Vacancy extractVacancyFromRequest(HttpServletRequest req) {
        Vacancy v = new Vacancy();
        v.setJobTitle(ValidationUtil.sanitize(req.getParameter("jobTitle")));
        v.setJobCode(ValidationUtil.sanitize(req.getParameter("jobCode")));
        v.setDescription(ValidationUtil.sanitize(req.getParameter("description")));
        v.setRequirements(ValidationUtil.sanitize(req.getParameter("requirements")));
        v.setResponsibilities(ValidationUtil.sanitize(req.getParameter("responsibilities")));
        v.setQualifications(ValidationUtil.sanitize(req.getParameter("qualifications")));
        v.setSkillsRequired(ValidationUtil.sanitize(req.getParameter("skillsRequired")));
        v.setEmploymentType(req.getParameter("employmentType"));
        v.setExperienceLevel(req.getParameter("experienceLevel"));
        v.setWorkMode(req.getParameter("workMode"));
        v.setIndustry(ValidationUtil.sanitize(req.getParameter("industry")));
        v.setLocation(ValidationUtil.sanitize(req.getParameter("location")));
        v.setSalaryCurrency(ValidationUtil.sanitize(req.getParameter("salaryCurrency")));
        v.setStatus(req.getParameter("status"));

        try {
            String sMin = req.getParameter("salaryMin");
            if (sMin != null && !sMin.isEmpty()) v.setSalaryMin(new BigDecimal(sMin));
        } catch (Exception ignored) {}

        try {
            String sMax = req.getParameter("salaryMax");
            if (sMax != null && !sMax.isEmpty()) v.setSalaryMax(new BigDecimal(sMax));
        } catch (Exception ignored) {}

        try {
            String vCount = req.getParameter("vacanciesCount");
            if (vCount != null && !vCount.isEmpty()) v.setVacanciesCount(Integer.parseInt(vCount));
        } catch (Exception ignored) {
            v.setVacanciesCount(1);
        }

        try {
            String deadline = req.getParameter("applicationDeadline");
            if (deadline != null && !deadline.isEmpty()) v.setApplicationDeadline(Date.valueOf(deadline));
        } catch (Exception ignored) {}

        return v;
    }

    private String validateVacancy(Vacancy v) {
        if (!ValidationUtil.isNotEmpty(v.getJobTitle())) return "Job title is required.";
        if (!ValidationUtil.isNotEmpty(v.getDescription())) return "Job description is required.";
        if (!ValidationUtil.isNotEmpty(v.getLocation())) return "Job location is required.";
        if (v.getApplicationDeadline() == null) return "Valid application deadline is required.";
        if (v.getApplicationDeadline().before(new java.util.Date(System.currentTimeMillis() - 86400000L))) {
            return "Application deadline cannot be in the past.";
        }
        if (v.getSalaryMin() != null && v.getSalaryMax() != null && v.getSalaryMin().compareTo(v.getSalaryMax()) > 0) {
            return "Minimum salary cannot exceed maximum salary.";
        }
        return null;
    }

    private Employer getEmployerFromSession(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        Employer emp = (Employer) session.getAttribute("currentEmployer");
        if (emp == null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null && "EMPLOYER".equalsIgnoreCase(user.getRole())) {
                try {
                    emp = employerDAO.findByUserId(user.getUserId());
                    session.setAttribute("currentEmployer", emp);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return emp;
    }
}
