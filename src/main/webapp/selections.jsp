<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-1">
            <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
            <li class="breadcrumb-item active">Outcomes</li>
            <li class="breadcrumb-item active">Selections</li>
        </ol>
    </nav>
    <h1><i class="bi bi-trophy-fill me-2 text-warning"></i>Final Selections</h1>
    <p>Students who cleared all interviews and received placement offers.</p>
</div>

<%-- ===== Add selection form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">Mark Student as Selected</div>
    <div class="card-body">
        <p class="text-muted small mb-3">
            &#9432; Only applications with at least one <span class="badge bg-success">PASS</span> interview result appear here.
        </p>

        <c:choose>
            <c:when test="${empty eligibleApplications}">
                <div class="alert alert-info py-2 mb-0">
                    No eligible applications currently. Students must pass at least one interview round before appearing here.
                </div>
            </c:when>
            <c:otherwise>
                <form method="post" action="selections" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Eligible Application <span class="text-danger">*</span></label>
                        <select class="form-select" name="applicationId" required>
                            <option value="">Select student &amp; drive&hellip;</option>
                            <c:forEach var="application" items="${eligibleApplications}">
                                <option value="${application.applicationId}">
                                    ${application.studentName} &rarr; ${application.companyName} (${application.jobRole})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Package (LPA) <span class="text-danger">*</span></label>
                        <input class="form-control" type="number" step="0.01" min="0.01"
                               name="packageLpa" placeholder="e.g. 8.5" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Initial Offer Status</label>
                        <select class="form-select" name="offerStatus">
                            <option value="OFFERED">OFFERED</option>
                            <option value="ACCEPTED">ACCEPTED</option>
                            <option value="DECLINED">DECLINED</option>
                        </select>
                    </div>

                    <div class="col-12">
                        <button class="btn btn-success" type="submit">&#127942; Finalise Selection</button>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- ===== Selections table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        Selected Students
        <c:if test="${not empty selections}">
            <span class="badge bg-success ms-1">${selections.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Student</th>
                    <th>Branch</th>
                    <th>Company &amp; Role</th>
                    <th>Package (LPA)</th>
                    <th>Offer Status</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${selections}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.selectionId}</td>
                        <td class="fw-semibold">${item.studentName}</td>
                        <td class="text-muted small">${item.studentBranch}</td>
                        <td>
                            <span class="fw-semibold">${item.companyName}</span><br>
                            <span class="text-muted small">${item.jobRole}</span>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border fs-6">&#8377; ${item.packageLpa} LPA</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${item.offerStatus == 'ACCEPTED'}">
                                    <span class="badge bg-success">&#10003; ACCEPTED</span>
                                </c:when>
                                <c:when test="${item.offerStatus == 'DECLINED'}">
                                    <span class="badge bg-danger">&#10007; DECLINED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-primary">&#128195; OFFERED</span>
                                </c:otherwise>
                            </c:choose>
                            &nbsp;
                            <form method="post" action="selections" class="d-inline-flex gap-1">
                                <input type="hidden" name="action" value="status">
                                <input type="hidden" name="selectionId" value="${item.selectionId}">
                                <select class="form-select form-select-sm" name="offerStatus" style="width:auto;">
                                    <option value="OFFERED"  ${item.offerStatus == 'OFFERED'  ? 'selected' : ''}>OFFERED</option>
                                    <option value="ACCEPTED" ${item.offerStatus == 'ACCEPTED' ? 'selected' : ''}>ACCEPTED</option>
                                    <option value="DECLINED" ${item.offerStatus == 'DECLINED' ? 'selected' : ''}>DECLINED</option>
                                </select>
                                <button class="btn btn-sm btn-outline-secondary" type="submit">&#10003;</button>
                            </form>
                        </td>
                        <td>
                            <a class="btn btn-sm btn-outline-danger"
                               href="selections?action=delete&id=${item.selectionId}"
                               onclick="return confirm('Remove selection for ${item.studentName}?');">Remove</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty selections}">
                    <tr><td colspan="7"><div class="empty-state"><span class="empty-icon">&#127942;</span><h5>No Selections Yet</h5><p>Complete the interview stage first, then finalise selections here.</p></div></td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
