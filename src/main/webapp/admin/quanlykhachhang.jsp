<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "customers");
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Khách hàng - BHD Sport Shoes</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bs-body-font-family: 'Roboto', sans-serif;
            --heading-font: 'Josefin Sans', sans-serif;
            --bittersweet: #ff675c;
            --rich-black: #101720;
            --cultured: #F0F2F3;
            --gainsboro: #DCDCDC;
            --status-done-bg: #d1fae5;
            --status-done-text: #065f46;
            --status-new-bg: #fee2e2;
            --status-new-text: #991b1b;
            --surface-variant: #e1e3e4;
            --on-surface-variant: #59413e;
            --sidebar-width: 250px;
            --header-height: 70px;
        }

        body {
            background-color: var(--cultured);
            font-family: var(--bs-body-font-family);
            font-size: 14px;
        }

        h1, h2, h3, h4, h5, h6, .heading-font {
            font-family: var(--heading-font);
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background-color: var(--rich-black);
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 1000;
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
            display: flex;
            flex-direction: column;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0 1.5rem;
            margin-bottom: 2rem;
        }

        .sidebar-logo img {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            border: 2px solid var(--bittersweet);
        }

        .sidebar-logo-text h1 {
            font-size: 22px;
            color: white;
            margin: 0;
            text-transform: uppercase;
            font-weight: 600;
        }

        .sidebar-logo-text p {
            color: #a0a0a0;
            margin: 0;
            font-size: 14px;
        }

        .sidebar-nav {
            flex: 1;
            padding: 0 1rem;
        }

        .nav-link.sidebar-item {
            color: #a0a0a0;
            font-family: var(--heading-font);
            font-size: 16px;
            font-weight: 500;
            padding: 0.75rem 1rem;
            margin-bottom: 0.25rem;
            border-radius: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.2s;
        }

        .nav-link.sidebar-item:hover {
            color: white;
            background-color: rgba(255,255,255,0.1);
        }

        .nav-link.sidebar-item:hover .material-symbols-outlined {
            color: var(--bittersweet);
        }

        .nav-link.sidebar-item.active {
            color: white;
            background-color: rgba(255,255,255,0.05);
            border-left: 4px solid var(--bittersweet);
            border-radius: 0 0.25rem 0.25rem 0;
        }

        .nav-link.sidebar-item.active .material-symbols-outlined {
            color: var(--bittersweet);
            font-variation-settings: 'FILL' 1;
        }

        .sidebar-footer {
            padding: 0 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .btn-bittersweet {
            background-color: var(--bittersweet);
            color: white;
            font-family: var(--heading-font);
            font-weight: 600;
            border: none;
            padding: 0.75rem;
            border-radius: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
        }

        .btn-bittersweet:hover {
            background-color: #ff756b;
            color: white;
        }

        /* Header */
        .top-header {
            position: fixed;
            top: 0;
            right: 0;
            left: var(--sidebar-width);
            height: var(--header-height);
            background-color: white;
            box-shadow: 0 15px 15px rgba(0,0,0,0.05);
            z-index: 900;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
        }

        .search-bar {
            position: relative;
            width: 300px;
        }

        .search-bar input {
            background-color: var(--cultured);
            border: none;
            border-radius: 50rem;
            padding-left: 2.5rem;
            box-shadow: none;
        }

        .search-bar input:focus {
            background-color: var(--cultured);
            box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25);
        }

        .search-bar .material-symbols-outlined {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 20px;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-actions .icon-btn {
            background: none;
            border: none;
            color: #6c757d;
            position: relative;
            padding: 0.5rem;
            border-radius: 50%;
            transition: all 0.2s;
        }

        .header-actions .icon-btn:hover {
            background-color: var(--cultured);
            color: var(--bittersweet);
        }

        .header-actions .notification-dot {
            position: absolute;
            top: 6px;
            right: 6px;
            width: 8px;
            height: 8px;
            background-color: var(--bittersweet);
            border-radius: 50%;
        }

        .divider {
            width: 1px;
            height: 32px;
            background-color: var(--gainsboro);
            margin: 0 0.5rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            cursor: pointer;
        }

        .user-info {
            text-align: right;
        }

        .user-info .name {
            font-family: var(--heading-font);
            font-weight: 600;
            color: #191c1d;
            margin: 0;
            font-size: 14px;
            transition: color 0.2s;
        }

        .user-profile:hover .user-info .name {
            color: var(--bittersweet);
        }

        .user-info .email {
            color: #6c757d;
            margin: 0;
            font-size: 12px;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 1px solid var(--gainsboro);
            transition: border-color 0.2s;
            object-fit: cover;
        }

        .user-profile:hover img {
            border-color: var(--bittersweet);
        }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--header-height);
            padding: 2rem;
            min-height: calc(100vh - var(--header-height));
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: #191c1d;
            margin-bottom: 0.25rem;
        }

        .page-subtitle {
            color: #6c757d;
            margin: 0;
            font-size: 16px;
        }

        .card-custom {
            background-color: white;
            border-radius: 0.75rem;
            border: 1px solid rgba(220, 220, 220, 0.5);
            box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            padding: 1.5rem;
        }

        .card-table-container {
            background-color: white;
            border-radius: 0.75rem;
            border: 1px solid rgba(220, 220, 220, 0.5);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .form-label-custom {
            font-family: var(--heading-font);
            font-weight: 600;
            color: var(--on-surface-variant);
            font-size: 14px;
            margin-bottom: 0.5rem;
        }

        .form-control-custom, .form-select-custom {
            background-color: var(--cultured);
            border: 1px solid rgba(220, 220, 220, 0.5);
            padding: 0.6rem 1rem;
            font-size: 14px;
            border-radius: 0.25rem;
            width: 100%;
        }

        .form-control-custom:focus, .form-select-custom:focus {
            border-color: var(--bittersweet);
            box-shadow: 0 0 0 1px var(--bittersweet);
            background-color: var(--cultured);
            outline: none;
        }

        .search-input-wrapper {
            position: relative;
        }

        .search-input-wrapper .material-symbols-outlined {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 18px;
        }

        .search-input-wrapper .form-control-custom {
            padding-left: 2.5rem;
        }

        .btn-filter {
            background-color: var(--gainsboro);
            color: var(--rich-black);
            font-family: var(--heading-font);
            font-weight: 600;
            border: none;
            padding: 0.6rem 2rem;
            border-radius: 0.25rem;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: background-color 0.2s;
            width: 100%;
        }

        .btn-filter:hover {
            background-color: #d0d0d0;
        }

        .table-custom {
            margin-bottom: 0;
            width: 100%;
        }

        .table-custom th {
            font-family: var(--heading-font);
            font-weight: 700;
            font-size: 13px;
            color: var(--on-surface-variant);
            text-transform: uppercase;
            background-color: #f8fafb;
            border-bottom: 1px solid var(--gainsboro);
            padding: 1rem 1.5rem;
            border-top: none;
        }

        .table-custom td {
            vertical-align: middle;
            padding: 1rem 1.5rem;
            color: #191c1d;
            border-bottom: 1px solid rgba(220, 220, 220, 0.5);
        }

        .table-custom tbody tr {
            transition: background-color 0.2s;
        }

        .table-custom tbody tr:hover {
            background-color: rgba(240, 242, 243, 0.5);
        }

        .table-custom tbody tr.locked {
            opacity: 0.75;
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .user-name {
            font-family: var(--heading-font);
            font-weight: 600;
            transition: color 0.2s;
        }

        .table-custom tbody tr:hover .user-name {
            color: var(--bittersweet);
        }

        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25em 0.6em;
            font-size: 12px;
            font-weight: 700;
            border-radius: 50rem;
        }

        .badge-active {
            background-color: var(--status-done-bg);
            color: var(--status-done-text);
        }

        .badge-active .dot {
            background-color: var(--status-done-text);
        }

        .badge-locked {
            background-color: var(--status-new-bg);
            color: var(--status-new-text);
        }

        .badge-locked .dot {
            background-color: var(--status-new-text);
        }

        .badge-role {
            background-color: var(--surface-variant);
            color: var(--on-surface-variant);
            padding: 0.25em 0.6em;
            font-size: 12px;
            font-weight: 700;
            border-radius: 50rem;
            display: inline-block;
        }

        .badge-role-admin {
            background-color: #ffb4ab;
            color: #410002;
        }

        .dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            display: inline-block;
        }

        .avatar-sm {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 1px solid var(--gainsboro);
        }

        .avatar-placeholder {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--gainsboro);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--heading-font);
            font-weight: 600;
            color: #585f6a;
        }

        .action-btns {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }

        .action-btn {
            background: none;
            border: none;
            color: #585f6a;
            padding: 0.375rem;
            border-radius: 0.25rem;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .action-btn .material-symbols-outlined {
            font-size: 20px;
        }

        .action-btn:hover {
            color: var(--bittersweet);
            background-color: rgba(255, 103, 92, 0.1);
        }

        .action-btn.delete:hover {
            color: #ba1a1a;
            background-color: rgba(186, 26, 26, 0.1);
        }

        .pagination-container {
            padding: 1rem 1.5rem;
            border-top: 1px solid rgba(220, 220, 220, 0.5);
            background-color: #f8fafb;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .pagination-info {
            color: #585f6a;
        }

        .pagination-custom {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .pagination-custom .page-btn {
            border: none;
            background: none;
            color: #585f6a;
            font-family: var(--heading-font);
            font-weight: 600;
            border-radius: 0.25rem;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
            transition: all 0.2s;
            text-decoration: none;
        }

        .pagination-custom .page-btn.active {
            background-color: var(--bittersweet);
            color: white;
        }

        .pagination-custom .page-btn:hover:not(.active):not(:disabled) {
            background-color: var(--cultured);
            color: #191c1d;
        }

        .pagination-custom .page-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .breadcrumb {
            margin-bottom: 0.5rem;
        }

        .breadcrumb .breadcrumb-item {
            font-size: 14px;
        }

        .breadcrumb .breadcrumb-item a {
            color: #585f6a;
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb .breadcrumb-item a:hover {
            color: var(--bittersweet);
        }

        .breadcrumb .breadcrumb-item.active {
            color: var(--bittersweet);
        }

        .breadcrumb .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            color: #585f6a;
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <img alt="BHD Sport Logo" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA3HW64KcdI-KoR6kIMYLV_jZBO6TEyUktf1dG1ql68AoO93b4Y0Tx8Tpx5iOiiBRJ8v0eRf4HvXhO6pJj0RWR_YmSx2mAdx7XT6xWfPW87URd09NRPeLPajNfkYRK3WfUj98vHLp8uqM-4jqrg2x550_s7oEEjsSEzLVDII3gRXcY0NlVgFg1VJyUX0Qu0Leq5BWTZYQ9IaQCJ_XNtKTgjrcv38DzYl6wcQI0wnbB7RKDU39BRgxZQ5e3u9DWyOEHFFCFe_gSDPE8m"/>
        <div class="sidebar-logo-text">
            <h1>BHD Sport</h1>
            <p>Admin Panel</p>
        </div>
    </div>
    <nav class="sidebar-nav">
        <a class="nav-link sidebar-item" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
            <span class="material-symbols-outlined">dashboard</span>
            Bảng điều khiển
        </a>
        <a class="nav-link sidebar-item" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
            <span class="material-symbols-outlined">shopping_cart</span>
            Đơn hàng
        </a>
        <a class="nav-link sidebar-item" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
            <span class="material-symbols-outlined">inventory_2</span>
            Kho hàng
        </a>
        <a class="nav-link sidebar-item active" href="${pageContext.request.contextPath}/admin/quanlykhachhang.jsp">
            <span class="material-symbols-outlined">group</span>
            Khách hàng
        </a>
        <a class="nav-link sidebar-item" href="${pageContext.request.contextPath}/admin/thongke.jsp">
            <span class="material-symbols-outlined">assessment</span>
            Báo cáo
        </a>
        <a class="nav-link sidebar-item" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
            <span class="material-symbols-outlined">settings</span>
            Cài đặt
        </a>
    </nav>
    <div class="sidebar-footer">
        <button class="btn-bittersweet w-100">
            <span class="material-symbols-outlined fs-6">add</span>
            Thêm sản phẩm mới
        </button>
        <a class="nav-link sidebar-item p-0 mt-3" href="${pageContext.request.contextPath}/logout" style="margin-left: 1rem; margin-bottom: 1rem;">
            <span class="material-symbols-outlined">logout</span>
            Đăng xuất
        </a>
    </div>
</aside>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- Header -->
<header class="top-header">
    <div class="search-bar">
        <span class="material-symbols-outlined">search</span>
        <input class="form-control" placeholder="Tìm kiếm nhanh..." type="text"/>
    </div>
    <div class="header-actions">
        <button class="icon-btn">
            <span class="material-symbols-outlined">notifications</span>
            <span class="notification-dot"></span>
        </button>
        <button class="icon-btn">
            <span class="material-symbols-outlined">help</span>
        </button>
        <div class="divider"></div>
        <div class="user-profile">
            <div class="user-info d-none d-sm-block">
                <p class="name">Quản trị viên</p>
                <p class="email">admin@bhdsport.com</p>
            </div>
            <img alt="Admin Avatar" src="https://lh3.googleusercontent.com/aida-public/AB6AXuACx6QPr6esEQ3y6Pmnopwpd1kOWsPGVMrwD_G3NTs5J1UT8mw0u98-rpKZZlEMRlh8GQhmT6Ra1NgoxWOrjKlLlDt96_edHMIIZX6GAYmQQF1-F6dB7Fom0U17dsMDe5BOtmuOcC6klpFzFiirGQIZ0M2ZLrQrDBUwXKbJJkSErb_lE4KRiTyQfht2nJRQ09FOV54n0Q6fK6-NpRziF5zcrhx47T5IPBik7W5Lof-ZP4Y3KY2yDPAAYE7HNBC6SBZEd8G5zqjzS5A1"/>
        </div>
    </div>
</header>
--%>
<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb & Header -->
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                <li aria-current="page" class="breadcrumb-item active">Quản lý Khách hàng</li>
            </ol>
        </nav>
        <div class="page-header">
            <div>
                <h2 class="page-title">Quản lý Khách hàng</h2>
                <p class="page-subtitle">Theo dõi và quản lý danh sách người dùng hệ thống.</p>
            </div>
            <button class="btn btn-bittersweet">
                <span class="material-symbols-outlined fs-6">person_add</span>
                Thêm Khách Hàng
            </button>
        </div>
    </div>
    <!-- Filter Bar -->
    <div class="card-custom">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-lg-5">
                <label class="form-label-custom">Tìm kiếm</label>
                <div class="search-input-wrapper">
                    <span class="material-symbols-outlined">search</span>
                    <input class="form-control-custom" placeholder="Tên hoặc email..." type="text"/>
                </div>
            </div>
            <div class="col-12 col-md-4 col-lg-3">
                <label class="form-label-custom">Vai trò</label>
                <select class="form-select-custom">
                    <option value="all">Tất cả</option>
                    <option value="customer">Khách hàng</option>
                    <option value="admin">Quản trị viên</option>
                </select>
            </div>
            <div class="col-12 col-md-4 col-lg-2">
                <label class="form-label-custom">Trạng thái</label>
                <select class="form-select-custom">
                    <option value="all">Tất cả</option>
                    <option value="active">Đang hoạt động</option>
                    <option value="locked">Bị khóa</option>
                </select>
            </div>
            <div class="col-12 col-md-4 col-lg-2">
                <button class="btn-filter">
                    <span class="material-symbols-outlined fs-6">filter_list</span>
                    Lọc
                </button>
            </div>
        </div>
    </div>
    <!-- Data Table -->
    <div class="card-table-container">
        <div class="table-responsive">
            <table class="table table-custom table-hover">
                <thead>
                <tr>
                    <th width="5%">#</th>
                    <th width="20%">Họ tên</th>
                    <th width="20%">Email</th>
                    <th width="15%">Số điện thoại</th>
                    <th width="10%">Vai trò</th>
                    <th width="12%">Trạng thái</th>
                    <th width="10%">Ngày tạo</th>
                    <th class="text-end" width="8%">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="text-secondary">01</td>
                    <td>
                        <div class="user-cell">
                            <img alt="Avatar" class="avatar-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBA85hc8RBayn1BAQHyJok-sWuowvV_TsZzPUZ3zauihiKjKcXVYTUoxn_q4jLkYnh9zL8PqMUjcomzMBZVe86rLhsTht8iWV77P7o2oPZtp6p10oZuNtNpjgWyG7ejrlAhtZBedpomB6ckGdvasvgMebpHJit0Lm4wSVbRyYOHHmw47fkuLlAShdFIKV9kvhgbHQDhKfWTAEBl8dRR9MpfAy9H8lvgQleI_8HZSZrGInbIFs0nsDJnBV4826X_tj5DEND7n2ConlDT"/>
                            <span class="user-name">Nguyễn Văn An</span>
                        </div>
                    </td>
                    <td class="text-secondary">an.nguyen@email.com</td>
                    <td>0901 234 567</td>
                    <td>
                        <span class="badge-role">Khách hàng</span>
                    </td>
                    <td>
<span class="badge-status badge-active">
<span class="dot"></span>
                                    Đang hoạt động
                                </span>
                    </td>
                    <td class="text-secondary">12/10/2023</td>
                    <td>
                        <div class="action-btns">
                            <button class="action-btn" title="Xem chi tiết">
                                <span class="material-symbols-outlined">visibility</span>
                            </button>
                            <button class="action-btn delete" title="Khóa tài khoản">
                                <span class="material-symbols-outlined">lock_open</span>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="text-secondary">02</td>
                    <td>
                        <div class="user-cell">
                            <img alt="Avatar" class="avatar-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCptsu14Ia4SrGc7gfKnXdukrrUwmIb63dcALgjHN5z3bEi0BVlg2d8RIIzCz-t4OfLxg9MTv-oWmeNG-wvJet1K7c7RFPKg0kidgbZw8ZFFBNCsap6K3ZW5knXb4WCJjXd4jU1BT3GJdWdeZnD0AUB9LwDTcpP_mCLdRwHKOT7G-gTUB4-4JOa_NwOBdG9jnGNtgNL1h_y-2rUlmAs-WWdcK7f00-iSwcr_BJ_ExsLj23i3pzUnYuCcLqMIuTg9TebMYXnkeVhpNHq"/>
                            <span class="user-name">Trần Bình</span>
                        </div>
                    </td>
                    <td class="text-secondary">binh.tran@email.com</td>
                    <td>0912 345 678</td>
                    <td>
                        <span class="badge-role badge-role-admin">Quản trị viên</span>
                    </td>
                    <td>
<span class="badge-status badge-active">
<span class="dot"></span>
                                    Đang hoạt động
                                </span>
                    </td>
                    <td class="text-secondary">15/10/2023</td>
                    <td>
                        <div class="action-btns">
                            <button class="action-btn" title="Xem chi tiết">
                                <span class="material-symbols-outlined">visibility</span>
                            </button>
                            <button class="action-btn delete" title="Khóa tài khoản">
                                <span class="material-symbols-outlined">lock_open</span>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr class="locked">
                    <td class="text-secondary">03</td>
                    <td>
                        <div class="user-cell">
                            <div class="avatar-placeholder">L</div>
                            <span class="user-name text-secondary text-decoration-line-through">Lê Văn Cường</span>
                        </div>
                    </td>
                    <td class="text-secondary">cuong.le@email.com</td>
                    <td class="text-secondary">0923 456 789</td>
                    <td>
                        <span class="badge-role">Khách hàng</span>
                    </td>
                    <td>
<span class="badge-status badge-locked">
<span class="dot"></span>
                                    Bị khóa
                                </span>
                    </td>
                    <td class="text-secondary">20/10/2023</td>
                    <td>
                        <div class="action-btns">
                            <button class="action-btn" title="Xem chi tiết">
                                <span class="material-symbols-outlined">visibility</span>
                            </button>
                            <button class="action-btn delete" title="Mở khóa tài khoản">
                                <span class="material-symbols-outlined">lock</span>
                            </button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="pagination-container">
            <span class="pagination-info">Hiển thị 1 - 3 của 124 khách hàng</span>
            <div class="pagination-custom">
                <button class="page-btn" disabled="">
                    <span class="material-symbols-outlined fs-6">chevron_left</span>
                </button>
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
                <span class="px-2 text-secondary">...</span>
                <button class="page-btn">13</button>
                <button class="page-btn">
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                </button>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
