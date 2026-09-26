package com.placement.controller;

import java.io.IOException;
import com.placement.dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    
    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        request.setAttribute("highestPackage", reportDAO.getHighestPackage());
        request.setAttribute("averagePackage", reportDAO.getAveragePackage());
        request.setAttribute("branchData", reportDAO.getPlacementsByBranch());
        request.setAttribute("pageTitle", "Analytics Reports");
        
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}
