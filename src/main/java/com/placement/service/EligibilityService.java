package com.placement.service;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.DriveDAO;
import com.placement.dao.SelectionDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Drive;
import com.placement.model.Student;
import com.placement.service.EligibilityResult.Status;

public class EligibilityService {

    private final StudentDAO studentDAO = new StudentDAO();
    private final DriveDAO driveDAO = new DriveDAO();
    private final ApplicationDAO applicationDAO = new ApplicationDAO();
    private final SelectionDAO selectionDAO = new SelectionDAO();

    public EligibilityResult evaluate(int studentId, int driveId) {

        // 1. Student exists
        Student student = studentDAO.getStudentById(studentId);
        if (student == null) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Student not found.");
        }

        // 2. Drive exists
        Drive drive = driveDAO.getDriveById(driveId);
        if (drive == null) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Drive not found.");
        }

        // 3. Drive status is ACTIVE (Note: Some drives default to UPCOMING. We assume active meaning not CLOSED)
        if ("CLOSED".equalsIgnoreCase(drive.getStatus())) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "This drive is closed.");
        }

        // 4. Student CGPA >= drive minimum CGPA
        if (student.getCgpa() < drive.getMinCgpa()) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "CGPA requirement not satisfied.");
        }

        // 5. Student backlogs <= drive maximum backlogs
        if (student.getBacklogs() > drive.getMaxBacklogs()) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Backlog requirement not satisfied.");
        }

        // 6. Student branch matches eligible branch
        if (!isBranchEligible(student.getBranch(), drive.getEligibleBranches())) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Branch not eligible.");
        }

        // 7. Student has not already applied
        if (applicationDAO.hasApplied(studentId, driveId)) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Student already applied.");
        }

        // 8. Student has not already been selected for the drive
        if (selectionDAO.hasBeenSelected(studentId, driveId)) {
            return new EligibilityResult(Status.NOT_ELIGIBLE, "Student already selected.");
        }

        return new EligibilityResult(Status.ELIGIBLE, "Eligible to apply.");
    }

    private boolean isBranchEligible(String studentBranch, String eligibleBranches) {
        if (eligibleBranches == null || eligibleBranches.isBlank() || "ALL".equalsIgnoreCase(eligibleBranches.trim())) {
            return true;
        }
        if (studentBranch == null) {
            return false;
        }
        String[] parts = eligibleBranches.split(",");
        for (String part : parts) {
            if (studentBranch.trim().equalsIgnoreCase(part.trim())) {
                return true;
            }
        }
        return false;
    }
}
