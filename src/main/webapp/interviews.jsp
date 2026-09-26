<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.placement.model.Interview" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    /* Prepare the datetime string for the edit form input[type=datetime-local].
       This scriptlet is necessary because JSP EL cannot call instance methods
       like toLocalDateTime().format(...) on a java.sql.Timestamp directly. */
    Interview editInterview = (Interview) request.getAttribute("interview");
    String datetimeValue = "";
    if (editInterview != null && editInterview.getInterviewDatetime() != null) {
        datetimeValue = editInterview.getInterviewDatetime()
                .toLocalDateTime()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
    }
    request.setAttribute("datetimeValue", datetimeValue);
%>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Interview Rounds</h2>
    <span class="text-muted small">Schedule rounds and record results (PENDING / PASS / FAIL)</span>
</div>

<%-- ===== Schedule / Edit form ===== --%>
<div class="card border-0 shadow-sm mb-4">
    <div class="card-header bg-white fw-semibold">
        <c:choose>
            <c:when test="${not empty interview}">Edit Interview</c:when>
            <c:otherwise>Schedule Interview Round</c:otherwise>
        </c:choose>
    </div>
    <div class="card-body">
        <form method="post" action="interviews" class="row g-3">
            <c:if test="${not empty interview}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="interviewId" value="${interview.interviewId}">
            </c:if>

            <div class="col-md-5">
                <label class="form-label">Application</label>
                <select class="form-select" name="applicationId" required>
                    <option value="">Select application&hellip;</option>
                    <c:forEach var="application" items="${applications}">
                        <option value="${application.applicationId}"
                            ${interview.applicationId == application.applicationId ? 'selected' : ''}>
                            #${application.applicationId} &mdash; ${application.studentName}
                            &rarr; ${application.companyName} (${application.jobRole})
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label">Round Name</label>
                <input class="form-control" name="roundName" required
                       placeholder="e.g. Aptitude / Technical / HR"
                       value="${interview.roundName}">
            </div>

            <div class="col-md-2">
                <label class="form-label">Date &amp; Time</label>
                <input class="form-control" type="datetime-local"
                       name="interviewDatetime" value="${datetimeValue}">
            </div>

            <div class="col-md-2">
                <label class="form-label">Result</label>
                <select class="form-select" name="result">
                    <option value="PENDING" ${interview.result == 'PENDING' || empty interview ? 'selected' : ''}>PENDING</option>
                    <option value="PASS"    ${interview.result == 'PASS'    ? 'selected' : ''}>PASS</option>
                    <option value="FAIL"    ${interview.result == 'FAIL'    ? 'selected' : ''}>FAIL</option>
                </select>
            </div>

            <div class="col-12">
                <button class="btn btn-primary" type="submit">
                    <c:choose>
                        <c:when test="${not empty interview}">Update</c:when>
                        <c:otherwise>Schedule</c:otherwise>
                    </c:choose>
                </button>
                <c:if test="${not empty interview}">
                    <a class="btn btn-outline-secondary ms-2" href="interviews">Cancel</a>
                </c:if>
            </div>
        </form>
        <p class="text-muted small mt-2 mb-0">
            &#9432; A student must have at least one <strong>PASS</strong> result to be eligible for Final Selection.
        </p>
    </div>
</div>

<%-- ===== Interviews table ===== --%>
<div class="card border-0 shadow-sm">
    <div class="card-header bg-white fw-semibold">
        All Interview Records
        <c:if test="${not empty interviews}">
            <span class="badge bg-secondary ms-1">${interviews.size()}</span>
        </c:if>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-3">ID</th>
                    <th>Student</th>
                    <th>Company &amp; Role</th>
                    <th>Round</th>
                    <th>Scheduled</th>
                    <th>Result</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${interviews}">
                    <tr>
                        <td class="ps-3 text-muted small">#${item.interviewId}</td>
                        <td class="fw-semibold">${item.studentName}</td>
                        <td>
                            <span class="fw-semibold">${item.companyName}</span><br>
                            <span class="text-muted small">${item.jobRole}</span>
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border">${item.roundName}</span>
                        </td>
                        <td class="small text-muted">${item.interviewDatetime}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.result == 'PASS'}">
                                    <span class="badge bg-success fs-6">&#10003; PASS</span>
                                </c:when>
                                <c:when test="${item.result == 'FAIL'}">
                                    <span class="badge bg-danger fs-6">&#10007; FAIL</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark fs-6">&#8987; PENDING</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-nowrap">
                            <a class="btn btn-sm btn-outline-primary"
                               href="interviews?action=edit&id=${item.interviewId}">Edit</a>
                            <a class="btn btn-sm btn-outline-danger ms-1"
                               href="interviews?action=delete&id=${item.interviewId}"
                               onclick="return confirm('Delete this interview record for ${item.studentName}?');">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty interviews}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">
                            &#128197; No interview records yet. Schedule the first round above.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
