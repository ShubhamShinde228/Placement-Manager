package com.placement.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Drive;
import com.placement.util.DBConnection;

public class DriveDAO {

    public boolean addDrive(Drive drive) {
        String sql = "INSERT INTO drives (company_id, job_role, drive_date, venue, "
                + "min_cgpa, max_backlogs, eligible_branches, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            bind(ps, drive);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Drive> getAllDrives() {
        List<Drive> drives = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name FROM drives d "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "ORDER BY d.drive_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                drives.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return drives;
    }

    public List<Drive> getActiveDrives() {
        List<Drive> drives = new ArrayList<>();
        String sql = "SELECT d.*, c.name AS company_name FROM drives d "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "WHERE d.status = 'OPEN' "
                + "ORDER BY d.drive_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                drives.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return drives;
    }

    public Drive getDriveById(int driveId) {
        String sql = "SELECT d.*, c.name AS company_name FROM drives d "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "WHERE d.drive_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, driveId);
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

    public boolean updateDrive(Drive drive) {
        String sql = "UPDATE drives SET company_id = ?, job_role = ?, drive_date = ?, "
                + "venue = ?, min_cgpa = ?, max_backlogs = ?, eligible_branches = ?, "
                + "status = ? WHERE drive_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            bind(ps, drive);
            ps.setInt(9, drive.getDriveId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDrive(int driveId) {
        String sql = "DELETE FROM drives WHERE drive_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, driveId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void bind(PreparedStatement ps, Drive drive) throws Exception {
        ps.setInt(1, drive.getCompanyId());
        ps.setString(2, drive.getJobRole());
        if (drive.getDriveDate() != null) {
            ps.setDate(3, drive.getDriveDate());
        } else {
            ps.setDate(3, (Date) null);
        }
        ps.setString(4, drive.getVenue());
        ps.setDouble(5, drive.getMinCgpa());
        ps.setInt(6, drive.getMaxBacklogs());
        ps.setString(7, drive.getEligibleBranches());
        ps.setString(8, drive.getStatus());
    }

    private Drive map(ResultSet rs) throws Exception {
        Drive drive = new Drive();
        drive.setDriveId(rs.getInt("drive_id"));
        drive.setCompanyId(rs.getInt("company_id"));
        drive.setJobRole(rs.getString("job_role"));
        drive.setDriveDate(rs.getDate("drive_date"));
        drive.setVenue(rs.getString("venue"));
        drive.setMinCgpa(rs.getDouble("min_cgpa"));
        drive.setMaxBacklogs(rs.getInt("max_backlogs"));
        drive.setEligibleBranches(rs.getString("eligible_branches"));
        drive.setStatus(rs.getString("status"));
        drive.setCompanyName(rs.getString("company_name"));
        return drive;
    }
}
