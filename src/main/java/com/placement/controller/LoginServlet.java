package com.placement.controller;

import java.io.IOException;

import com.placement.dao.UserDAO;
import com.placement.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.login(username, password);

        if (user != null) {

            HttpSession session = request.getSession();
            user.setPassword(null);
            session.setAttribute("user", user);

            response.sendRedirect("dashboard.jsp");

        } else {

            request.setAttribute(
                    "error",
                    "Invalid username or password"
            );

            request.getRequestDispatcher("login.jsp")
                   .forward(request, response);
        }
    }
}