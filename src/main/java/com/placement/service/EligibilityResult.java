package com.placement.service;

public class EligibilityResult {

    public enum Status {
        ELIGIBLE,
        NOT_ELIGIBLE
    }

    private Status status;
    private String reason;

    public EligibilityResult(Status status, String reason) {
        this.status = status;
        this.reason = reason;
    }

    public boolean isEligible() {
        return this.status == Status.ELIGIBLE;
    }

    public Status getStatus() {
        return status;
    }

    public String getReason() {
        return reason;
    }
}
