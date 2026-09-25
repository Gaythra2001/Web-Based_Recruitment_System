package com.recruitment.controller;

import com.recruitment.dao.ApplicationDAO;
import com.recruitment.dao.AuditLogDAO;
import com.recruitment.dao.CandidateProfileDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.VacancyDAO;
import com.recruitment.model.Application;
import com.recruitment.model.CandidateProfile;
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
import java.sql.SQLException;
import java.util.List;

/**
 * Controller handling Job Applications from candidate submission through employer status review.
 */
@WebServlet(name = "ApplicationServlet", urlPatterns = {
    "/apply",
    "/candidate/applications",
    "/candidate/applications/withdraw",
    "/employer/application/update-status"
})
public class ApplicationServlet extends HttpServlet {

    private ApplicationDAO applicationDAO;
    private CandidateProfileDAO candidateProfileDAO;
    private VacancyDAO vacancyDAO;
    private EmployerDAO employerDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        applicationDAO = new ApplicationDAO();
        candidateProfileDAO = new CandidateProfileDAO();
        vacancyDAO = new VacancyDAO();
        employerDAO = new EmployerDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/candidate/applications".equals(path)) {
            showCandidateApplications(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/vacancies");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        try {
            switch (path) {
                case "/apply":
                    handleCandidateApply(request, response);
                    break;
                case "/candidate/applications/withdraw":
                    handleCandidateWithdraw(request, response);
                    break;
                case "/employer/application/update-status":
                    handleEmployerStatusUpdate(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/vacancies");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("flashError", "Application processing failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/vacancies");
        }
    }

    private void showCandidateApplications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        try {
            CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
            if (cp == null) {
                response.sendRedirect(request.getContextPath() + "/candidate/profile");
                return;
            }

            List<Application> applications = applicationDAO.findByCandidateId(cp.getCandidateId());
            request.setAttribute("applications", applications);
            request.getRequestDispatcher("/WEB-INF/views/candidate/my-applications.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load candidate applications.");
        }
    }

    private void handleCandidateApply(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
        String coverLetter = ValidationUtil.sanitize(request.getParameter("coverLetter"));

        Vacancy v = vacancyDAO.findById(vacancyId);
        if (v == null || !"PUBLISHED".equals(v.getStatus())) {
            session.setAttribute("flashError", "This vacancy is not open for applications.");
            response.sendRedirect(request.getContextPath() + "/vacancies");
            return;
        }

        CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
        if (cp == null) {
            session.setAttribute("flashError", "Please complete your profile before applying.");
            response.sendRedirect(request.getContextPath() + "/candidate/profile");
            return;
        }

        if (applicationDAO.hasCandidateApplied(vacancyId, cp.getCandidateId())) {
            session.setAttribute("flashError", "You have already applied for this vacancy.");
            response.sendRedirect(request.getContextPath() + "/vacancies/view?id=" + vacancyId);
            return;
        }

        Application app = new Application();
        app.setVacancyId(vacancyId);
        app.setCandidateId(cp.getCandidateId());
        app.setCoverLetter(coverLetter);
        app.setCvSnapshotPath(cp.getCvFilePath());

        int appId = applicationDAO.submitApplication(app, user.getUserId());
        if (appId > 0) {
            auditLogDAO.log(user.getUserId(), "APPLY", "Application", appId,
                    "Applied to vacancy ID " + vacancyId + ": " + v.getJobTitle(), request.getRemoteAddr());
            session.setAttribute("flashSuccess", "Your application has been submitted successfully!");
            response.sendRedirect(request.getContextPath() + "/candidate/applications");
        } else {
            session.setAttribute("flashError", "Failed to submit application. Please try again.");
            response.sendRedirect(request.getContextPath() + "/vacancies/view?id=" + vacancyId);
        }
    }

    private void handleCandidateWithdraw(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());

        if (cp != null) {
            boolean withdrawn = applicationDAO.withdrawApplication(applicationId, cp.getCandidateId(), user.getUserId());
            if (withdrawn) {
                auditLogDAO.log(user.getUserId(), "WITHDRAW_APPLICATION", "Application", applicationId,
                        "Candidate withdrew application ID " + applicationId, request.getRemoteAddr());
                session.setAttribute("flashSuccess", "Application withdrawn.");
            } else {
                session.setAttribute("flashError", "Could not withdraw application.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/candidate/applications");
    }

    private void handleEmployerStatusUpdate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        int vacancyId = Integer.parseInt(request.getParameter("vacancyId"));
        String newStatus = request.getParameter("status");
        String remarks = ValidationUtil.sanitize(request.getParameter("remarks"));
        String recruiterNotes = ValidationUtil.sanitize(request.getParameter("recruiterNotes"));

        Employer emp = employerDAO.findByUserId(user.getUserId());
        Vacancy v = vacancyDAO.findById(vacancyId);

        if (emp == null || v == null || v.getEmployerId() != emp.getEmployerId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized.");
            return;
        }

        boolean updated = applicationDAO.updateStatus(applicationId, newStatus, user.getUserId(), remarks, recruiterNotes);
        if (updated) {
            auditLogDAO.log(user.getUserId(), "UPDATE_APPLICATION_STATUS", "Application", applicationId,
                    "Application status changed to " + newStatus, request.getRemoteAddr());
            session.setAttribute("flashSuccess", "Applicant status updated to " + newStatus);
        } else {
            session.setAttribute("flashError", "Failed to update application status.");
        }
        response.sendRedirect(request.getContextPath() + "/employer/vacancies/applications?id=" + vacancyId);
    }
}
