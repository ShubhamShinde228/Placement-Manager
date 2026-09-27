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
                <li class="breadcrumb-item active">Students</li>
            </ol>
        </nav>
        <h1><i class="bi bi-people-fill me-2 text-primary"></i>Students</h1>
        <p>Register and manage placement-eligible student records.</p>
    </div>
</div>

<!-- Add / Edit Form -->
<div class="card mb-4">
    <div class="card-header d-flex align-items-center gap-2">
        <c:choose>
            <c:when test="${not empty student}">
                <i class="bi bi-pencil-square text-warning"></i> Edit Student — <strong>${student.name}</strong>
            </c:when>
            <c:otherwise>
                <i class="bi bi-plus-circle-fill text-primary"></i> Add New Student
            </c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="students" class="row g-3">
            <c:if test="${not empty student}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="studentId" value="${student.studentId}">
            </c:if>

            <div class="col-md-4">
                <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                <input class="form-control" name="name" required placeholder="e.g. Rahul Patil" value="${student.name}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                <input class="form-control" type="email" name="email" required placeholder="student@college.edu" value="${student.email}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Phone</label>
                <input class="form-control" name="phone" placeholder="10-digit mobile" value="${student.phone}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Branch <span class="text-danger">*</span></label>
                <input class="form-control" name="branch" placeholder="e.g. MCA, CSE, ECE" value="${student.branch}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">CGPA <span class="text-danger">*</span></label>
                <input class="form-control" type="number" step="0.01" min="0" max="10" name="cgpa"
                       value="${empty student ? '0.00' : student.cgpa}" required>
                <div class="form-text">0.00 – 10.00</div>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Active Backlogs <span class="text-danger">*</span></label>
                <input class="form-control" type="number" min="0" name="backlogs"
                       value="${empty student ? 0 : student.backlogs}" required>
                <div class="form-text">Enter 0 if none.</div>
            </div>
            <div class="col-12">
                <button class="btn btn-primary" type="submit">
                    <i class="bi bi-check-lg me-1"></i>
                    <c:choose>
                        <c:when test="${not empty student}">Update Student</c:when>
                        <c:otherwise>Add Student</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${not empty student}">
                    <a class="btn btn-outline-secondary ms-2" href="students">Cancel</a>
                </c:if>
            </div>
        </form>
    </div>
</div>

<!-- Students List -->
<div class="card">
    <div class="card-header d-flex align-items-center justify-content-between">
        <span><i class="bi bi-table me-2"></i>Registered Students
            <c:if test="${not empty students}">
                <span class="badge bg-secondary ms-1">${students.size()}</span>
            </c:if>
        </span>
    </div>
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty students}">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4">#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Branch</th>
                                <th>CGPA</th>
                                <th>Backlogs</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${students}">
                                <tr>
                                    <td class="ps-4 text-muted small">${item.studentId}</td>
                                    <td class="fw-semibold">${item.name}</td>
                                    <td class="small text-muted">${item.email}</td>
                                    <td class="small">${item.phone}</td>
                                    <td><span class="badge bg-light text-dark border">${item.branch}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.cgpa >= 8.0}"><span class="badge bg-success">${item.cgpa}</span></c:when>
                                            <c:when test="${item.cgpa >= 6.0}"><span class="badge bg-warning text-dark">${item.cgpa}</span></c:when>
                                            <c:otherwise><span class="badge bg-danger">${item.cgpa}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.backlogs == 0}"><span class="badge bg-success">0</span></c:when>
                                            <c:otherwise><span class="badge bg-danger">${item.backlogs}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-nowrap">
                                        <a class="btn btn-sm btn-outline-primary" href="students?action=edit&id=${item.studentId}">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <a class="btn btn-sm btn-outline-danger ms-1"
                                           href="students?action=delete&id=${item.studentId}"
                                           onclick="return confirm('Delete ${item.name}? Their applications will also be removed.');">
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
                    <span class="empty-icon">&#128100;</span>
                    <h5>No Students Registered</h5>
                    <p>Add your first student to begin the placement process.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
