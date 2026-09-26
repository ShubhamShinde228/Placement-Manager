package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Student;
import com.placement.util.DBConnection;

public class StudentDAO {

    // CREATE
    public boolean addStudent(Student student) {

        String sql = "INSERT INTO students " +
                     "(name, email, phone, branch, cgpa, backlogs) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getBranch());
            ps.setDouble(5, student.getCgpa());
            ps.setInt(6, student.getBacklogs());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // READ ALL
    public List<Student> getAllStudents() {

        List<Student> students = new ArrayList<>();

        String sql = "SELECT * FROM students ORDER BY student_id DESC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Student student = new Student();

                student.setStudentId(
                    rs.getInt("student_id")
                );

                student.setName(
                    rs.getString("name")
                );

                student.setEmail(
                    rs.getString("email")
                );

                student.setPhone(
                    rs.getString("phone")
                );

                student.setBranch(
                    rs.getString("branch")
                );

                student.setCgpa(
                    rs.getDouble("cgpa")
                );

                student.setBacklogs(
                    rs.getInt("backlogs")
                );

                students.add(student);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return students;
    }


    // READ BY ID
    public Student getStudentById(int studentId) {

        Student student = null;

        String sql = "SELECT * FROM students WHERE student_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, studentId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                student = new Student();

                student.setStudentId(
                    rs.getInt("student_id")
                );

                student.setName(
                    rs.getString("name")
                );

                student.setEmail(
                    rs.getString("email")
                );

                student.setPhone(
                    rs.getString("phone")
                );

                student.setBranch(
                    rs.getString("branch")
                );

                student.setCgpa(
                    rs.getDouble("cgpa")
                );

                student.setBacklogs(
                    rs.getInt("backlogs")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return student;
    }


    // UPDATE
    public boolean updateStudent(Student student) {

        String sql = "UPDATE students SET " +
                     "name = ?, email = ?, phone = ?, " +
                     "branch = ?, cgpa = ?, backlogs = ? " +
                     "WHERE student_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getBranch());
            ps.setDouble(5, student.getCgpa());
            ps.setInt(6, student.getBacklogs());
            ps.setInt(7, student.getStudentId());

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // DELETE
    public boolean deleteStudent(int studentId) {

        String sql =
            "DELETE FROM students WHERE student_id = ?";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, studentId);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}