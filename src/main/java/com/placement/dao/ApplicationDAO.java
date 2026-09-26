package com.placement.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Application;
import com.placement.model.Drive;
import com.placement.model.Student;
import com.placement.util.DBConnection;

public class ApplicationDAO {

    private final StudentDAO studentDAO = new StudentDAO();
    private final DriveDAO driveDAO = new DriveDAO();

    public String addApplication(int studentId, int driveId) {
        Student student = studentDAO.getStudentById(studentId);
        Drive drive = driveDAO.getDriveById(driveId);

        if (student == null) {
            return "Student not found.";
        }
        if (drive == null) {
            return "Drive not found.";
        }
        if ("CLOSED".equalsIgnoreCase(drive.getStatus())) {
            return "This drive is closed.";
        }
        if (student.getCgpa() < drive.getMinCgpa()) {
            return "Student CGPA is below the drive requirement.";
        }
        if (student.getBacklogs() > drive.getMaxBacklogs()) {
            return "Student has more backlogs than allowed.";
        }
        if (!branchEligible(student.getBranch(), drive.getEligibleBranches())) {
            return "Student branch is not eligible for this drive.";
        }

        String sql = "INSERT INTO applications (student_id, drive_id, applied_date, status) "
                + "VALUES (?, ?, ?, 'APPLIED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, driveId);
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            return null;

        } catch (Exception e) {
            e.printStackTrace();
            return "Could not apply. The student may already have applied to this drive.";
        }
    }

    public List<Application> getAllApplications() {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.*, s.name AS student_name, s.cgpa AS student_cgpa, "
                + "s.backlogs AS student_backlogs, s.branch AS student_branch, "
                + "d.job_role, c.name AS company_name "
                + "FROM applications a "
                + "JOIN students s ON a.student_id = s.student_id "
                + "JOIN drives d ON a.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "ORDER BY a.application_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                applications.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return applications;
    }

    public Application getApplicationById(int applicationId) {
        String sql = "SELECT a.*, s.name AS student_name, s.cgpa AS student_cgpa, "
                + "s.backlogs AS student_backlogs, s.branch AS student_branch, "
                + "d.job_role, c.name AS company_name "
                + "FROM applications a "
                + "JOIN students s ON a.student_id = s.student_id "
                + "JOIN drives d ON a.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "WHERE a.application_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Application> getEligibleForSelection() {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT a.*, s.name AS student_name, s.cgpa AS student_cgpa, "
                + "s.backlogs AS student_backlogs, s.branch AS student_branch, "
                + "d.job_role, c.name AS company_name "
                + "FROM applications a "
                + "JOIN students s ON a.student_id = s.student_id "
                + "JOIN drives d ON a.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "WHERE EXISTS (SELECT 1 FROM interviews i "
                + "              WHERE i.application_id = a.application_id "
                + "              AND i.result = 'PASS') "
                + "AND NOT EXISTS (SELECT 1 FROM selections sel "
                + "                WHERE sel.student_id = a.student_id "
                + "                AND sel.drive_id = a.drive_id) "
                + "ORDER BY a.application_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                applications.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return applications;
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE applications SET status = ? WHERE application_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteApplication(int applicationId) {
        String sql = "DELETE FROM applications WHERE application_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasPassedInterview(int applicationId) {
        String sql = "SELECT 1 FROM interviews WHERE application_id = ? AND result = 'PASS' LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, applicationId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean branchEligible(String studentBranch, String eligibleBranches) {
        if (eligibleBranches == null || eligibleBranches.isBlank()
                || "ALL".equalsIgnoreCase(eligibleBranches.trim())) {
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

    public boolean hasApplied(int studentId, int driveId) {
        String sql = "SELECT 1 FROM applications WHERE student_id = ? AND drive_id = ? LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, driveId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Application map(ResultSet rs) throws Exception {
        Application application = new Application();
        application.setApplicationId(rs.getInt("application_id"));
        application.setStudentId(rs.getInt("student_id"));
        application.setDriveId(rs.getInt("drive_id"));
        application.setAppliedDate(rs.getDate("applied_date"));
        application.setStatus(rs.getString("status"));
        application.setStudentName(rs.getString("student_name"));
        application.setJobRole(rs.getString("job_role"));
        application.setCompanyName(rs.getString("company_name"));
        application.setStudentCgpa(rs.getDouble("student_cgpa"));
        application.setStudentBacklogs(rs.getInt("student_backlogs"));
        application.setStudentBranch(rs.getString("student_branch"));
        return application;
    }
}
