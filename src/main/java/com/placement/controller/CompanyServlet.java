package com.placement.controller;

import java.io.IOException;

import com.placement.dao.CompanyDAO;
import com.placement.model.Company;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/companies")
public class CompanyServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CompanyDAO companyDAO;

    @Override
    public void init() {
        companyDAO = new CompanyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (companyDAO.deleteCompany(id)) {
                WebUtil.flashSuccess(request, "Company deleted.");
            } else {
                WebUtil.flashError(request, "Could not delete company.");
            }
            response.sendRedirect("companies");
            return;
        }

        if ("edit".equals(action)) {
            request.setAttribute("company",
                    companyDAO.getCompanyById(WebUtil.parseInt(request.getParameter("id"), 0)));
        }

        request.setAttribute("companies", companyDAO.getAllCompanies());
        request.setAttribute("pageTitle", "Companies");
        request.getRequestDispatcher("companies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Company company = new Company();
        company.setName(WebUtil.trim(request.getParameter("name")));
        company.setSector(WebUtil.trim(request.getParameter("sector")));
        company.setHrName(WebUtil.trim(request.getParameter("hrName")));
        company.setHrEmail(WebUtil.trim(request.getParameter("hrEmail")));
        company.setHrPhone(WebUtil.trim(request.getParameter("hrPhone")));

        if (WebUtil.isBlank(company.getName())) {
            WebUtil.flashError(request, "Company name is required.");
            response.sendRedirect("companies");
            return;
        }

        String action = request.getParameter("action");
        boolean ok;
        if ("update".equals(action)) {
            company.setCompanyId(WebUtil.parseInt(request.getParameter("companyId"), 0));
            ok = companyDAO.updateCompany(company);
        } else {
            ok = companyDAO.addCompany(company);
        }

        if (ok) {
            WebUtil.flashSuccess(request, "Company saved.");
        } else {
            WebUtil.flashError(request, "Could not save company.");
        }
        response.sendRedirect("companies");
    }
}
