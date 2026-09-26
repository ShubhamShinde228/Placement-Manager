package com.placement.controller;

import java.io.IOException;
import com.placement.dao.UserDAO;
import com.placement.model.User;
import com.placement.util.WebUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {
    
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Settings");
        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        if ("updatePassword".equals(action)) {
            User user = (User) request.getSession().getAttribute("user");
            String newPassword = request.getParameter("newPassword");
            
            if (newPassword != null && newPassword.length() >= 6) {
                if (userDAO.updatePassword(user.getUserId(), newPassword)) {
                    WebUtil.flashSuccess(request, "Password updated successfully!");
                } else {
                    WebUtil.flashError(request, "Failed to update password.");
                }
            } else {
                WebUtil.flashError(request, "Password must be at least 6 characters.");
            }
        }
        response.sendRedirect("settings");
    }
}
