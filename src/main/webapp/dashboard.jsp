<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header d-flex justify-content-between align-items-start flex-wrap gap-2">
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item active">Dashboard</li>
            </ol>
        </nav>
        <h1><i class="bi bi-speedometer2 me-2 text-primary"></i>${greeting}, <%= currentUser != null ? currentUser.getUsername() : "Placement Officer" %>!</h1>
        <p>Here is your real-time placement activity overview.</p>
    </div>
    <a href="drives" class="btn btn-primary btn-sm">
        <i class="bi bi-plus-lg me-1"></i> Create Drive
    </a>
</div>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#3554a5;">
            <div class="card-body">
                <div class="kpi-label text-primary mb-1">Students</div>
                <div class="kpi-value">${totalStudents}</div>
                <div class="small text-muted mt-1"><i class="bi bi-people-fill"></i> Registered</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#0ea5e9;">
            <div class="card-body">
                <div class="kpi-label" style="color:#0ea5e9;">Companies</div>
                <div class="kpi-value">${totalCompanies}</div>
                <div class="small text-muted mt-1"><i class="bi bi-building-fill"></i> Recruiting</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#22c55e;">
            <div class="card-body">
                <div class="kpi-label text-success mb-1">Active Drives</div>
                <div class="kpi-value">${activeDrives}</div>
                <div class="small text-muted mt-1"><i class="bi bi-briefcase-fill"></i> Open now</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#f59e0b;">
            <div class="card-body">
                <div class="kpi-label text-warning mb-1">Applications</div>
                <div class="kpi-value">${totalApplications}</div>
                <div class="small text-muted mt-1"><i class="bi bi-file-text-fill"></i> Submitted</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#a855f7;">
            <div class="card-body">
                <div class="kpi-label" style="color:#a855f7;">Interviews</div>
                <div class="kpi-value">${totalInterviews}</div>
                <div class="small text-muted mt-1"><i class="bi bi-mic-fill"></i> Conducted</div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-2">
        <div class="card kpi-card h-100" style="border-left-color:#ef4444;">
            <div class="card-body">
                <div class="kpi-label text-danger mb-1">Selections</div>
                <div class="kpi-value">${totalSelections}</div>
                <div class="small text-muted mt-1"><i class="bi bi-trophy-fill"></i> Placed</div>
            </div>
        </div>
    </div>
</div>

<!-- Placement Pipeline -->
<div class="card mb-4">
    <div class="card-header d-flex align-items-center justify-content-between">
        <span><i class="bi bi-diagram-3-fill me-2 text-primary"></i>Placement Lifecycle Pipeline</span>
        <small class="text-muted fw-normal">End-to-end recruitment flow</small>
    </div>
    <div class="card-body py-3">
        <div class="pipeline-steps">
            <div class="pipeline-step ${totalApplications > 0 ? 'done' : 'future'}">
                <div class="step-circle"><i class="bi bi-file-earmark-plus"></i></div>
                <div class="step-label">Applied</div>
                <div class="small text-primary fw-bold">${totalApplications}</div>
            </div>
            <div class="pipeline-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="pipeline-step future">
                <div class="step-circle"><i class="bi bi-clipboard2-check"></i></div>
                <div class="step-label">Assessment</div>
                <div class="small text-muted">Phase 2</div>
            </div>
            <div class="pipeline-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="pipeline-step future">
                <div class="step-circle"><i class="bi bi-funnel"></i></div>
                <div class="step-label">Shortlisted</div>
                <div class="small text-muted">Phase 2</div>
            </div>
            <div class="pipeline-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="pipeline-step ${totalInterviews > 0 ? 'done' : 'future'}">
                <div class="step-circle"><i class="bi bi-mic"></i></div>
                <div class="step-label">Interview</div>
                <div class="small ${totalInterviews > 0 ? 'text-primary' : 'text-muted'} fw-bold">${totalInterviews > 0 ? totalInterviews : '—'}</div>
            </div>
            <div class="pipeline-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="pipeline-step ${totalSelections > 0 ? 'done' : 'future'}">
                <div class="step-circle"><i class="bi bi-trophy"></i></div>
                <div class="step-label">Selected</div>
                <div class="small ${totalSelections > 0 ? 'text-primary' : 'text-muted'} fw-bold">${totalSelections > 0 ? totalSelections : '—'}</div>
            </div>
            <div class="pipeline-arrow"><i class="bi bi-chevron-right"></i></div>
            <div class="pipeline-step future">
                <div class="step-circle"><i class="bi bi-envelope-paper"></i></div>
                <div class="step-label">Offer</div>
                <div class="small text-muted">Phase 2</div>
            </div>
        </div>
    </div>
</div>

<!-- Active Drives Table -->
<div class="card">
    <div class="card-header d-flex align-items-center justify-content-between">
        <span><i class="bi bi-briefcase-fill me-2 text-success"></i>Active Placement Drives</span>
        <a href="drives" class="btn btn-sm btn-outline-primary">View All</a>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty openDrives}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Company</th>
                                <th>Role</th>
                                <th>Drive Date</th>
                                <th>Min CGPA</th>
                                <th>Branches</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${openDrives}">
                                <tr>
                                    <td class="ps-4 fw-semibold">${d.companyName}</td>
                                    <td>${d.jobRole}</td>
                                    <td class="small text-muted">${d.driveDate != null ? d.driveDate : '—'}</td>
                                    <td><span class="badge bg-light text-dark border">&ge; ${d.minCgpa}</span></td>
                                    <td class="small">${d.eligibleBranches}</td>
                                    <td><span class="badge badge-open">&#9679; OPEN</span></td>
                                    <td>
                                        <a href="applications" class="btn btn-xs btn-outline-primary btn-sm">View Applications</a>
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
                    <h5>No Active Drives</h5>
                    <p>There are currently no open placement drives.<br>Create a drive and set its status to OPEN to begin accepting applications.</p>
                    <a href="drives" class="btn btn-primary btn-sm">Create Placement Drive</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>