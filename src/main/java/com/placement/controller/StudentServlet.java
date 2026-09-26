package com.placement.controller;

import java.io.IOException;
import java.util.List;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (studentDAO.deleteStudent(id)) {
                WebUtil.flashSuccess(request, "Student deleted.");
            } else {
                WebUtil.flashError(request, "Could not delete student.");
            }
            response.sendRedirect("students");
            return;
        }

        if ("edit".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            request.setAttribute("student", studentDAO.getStudentById(id));
        }

        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.setAttribute("pageTitle", "Students");
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        Student student = new Student();
        student.setName(WebUtil.trim(request.getParameter("name")));
        student.setEmail(WebUtil.trim(request.getParameter("email")));
        student.setPhone(WebUtil.trim(request.getParameter("phone")));
        student.setBranch(WebUtil.trim(request.getParameter("branch")));
        student.setCgpa(WebUtil.parseDouble(request.getParameter("cgpa"), 0));
        student.setBacklogs(WebUtil.parseInt(request.getParameter("backlogs"), 0));

        if (WebUtil.isBlank(student.getName()) || WebUtil.isBlank(student.getEmail())) {
            WebUtil.flashError(request, "Name and email are required.");
            response.sendRedirect("students");
            return;
        }
        if (student.getCgpa() < 0 || student.getCgpa() > 10) {
            WebUtil.flashError(request, "CGPA must be between 0 and 10.");
            response.sendRedirect("students");
            return;
        }
        if (student.getBacklogs() < 0) {
            WebUtil.flashError(request, "Backlogs cannot be negative.");
            response.sendRedirect("students");
            return;
        }

        boolean ok;
        if ("update".equals(action)) {
            student.setStudentId(WebUtil.parseInt(request.getParameter("studentId"), 0));
            ok = studentDAO.updateStudent(student);
            WebUtil.flashSuccess(request, ok ? "Student updated." : "Could not update student.");
        } else {
            ok = studentDAO.addStudent(student);
            if (ok) {
                WebUtil.flashSuccess(request, "Student added.");
            } else {
                WebUtil.flashError(request, "Could not add student. Email may already exist.");
            }
        }
        response.sendRedirect("students");
    }
}
