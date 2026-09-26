<%@ page import="com.placement.model.User" %>
<%@ page import="com.placement.dao.NotificationDAO" %>
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null || pageTitle.trim().isEmpty()) {
        pageTitle = "Placement Manager";
    }
    User currentUser = (User) session.getAttribute("user");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");

    int unreadCount = 0;
    try {
        unreadCount = new NotificationDAO().getUnreadCount();
    } catch(Exception e) {}
    
    String currentUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= pageTitle %> — Placement Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { 
            background-color: #f4f6f9; 
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            overflow-x: hidden;
        }
        /* Top Navbar */
        .navbar {
            background-color: #ffffff;
            border-bottom: 1px solid #e3e6f0;
            z-index: 1040;
            padding: 0.75rem 1.5rem;
        }
        .navbar-brand {
            font-weight: 700;
            color: #4e73df !important;
            letter-spacing: 0.5px;
            font-size: 1.2rem;
        }
        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 60px;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 1.5rem 0 0;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            background-color: #4e73df;
            background-image: linear-gradient(180deg, #4e73df 10%, #224abe 100%);
            background-size: cover;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            font-weight: 500;
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: #fff;
            background: rgba(255, 255, 255, 0.15);
        }
        .sidebar .nav-link i {
            font-size: 1.1rem;
        }
        /* Main Content */
        main {
            margin-top: 60px;
            padding-top: 2rem;
            min-height: calc(100vh - 60px);
        }
        /* Utilities */
        .card {
            border: none;
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .text-primary-custom {
            color: #4e73df;
        }
    </style>
</head>
<body>

<!-- Top Navbar -->
<nav class="navbar navbar-expand navbar-light fixed-top shadow-sm">
    <a class="navbar-brand d-flex align-items-center gap-2" href="<%= request.getContextPath() %>/dashboard">
        <i class="bi bi-mortarboard-fill text-primary-custom"></i>
        <span>Placement360</span>
    </a>
    
    <ul class="navbar-nav ms-auto align-items-center">
        <!-- Notification Bell -->
        <li class="nav-item dropdown no-arrow mx-1">
            <a class="nav-link text-secondary position-relative" href="notifications">
                <i class="bi bi-bell-fill fs-5"></i>
                <% if (unreadCount > 0) { %>
                    <span class="position-absolute top-25 start-75 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem;">
                        <%= unreadCount %>
                    </span>
                <% } %>
            </a>
        </li>
        <div class="topbar-divider d-none d-sm-block mx-3 border-start h-50"></div>
        <!-- User Info -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle text-dark d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                <span class="d-none d-lg-inline small fw-bold">
                    <%= currentUser != null ? currentUser.getUsername() : "Admin" %>
                </span>
                <i class="bi bi-person-circle fs-4 text-secondary"></i>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="settings"><i class="bi bi-gear fa-sm fa-fw me-2 text-gray-400"></i> Settings</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="logout"><i class="bi bi-box-arrow-right fa-sm fa-fw me-2 text-gray-400"></i> Logout</a></li>
            </ul>
        </li>
    </ul>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block sidebar collapse">
            <div class="position-sticky">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.endsWith("/dashboard.jsp") || currentUri.endsWith("/dashboard") ? "active" : "" %>" href="dashboard.jsp">
                            <i class="bi bi-house-door-fill"></i>
                            Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/students") ? "active" : "" %>" href="students">
                            <i class="bi bi-mortarboard-fill"></i>
                            Students
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/companies") ? "active" : "" %>" href="companies">
                            <i class="bi bi-building-fill"></i>
                            Companies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/drives") ? "active" : "" %>" href="drives">
                            <i class="bi bi-briefcase-fill"></i>
                            Drives
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/applications") ? "active" : "" %>" href="applications">
                            <i class="bi bi-file-earmark-text-fill"></i>
                            Applications
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/interviews") ? "active" : "" %>" href="interviews">
                            <i class="bi bi-mic-fill"></i>
                            Interviews
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/selections") ? "active" : "" %>" href="selections">
                            <i class="bi bi-trophy-fill"></i>
                            Selections
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link <%= currentUri.contains("/reports") ? "active" : "" %>" href="reports">
                            <i class="bi bi-bar-chart-fill"></i>
                            Reports
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= currentUri.contains("/settings") ? "active" : "" %>" href="settings">
                            <i class="bi bi-gear-fill"></i>
                            Settings
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 d-flex flex-column" style="min-height: calc(100vh - 60px); margin-top: 60px;">
            <div class="flex-grow-1 mb-4">
                <% if (flashSuccess != null) { %>
                    <div class="alert alert-success alert-dismissible fade show mt-4 border-0 shadow-sm" role="alert">
                        <strong><i class="bi bi-check-circle-fill"></i></strong> <%= flashSuccess %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                <% if (flashError != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show mt-4 border-0 shadow-sm" role="alert">
                        <strong><i class="bi bi-exclamation-triangle-fill"></i></strong> <%= flashError %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
