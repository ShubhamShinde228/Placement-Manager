<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Settings</h2>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white fw-semibold">
                Security Settings
            </div>
            <div class="card-body">
                <form method="post" action="settings">
                    <input type="hidden" name="action" value="updatePassword">
                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" name="newPassword" class="form-control" required minlength="6" placeholder="Enter new password">
                    </div>
                    <button type="submit" class="btn btn-primary">Update Password</button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
