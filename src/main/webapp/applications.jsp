<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-1">
            <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active">Recruitment Process</li>
            <li class="breadcrumb-item active">Applications</li>
        </ol>
    </nav>
    <h1><i class="bi bi-file-earmark-text-fill me-2 text-primary"></i>Applications</h1>
    <p>Manage student applications across the placement pipeline. Eligibility is enforced automatically.</p>
</div>

<!-- Pipeline Status Reference -->
<div class="card mb-4">
    <div class="card-body py-2">
        <div class="d-flex flex-wrap gap-2 align-items-center small fw-semibold">
            <span class="badge badge-applied">APPLIED</span>
            <i class="bi bi-arrow-right text-muted"></i>
            <span class="badge badge-review">UNDER REVIEW</span>
            <i class="bi bi-arrow-right text-muted"></i>
            <span class="badge badge-shortlist">SHORTLISTED</span>
            <i class="bi bi-arrow-right text-muted"></i>
            <span class="badge badge-interview">INTERVIEW</span>
            <i class="bi bi-arrow-right text-muted"></i>
            <span class="badge badge-selected">SELECTED</span>
            <span class="text-muted mx-2">|</span>
            <span class="badge badge-rejected">REJECTED</span>
        </div>
    </div>
</div>

<!-- Apply Form -->
<div class="card mb-4">
    <div class="card-header"><i class="bi bi-plus-circle-fill text-primary me-2"></i>Apply Student to Drive</div>
    <div class="card-body">
        <form method="post" action="applications" class="row g-3">
            <div class="col-md-5">
                <label class="form-label fw-semibold">Student</label>
                <select class="form-select" name="studentId" required>
                    <option value="">Select student&hellip;</option>
                    <c:forEach var="student" items="${students}">
                        <option value="${student.studentId}">
                            ${student.name} — ${student.branch} | CGPA: ${student.cgpa} | BL: ${student.backlogs}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-5">
                <label class="form-label fw-semibold">Placement Drive</label>
                <select class="form-select" name="driveId" required>
                    <option value="">Select drive&hellip;</option>
                    <c:forEach var="drive" items="${drives}">
                        <option value="${drive.driveId}">
                            ${drive.companyName} — ${drive.jobRole} (${drive.status} | CGPA &ge; ${drive.minCgpa})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button class="btn btn-primary w-100" type="submit"><i class="bi bi-send-fill me-1"></i>Apply</button>
            </div>
        </form>
        <p class="text-muted small mt-2 mb-0">
            <i class="bi bi-info-circle me-1"></i>Eligibility (CGPA, backlogs, branch, drive status, duplicates) is enforced automatically.
        </p>
    </div>
</div>

<!-- Applications Table -->
<div class="card">
    <div class="card-header">
        <i class="bi bi-table me-2"></i>All Applications
        <c:if test="${not empty applications}">
            <span class="badge bg-secondary ms-1">${applications.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty applications}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">#</th>
                                <th>Student</th>
                                <th>Company &amp; Role</th>
                                <th>Applied Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${applications}">
                                <tr>
                                    <td class="ps-4 text-muted small">${item.applicationId}</td>
                                    <td>
                                        <span class="fw-semibold">${item.studentName}</span><br>
                                        <span class="text-muted small">${item.studentBranch} &bull; CGPA ${item.studentCgpa} &bull; BL ${item.studentBacklogs}</span>
                                    </td>
                                    <td>
                                        <span class="fw-semibold">${item.companyName}</span><br>
                                        <span class="text-muted small">${item.jobRole}</span>
                                    </td>
                                    <td class="small text-muted">${item.appliedDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'APPLIED'}">      <span class="badge badge-applied">APPLIED</span></c:when>
                                            <c:when test="${item.status == 'UNDER_REVIEW'}"> <span class="badge badge-review">UNDER REVIEW</span></c:when>
                                            <c:when test="${item.status == 'SHORTLISTED'}">  <span class="badge badge-shortlist">SHORTLISTED</span></c:when>
                                            <c:when test="${item.status == 'INTERVIEW'}">    <span class="badge badge-interview">INTERVIEW</span></c:when>
                                            <c:when test="${item.status == 'SELECTED'}">     <span class="badge badge-selected">SELECTED</span></c:when>
                                            <c:when test="${item.status == 'REJECTED'}">     <span class="badge badge-rejected">REJECTED</span></c:when>
                                            <c:otherwise><span class="badge bg-light text-dark border">${item.status}</span></c:otherwise>
                                        </c:choose>
                                        <form method="post" action="applications" class="d-inline-flex gap-1 ms-1">
                                            <input type="hidden" name="action" value="status">
                                            <input type="hidden" name="applicationId" value="${item.applicationId}">
                                            <select class="form-select form-select-sm" name="status" style="width:auto;">
                                                <c:forEach var="s" items="${validStatuses}">
                                                    <option value="${s}" ${item.status == s ? 'selected' : ''}>${s}</option>
                                                </c:forEach>
                                            </select>
                                            <button class="btn btn-sm btn-outline-primary" type="submit"><i class="bi bi-check-lg"></i></button>
                                        </form>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-outline-danger"
                                           href="applications?action=delete&id=${item.applicationId}"
                                           onclick="return confirm('Delete application #${item.applicationId}?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <span class="empty-icon">&#128203;</span>
                    <h5>No Applications Yet</h5>
                    <p>Apply a student to an open placement drive using the form above.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
