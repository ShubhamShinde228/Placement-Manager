package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import com.placement.util.DBConnection;

public class ReportDAO {

    public double getHighestPackage() {
        String sql = "SELECT MAX(package_lpa) FROM selections";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public double getAveragePackage() {
        String sql = "SELECT AVG(package_lpa) FROM selections";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public Map<String, Integer> getPlacementsByBranch() {
        Map<String, Integer> data = new HashMap<>();
        String sql = "SELECT st.branch, COUNT(s.selection_id) FROM selections s " +
                     "JOIN students st ON s.student_id = st.student_id " +
                     "GROUP BY st.branch";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}
