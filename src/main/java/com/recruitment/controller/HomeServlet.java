package com.recruitment.controller;

import com.recruitment.dao.ApplicationDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.VacancyDAO;
import com.recruitment.model.Vacancy;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller for the Public Homepage / Landing page.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private VacancyDAO vacancyDAO;
    private EmployerDAO employerDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() throws ServletException {
        vacancyDAO = new VacancyDAO();
        employerDAO = new EmployerDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Trigger automatic expiry check
            vacancyDAO.autoExpirePastDeadlines();

            // Fetch top 6 recent published vacancies
            List<Vacancy> featuredVacancies = vacancyDAO.searchAndFilter(null, null, null, null, null, null, 0, 6);
            
            // Stats
            int totalVacancies = vacancyDAO.countPublished();
            int totalEmployers = employerDAO.findAll().size();
            int totalApplications = applicationDAO.countTotal();

            request.setAttribute("featuredVacancies", featuredVacancies);
            request.setAttribute("totalVacancies", totalVacancies);
            request.setAttribute("totalEmployers", totalEmployers);
            request.setAttribute("totalApplications", totalApplications);

            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load homepage data.");
        }
    }
}
