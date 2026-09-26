package com.placement.controller;

import java.io.IOException;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.SelectionDAO;
import com.placement.service.PlacementService;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles final-selection CRUD.
 *
 * GET  ?action=delete&id=X   — remove a selection
 * GET  (default)             — show selections list + eligible-applications form
 * POST action=status         — update offer status (OFFERED/ACCEPTED/DECLINED)
 * POST (default)             — create new selection via PlacementService
 */
@WebServlet("/selections")
public class SelectionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private SelectionDAO    selectionDAO;
    private ApplicationDAO  applicationDAO;
    private PlacementService placementService;

    @Override
    public void init() {
        selectionDAO    = new SelectionDAO();
        applicationDAO  = new ApplicationDAO();
        placementService = new PlacementService();
    }

    // ──────────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (selectionDAO.deleteSelection(id)) {
                WebUtil.flashSuccess(request, "Selection removed.");
            } else {
                WebUtil.flashError(request, "Could not remove selection.");
            }
            response.sendRedirect("selections");
            return;
        }

        request.setAttribute("selections",          selectionDAO.getAllSelections());
        request.setAttribute("eligibleApplications", applicationDAO.getEligibleForSelection());
        request.setAttribute("pageTitle", "Final Selection");
        request.getRequestDispatcher("selections.jsp").forward(request, response);
    }

    // ──────────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ── Update offer status ────────────────────────────────────────────
        if ("status".equals(action)) {
            int    id     = WebUtil.parseInt(request.getParameter("selectionId"), 0);
            String status = WebUtil.trim(request.getParameter("offerStatus"));

            if (!status.equals("OFFERED") && !status.equals("ACCEPTED") && !status.equals("DECLINED")) {
                WebUtil.flashError(request, "Invalid offer status.");
                response.sendRedirect("selections");
                return;
            }

            if (selectionDAO.updateOfferStatus(id, status)) {
                WebUtil.flashSuccess(request, "Offer status updated to " + status + ".");
            } else {
                WebUtil.flashError(request, "Could not update offer status.");
            }
            response.sendRedirect("selections");
            return;
        }

        // ── Create new selection ───────────────────────────────────────────
        int    applicationId = WebUtil.parseInt(request.getParameter("applicationId"), 0);
        double packageLpa    = WebUtil.parseDouble(request.getParameter("packageLpa"), 0);
        String offerStatus   = WebUtil.trim(request.getParameter("offerStatus"));

        if (applicationId <= 0) {
            WebUtil.flashError(request, "Please select a valid eligible application.");
            response.sendRedirect("selections");
            return;
        }

        // PlacementService validates all business rules then inserts
        String error = placementService.finaliseSelection(applicationId, packageLpa, offerStatus);
        if (error == null) {
            WebUtil.flashSuccess(request, "Student marked as selected. Offer issued.");
        } else {
            WebUtil.flashError(request, error);
        }
        response.sendRedirect("selections");
    }
}
