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
                <li class="breadcrumb-item active">Companies</li>
            </ol>
        </nav>
        <h1><i class="bi bi-building-fill me-2 text-primary"></i>Companies</h1>
        <p>Manage recruiting companies and their HR contact information.</p>
    </div>
</div>

<!-- Add / Edit Form -->
<div class="card mb-4">
    <div class="card-header d-flex align-items-center gap-2">
        <c:choose>
            <c:when test="${not empty company}">
                <i class="bi bi-pencil-square text-warning"></i> Edit Company — <strong>${company.name}</strong>
            </c:when>
            <c:otherwise>
                <i class="bi bi-plus-circle-fill text-primary"></i> Add New Company
            </c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="companies" class="row g-3">
            <c:if test="${not empty company}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="companyId" value="${company.companyId}">
            </c:if>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Company Name <span class="text-danger">*</span></label>
                <input class="form-control" name="name" required placeholder="e.g. TechNova Solutions" value="${company.name}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Sector / Industry</label>
                <input class="form-control" name="sector" placeholder="e.g. IT, Finance, Core" value="${company.sector}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">HR Contact Name</label>
                <input class="form-control" name="hrName" placeholder="e.g. Priya Sharma" value="${company.hrName}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">HR Email</label>
                <input class="form-control" type="email" name="hrEmail" placeholder="hr@company.com" value="${company.hrEmail}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">HR Phone</label>
                <input class="form-control" name="hrPhone" placeholder="10-digit number" value="${company.hrPhone}">
            </div>
            <div class="col-12">
                <button class="btn btn-primary" type="submit">
                    <i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${not empty company}">Update Company</c:when>
                        <c:otherwise>Add Company</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${not empty company}">
                    <a class="btn btn-outline-secondary ms-2" href="companies">Cancel</a>
                </c:if>
            </div>
        </form>
    </div>
</div>

<!-- Companies List -->
<div class="card">
    <div class="card-header">
        <i class="bi bi-table me-2"></i>Registered Companies
        <c:if test="${not empty companies}">
            <span class="badge bg-secondary ms-1">${companies.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty companies}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">#</th>
                                <th>Company Name</th>
                                <th>Sector</th>
                                <th>HR Name</th>
                                <th>HR Email</th>
                                <th>HR Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${companies}">
                                <tr>
                                    <td class="ps-4 text-muted small">${item.companyId}</td>
                                    <td class="fw-semibold">${item.name}</td>
                                    <td>
                                        <c:if test="${not empty item.sector}">
                                            <span class="badge bg-light text-dark border">${item.sector}</span>
                                        </c:if>
                                    </td>
                                    <td>${item.hrName}</td>
                                    <td class="small text-muted">${item.hrEmail}</td>
                                    <td class="small">${item.hrPhone}</td>
                                    <td class="text-nowrap">
                                        <a class="btn btn-sm btn-outline-primary" href="companies?action=edit&id=${item.companyId}">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a class="btn btn-sm btn-outline-danger ms-1"
                                           href="companies?action=delete&id=${item.companyId}"
                                           onclick="return confirm('Delete ${item.name}? This will also remove all their placement drives.');">
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
                    <span class="empty-icon">&#127963;</span>
                    <h5>No Companies Added Yet</h5>
                    <p>Add your first recruiting company to create placement drives.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
