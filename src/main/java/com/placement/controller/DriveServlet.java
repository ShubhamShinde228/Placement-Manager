package com.placement.controller;

import java.io.IOException;
import java.sql.Date;

import com.placement.dao.CompanyDAO;
import com.placement.dao.DriveDAO;
import com.placement.model.Drive;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/drives")
public class DriveServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DriveDAO driveDAO;
    private CompanyDAO companyDAO;

    @Override
    public void init() {
        driveDAO = new DriveDAO();
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (driveDAO.deleteDrive(id)) {
                WebUtil.flashSuccess(request, "Drive deleted.");
            } else {
                WebUtil.flashError(request, "Could not delete drive.");
            }
            response.sendRedirect("drives");
            return;
        }

        if ("edit".equals(action)) {
            request.setAttribute("drive",
                    driveDAO.getDriveById(WebUtil.parseInt(request.getParameter("id"), 0)));
        }

        request.setAttribute("drives", driveDAO.getAllDrives());
        request.setAttribute("companies", companyDAO.getAllCompanies());
        request.setAttribute("pageTitle", "Placement Drives");
        request.getRequestDispatcher("drives.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Drive drive = new Drive();
        drive.setCompanyId(WebUtil.parseInt(request.getParameter("companyId"), 0));
        drive.setJobRole(WebUtil.trim(request.getParameter("jobRole")));
        drive.setVenue(WebUtil.trim(request.getParameter("venue")));
        drive.setMinCgpa(WebUtil.parseDouble(request.getParameter("minCgpa"), 0));
        drive.setMaxBacklogs(WebUtil.parseInt(request.getParameter("maxBacklogs"), 0));
        drive.setEligibleBranches(WebUtil.trim(request.getParameter("eligibleBranches")));
        drive.setStatus(WebUtil.trim(request.getParameter("status")));

        String dateValue = request.getParameter("driveDate");
        if (!WebUtil.isBlank(dateValue)) {
            drive.setDriveDate(Date.valueOf(dateValue));
        }

        if (drive.getCompanyId() <= 0 || WebUtil.isBlank(drive.getJobRole())) {
            WebUtil.flashError(request, "Company and job role are required.");
            response.sendRedirect("drives");
            return;
        }

        String action = request.getParameter("action");
        boolean ok;
        if ("update".equals(action)) {
            drive.setDriveId(WebUtil.parseInt(request.getParameter("driveId"), 0));
            ok = driveDAO.updateDrive(drive);
        } else {
            ok = driveDAO.addDrive(drive);
        }

        if (ok) {
            WebUtil.flashSuccess(request, "Drive saved.");
        } else {
            WebUtil.flashError(request, "Could not save drive. Add a company first if the list is empty.");
        }
        response.sendRedirect("drives");
    }
}
