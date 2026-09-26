<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h2 class="mb-0">Notifications</h2>
    <a href="notifications?action=markRead" class="btn btn-sm btn-outline-primary">Mark All as Read</a>
</div>

<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <ul class="list-group list-group-flush">
            <c:forEach var="note" items="${notifications}">
                <li class="list-group-item px-4 py-3 ${note.read ? 'bg-white' : 'bg-light'}">
                    <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1 ${note.read ? 'text-muted' : 'fw-bold text-dark'}">
                            <i class="bi bi-bell-fill text-primary me-2"></i> ${note.message}
                        </h6>
                        <small class="text-muted">${note.createdAt}</small>
                    </div>
                </li>
            </c:forEach>
            <c:if test="${empty notifications}">
                <li class="list-group-item text-center py-5 text-muted">
                    <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                    No notifications yet.
                </li>
            </c:if>
        </ul>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
