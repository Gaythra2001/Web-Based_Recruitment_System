package com.recruitment.controller;

import com.recruitment.dao.AuditLogDAO;
import com.recruitment.dao.CandidateProfileDAO;
import com.recruitment.dao.EmployerDAO;
import com.recruitment.dao.UserDAO;
import com.recruitment.model.CandidateProfile;
import com.recruitment.model.Employer;
import com.recruitment.model.User;
import com.recruitment.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.SQLException;
import java.util.UUID;

/**
 * Controller for Candidate and Employer profile management and PDF CV upload.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {
    "/candidate/profile",
    "/employer/profile"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 15     // 15 MB
)
public class ProfileServlet extends HttpServlet {

    private CandidateProfileDAO candidateProfileDAO;
    private EmployerDAO employerDAO;
    private UserDAO userDAO;
    private AuditLogDAO auditLogDAO;

    @Override
    public void init() throws ServletException {
        candidateProfileDAO = new CandidateProfileDAO();
        employerDAO = new EmployerDAO();
        userDAO = new UserDAO();
        auditLogDAO = new AuditLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        try {
            if ("/candidate/profile".equals(path)) {
                CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
                if (cp == null) {
                    cp = new CandidateProfile();
                    cp.setUserId(user.getUserId());
                    candidateProfileDAO.createProfile(cp);
                    cp = candidateProfileDAO.findByUserId(user.getUserId());
                }
                request.setAttribute("profile", cp);
                request.getRequestDispatcher("/WEB-INF/views/candidate/profile.jsp").forward(request, response);
            } else if ("/employer/profile".equals(path)) {
                Employer emp = employerDAO.findByUserId(user.getUserId());
                if (emp == null) {
                    emp = new Employer();
                    emp.setUserId(user.getUserId());
                    emp.setCompanyName("Company Name");
                    employerDAO.createEmployer(emp);
                    emp = employerDAO.findByUserId(user.getUserId());
                }
                request.setAttribute("employer", emp);
                request.getRequestDispatcher("/WEB-INF/views/employer/profile.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error loading profile.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        try {
            if ("/candidate/profile".equals(path)) {
                handleCandidateProfileUpdate(request, response, user);
            } else if ("/employer/profile".equals(path)) {
                handleEmployerProfileUpdate(request, response, user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("flashError", "Failed to update profile: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + path);
        }
    }

    private void handleCandidateProfileUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws SQLException, IOException, ServletException {
        CandidateProfile cp = candidateProfileDAO.findByUserId(user.getUserId());
        if (cp == null) {
            cp = new CandidateProfile();
            cp.setUserId(user.getUserId());
            int id = candidateProfileDAO.createProfile(cp);
            cp.setCandidateId(id);
        }

        // Basic user info
        String firstName = ValidationUtil.sanitize(request.getParameter("firstName"));
        String lastName = ValidationUtil.sanitize(request.getParameter("lastName"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        userDAO.updateUser(user);

        // Profile fields
        String dob = request.getParameter("dateOfBirth");
        if (dob != null && !dob.isEmpty()) {
            try { cp.setDateOfBirth(Date.valueOf(dob)); } catch (Exception ignored) {}
        }
        cp.setGender(request.getParameter("gender"));
        cp.setAddress(ValidationUtil.sanitize(request.getParameter("address")));
        cp.setCity(ValidationUtil.sanitize(request.getParameter("city")));
        cp.setCountry(ValidationUtil.sanitize(request.getParameter("country")));
        cp.setCurrentJobTitle(ValidationUtil.sanitize(request.getParameter("currentJobTitle")));
        cp.setEducation(ValidationUtil.sanitize(request.getParameter("education")));
        cp.setSkills(ValidationUtil.sanitize(request.getParameter("skills")));
        cp.setExperience(ValidationUtil.sanitize(request.getParameter("experience")));
        cp.setProfileSummary(ValidationUtil.sanitize(request.getParameter("profileSummary")));

        candidateProfileDAO.updateProfile(cp);

        // File upload (CV / Resume)
        try {
            Part filePart = request.getPart("cvFile");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (submittedFileName.toLowerCase().endsWith(".pdf")) {
                    String uploadDir = getServletContext().getRealPath("/uploads/cv");
                    File uploadDirFile = new File(uploadDir);
                    if (!uploadDirFile.exists()) {
                        uploadDirFile.mkdirs();
                    }

                    String uniqueName = UUID.randomUUID().toString() + "_" + submittedFileName.replaceAll("\\s+", "_");
                    String fullPath = uploadDir + File.separator + uniqueName;
                    filePart.write(fullPath);

                    String relativeWebPath = "uploads/cv/" + uniqueName;
                    candidateProfileDAO.updateCv(cp.getCandidateId(), submittedFileName, relativeWebPath);
                    cp.setCvFileName(submittedFileName);
                    cp.setCvFilePath(relativeWebPath);
                } else {
                    request.getSession().setAttribute("flashError", "Only PDF documents are allowed for CV upload.");
                    response.sendRedirect(request.getContextPath() + "/candidate/profile");
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("CV upload skipped or failed: " + e.getMessage());
        }

        auditLogDAO.log(user.getUserId(), "UPDATE_PROFILE", "CandidateProfile", cp.getCandidateId(),
                "Candidate updated profile details", request.getRemoteAddr());

        request.getSession().setAttribute("currentUser", user);
        request.getSession().setAttribute("currentCandidate", cp);
        request.getSession().setAttribute("flashSuccess", "Profile updated successfully!");
        response.sendRedirect(request.getContextPath() + "/candidate/profile");
    }

    private void handleEmployerProfileUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws SQLException, IOException {
        Employer emp = employerDAO.findByUserId(user.getUserId());
        if (emp == null) {
            emp = new Employer();
            emp.setUserId(user.getUserId());
            int id = employerDAO.createEmployer(emp);
            emp.setEmployerId(id);
        }

        emp.setCompanyName(ValidationUtil.sanitize(request.getParameter("companyName")));
        emp.setCompanyEmail(ValidationUtil.sanitize(request.getParameter("companyEmail")));
        emp.setCompanyPhone(ValidationUtil.sanitize(request.getParameter("companyPhone")));
        emp.setCompanyAddress(ValidationUtil.sanitize(request.getParameter("companyAddress")));
        emp.setCity(ValidationUtil.sanitize(request.getParameter("city")));
        emp.setIndustry(ValidationUtil.sanitize(request.getParameter("industry")));
        emp.setWebsite(ValidationUtil.sanitize(request.getParameter("website")));
        emp.setCompanyDescription(ValidationUtil.sanitize(request.getParameter("companyDescription")));

        employerDAO.updateEmployer(emp);

        auditLogDAO.log(user.getUserId(), "UPDATE_EMPLOYER_PROFILE", "Employer", emp.getEmployerId(),
                "Employer updated company profile: " + emp.getCompanyName(), request.getRemoteAddr());

        request.getSession().setAttribute("currentEmployer", emp);
        request.getSession().setAttribute("flashSuccess", "Company profile updated successfully!");
        response.sendRedirect(request.getContextPath() + "/employer/profile");
    }
}
