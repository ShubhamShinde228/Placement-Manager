package com.placement.controller;

import java.io.IOException;
import com.placement.dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String action = request.getParameter("action");
        if ("markRead".equals(action)) {
            notificationDAO.markAllAsRead();
            response.sendRedirect("notifications");
            return;
        }

        request.setAttribute("notifications", notificationDAO.getAllNotifications());
        request.setAttribute("pageTitle", "Notifications");
        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}
