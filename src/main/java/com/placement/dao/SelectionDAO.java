package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Application;
import com.placement.model.Selection;
import com.placement.util.DBConnection;

public class SelectionDAO {

    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    public String addSelection(int applicationId, double packageLpa, String offerStatus) {
        Application application = applicationDAO.getApplicationById(applicationId);
        if (application == null) {
            return "Application not found.";
        }
        if (!applicationDAO.hasPassedInterview(applicationId)) {
            return "Student must have at least one PASS interview result.";
        }

        String sql = "INSERT INTO selections (student_id, drive_id, package_lpa, offer_status) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, application.getStudentId());
            ps.setInt(2, application.getDriveId());
            ps.setDouble(3, packageLpa);
            ps.setString(4, offerStatus == null ? "OFFERED" : offerStatus);
            ps.executeUpdate();
            applicationDAO.updateStatus(applicationId, "SELECTED");
            return null;

        } catch (Exception e) {
            e.printStackTrace();
            return "Could not save selection. This student may already be selected for the drive.";
        }
    }

    public List<Selection> getAllSelections() {
        List<Selection> selections = new ArrayList<>();
        String sql = "SELECT sel.*, s.name AS student_name, s.branch AS student_branch, "
                + "d.job_role, c.name AS company_name "
                + "FROM selections sel "
                + "JOIN students s ON sel.student_id = s.student_id "
                + "JOIN drives d ON sel.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "ORDER BY sel.selection_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                selections.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return selections;
    }

    public boolean updateOfferStatus(int selectionId, String offerStatus) {
        String sql = "UPDATE selections SET offer_status = ? WHERE selection_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, offerStatus);
            ps.setInt(2, selectionId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSelection(int selectionId) {
        String sql = "DELETE FROM selections WHERE selection_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, selectionId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasBeenSelected(int studentId, int driveId) {
        String sql = "SELECT 1 FROM selections WHERE student_id = ? AND drive_id = ? LIMIT 1";
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

    private Selection map(ResultSet rs) throws Exception {
        Selection selection = new Selection();
        selection.setSelectionId(rs.getInt("selection_id"));
        selection.setStudentId(rs.getInt("student_id"));
        selection.setDriveId(rs.getInt("drive_id"));
        selection.setPackageLpa(rs.getDouble("package_lpa"));
        selection.setOfferStatus(rs.getString("offer_status"));
        selection.setStudentName(rs.getString("student_name"));
        selection.setStudentBranch(rs.getString("student_branch"));
        selection.setJobRole(rs.getString("job_role"));
        selection.setCompanyName(rs.getString("company_name"));
        return selection;
    }
}
