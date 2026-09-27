<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-1">
            <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active">Administration</li>
            <li class="breadcrumb-item active">Settings</li>
        </ol>
    </nav>
    <h1><i class="bi bi-gear-fill me-2 text-primary"></i>Settings</h1>
    <p>Manage your account and application preferences.</p>
</div>

<div class="row">
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header"><i class="bi bi-shield-lock-fill me-2 text-primary"></i>Security Settings</div>
            <div class="card-body">
                <p class="text-muted small mb-3">Update your admin password. Minimum 6 characters required.</p>
                <form method="post" action="settings">
                    <input type="hidden" name="action" value="updatePassword">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">New Password</label>
                        <input type="password" name="newPassword" class="form-control" required minlength="6"
                               placeholder="Enter new password">
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Update Password
                    </button>
                </form>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card mb-4">
            <div class="card-header"><i class="bi bi-info-circle-fill me-2 text-muted"></i>Application Info</div>
            <div class="card-body">
                <table class="table table-sm mb-0">
                    <tr><td class="text-muted">Application</td><td><strong>Placement360</strong></td></tr>
                    <tr><td class="text-muted">Stack</td><td>Java 17 + Tomcat 10.1 + MySQL</td></tr>
                    <tr><td class="text-muted">Framework</td><td>Jakarta Servlet 6.0 + JSP + JSTL</td></tr>
                    <tr><td class="text-muted">UI</td><td>Bootstrap 5.3.3</td></tr>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
