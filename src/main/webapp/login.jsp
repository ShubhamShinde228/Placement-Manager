<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login — College Placement Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 60%, #084298 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 1rem 3rem rgba(0,0,0,.25);
            max-width: 420px;
            width: 100%;
        }
        .login-header {
            background: linear-gradient(135deg, #0d6efd, #0a58ca);
            border-radius: 1rem 1rem 0 0;
            padding: 2rem;
            text-align: center;
            color: white;
        }
        .login-header .icon {
            font-size: 2.5rem;
            margin-bottom: .5rem;
        }
        .login-body { padding: 2rem; }
        .form-control:focus { border-color: #0d6efd; box-shadow: 0 0 0 .2rem rgba(13,110,253,.2); }
    </style>
</head>
<body>

<div class="login-card card">
    <div class="login-header">
        <div class="icon">&#127891;</div>
        <h4 class="mb-0 fw-bold">College Placement Manager</h4>
        <small class="opacity-75">Admin &amp; Placement Officer Portal</small>
    </div>
    <div class="login-body">

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-sm py-2" role="alert">
                &#10007; ${error}
            </div>
        </c:if>

        <form action="login" method="post" novalidate>

            <div class="mb-3">
                <label for="username" class="form-label fw-semibold">Username</label>
                <input type="text" id="username" name="username"
                       class="form-control" placeholder="Enter username"
                       required autofocus autocomplete="username">
            </div>

            <div class="mb-4">
                <label for="password" class="form-label fw-semibold">Password</label>
                <input type="password" id="password" name="password"
                       class="form-control" placeholder="Enter password"
                       required autocomplete="current-password">
            </div>

            <button type="submit" class="btn btn-primary w-100 fw-semibold py-2">
                Sign In &rarr;
            </button>

        </form>

        <p class="text-center text-muted small mt-4 mb-0">
            College Placement Management System
        </p>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>