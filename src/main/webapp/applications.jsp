<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Applications</h2>
    <span class="text-muted small">Placement pipeline &mdash; manage student applications</span>
</div>

<%-- ===== Pipeline progress indicator ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-body py-2">
        <div class="d-flex flex-wrap gap-1 align-items-center small fw-semibold">
            <span class="badge bg-secondary">APPLIED</span>
            <span class="text-muted">&rarr;</span>
            <span class="badge bg-info text-dark">UNDER REVIEW</span>
            <span class="text-muted">&rarr;</span>
            <span class="badge bg-primary">SHORTLISTED</span>
            <span class="text-muted">&rarr;</span>
            <span class="badge bg-warning text-dark">INTERVIEW</span>
            <span class="text-muted">&rarr;</span>
            <span class="badge bg-success">SELECTED</span>
            <span class="ms-2 text-muted">|</span>
            <span class="badge bg-danger ms-1">REJECTED</span>
        </div>
    </div>
</div>

<%-- ===== Apply form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">Apply Student to Drive</div>
    <div class="card-body">
        <form method="post" action="applications" class="row g-3">
            <div class="col-md-5">
                <label class="form-label">Student</label>
                <select class="form-select" name="studentId" required>
                    <option value="">Select student&hellip;</option>
                    <c:forEach var="student" items="${students}">
                        <option value="${student.studentId}">
                            ${student.name} &mdash; ${student.branch} | CGPA: ${student.cgpa} | Backlogs: ${student.backlogs}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-5">
                <label class="form-label">Placement Drive</label>
                <select class="form-select" name="driveId" required>
                    <option value="">Select drive&hellip;</option>
                    <c:forEach var="drive" items="${drives}">
                        <option value="${drive.driveId}">
                            ${drive.companyName} &mdash; ${drive.jobRole}
                            (${drive.status} | Min CGPA: ${drive.minCgpa})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button class="btn btn-primary w-100" type="submit">Apply</button>
            </div>
        </form>
        <p class="text-muted small mt-2 mb-0">
            &#9432; Eligibility (CGPA, backlogs, branch, drive status, duplicates) is enforced automatically.
        </p>
    </div>
</div>

<%-- ===== Applications table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        All Applications
        <c:if test="${not empty applications}">
            <span class="badge bg-secondary ms-1">${applications.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Student</th>
                    <th>Company &amp; Role</th>
                    <th>Applied</th>
                    <th>Pipeline Status</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${applications}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.applicationId}</td>
                        <td>
                            <span class="fw-semibold">${item.studentName}</span><br>
                            <span class="text-muted small">
                                ${item.studentBranch} &bull; CGPA ${item.studentCgpa} &bull; BL ${item.studentBacklogs}
                            </span>
                        </td>
                        <td>
                            <span class="fw-semibold">${item.companyName}</span><br>
                            <span class="text-muted small">${item.jobRole}</span>
                        </td>
                        <td class="small text-muted">${item.appliedDate}</td>
                        <td>
                            <%-- Status badge --%>
                            <c:choose>
                                <c:when test="${item.status == 'APPLIED'}">
                                    <span class="badge bg-secondary">APPLIED</span>
                                </c:when>
                                <c:when test="${item.status == 'UNDER_REVIEW'}">
                                    <span class="badge bg-info text-dark">UNDER REVIEW</span>
                                </c:when>
                                <c:when test="${item.status == 'SHORTLISTED'}">
                                    <span class="badge bg-primary">SHORTLISTED</span>
                                </c:when>
                                <c:when test="${item.status == 'INTERVIEW'}">
                                    <span class="badge bg-warning text-dark">INTERVIEW</span>
                                </c:when>
                                <c:when test="${item.status == 'SELECTED'}">
                                    <span class="badge bg-success">SELECTED</span>
                                </c:when>
                                <c:when test="${item.status == 'REJECTED'}">
                                    <span class="badge bg-danger">REJECTED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-light text-dark">${item.status}</span>
                                </c:otherwise>
                            </c:choose>
                            <%-- Inline status update form --%>
                            <form method="post" action="applications" class="d-inline-flex gap-1 ms-1">
                                <input type="hidden" name="action" value="status">
                                <input type="hidden" name="applicationId" value="${item.applicationId}">
                                <select class="form-select form-select-sm" name="status" style="width:auto;">
                                    <c:forEach var="s" items="${validStatuses}">
                                        <option value="${s}" ${item.status == s ? 'selected' : ''}>${s}</option>
                                    </c:forEach>
                                </select>
                                <button class="btn btn-sm btn-outline-primary" type="submit">&#10003;</button>
                            </form>
                        </td>
                        <td>
                            <a class="btn btn-sm btn-outline-danger"
                               href="applications?action=delete&id=${item.applicationId}"
                               onclick="return confirm('Delete application #${item.applicationId} for ${item.studentName}? This cannot be undone.');">
                                Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty applications}">
                    <tr>
                        <td colspan="6" class="text-center text-muted py-4">
                            &#128203; No applications yet. Apply a student to a drive above.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
