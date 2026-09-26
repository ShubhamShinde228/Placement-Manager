package com.placement.model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private String message;
    private Timestamp createdAt;
    private boolean isRead;

    public Notification() {}

    public Notification(int id, String message, Timestamp createdAt, boolean isRead) {
        this.id = id;
        this.message = message;
        this.createdAt = createdAt;
        this.isRead = isRead;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
}
