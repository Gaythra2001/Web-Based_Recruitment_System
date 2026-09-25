package com.recruitment.filter;

import com.recruitment.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Access Control Filter for protecting role-restricted routes.
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/employer/*",
    "/admin/*",
    "/candidate/*",
    "/apply"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if (currentUser == null) {
            session = request.getSession(true);
            session.setAttribute("flashError", "Please log in to access this page.");
            response.sendRedirect(contextPath + "/login");
            return;
        }

        // Account status check
        if (!"ACTIVE".equalsIgnoreCase(currentUser.getAccountStatus())) {
            session.invalidate();
            response.sendRedirect(contextPath + "/login?error=account_suspended");
            return;
        }

        // Role-based authorization
        if (path.startsWith("/admin/") && !"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Administrator role required.");
            return;
        }

        if (path.startsWith("/employer/") && !"EMPLOYER".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Employer role required.");
            return;
        }

        if ((path.startsWith("/candidate/") || path.startsWith("/apply")) && !"JOB_SEEKER".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Job Seeker role required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
