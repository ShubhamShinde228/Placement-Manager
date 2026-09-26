package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Interview;
import com.placement.util.DBConnection;

public class InterviewDAO {

    public boolean addInterview(Interview interview) {
        String sql = "INSERT INTO interviews (application_id, round_name, interview_datetime, result) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interview.getApplicationId());
            ps.setString(2, interview.getRoundName());
            ps.setTimestamp(3, interview.getInterviewDatetime());
            ps.setString(4, interview.getResult() == null ? "PENDING" : interview.getResult());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Interview> getAllInterviews() {
        List<Interview> interviews = new ArrayList<>();
        String sql = "SELECT i.*, s.name AS student_name, d.job_role, c.name AS company_name "
                + "FROM interviews i "
                + "JOIN applications a ON i.application_id = a.application_id "
                + "JOIN students s ON a.student_id = s.student_id "
                + "JOIN drives d ON a.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "ORDER BY i.interview_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                interviews.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return interviews;
    }

    public Interview getInterviewById(int interviewId) {
        String sql = "SELECT i.*, s.name AS student_name, d.job_role, c.name AS company_name "
                + "FROM interviews i "
                + "JOIN applications a ON i.application_id = a.application_id "
                + "JOIN students s ON a.student_id = s.student_id "
                + "JOIN drives d ON a.drive_id = d.drive_id "
                + "JOIN companies c ON d.company_id = c.company_id "
                + "WHERE i.interview_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interviewId);
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

    public boolean updateInterview(Interview interview) {
        String sql = "UPDATE interviews SET application_id = ?, round_name = ?, "
                + "interview_datetime = ?, result = ? WHERE interview_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interview.getApplicationId());
            ps.setString(2, interview.getRoundName());
            ps.setTimestamp(3, interview.getInterviewDatetime());
            ps.setString(4, interview.getResult());
            ps.setInt(5, interview.getInterviewId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInterview(int interviewId) {
        String sql = "DELETE FROM interviews WHERE interview_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, interviewId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Interview map(ResultSet rs) throws Exception {
        Interview interview = new Interview();
        interview.setInterviewId(rs.getInt("interview_id"));
        interview.setApplicationId(rs.getInt("application_id"));
        interview.setRoundName(rs.getString("round_name"));
        Timestamp ts = rs.getTimestamp("interview_datetime");
        interview.setInterviewDatetime(ts);
        interview.setResult(rs.getString("result"));
        interview.setStudentName(rs.getString("student_name"));
        interview.setJobRole(rs.getString("job_role"));
        interview.setCompanyName(rs.getString("company_name"));
        return interview;
    }
}
