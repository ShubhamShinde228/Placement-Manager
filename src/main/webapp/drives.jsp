<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header d-flex justify-content-between align-items-start flex-wrap gap-2">
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active">Placement Management</li>
                <li class="breadcrumb-item active">Placement Drives</li>
            </ol>
        </nav>
        <h1><i class="bi bi-briefcase-fill me-2 text-primary"></i>Placement Drives</h1>
        <p>Create and manage company recruitment drives. Set eligibility criteria and drive status.</p>
    </div>
</div>

<!-- Create / Edit Form -->
<div class="card mb-4">
    <div class="card-header d-flex align-items-center gap-2">
        <c:choose>
            <c:when test="${not empty drive}">
                <i class="bi bi-pencil-square text-warning"></i> Edit Drive — <strong>${drive.jobRole}</strong>
            </c:when>
            <c:otherwise>
                <i class="bi bi-plus-circle-fill text-primary"></i> Create Placement Drive
            </c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="drives" class="row g-3">
            <c:if test="${not empty drive}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="driveId" value="${drive.driveId}">
            </c:if>

            <div class="col-md-4">
                <label class="form-label fw-semibold">Company <span class="text-danger">*</span></label>
                <select class="form-select" name="companyId" required>
                    <option value="">Select company&hellip;</option>
                    <c:forEach var="company" items="${companies}">
                        <option value="${company.companyId}" ${drive.companyId == company.companyId ? 'selected' : ''}>${company.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Job Role <span class="text-danger">*</span></label>
                <input class="form-control" name="jobRole" required placeholder="e.g. Java Developer" value="${drive.jobRole}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Drive Date</label>
                <input class="form-control" type="date" name="driveDate" value="${drive.driveDate}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Venue / Mode</label>
                <input class="form-control" name="venue" placeholder="e.g. Campus / Online" value="${drive.venue}">
            </div>
            <div class="col-md-2">
                <label class="form-label fw-semibold">Min CGPA <span class="text-danger">*</span></label>
                <input class="form-control" type="number" step="0.01" min="0" max="10" name="minCgpa"
                       value="${empty drive ? '0.00' : drive.minCgpa}" required>
            </div>
            <div class="col-md-2">
                <label class="form-label fw-semibold">Max Backlogs <span class="text-danger">*</span></label>
                <input class="form-control" type="number" min="0" name="maxBacklogs"
                       value="${empty drive ? 99 : drive.maxBacklogs}" required>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Eligible Branches</label>
                <input class="form-control" name="eligibleBranches" placeholder="ALL  or  CSE, MCA, ECE" value="${drive.eligibleBranches}">
                <div class="form-text">Use <code>ALL</code> for all branches, or comma-separated.</div>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Drive Status <span class="text-danger">*</span></label>
                <select class="form-select" name="status" required>
                    <option value="UPCOMING" ${drive.status == 'UPCOMING' ? 'selected' : ''}>UPCOMING</option>
                    <option value="OPEN"     ${drive.status == 'OPEN'     ? 'selected' : ''}>OPEN — accepting applications</option>
                    <option value="CLOSED"   ${drive.status == 'CLOSED'   ? 'selected' : ''}>CLOSED</option>
                </select>
                <div class="form-text">Only <strong>OPEN</strong> drives accept new applications.</div>
            </div>
            <div class="col-12">
                <button class="btn btn-primary" type="submit">
                    <i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${not empty drive}">Update Drive</c:when>
                        <c:otherwise>Create Drive</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${not empty drive}">
                    <a class="btn btn-outline-secondary ms-2" href="drives">Cancel</a>
                </c:if>
            </div>
        </form>
    </div>
</div>

<!-- All Drives Table -->
<div class="card">
    <div class="card-header">
        <i class="bi bi-table me-2"></i>All Placement Drives
        <c:if test="${not empty drives}">
            <span class="badge bg-secondary ms-1">${drives.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty drives}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">Company</th>
                                <th>Role</th>
                                <th>Date</th>
                                <th>Venue</th>
                                <th>Min CGPA</th>
                                <th>Max BL</th>
                                <th>Branches</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${drives}">
                                <tr>
                                    <td class="ps-4 fw-semibold">${item.companyName}</td>
                                    <td>${item.jobRole}</td>
                                    <td class="small text-muted">${item.driveDate}</td>
                                    <td class="small">${item.venue}</td>
                                    <td><span class="badge bg-light text-dark border">&ge; ${item.minCgpa}</span></td>
                                    <td><span class="badge bg-light text-dark border">&le; ${item.maxBacklogs}</span></td>
                                    <td class="small">${item.eligibleBranches}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'OPEN'}"><span class="badge badge-open">&#9679; OPEN</span></c:when>
                                            <c:when test="${item.status == 'CLOSED'}"><span class="badge bg-danger">&#9679; CLOSED</span></c:when>
                                            <c:otherwise><span class="badge badge-upcoming">&#9679; UPCOMING</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-nowrap">
                                        <a class="btn btn-sm btn-outline-primary" href="drives?action=edit&id=${item.driveId}">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a class="btn btn-sm btn-outline-danger ms-1"
                                           href="drives?action=delete&id=${item.driveId}"
                                           onclick="return confirm('Delete drive for ${item.jobRole} at ${item.companyName}?');">
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
                    <h5>No Placement Drives Created</h5>
                    <p>Add a company first, then create a placement drive to begin the recruitment process.</p>
                    <a href="companies" class="btn btn-outline-primary btn-sm me-2">Add Company First</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
