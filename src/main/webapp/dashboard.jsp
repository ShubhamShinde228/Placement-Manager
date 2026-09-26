<%@ page session="true" %>
<%@ page import="com.placement.dao.*" %>
<%
    request.setAttribute("pageTitle", "Dashboard");

    // Fetch actual real-time counts from the DAOs!
    int studentCount = new StudentDAO().getAllStudents().size();
    int companyCount = new CompanyDAO().getAllCompanies().size();
    int driveCount = new DriveDAO().getAllDrives().size();
    int selectionCount = new SelectionDAO().getAllSelections().size();
%>
<%@ include file="includes/header.jsp" %>

<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
    <div>
        <h2 class="h3 fw-bold text-gray-800">Good Morning, <%= currentUser != null ? currentUser.getUsername() : "Admin" %></h2>
        <p class="text-muted mb-0">Here's your placement overview</p>
    </div>
    <div class="btn-toolbar mb-2 mb-md-0">
        <a href="drives" class="btn btn-sm btn-primary shadow-sm">
            <i class="bi bi-plus-lg"></i> Create Drive
        </a>
    </div>
</div>

<!-- Stat Cards -->
<div class="row mb-4">
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-0 border-start border-4 border-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs fw-bold text-primary text-uppercase mb-1">Students</div>
                        <div class="h3 mb-0 fw-bold text-gray-800"><%= studentCount %></div>
                    </div>
                    <div class="col-auto">
                        <i class="bi bi-mortarboard-fill fs-2 text-muted opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-0 border-start border-4 border-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs fw-bold text-success text-uppercase mb-1">Companies</div>
                        <div class="h3 mb-0 fw-bold text-gray-800"><%= companyCount %></div>
                    </div>
                    <div class="col-auto">
                        <i class="bi bi-building-fill fs-2 text-muted opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-0 border-start border-4 border-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs fw-bold text-info text-uppercase mb-1">Drives</div>
                        <div class="h3 mb-0 fw-bold text-gray-800"><%= driveCount %></div>
                    </div>
                    <div class="col-auto">
                        <i class="bi bi-briefcase-fill fs-2 text-muted opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-0 border-start border-4 border-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs fw-bold text-warning text-uppercase mb-1">Selected</div>
                        <div class="h3 mb-0 fw-bold text-gray-800"><%= selectionCount %></div>
                    </div>
                    <div class="col-auto">
                        <i class="bi bi-trophy-fill fs-2 text-muted opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- Pipeline -->
    <div class="col-lg-7 mb-4">
        <div class="card shadow mb-4 h-100">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between bg-white">
                <h6 class="m-0 fw-bold text-primary">Placement Pipeline</h6>
            </div>
            <div class="card-body d-flex align-items-center">
                <div class="w-100 text-center">
                    <div class="d-flex justify-content-between align-items-center px-4 position-relative">
                        <!-- Pipeline Line -->
                        <div class="position-absolute bg-light w-75" style="height: 4px; top: 30px; left: 12.5%; z-index: 0;"></div>
                        
                        <!-- Steps -->
                        <div class="position-relative z-1 text-center">
                            <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center mx-auto mb-2 shadow" style="width: 60px; height: 60px;">
                                <i class="bi bi-file-earmark-arrow-up fs-4"></i>
                            </div>
                            <span class="fw-bold text-dark small">Applied</span>
                        </div>
                        <div class="position-relative z-1 text-center">
                            <div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center mx-auto mb-2 shadow" style="width: 60px; height: 60px;">
                                <i class="bi bi-card-checklist fs-4"></i>
                            </div>
                            <span class="fw-bold text-dark small">Shortlisted</span>
                        </div>
                        <div class="position-relative z-1 text-center">
                            <div class="rounded-circle bg-warning text-white d-flex align-items-center justify-content-center mx-auto mb-2 shadow" style="width: 60px; height: 60px;">
                                <i class="bi bi-mic-fill fs-4"></i>
                            </div>
                            <span class="fw-bold text-dark small">Interview</span>
                        </div>
                        <div class="position-relative z-1 text-center">
                            <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center mx-auto mb-2 shadow" style="width: 60px; height: 60px;">
                                <i class="bi bi-check-lg fs-4"></i>
                            </div>
                            <span class="fw-bold text-dark small">Selected</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Upcoming Interviews -->
    <div class="col-lg-5 mb-4">
        <div class="card shadow mb-4 h-100">
            <div class="card-header py-3 bg-white">
                <h6 class="m-0 fw-bold text-primary">Upcoming Interviews</h6>
            </div>
            <div class="card-body p-0">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item px-4 py-3 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark">Rahul Patil</div>
                            <small class="text-muted"><i class="bi bi-code-square me-1"></i> Technical Round</small>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-light text-primary border border-primary-subtle p-2">Today 10:00 AM</span>
                        </div>
                    </li>
                    <li class="list-group-item px-4 py-3 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark">Sneha Joshi</div>
                            <small class="text-muted"><i class="bi bi-people-fill me-1"></i> HR Round</small>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-light text-primary border border-primary-subtle p-2">Today 11:30 AM</span>
                        </div>
                    </li>
                    <li class="list-group-item px-4 py-3 d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-dark">Amit Kumar</div>
                            <small class="text-muted"><i class="bi bi-laptop me-1"></i> Aptitude Test</small>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-light text-dark border p-2">Tomorrow 09:00 AM</span>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="card-footer bg-white text-center">
                <a href="interviews" class="text-primary text-decoration-none small fw-bold">View All Interviews <i class="bi bi-chevron-right"></i></a>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>