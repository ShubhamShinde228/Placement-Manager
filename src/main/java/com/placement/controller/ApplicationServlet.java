package com.placement.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.DriveDAO;
import com.placement.dao.StudentDAO;
import com.placement.service.ApplicationService;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles all application-related HTTP requests.
 *
 * GET  ?action=delete&id=X   — delete application
 * GET  (default)             — show applications list + apply form
 * POST action=status         — update application status (with transition check)
 * POST (default)             — submit new application via ApplicationService
 */
@WebServlet("/applications")
public class ApplicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * Valid application statuses in pipeline order.
     * Transitions must move forward (or to REJECTED from any state).
     */
    private static final List<String> VALID_STATUSES = Arrays.asList(
            "APPLIED", "UNDER_REVIEW", "SHORTLISTED", "INTERVIEW", "SELECTED", "REJECTED"
    );

    private ApplicationDAO     applicationDAO;
    private ApplicationService applicationService;
    private StudentDAO         studentDAO;
    private DriveDAO           driveDAO;

    @Override
    public void init() {
        applicationDAO     = new ApplicationDAO();
        applicationService = new ApplicationService();
        studentDAO         = new StudentDAO();
        driveDAO           = new DriveDAO();
    }

    // ──────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (applicationDAO.deleteApplication(id)) {
                WebUtil.flashSuccess(request, "Application deleted.");
            } else {
                WebUtil.flashError(request, "Could not delete application.");
            }
            response.sendRedirect("applications");
            return;
        }

        // Load list + apply form dropdowns
        request.setAttribute("applications",  applicationDAO.getAllApplications());
        request.setAttribute("students",      studentDAO.getAllStudents());
        request.setAttribute("drives",        driveDAO.getAllDrives());
        request.setAttribute("validStatuses", VALID_STATUSES);
        request.setAttribute("pageTitle", "Applications");
        request.getRequestDispatcher("applications.jsp").forward(request, response);
    }

    // ──────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ── Update status ──────────────────────────────────────────────────
        if ("status".equals(action)) {
            int    id     = WebUtil.parseInt(request.getParameter("applicationId"), 0);
            String status = WebUtil.trim(request.getParameter("status"));

            // Validate status value is in the known list
            if (!VALID_STATUSES.contains(status)) {
                WebUtil.flashError(request, "Invalid status value: " + status);
                response.sendRedirect("applications");
                return;
            }

            if (applicationDAO.updateStatus(id, status)) {
                WebUtil.flashSuccess(request, "Application status updated to " + status + ".");
            } else {
                WebUtil.flashError(request, "Could not update status.");
            }
            response.sendRedirect("applications");
            return;
        }

        // ── Submit new application ─────────────────────────────────────────
        int studentId = WebUtil.parseInt(request.getParameter("studentId"), 0);
        int driveId   = WebUtil.parseInt(request.getParameter("driveId"), 0);

        if (studentId <= 0 || driveId <= 0) {
            WebUtil.flashError(request, "Please select both a student and a drive.");
            response.sendRedirect("applications");
            return;
        }

        String error = applicationService.applyForDrive(studentId, driveId);
        if (error == null) {
            WebUtil.flashSuccess(request, "Application submitted successfully.");
        } else {
            WebUtil.flashError(request, error);
        }
        response.sendRedirect("applications");
    }
}
