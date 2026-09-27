package com.placement.controller;

import java.io.IOException;
import java.time.LocalTime;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.DriveDAO;
import com.placement.dao.InterviewDAO;
import com.placement.dao.SelectionDAO;
import com.placement.dao.StudentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StudentDAO     studentDAO;
    private CompanyDAO     companyDAO;
    private DriveDAO       driveDAO;
    private ApplicationDAO applicationDAO;
    private InterviewDAO   interviewDAO;
    private SelectionDAO   selectionDAO;

    @Override
    public void init() {
        studentDAO     = new StudentDAO();
        companyDAO     = new CompanyDAO();
        driveDAO       = new DriveDAO();
        applicationDAO = new ApplicationDAO();
        interviewDAO   = new InterviewDAO();
        selectionDAO   = new SelectionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // KPI counts — all from real DB
        request.setAttribute("totalStudents",    studentDAO.getAllStudents().size());
        request.setAttribute("totalCompanies",   companyDAO.getAllCompanies().size());
        request.setAttribute("activeDrives",     driveDAO.getActiveDrives().size());
        request.setAttribute("totalApplications",applicationDAO.getAllApplications().size());
        request.setAttribute("totalInterviews",  interviewDAO.getAllInterviews().size());
        request.setAttribute("totalSelections",  selectionDAO.getAllSelections().size());

        // Active drives list for the dashboard table
        request.setAttribute("openDrives", driveDAO.getActiveDrives());

        // Greeting
        int hour = LocalTime.now().getHour();
        String greeting = hour < 12 ? "Good Morning" : hour < 17 ? "Good Afternoon" : "Good Evening";
        request.setAttribute("greeting", greeting);

        request.setAttribute("pageTitle", "Dashboard");
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
