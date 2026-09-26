<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Company Management</h2>
    <span class="text-muted small">Manage recruiting companies and HR contacts</span>
</div>

<%-- ===== Add / Edit form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">
        <c:choose>
            <c:when test="${not empty company}">&#9998; Edit Company — ${company.name}</c:when>
            <c:otherwise>&#43; Add New Company</c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="companies" class="row g-3">
            <c:if test="${not empty company}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="companyId" value="${company.companyId}">
            </c:if>

            <div class="col-md-4">
                <label class="form-label">Company Name <span class="text-danger">*</span></label>
                <input class="form-control" name="name" required
                       placeholder="e.g. TechNova Solutions"
                       value="${company.name}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Sector / Industry</label>
                <input class="form-control" name="sector"
                       placeholder="e.g. IT, Finance, Core"
                       value="${company.sector}">
            </div>

            <div class="col-md-4">
                <label class="form-label">HR Contact Name</label>
                <input class="form-control" name="hrName"
                       placeholder="e.g. Priya Sharma"
                       value="${company.hrName}">
            </div>

            <div class="col-md-4">
                <label class="form-label">HR Email</label>
                <input class="form-control" type="email" name="hrEmail"
                       placeholder="hr@company.com"
                       value="${company.hrEmail}">
            </div>

            <div class="col-md-4">
                <label class="form-label">HR Phone</label>
                <input class="form-control" name="hrPhone"
                       placeholder="10-digit number"
                       value="${company.hrPhone}">
            </div>

            <div class="col-12">
                <button class="btn btn-primary" type="submit">
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

<%-- ===== Companies table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        Registered Companies
        <c:if test="${not empty companies}">
            <span class="badge bg-secondary ms-1">${companies.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Company Name</th>
                    <th>Sector</th>
                    <th>HR Name</th>
                    <th>HR Email</th>
                    <th>HR Phone</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${companies}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.companyId}</td>
                        <td class="fw-semibold">${item.name}</td>
                        <td>
                            <c:if test="${not empty item.sector}">
                                <span class="badge bg-light text-dark border">${item.sector}</span>
                            </c:if>
                        </td>
                        <td>${item.hrName}</td>
                        <td class="small">${item.hrEmail}</td>
                        <td class="small">${item.hrPhone}</td>
                        <td class="text-nowrap">
                            <a class="btn btn-sm btn-outline-primary"
                               href="companies?action=edit&id=${item.companyId}">Edit</a>
                            <a class="btn btn-sm btn-outline-danger ms-1"
                               href="companies?action=delete&id=${item.companyId}"
                               onclick="return confirm('Delete ${item.name}? This will also remove all their placement drives.');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty companies}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">
                            &#127963; No companies added yet. Add the first company above.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
