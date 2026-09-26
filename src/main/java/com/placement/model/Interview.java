package com.placement.model;

import java.sql.Timestamp;

public class Interview {

    private int interviewId;
    private int applicationId;
    private String roundName;
    private Timestamp interviewDatetime;
    private String result;
    private String studentName;
    private String jobRole;
    private String companyName;

    public int getInterviewId() {
        return interviewId;
    }

    public void setInterviewId(int interviewId) {
        this.interviewId = interviewId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getRoundName() {
        return roundName;
    }

    public void setRoundName(String roundName) {
        this.roundName = roundName;
    }

    public Timestamp getInterviewDatetime() {
        return interviewDatetime;
    }

    public void setInterviewDatetime(Timestamp interviewDatetime) {
        this.interviewDatetime = interviewDatetime;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getJobRole() {
        return jobRole;
    }

    public void setJobRole(String jobRole) {
        this.jobRole = jobRole;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
}
