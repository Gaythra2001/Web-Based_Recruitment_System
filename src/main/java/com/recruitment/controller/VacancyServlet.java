package com.recruitment.controller;

import com.recruitment.dao.ApplicationDAO;
import com.recruitment.dao.CandidateProfileDAO;
import com.recruitment.dao.VacancyDAO;
import com.recruitment.model.CandidateProfile;
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
 * Controller for Job Seekers and public visitors to search, filter, and view vacancies.
 */
@WebServlet(name = "VacancyServlet", urlPatterns = {"/vacancies", "/vacancies/view"})
public class VacancyServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9;

    private VacancyDAO vacancyDAO;
    private ApplicationDAO applicationDAO;
    private CandidateProfileDAO candidateProfileDAO;

    @Override
    public void init() throws ServletException {
        vacancyDAO = new VacancyDAO();
        applicationDAO = new ApplicationDAO();
        candidateProfileDAO = new CandidateProfileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/vacancies/view".equals(servletPath)) {
            handleVacancyDetail(request, response);
        } else {
            handleVacancyList(request, response);
        }
    }

    private void handleVacancyList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Auto expire past deadlines
        vacancyDAO.autoExpirePastDeadlines();

        String keyword = ValidationUtil.sanitize(request.getParameter("keyword"));
        String location = ValidationUtil.sanitize(request.getParameter("location"));
        String industry = ValidationUtil.sanitize(request.getParameter("industry"));
        String employmentType = ValidationUtil.sanitize(request.getParameter("employmentType"));
        String experienceLevel = ValidationUtil.sanitize(request.getParameter("experienceLevel"));
        String workMode = ValidationUtil.sanitize(request.getParameter("workMode"));

        int page = 1;
        try {
            String pStr = request.getParameter("page");
            if (pStr != null && !pStr.trim().isEmpty()) {
                page = Math.max(1, Integer.parseInt(pStr.trim()));
            }
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * PAGE_SIZE;

        try {
            int totalResults = vacancyDAO.countSearchResults(keyword, location, industry, employmentType, experienceLevel, workMode);
            List<Vacancy> vacancies = vacancyDAO.searchAndFilter(keyword, location, industry, employmentType, experienceLevel, workMode, offset, PAGE_SIZE);
            int totalPages = (int) Math.ceil((double) totalResults / PAGE_SIZE);

            request.setAttribute("vacancies", vacancies);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalResults", totalResults);

            request.setAttribute("keyword", keyword);
            request.setAttribute("location", location);
            request.setAttribute("industry", industry);
            request.setAttribute("employmentType", employmentType);
            request.setAttribute("experienceLevel", experienceLevel);
            request.setAttribute("workMode", workMode);

            request.getRequestDispatcher("/WEB-INF/views/vacancy/list.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading vacancies.");
        }
    }

    private void handleVacancyDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/vacancies");
            return;
        }

        try {
            int vacancyId = Integer.parseInt(idParam.trim());
            Vacancy vacancy = vacancyDAO.findById(vacancyId);

            if (vacancy == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Job Vacancy not found.");
                return;
            }

            // Increment view count
            vacancyDAO.incrementViews(vacancyId);

            // Check if current user is logged-in Job Seeker and if already applied
            HttpSession session = request.getSession(false);
            boolean alreadyApplied = false;
            boolean hasCv = false;

            if (session != null && session.getAttribute("currentUser") != null) {
                User user = (User) session.getAttribute("currentUser");
                if ("JOB_SEEKER".equalsIgnoreCase(user.getRole())) {
                    CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
                    if (cp != null) {
                        alreadyApplied = applicationDAO.hasCandidateApplied(vacancyId, cp.getCandidateId());
                        hasCv = (cp.getCvFilePath() != null && !cp.getCvFilePath().isEmpty());
                        session.setAttribute("currentCandidate", cp);
                    }
                }
            }

            request.setAttribute("vacancy", vacancy);
            request.setAttribute("alreadyApplied", alreadyApplied);
            request.setAttribute("hasCv", hasCv);

            request.getRequestDispatcher("/WEB-INF/views/vacancy/view.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vacancies");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching vacancy details.");
        }
    }
}
