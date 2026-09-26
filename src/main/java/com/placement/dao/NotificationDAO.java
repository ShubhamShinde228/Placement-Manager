package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.placement.model.Notification;
import com.placement.util.DBConnection;

public class NotificationDAO {

    public void addNotification(String message) {
        String sql = "INSERT INTO notifications (message) VALUES (?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, message);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Notification(
                    rs.getInt("id"),
                    rs.getString("message"),
                    rs.getTimestamp("created_at"),
                    rs.getBoolean("is_read")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void markAllAsRead() {
        String sql = "UPDATE notifications SET is_read = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getUnreadCount() {
        String sql = "SELECT COUNT(*) FROM notifications WHERE is_read = FALSE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
