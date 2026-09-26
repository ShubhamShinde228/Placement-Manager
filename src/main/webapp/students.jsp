<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Student Management</h2>
    <span class="text-muted small">Add, edit and manage placement-eligible students</span>
</div>

<%-- ===== Add / Edit form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">
        <c:choose>
            <c:when test="${not empty student}">&#9998; Edit Student — ${student.name}</c:when>
            <c:otherwise>&#43; Add New Student</c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="students" class="row g-3">
            <c:if test="${not empty student}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="studentId" value="${student.studentId}">
            </c:if>

            <div class="col-md-4">
                <label class="form-label">Full Name <span class="text-danger">*</span></label>
                <input class="form-control" name="name" required
                       placeholder="e.g. Rahul Patil"
                       value="${student.name}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input class="form-control" type="email" name="email" required
                       placeholder="student@college.edu"
                       value="${student.email}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Phone</label>
                <input class="form-control" name="phone"
                       placeholder="10-digit mobile number"
                       value="${student.phone}">
            </div>

            <div class="col-md-4">
                <label class="form-label">Branch <span class="text-danger">*</span></label>
                <input class="form-control" name="branch"
                       placeholder="e.g. MCA, CSE, ECE"
                       value="${student.branch}">
            </div>

            <div class="col-md-4">
                <label class="form-label">CGPA <span class="text-danger">*</span></label>
                <input class="form-control" type="number" step="0.01" min="0" max="10"
                       name="cgpa" value="${empty student ? '0.00' : student.cgpa}" required>
                <div class="form-text">0.00 – 10.00</div>
            </div>

            <div class="col-md-4">
                <label class="form-label">Active Backlogs <span class="text-danger">*</span></label>
                <input class="form-control" type="number" min="0"
                       name="backlogs" value="${empty student ? 0 : student.backlogs}" required>
                <div class="form-text">Enter 0 if no backlogs.</div>
            </div>

            <div class="col-12">
                <button class="btn btn-primary" type="submit">
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

<%-- ===== Students table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        Registered Students
        <c:if test="${not empty students}">
            <span class="badge bg-secondary ms-1">${students.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Branch</th>
                    <th>CGPA</th>
                    <th>Backlogs</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${students}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.studentId}</td>
                        <td class="fw-semibold">${item.name}</td>
                        <td class="small">${item.email}</td>
                        <td class="small">${item.phone}</td>
                        <td><span class="badge bg-light text-dark border">${item.branch}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${item.cgpa >= 8}">
                                    <span class="badge bg-success">${item.cgpa}</span>
                                </c:when>
                                <c:when test="${item.cgpa >= 6}">
                                    <span class="badge bg-warning text-dark">${item.cgpa}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">${item.cgpa}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${item.backlogs == 0}">
                                    <span class="badge bg-success">0</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">${item.backlogs}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-nowrap">
                            <a class="btn btn-sm btn-outline-primary"
                               href="students?action=edit&id=${item.studentId}">Edit</a>
                            <a class="btn btn-sm btn-outline-danger ms-1"
                               href="students?action=delete&id=${item.studentId}"
                               onclick="return confirm('Delete student ${item.name}? Their applications will also be removed.');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty students}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-4">
                            &#128100; No students registered yet. Add the first student above.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
