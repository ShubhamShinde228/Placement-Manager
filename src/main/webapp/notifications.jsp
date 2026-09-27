<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="includes/header.jsp" %>

<!-- Page Header -->
<div class="page-header d-flex justify-content-between align-items-start flex-wrap gap-2">
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                <li class="breadcrumb-item active">Administration</li>
                <li class="breadcrumb-item active">Notifications</li>
            </ol>
        </nav>
        <h1><i class="bi bi-bell-fill me-2 text-primary"></i>Notifications</h1>
        <p>System alerts and placement activity notifications.</p>
    </div>
    <a href="notifications?action=markRead" class="btn btn-sm btn-outline-secondary">
        <i class="bi bi-check-all me-1"></i> Mark All Read
    </a>
</div>

<div class="card">
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${not empty notifications}">
                <ul class="list-group list-group-flush">
                    <c:forEach var="note" items="${notifications}">
                        <li class="list-group-item px-4 py-3 ${note.read ? '' : 'bg-light'}">
                            <div class="d-flex w-100 justify-content-between">
                                <span class="${note.read ? 'text-muted' : 'fw-semibold text-dark'}">
                                    <i class="bi bi-bell${note.read ? '' : '-fill'} text-primary me-2"></i>${note.message}
                                </span>
                                <small class="text-muted text-nowrap ms-3">${note.createdAt}</small>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <span class="empty-icon">&#128276;</span>
                    <h5>No Notifications</h5>
                    <p>You're all caught up. No notifications at this time.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
