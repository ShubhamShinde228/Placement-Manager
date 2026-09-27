<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header d-flex justify-content-between align-items-start flex-wrap gap-2">
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active">Analytics</li>
            </ol>
        </nav>
        <h1><i class="bi bi-bar-chart-fill me-2 text-primary"></i>Placement Analytics</h1>
        <p>Key metrics and statistics derived from your live placement data.</p>
    </div>
    <button class="btn btn-sm btn-outline-secondary" onclick="window.print()">
        <i class="bi bi-printer me-1"></i> Print Report
    </button>
</div>

<!-- Key Metrics -->
<div class="row g-3 mb-4">
    <div class="col-md-6">
        <div class="card h-100 kpi-card" style="border-left-color:#22c55e;">
            <div class="card-body">
                <div class="kpi-label text-success mb-1">Highest Package</div>
                <div class="kpi-value">${highestPackage} <small class="fs-6 fw-normal text-muted">LPA</small></div>
                <div class="small text-muted mt-1"><i class="bi bi-graph-up-arrow text-success"></i> Best offer received</div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card h-100 kpi-card" style="border-left-color:#3554a5;">
            <div class="card-body">
                <div class="kpi-label text-primary mb-1">Average Package</div>
                <div class="kpi-value">${String.format("%.2f", averagePackage)} <small class="fs-6 fw-normal text-muted">LPA</small></div>
                <div class="small text-muted mt-1"><i class="bi bi-graph-up text-primary"></i> Mean CTC across all selections</div>
            </div>
        </div>
    </div>
</div>

<!-- Branch-wise Placements -->
<div class="card mb-4">
    <div class="card-header"><i class="bi bi-pie-chart-fill me-2 text-primary"></i>Placements by Branch</div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty branchData}">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Branch</th>
                            <th>Total Selections</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${branchData}">
                            <tr>
                                <td class="ps-4 fw-semibold">${entry.key}</td>
                                <td><span class="badge bg-primary rounded-pill">${entry.value}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <span class="empty-icon">&#128202;</span>
                    <h5>No Placement Data Yet</h5>
                    <p>Analytics will populate once students are selected through the placement process.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Coming Soon -->
<div class="card border-dashed" style="border: 2px dashed #e2e8f0;">
    <div class="card-body text-center py-5">
        <i class="bi bi-graph-up-arrow fs-1 text-muted d-block mb-3" style="opacity:.3;"></i>
        <h5 class="text-muted">Drive Analytics & Student Performance</h5>
        <p class="text-muted small">Advanced charts, drive-specific reports, and student performance tracking are coming in the next phase.</p>
        <span class="badge bg-light text-muted border">Phase 2</span>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
