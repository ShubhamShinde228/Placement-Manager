package com.placement.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.time.LocalDate;

import com.placement.util.DBConnection;

/**
 * Orchestrates the student → application workflow.
 *
 * Architecture:
 *   ApplicationServlet → ApplicationService → EligibilityService + JDBC
 *
 * The DAOs are bypassed here deliberately: ApplicationDAO.addApplication()
 * had its own eligibility logic, but we now route ALL application creation
 * through EligibilityService so the checks are in one place.
 *
 * ApplicationDAO retains its read methods (getAll, getById, etc.) and the
 * updateStatus / deleteApplication methods, which are unaffected.
 */
public class ApplicationService {

    private final EligibilityService eligibilityService = new EligibilityService();

    /**
     * Validates eligibility and, if all rules pass, inserts a new application.
     *
     * @param studentId student attempting to apply
     * @param driveId   target placement drive
     * @return null on success, or a human-readable error message on failure
     */
    public String applyForDrive(int studentId, int driveId) {

        // ── Step 1: Run full eligibility check ──────────────────────────────
        EligibilityResult result = eligibilityService.evaluate(studentId, driveId);

        if (!result.isEligible()) {
            // Return the failing reason as the flash error
            return result.getReason();
        }

        // ── Step 2: Insert application ──────────────────────────────────────
        String sql = "INSERT INTO applications (student_id, drive_id, applied_date, status) "
                   + "VALUES (?, ?, ?, 'APPLIED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, driveId);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            return null; // null = success

        } catch (Exception e) {
            System.err.println("ApplicationService.applyForDrive error: " + e.getMessage());
            return "Could not submit application. The student may already have applied to this drive.";
        }
    }

    /**
     * Returns the full EligibilityResult for a student+drive pair.
     * Used by the UI to display a detailed eligibility breakdown before applying.
     */
    public EligibilityResult checkEligibility(int studentId, int driveId) {
        return eligibilityService.evaluate(studentId, driveId);
    }
}
