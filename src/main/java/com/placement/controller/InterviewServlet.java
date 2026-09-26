package com.placement.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.InterviewDAO;
import com.placement.model.Interview;
import com.placement.util.WebUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/interviews")
public class InterviewServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private InterviewDAO interviewDAO;
    private ApplicationDAO applicationDAO;

    @Override
    public void init() {
        interviewDAO = new InterviewDAO();
        applicationDAO = new ApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = WebUtil.parseInt(request.getParameter("id"), 0);
            if (interviewDAO.deleteInterview(id)) {
                WebUtil.flashSuccess(request, "Interview deleted.");
            } else {
                WebUtil.flashError(request, "Could not delete interview.");
            }
            response.sendRedirect("interviews");
            return;
        }

        if ("edit".equals(action)) {
            request.setAttribute("interview",
                    interviewDAO.getInterviewById(WebUtil.parseInt(request.getParameter("id"), 0)));
        }

        request.setAttribute("interviews", interviewDAO.getAllInterviews());
        request.setAttribute("applications", applicationDAO.getAllApplications());
        request.setAttribute("pageTitle", "Interviews");
        request.getRequestDispatcher("interviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Interview interview = new Interview();
        interview.setApplicationId(WebUtil.parseInt(request.getParameter("applicationId"), 0));
        interview.setRoundName(WebUtil.trim(request.getParameter("roundName")));
        interview.setResult(WebUtil.trim(request.getParameter("result")));
        interview.setInterviewDatetime(parseTimestamp(request.getParameter("interviewDatetime")));

        if (interview.getApplicationId() <= 0 || WebUtil.isBlank(interview.getRoundName())) {
            WebUtil.flashError(request, "Application and round name are required.");
            response.sendRedirect("interviews");
            return;
        }
        if (WebUtil.isBlank(interview.getResult())) {
            interview.setResult("PENDING");
        }

        String action = request.getParameter("action");
        boolean ok;
        if ("update".equals(action)) {
            interview.setInterviewId(WebUtil.parseInt(request.getParameter("interviewId"), 0));
            ok = interviewDAO.updateInterview(interview);
        } else {
            ok = interviewDAO.addInterview(interview);
        }

        if (ok) {
            WebUtil.flashSuccess(request, "Interview saved.");
        } else {
            WebUtil.flashError(request, "Could not save interview.");
        }
        response.sendRedirect("interviews");
    }

    private Timestamp parseTimestamp(String value) {
        if (WebUtil.isBlank(value)) {
            return null;
        }
        String normalized = value.replace("T", " ");
        if (normalized.length() == 16) {
            normalized = normalized + ":00";
        }
        try {
            return Timestamp.valueOf(normalized);
        } catch (Exception e) {
            return null;
        }
    }
}
