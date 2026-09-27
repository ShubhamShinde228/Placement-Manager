<%@ page import="com.placement.model.User" %>
<%@ page import="com.placement.dao.NotificationDAO" %>
<%
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null || pageTitle.trim().isEmpty()) pageTitle = "Placement360";

    User currentUser = (User) session.getAttribute("user");
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    if (flashSuccess != null) session.removeAttribute("flashSuccess");
    if (flashError   != null) session.removeAttribute("flashError");

    int unreadCount = 0;
    try { unreadCount = new NotificationDAO().getUnreadCount(); } catch(Exception ignored) {}

    String uri = request.getRequestURI();
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= pageTitle %> — Placement360</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --sidebar-width: 255px;
            --topbar-height: 60px;
            --primary: #3554a5;
            --primary-dark: #1e3a8a;
            --sidebar-text: rgba(255,255,255,0.75);
            --sidebar-text-active: #fff;
        }
        body { background: #f0f2f7; font-family: 'Segoe UI', system-ui, sans-serif; overflow-x: hidden; }

        /* ── Topbar ── */
        .topbar {
            position: fixed; top: 0; left: var(--sidebar-width); right: 0;
            height: var(--topbar-height); z-index: 1030;
            background: #fff; border-bottom: 1px solid #e2e8f0;
            display: flex; align-items: center; padding: 0 1.5rem;
        }
        .topbar-brand { font-weight: 700; font-size: 1.1rem; color: var(--primary); letter-spacing: .5px; }

        /* ── Sidebar ── */
        .sidebar {
            position: fixed; top: 0; left: 0; bottom: 0; width: var(--sidebar-width);
            z-index: 1040; overflow-y: auto;
            background: linear-gradient(170deg, #1e3a8a 0%, #3554a5 60%, #2d6a9f 100%);
            display: flex; flex-direction: column;
        }
        .sidebar-header {
            padding: 1.1rem 1.4rem; border-bottom: 1px solid rgba(255,255,255,.1);
            display: flex; align-items: center; gap: 10px; min-height: var(--topbar-height);
        }
        .sidebar-logo { font-weight: 700; font-size: 1.05rem; color: #fff; line-height: 1.2; }
        .sidebar-logo small { font-size: 0.65rem; opacity: .7; display: block; font-weight: 400; }

        .sidebar-section {
            padding: 0.9rem 1rem 0.2rem;
            font-size: 0.65rem; font-weight: 700; letter-spacing: .12em;
            color: rgba(255,255,255,.4); text-transform: uppercase;
        }
        .sidebar .nav-link {
            color: var(--sidebar-text); padding: .6rem 1.2rem;
            display: flex; align-items: center; gap: 10px;
            font-size: .875rem; font-weight: 500; border-radius: 6px; margin: 1px 8px;
            transition: background .15s, color .15s;
        }
        .sidebar .nav-link:hover { background: rgba(255,255,255,.1); color: var(--sidebar-text-active); }
        .sidebar .nav-link.active { background: rgba(255,255,255,.18); color: #fff; font-weight: 600; }
        .sidebar .nav-link.disabled-link {
            color: rgba(255,255,255,.3); cursor: default; pointer-events: none;
        }
        .sidebar .nav-link .nav-icon { font-size: 1rem; width: 18px; text-align: center; flex-shrink: 0; }
        .soon-badge {
            margin-left: auto; font-size: .58rem; background: rgba(255,255,255,.15);
            color: rgba(255,255,255,.6); padding: 1px 6px; border-radius: 10px;
            font-weight: 600; letter-spacing: .04em; text-transform: uppercase;
        }

        /* ── Main ── */
        .main-content {
            margin-left: var(--sidebar-width); margin-top: var(--topbar-height);
            min-height: calc(100vh - var(--topbar-height));
            padding: 1.75rem 1.75rem 3rem;
            display: flex; flex-direction: column;
        }

        /* ── Page Header ── */
        .page-header { margin-bottom: 1.5rem; }
        .page-header h1 { font-size: 1.4rem; font-weight: 700; color: #1e293b; margin: 0; }
        .page-header p  { color: #64748b; margin: .2rem 0 0; font-size: .875rem; }

        /* ── Breadcrumb ── */
        .breadcrumb { font-size: .8rem; margin-bottom: .5rem; }
        .breadcrumb-item.active { color: #64748b; }
        .breadcrumb-item a { color: var(--primary); text-decoration: none; }

        /* ── Cards ── */
        .card { border: 1px solid #e8edf2; border-radius: .6rem; box-shadow: 0 1px 4px rgba(0,0,0,.05); }
        .card-header { background: #fff; border-bottom: 1px solid #e8edf2; font-weight: 600; font-size: .9rem; padding: .85rem 1.25rem; }

        /* ── KPI Cards ── */
        .kpi-card { border-left: 4px solid; }
        .kpi-card .kpi-label { font-size: .7rem; font-weight: 700; text-transform: uppercase; letter-spacing: .08em; }
        .kpi-card .kpi-value { font-size: 1.8rem; font-weight: 700; color: #1e293b; line-height: 1.1; }
        .kpi-card .kpi-icon { font-size: 2rem; opacity: .2; }

        /* ── Tables ── */
        .table th { font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; color: #64748b; }

        /* ── Status Badges ── */
        .badge-applied   { background: #6c757d; color: #fff; }
        .badge-review    { background: #0ea5e9; color: #fff; }
        .badge-shortlist { background: #3554a5; color: #fff; }
        .badge-interview { background: #f59e0b; color: #fff; }
        .badge-selected  { background: #22c55e; color: #fff; }
        .badge-rejected  { background: #ef4444; color: #fff; }
        .badge-open      { background: #22c55e; color: #fff; }
        .badge-upcoming  { background: #f59e0b; color: #fff; }
        .badge-closed    { background: #ef4444; color: #fff; }
        .badge-pass      { background: #22c55e; color: #fff; }
        .badge-fail      { background: #ef4444; color: #fff; }
        .badge-pending   { background: #94a3b8; color: #fff; }

        /* ── Pipeline Steps ── */
        .pipeline-steps { display: flex; align-items: center; gap: 0; }
        .pipeline-step {
            flex: 1; text-align: center; padding: .6rem .3rem;
            font-size: .7rem; font-weight: 600; position: relative;
        }
        .pipeline-step .step-circle {
            width: 36px; height: 36px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto .35rem; font-size: .9rem;
        }
        .pipeline-step .step-label { color: #475569; }
        .pipeline-step.done   .step-circle { background: #3554a5; color: #fff; }
        .pipeline-step.future .step-circle { background: #e2e8f0; color: #94a3b8; }
        .pipeline-arrow { color: #cbd5e1; font-size: 1.1rem; flex-shrink: 0; }

        /* ── Empty State ── */
        .empty-state { text-align: center; padding: 3.5rem 1rem; color: #94a3b8; }
        .empty-state .empty-icon { font-size: 3rem; margin-bottom: 1rem; display: block; }
        .empty-state h5 { color: #64748b; font-weight: 600; margin-bottom: .4rem; }
        .empty-state p { font-size: .875rem; margin-bottom: 1.2rem; }

        /* ── Alerts ── */
        .alert { border: none; border-radius: .5rem; }

        /* ── Mobile ── */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); transition: transform .25s; }
            .sidebar.show { transform: translateX(0); }
            .topbar { left: 0; }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>

<!-- ══ SIDEBAR ══ -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <i class="bi bi-mortarboard-fill text-warning fs-5"></i>
        <div class="sidebar-logo">
            Placement360
            <small>Lifecycle Management</small>
        </div>
    </div>

    <ul class="nav flex-column py-2 flex-grow-1">

        <!-- Dashboard -->
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/dashboard") ? "active" : "" %>" href="<%= ctx %>/dashboard">
                <i class="bi bi-house-door-fill nav-icon"></i> Dashboard
            </a>
        </li>

        <!-- PLACEMENT MANAGEMENT -->
        <div class="sidebar-section">Placement Management</div>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/students") ? "active" : "" %>" href="<%= ctx %>/students">
                <i class="bi bi-people-fill nav-icon"></i> Students
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/companies") ? "active" : "" %>" href="<%= ctx %>/companies">
                <i class="bi bi-building-fill nav-icon"></i> Companies
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/drives") ? "active" : "" %>" href="<%= ctx %>/drives">
                <i class="bi bi-briefcase-fill nav-icon"></i> Placement Drives
            </a>
        </li>

        <!-- RECRUITMENT PROCESS -->
        <div class="sidebar-section">Recruitment Process</div>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/applications") ? "active" : "" %>" href="<%= ctx %>/applications">
                <i class="bi bi-file-earmark-text-fill nav-icon"></i> Applications
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link disabled-link">
                <i class="bi bi-clipboard2-check-fill nav-icon"></i> Assessments
                <span class="soon-badge">Soon</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link disabled-link">
                <i class="bi bi-funnel-fill nav-icon"></i> Shortlisting
                <span class="soon-badge">Soon</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/interviews") ? "active" : "" %>" href="<%= ctx %>/interviews">
                <i class="bi bi-mic-fill nav-icon"></i> Interviews
            </a>
        </li>

        <!-- OUTCOMES -->
        <div class="sidebar-section">Outcomes</div>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/selections") ? "active" : "" %>" href="<%= ctx %>/selections">
                <i class="bi bi-trophy-fill nav-icon"></i> Selections
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link disabled-link">
                <i class="bi bi-envelope-paper-fill nav-icon"></i> Offers
                <span class="soon-badge">Soon</span>
            </a>
        </li>

        <!-- ANALYTICS -->
        <div class="sidebar-section">Analytics</div>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/reports") ? "active" : "" %>" href="<%= ctx %>/reports">
                <i class="bi bi-bar-chart-fill nav-icon"></i> Placement Analytics
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link disabled-link">
                <i class="bi bi-graph-up nav-icon"></i> Drive Analytics
                <span class="soon-badge">Soon</span>
            </a>
        </li>

        <!-- ADMINISTRATION -->
        <div class="sidebar-section">Administration</div>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/notifications") ? "active" : "" %>" href="<%= ctx %>/notifications">
                <i class="bi bi-bell-fill nav-icon"></i> Notifications
                <% if (unreadCount > 0) { %>
                <span class="soon-badge" style="background:rgba(255,200,0,.3);color:#fde68a;"><%= unreadCount %></span>
                <% } %>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= uri.contains("/settings") ? "active" : "" %>" href="<%= ctx %>/settings">
                <i class="bi bi-gear-fill nav-icon"></i> Settings
            </a>
        </li>
    </ul>
</nav>

<!-- ══ TOPBAR ══ -->
<header class="topbar">
    <button class="btn btn-sm btn-light d-md-none me-3" id="sidebarToggle">
        <i class="bi bi-list fs-5"></i>
    </button>
    <span class="topbar-brand d-none d-md-block"><i class="bi bi-mortarboard-fill text-primary me-1"></i> Placement360</span>
    <div class="ms-auto d-flex align-items-center gap-3">
        <a href="<%= ctx %>/notifications" class="position-relative text-secondary" style="text-decoration:none;">
            <i class="bi bi-bell-fill fs-5"></i>
            <% if (unreadCount > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:.58rem;"><%= unreadCount %></span>
            <% } %>
        </a>
        <div class="dropdown">
            <button class="btn btn-light btn-sm dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle fs-5 text-secondary"></i>
                <span class="d-none d-md-inline fw-semibold small"><%= currentUser != null ? currentUser.getUsername() : "Admin" %></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-1">
                <li class="px-3 py-2"><small class="text-muted">Signed in as</small><br><strong class="small"><%= currentUser != null ? currentUser.getUsername() : "admin" %></strong></li>
                <li><hr class="dropdown-divider my-1"></li>
                <li><a class="dropdown-item small" href="<%= ctx %>/settings"><i class="bi bi-gear me-2"></i>Settings</a></li>
                <li><a class="dropdown-item small text-danger" href="<%= ctx %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
            </ul>
        </div>
    </div>
</header>

<!-- ══ MAIN CONTENT ══ -->
<main class="main-content">

    <% if (flashSuccess != null) { %>
    <div class="alert alert-success alert-dismissible fade show mb-3 shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i><%= flashSuccess %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
    <% if (flashError != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mb-3 shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><%= flashError %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>
