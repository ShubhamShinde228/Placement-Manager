<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Placement Drives</h2>
    <span class="text-muted small">Define eligibility criteria &amp; drive status</span>
</div>

<%-- ===== Create / Edit form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">
        <c:choose>
            <c:when test="${not empty drive}">Edit Drive</c:when>
            <c:otherwise>Create Placement Drive</c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="drives" class="row g-3">
            <c:if test="${not empty drive}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="driveId" value="${drive.driveId}">
            </c:if>

            <div class="col-md-4">
                <label class="form-label">Company <span class="text-danger">*</span></label>
                <select class="form-select" name="companyId" required>
                    <option value="">Select company&hellip;</option>
                    <c:forEach var="company" items="${companies}">
                        <option value="${company.companyId}"
                            ${drive.companyId == company.companyId ? 'selected' : ''}>
                            ${company.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-4">
                <label class="form-label">Job Role <span class="text-danger">*</span></label>
                <input class="form-control" name="jobRole" required
                       placeholder="e.g. Java Developer"
                       value="${drive.jobRole}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Drive Date</label>
                <input class="form-control" type="date" name="driveDate" value="${drive.driveDate}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Venue / Mode</label>
                <input class="form-control" name="venue"
                       placeholder="e.g. Campus / Online"
                       value="${drive.venue}">
            </div>

            <div class="col-md-2">
                <label class="form-label">Min CGPA <span class="text-danger">*</span></label>
                <input class="form-control" type="number" step="0.01" min="0" max="10"
                       name="minCgpa" value="${empty drive ? '0.00' : drive.minCgpa}" required>
            </div>

            <div class="col-md-2">
                <label class="form-label">Max Backlogs <span class="text-danger">*</span></label>
                <input class="form-control" type="number" min="0"
                       name="maxBacklogs" value="${empty drive ? 99 : drive.maxBacklogs}" required>
            </div>

            <div class="col-md-4">
                <label class="form-label">Eligible Branches</label>
                <input class="form-control" name="eligibleBranches"
                       placeholder="ALL  or  CSE, MCA, ECE"
                       value="${drive.eligibleBranches}">
                <div class="form-text">Use ALL for all branches, or comma-separated list.</div>
            </div>

            <div class="col-md-4">
                <label class="form-label">Status <span class="text-danger">*</span></label>
                <select class="form-select" name="status" required>
                    <option value="UPCOMING" ${drive.status == 'UPCOMING' ? 'selected' : ''}>UPCOMING</option>
                    <option value="OPEN"     ${drive.status == 'OPEN'     ? 'selected' : ''}>OPEN (accepting applications)</option>
                    <option value="CLOSED"   ${drive.status == 'CLOSED'   ? 'selected' : ''}>CLOSED</option>
                </select>
                <div class="form-text">Only <strong>OPEN</strong> drives accept new applications.</div>
            </div>

            <div class="col-12">
                <button class="btn btn-primary" type="submit">
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

<%-- ===== Drives table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        All Drives
        <c:if test="${not empty drives}">
            <span class="badge bg-secondary ms-1">${drives.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Company</th>
                    <th>Role</th>
                    <th>Date</th>
                    <th>Venue</th>
                    <th>Min CGPA</th>
                    <th>Max BL</th>
                    <th>Branches</th>
                    <th>Status</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${drives}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.driveId}</td>
                        <td class="fw-semibold">${item.companyName}</td>
                        <td>${item.jobRole}</td>
                        <td class="small text-muted">${item.driveDate}</td>
                        <td class="small">${item.venue}</td>
                        <td><span class="badge bg-light text-dark border">&ge; ${item.minCgpa}</span></td>
                        <td><span class="badge bg-light text-dark border">&le; ${item.maxBacklogs}</span></td>
                        <td class="small">${item.eligibleBranches}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == 'OPEN'}">
                                    <span class="badge bg-success">&#9679; OPEN</span>
                                </c:when>
                                <c:when test="${item.status == 'CLOSED'}">
                                    <span class="badge bg-danger">&#9679; CLOSED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark">&#9679; UPCOMING</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-nowrap">
                            <a class="btn btn-sm btn-outline-primary"
                               href="drives?action=edit&id=${item.driveId}">Edit</a>
                            <a class="btn btn-sm btn-outline-danger ms-1"
                               href="drives?action=delete&id=${item.driveId}"
                               onclick="return confirm('Delete drive for ${item.jobRole} at ${item.companyName}? All related applications will also be removed.');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty drives}">
                    <tr>
                        <td colspan="10" class="text-center text-muted py-4">
                            &#128203; No drives yet. Add a company first, then create a drive.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
