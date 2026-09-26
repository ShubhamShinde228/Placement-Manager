<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Placement Analytics</h2>
    <button class="btn btn-sm btn-primary" onclick="window.print()"><i class="bi bi-printer"></i> Print Report</button>
</div>

<div class="row mb-4">
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100 border-start border-4 border-success">
            <div class="card-body">
                <h6 class="text-muted text-uppercase fw-bold mb-1">Highest Package</h6>
                <h3 class="fw-bold text-dark mb-0">${highestPackage} LPA</h3>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card border-0 shadow-sm h-100 border-start border-4 border-info">
            <div class="card-body">
                <h6 class="text-muted text-uppercase fw-bold mb-1">Average Package</h6>
                <h3 class="fw-bold text-dark mb-0">${String.format("%.2f", averagePackage)} LPA</h3>
            </div>
        </div>
    </div>
</div>

<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">
        Placements by Branch
    </div>
    <div class="card-body p-0">
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
                        <td class="ps-4 fw-bold">${entry.key}</td>
                        <td><span class="badge bg-primary rounded-pill">${entry.value}</span></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty branchData}">
                    <tr><td colspan="2" class="text-center py-4 text-muted">No placement data available yet.</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
