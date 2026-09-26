package com.placement.service;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.SelectionDAO;

/**
 * Orchestrates the Interview → Final Selection workflow.
 *
 * Business rules enforced before a student can be selected:
 *  1. Application must exist
 *  2. The application's student must have at least one PASS interview result
 *  3. Duplicate selection is not allowed (student+drive unique)
 *
 * The actual database writes delegate to SelectionDAO to keep the DAO
 * responsible for SQL while this service owns the business logic.
 */
public class PlacementService {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final SelectionDAO   selectionDAO   = new SelectionDAO();

    /**
     * Validates and creates a final selection record for a student.
     *
     * @param applicationId  the application to finalise
     * @param packageLpa     offered compensation in Lakhs Per Annum
     * @param offerStatus    OFFERED | ACCEPTED | DECLINED
     * @return null on success, or a human-readable error message on failure
     */
    public String finaliseSelection(int applicationId, double packageLpa, String offerStatus) {

        // ── Rule 1: Application must exist ───────────────────────────────────
        var application = applicationDAO.getApplicationById(applicationId);
        if (application == null) {
            return "Application not found. Please select a valid application.";
        }

        // ── Rule 2: Student must have passed at least one interview ──────────
        if (!applicationDAO.hasPassedInterview(applicationId)) {
            return "The student must pass at least one interview round before final selection.";
        }

        // ── Rule 3: Package must be positive ─────────────────────────────────
        if (packageLpa <= 0) {
            return "Package (LPA) must be greater than zero.";
        }

        // ── Rule 4: Offer status must be valid ────────────────────────────────
        String status = (offerStatus == null || offerStatus.isBlank()) ? "OFFERED" : offerStatus.trim();
        if (!status.equals("OFFERED") && !status.equals("ACCEPTED") && !status.equals("DECLINED")) {
            return "Invalid offer status. Must be OFFERED, ACCEPTED, or DECLINED.";
        }

        // ── Delegate insert to SelectionDAO ───────────────────────────────────
        // SelectionDAO.addSelection() also marks the application as SHORTLISTED
        String error = selectionDAO.addSelection(applicationId, packageLpa, status);
        if (error != null) {
            return error;
        }

        // ── Update application status to SELECTED ────────────────────────────
        applicationDAO.updateStatus(applicationId, "SELECTED");

        return null; // null = success
    }
}
