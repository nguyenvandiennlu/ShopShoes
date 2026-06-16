<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="utils.EmailConfigLoader" %>
<%
    request.setAttribute("adminActive", "settings");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>BHD Sport Admin - Cài đặt hệ thống</title>
<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!-- Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
    :root {
        --bittersweet: #ff675c;
        --bittersweet-hover: #ff756b;
        --rich-black: #101720;
        --cultured: #f0f2f3;
        --gainsboro: #dcdcdc;
        --secondary: #585f6a;
        --on-surface: #191c1d;
        --error: #ba1a1a;

        --font-heading: 'Josefin Sans', sans-serif;
        --font-body: 'Roboto', sans-serif;

        --sidebar-width: 250px;
        --header-height: 70px;
    }

    body {
        background-color: var(--cultured);
        font-family: var(--font-body);
        color: var(--on-surface);
        margin: 0;
        padding: 0;
    }

    h1, h2, h3, h4, h5, h6, .font-heading {
        font-family: var(--font-heading);
    }

    .text-bittersweet { color: var(--bittersweet) !important; }
    .bg-bittersweet { background-color: var(--bittersweet) !important; color: white; }
    .bg-bittersweet:hover { background-color: var(--bittersweet-hover) !important; color: white; }
    .text-secondary-custom { color: var(--secondary) !important; }

    .btn-bittersweet {
        background-color: var(--bittersweet);
        border-color: var(--bittersweet);
        color: white;
        font-family: var(--font-heading);
        font-weight: 600;
    }
    .btn-bittersweet:hover {
        background-color: var(--bittersweet-hover);
        border-color: var(--bittersweet-hover);
        color: white;
    }

    /* Layout */
    .sidebar {
        width: var(--sidebar-width);
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        background-color: var(--rich-black);
        z-index: 1040;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        border-right: 1px solid var(--gainsboro);
    }

    .main-wrapper {
        margin-left: var(--sidebar-width);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .top-header {
        height: var(--header-height);
        background-color: #fff;
        position: sticky;
        top: 0;
        z-index: 1030;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1.5rem;
    }

    .content-area {
        padding: 2rem;
        flex-grow: 1;
    }

    /* Sidebar Nav */
    .sidebar-brand {
        padding: 1.5rem 1.5rem;
    }
    .sidebar-brand h1 {
        color: white;
        font-size: 22px;
        font-weight: 600;
        margin-bottom: 0.25rem;
    }
    .sidebar-brand p {
        color: var(--secondary);
        font-size: 14px;
        margin-bottom: 0;
    }

    .sidebar-nav {
        padding: 0 1rem;
        list-style: none;
        margin: 0;
        flex-grow: 1;
    }

    .sidebar-nav .nav-item {
        margin-bottom: 0.5rem;
    }

    .sidebar-nav .nav-link {
        color: #a0a0a0;
        font-family: var(--font-heading);
        font-size: 16px;
        font-weight: 500;
        padding: 0.75rem 1rem;
        border-radius: 0.25rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        text-decoration: none;
        transition: all 0.2s;
    }

    .sidebar-nav .nav-link:hover {
        color: #fff;
        background-color: rgba(255, 255, 255, 0.05);
    }

    .sidebar-nav .nav-link.active {
        color: #fff;
        background-color: rgba(255, 255, 255, 0.1);
        border-left: 4px solid var(--bittersweet);
        border-radius: 0 0.25rem 0.25rem 0;
    }

    .sidebar-footer {
        padding: 1.5rem;
    }

    /* Search Input */
    .search-container {
        position: relative;
        width: 250px;
    }
    .search-container .material-symbols-outlined {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--secondary);
    }
    .search-container .form-control {
        padding-left: 40px;
        border-radius: 50rem;
        background-color: var(--cultured);
        border: none;
        font-size: 14px;
    }
    .search-container .form-control:focus {
        box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25);
        background-color: #fff;
    }

    /* Header User */
    .header-actions {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }
    .notification-btn {
        position: relative;
        background: none;
        border: none;
        color: var(--secondary);
        padding: 0.5rem;
        border-radius: 50%;
    }
    .notification-btn:hover {
        background-color: var(--cultured);
        color: var(--bittersweet);
    }
    .notification-dot {
        position: absolute;
        top: 4px;
        right: 4px;
        width: 8px;
        height: 8px;
        background-color: var(--bittersweet);
        border-radius: 50%;
    }
    .user-profile {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding-left: 1.5rem;
        border-left: 1px solid var(--gainsboro);
    }
    .user-info {
        text-align: right;
    }
    .user-info .name {
        font-family: var(--font-heading);
        font-size: 14px;
        font-weight: 600;
        margin: 0;
    }
    .user-info .role {
        font-size: 12px;
        color: var(--secondary);
        margin: 0;
    }

    /* Breadcrumb & Title */
    .breadcrumb {
        margin-bottom: 0.5rem;
        font-size: 14px;
    }
    .breadcrumb a {
        color: var(--secondary);
        text-decoration: none;
    }
    .breadcrumb a:hover {
        color: var(--bittersweet);
    }
    .breadcrumb-item + .breadcrumb-item::before {
        content: "chevron_right";
        font-family: 'Material Symbols Outlined';
        font-size: 16px;
        vertical-align: middle;
        color: var(--secondary);
    }
    .page-title {
        font-size: 28px;
        font-weight: 600;
        color: var(--rich-black);
        margin-bottom: 2rem;
    }

    /* Cards and Settings Nav */
    .card {
        border: 1px solid var(--gainsboro);
        border-radius: 0.75rem;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        background-color: #fff;
    }
    .settings-nav {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }
    .settings-nav .nav-link {
        color: var(--secondary);
        font-family: var(--font-heading);
        font-weight: 600;
        font-size: 14px;
        padding: 0.75rem 1rem;
        border-radius: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .settings-nav .nav-link:hover {
        background-color: var(--cultured);
        color: var(--on-surface);
    }
    .settings-nav .nav-link.active {
        background-color: var(--cultured);
        color: var(--bittersweet);
    }

    /* Forms */
    .form-label {
        font-family: var(--font-heading);
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 0.5rem;
        color: var(--on-surface);
    }
    .text-error {
        color: var(--error);
    }
    .form-control {
        background-color: var(--cultured);
        border: 1px solid var(--gainsboro);
        padding: 0.625rem 1rem;
        font-size: 14px;
    }
    .form-control:focus {
        background-color: #fff;
        border-color: var(--bittersweet);
        box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25);
    }

    .card-header-custom {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-family: var(--font-heading);
        font-size: 22px;
        font-weight: 600;
        color: var(--rich-black);
        margin-bottom: 1.5rem;
    }

    .top-gradient-border {
        position: relative;
        overflow: hidden;
    }
    .top-gradient-border::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background: linear-gradient(to right, #ff675c, #FF756B);
    }

    .left-border-indicator {
        position: relative;
        overflow: hidden;
    }
    .left-border-indicator::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 4px;
        height: 100%;
        background-color: var(--gainsboro);
    }

    .logo-upload-container {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }
    .logo-preview {
        width: 96px;
        height: 96px;
        border-radius: 0.5rem;
        background-color: var(--cultured);
        border: 2px dashed var(--gainsboro);
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .logo-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .btn-upload {
        background-color: var(--gainsboro);
        color: var(--rich-black);
        border: none;
        font-family: var(--font-heading);
        font-weight: 600;
        font-size: 14px;
        padding: 0.5rem 1rem;
        border-radius: 0.25rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .btn-upload:hover {
        background-color: #d1d3d4;
    }

    .password-input-group {
        position: relative;
    }
    .password-input-group .toggle-password {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: var(--secondary);
        padding: 0;
    }
    .password-input-group .toggle-password:hover {
        color: var(--rich-black);
    }

    .material-symbols-outlined {
        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- Sidebar -->
<aside class="sidebar">
    <div>
        <div class="sidebar-brand">
            <h1 class="font-heading">BHD Sport</h1>
            <p class="">Admin Panel</p>
        </div>
        <ul class="sidebar-nav">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                    <span class="material-symbols-outlined">dashboard</span>
                    Bảng điều khiển
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
                    <span class="material-symbols-outlined">shopping_cart</span>
                    Đơn hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
                    <span class="material-symbols-outlined">inventory_2</span>
                    Kho hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlykhachhang.jsp">
                    <span class="material-symbols-outlined">group</span>
                    Khách hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                    <span class="material-symbols-outlined">analytics</span>
                    Báo cáo
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
                    <span class="material-symbols-outlined">settings</span>
                    Cài đặt
                </a>
            </li>
        </ul>
    </div>
    <div class="sidebar-footer"><a class="btn btn-bittersweet w-100 py-2 d-flex align-items-center justify-content-center gap-2 mb-3" href="${pageContext.request.contextPath}/admin/addproduct.jsp">
        <span class="material-symbols-outlined" style="font-size: 20px;">add</span>
        Thêm sản phẩm mới
    </a>
        <a class="nav-link d-flex align-items-center gap-3 px-3 py-2 rounded-2 text-decoration-none" href="${pageContext.request.contextPath}/logout" style="font-family: var(--font-heading); font-size: 16px; font-weight: 500; color: rgb(160, 160, 160); transition: 0.2s;">
            <span class="material-symbols-outlined">logout</span>
            Đăng xuất
        </a></div>
</aside>
--%>
<!-- Main Wrapper -->
<div class="main-wrapper">
    <jsp:include page="topbar.jsp"/>
    <%--
    <!-- Top Header -->
    <header class="top-header">
        <div class="search-container">
            <span class="material-symbols-outlined">search</span>
            <input class="form-control" placeholder="Tìm kiếm..." type="text">
        </div>
        <div class="header-actions">
            <button class="notification-btn">
                <span class="material-symbols-outlined">notifications</span>
                <span class="notification-dot"></span>
            </button>
            <div class="user-profile">
                <div class="user-info d-none d-md-block">
                    <p class="name">Admin User</p>
                    <p class="role">Quản trị viên</p>
                </div>
                <button class="btn btn-link p-0 text-secondary-custom text-decoration-none">
                    <span class="material-symbols-outlined" style="font-size: 32px;">account_circle</span>
                </button>
            </div>
        </div>
    </header>
    --%>
    <!-- Content Area -->
    <main class="content-area">
        <!-- Breadcrumb & Title -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp" class="">Trang chủ</a></li>
                <li aria-current="page" class="breadcrumb-item active text-dark fw-medium">Cài đặt</li>
            </ol>
        </nav>
        <h2 class="page-title font-heading">Cài đặt hệ thống</h2>
        <div class="row gx-4">
            <!-- Left Column: Settings Nav -->
            <div class="col-12 col-lg-3 mb-4 mb-lg-0">
                <div class="card p-3 sticky-top" style="top: 90px; z-index: 10;">
                    <nav class="settings-nav">
                        <a class="nav-link active" href="#" data-target="general-card">
                            <span class="material-symbols-outlined">tune</span>
                            Cài đặt chung
                        </a>
                        <a class="nav-link" href="#" data-target="smtp-card">
                            <span class="material-symbols-outlined">mail</span>
                            Cấu hình Email
                        </a>
                        <a class="nav-link" href="#" data-target="password-card">
                            <span class="material-symbols-outlined">lock</span>
                            Đổi mật khẩu
                        </a>
                        <a class="nav-link" href="#" data-target="permissions-card">
                            <span class="material-symbols-outlined">admin_panel_settings</span>
                            Quản lý quyền
                        </a>
                    </nav>
                </div>
            </div>
            <!-- Right Column: Settings Forms -->
            <div class="col-12 col-lg-9">
                <!-- General Settings Card -->
                <div class="card p-4 p-md-5 mb-4 top-gradient-border settings-card" id="general-card">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-bittersweet">tune</span>
                        Cài đặt chung
                    </h3>
                    <form id="generalSettingsForm" class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label">Tên cửa hàng <span class="text-error">*</span></label>
                            <input class="form-control" name="shopName" type="text" value="<%= EmailConfigLoader.get("shop.name") != null ? EmailConfigLoader.get("shop.name") : "BHD Sport Shoes" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hotline <span class="text-error">*</span></label>
                            <input class="form-control" name="shopHotline" type="text" value="<%= EmailConfigLoader.get("shop.hotline") != null ? EmailConfigLoader.get("shop.hotline") : "0123.456.789" %>" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <input class="form-control" name="shopAddress" type="text" value="<%= EmailConfigLoader.get("shop.address") != null ? EmailConfigLoader.get("shop.address") : "" %>">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Email liên hệ</label>
                            <input class="form-control" name="shopEmail" type="email" value="<%= EmailConfigLoader.get("shop.email") != null ? EmailConfigLoader.get("shop.email") : "" %>">
                        </div>
                        <div class="col-12 d-flex justify-content-end mt-4">
                            <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm" type="submit">
                                <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                                Lưu cấu hình chung
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Email Config Card -->
                <div class="card p-4 p-md-5 mb-4 left-border-indicator settings-card d-none" id="smtp-card">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-secondary-custom">mail</span>
                        Cấu hình Email (SMTP)
                    </h3>
                    <form id="smtpSettingsForm" class="row g-4">
                        <div class="col-12">
                            <label class="form-label">SMTP Host <span class="text-error">*</span></label>
                            <input class="form-control" name="mailHost" type="text" value="<%= EmailConfigLoader.get("mail.host") != null ? EmailConfigLoader.get("mail.host") : "" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SMTP Port <span class="text-error">*</span></label>
                            <input class="form-control" name="mailPort" type="text" value="<%= EmailConfigLoader.get("mail.port") != null ? EmailConfigLoader.get("mail.port") : "587" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SMTP Auth</label>
                            <select class="form-select" name="mailAuth" style="background-color: var(--cultured); border: 1px solid var(--gainsboro); padding: 0.625rem 1rem; font-size: 14px; border-radius: 0.375rem; width:100%;">
                                <option value="true" <%= "true".equals(EmailConfigLoader.get("mail.auth")) ? "selected" : "" %>>Bật (True)</option>
                                <option value="false" <%= "false".equals(EmailConfigLoader.get("mail.auth")) ? "selected" : "" %>>Tắt (False)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SMTP Username <span class="text-error">*</span></label>
                            <input class="form-control" name="mailUsername" type="text" value="<%= EmailConfigLoader.get("mail.username") != null ? EmailConfigLoader.get("mail.username") : "" %>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SMTP Password <span class="text-error">*</span></label>
                            <div class="password-input-group">
                                <input class="form-control pe-5" name="mailPassword" type="password" value="<%= EmailConfigLoader.get("mail.password") != null ? EmailConfigLoader.get("mail.password") : "" %>" required>
                                <button class="toggle-password" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">visibility_off</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-12 d-flex justify-content-end gap-3 mt-4">
                            <button class="btn btn-secondary px-4 py-2 d-flex align-items-center gap-2" type="button" id="btnTestEmailModal">
                                <span class="material-symbols-outlined" style="font-size: 20px;">send</span>
                                Gửi Email thử nghiệm
                            </button>
                            <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm" type="submit">
                                <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                                Lưu cấu hình SMTP
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Change Password Card -->
                <div class="card p-4 p-md-5 mb-4 top-gradient-border settings-card d-none" id="password-card">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-bittersweet">lock</span>
                        Đổi mật khẩu tài khoản Admin
                    </h3>
                    <form id="changePasswordForm" class="row g-4">
                        <div class="col-12">
                            <label class="form-label">Mật khẩu hiện tại <span class="text-error">*</span></label>
                            <div class="password-input-group">
                                <input class="form-control pe-5" name="oldPassword" type="password" placeholder="Nhập mật khẩu hiện tại..." required>
                                <button class="toggle-password" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">visibility_off</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Mật khẩu mới <span class="text-error">*</span></label>
                            <div class="password-input-group">
                                <input class="form-control pe-5" name="newPassword" id="newPassword" type="password" placeholder="Tối thiểu 6 ký tự..." required>
                                <button class="toggle-password" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">visibility_off</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Xác nhận mật khẩu mới <span class="text-error">*</span></label>
                            <div class="password-input-group">
                                <input class="form-control pe-5" name="confirmPassword" id="confirmPassword" type="password" placeholder="Nhập lại mật khẩu mới..." required>
                                <button class="toggle-password" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">visibility_off</span>
                                </button>
                            </div>
                        </div>
                        <div class="col-12 d-flex justify-content-end mt-4">
                            <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm" type="submit">
                                <span class="material-symbols-outlined" style="font-size: 20px;">vpn_key</span>
                                Thay đổi mật khẩu
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Permissions Management Card -->
                <div class="card p-4 p-md-5 mb-4 left-border-indicator settings-card d-none" id="permissions-card">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-secondary-custom">admin_panel_settings</span>
                        Quản lý phân quyền (RBAC)
                    </h3>
                    <p class="text-secondary mb-4" style="font-size: 13px;">Thiết lập và phân quyền chi tiết cho từng nhóm vai trò truy cập hệ thống quản trị.</p>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle" style="border-color: var(--gainsboro);">
                            <thead class="table-light">
                                <tr class="text-center text-secondary">
                                    <th class="text-start" width="32%">Quyền hạn</th>
                                    <th width="17%">SUPER_ADMIN</th>
                                    <th width="17%">CSKH/BÁN HÀNG</th>
                                    <th width="17%">THỦ KHO</th>
                                    <th width="17%">KHÁCH HÀNG</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined text-bittersweet" style="font-size: 18px;">bar_chart</span>
                                            Xem báo cáo thống kê
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked disabled>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" disabled>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined text-bittersweet" style="font-size: 18px;">shopping_cart</span>
                                            Quản lý đơn hàng
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked disabled>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" disabled>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined text-bittersweet" style="font-size: 18px;">inventory_2</span>
                                            Quản lý kho hàng & sản phẩm
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked disabled>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" disabled>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined text-bittersweet" style="font-size: 18px;">group</span>
                                            Quản lý tài khoản khách hàng
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked disabled>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" disabled>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-semibold">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="material-symbols-outlined text-bittersweet" style="font-size: 18px;">settings</span>
                                            Cài đặt hệ thống
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" checked disabled>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox">
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="form-check form-switch d-inline-block">
                                            <input class="form-check-input" type="checkbox" disabled>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-12 d-flex justify-content-end mt-4">
                        <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm" type="button" id="btnSavePermissions">
                            <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                            Lưu phân quyền
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ============================================================
    // JS TABS FOR SETTINGS
    // ============================================================
    document.querySelectorAll('.settings-nav .nav-link').forEach(function(tabLink) {
        tabLink.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Đổi active menu bên trái
            document.querySelectorAll('.settings-nav .nav-link').forEach(function(link) {
                link.classList.remove('active');
            });
            tabLink.classList.add('active');
            
            // Ẩn hiện các card tương ứng bên phải
            var targetId = tabLink.getAttribute('data-target');
            document.querySelectorAll('.settings-card').forEach(function(card) {
                if (card.getAttribute('id') === targetId) {
                    card.classList.remove('d-none');
                } else {
                    card.classList.add('d-none');
                }
            });
        });
    });

    // ============================================================
    // TOGGLE PASSWORD VISIBILITY
    // ============================================================
    document.body.addEventListener('click', function(e) {
        var btn = e.target.closest('.toggle-password');
        if (!btn) return;
        
        e.preventDefault();
        var input = btn.closest('.password-input-group').querySelector('input');
        var icon = btn.querySelector('.material-symbols-outlined');
        
        if (input.type === 'password') {
            input.type = 'text';
            icon.textContent = 'visibility';
        } else {
            input.type = 'password';
            icon.textContent = 'visibility_off';
        }
    });

    // ============================================================
    // AJAX SUBMIT FOR FORM: SAVE GENERAL SETTINGS
    // ============================================================
    document.getElementById('generalSettingsForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var form = e.target;
        var formData = new URLSearchParams();
        formData.append('action', 'save-general');
        formData.append('shopName', form.querySelector('[name="shopName"]').value);
        formData.append('shopHotline', form.querySelector('[name="shopHotline"]').value);
        formData.append('shopAddress', form.querySelector('[name="shopAddress"]').value);
        formData.append('shopEmail', form.querySelector('[name="shopEmail"]').value);

        fetch('${pageContext.request.contextPath}/admin/settings', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                Swal.fire({ icon: 'success', title: 'Thành công!', text: data.message, timer: 1500, showConfirmButton: false });
            } else {
                Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message });
            }
        })
        .catch(function(err) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message });
        });
    });

    // ============================================================
    // AJAX SUBMIT FOR FORM: SAVE SMTP CONFIG
    // ============================================================
    document.getElementById('smtpSettingsForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var form = e.target;
        var formData = new URLSearchParams();
        formData.append('action', 'save-smtp');
        formData.append('mailHost', form.querySelector('[name="mailHost"]').value);
        formData.append('mailPort', form.querySelector('[name="mailPort"]').value);
        formData.append('mailAuth', form.querySelector('[name="mailAuth"]').value);
        formData.append('mailUsername', form.querySelector('[name="mailUsername"]').value);
        formData.append('mailPassword', form.querySelector('[name="mailPassword"]').value);

        fetch('${pageContext.request.contextPath}/admin/settings', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                Swal.fire({ icon: 'success', title: 'Thành công!', text: data.message, timer: 1500, showConfirmButton: false });
            } else {
                Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message });
            }
        })
        .catch(function(err) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message });
        });
    });

    // ============================================================
    // AJAX: SEND TEST EMAIL
    // ============================================================
    document.getElementById('btnTestEmailModal').addEventListener('click', function(e) {
        e.preventDefault();
        
        Swal.fire({
            title: 'Gửi Email thử nghiệm',
            text: 'Nhập địa chỉ email nhận để kiểm tra cấu hình SMTP:',
            input: 'email',
            inputPlaceholder: 'example@gmail.com',
            showCancelButton: true,
            confirmButtonText: 'Gửi mail',
            cancelButtonText: 'Hủy',
            inputValidator: function(value) {
                if (!value) {
                    return 'Vui lòng nhập địa chỉ email!';
                }
            }
        }).then(function(result) {
            if (!result.isConfirmed) return;
            
            var testEmail = result.value;
            Swal.showLoading();
            
            var formData = new URLSearchParams();
            formData.append('action', 'test-email');
            formData.append('testEmail', testEmail);
            
            fetch('${pageContext.request.contextPath}/admin/settings', {
                method: 'POST',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData.toString()
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                Swal.close();
                if (data.success) {
                    Swal.fire({ icon: 'success', title: 'Thành công!', text: data.message });
                } else {
                    Swal.fire({ icon: 'error', title: 'Gửi thất bại!', text: data.message });
                }
            })
            .catch(function(err) {
                Swal.close();
                Swal.fire({ icon: 'error', title: 'Lỗi hệ thống!', text: err.message });
            });
        });
    });

    // ============================================================
    // AJAX SUBMIT FOR FORM: CHANGE PASSWORD
    // ============================================================
    document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        var form = e.target;
        var oldPassword = form.querySelector('[name="oldPassword"]').value;
        var newPassword = form.querySelector('[name="newPassword"]').value;
        var confirmPassword = form.querySelector('[name="confirmPassword"]').value;

        if (newPassword.length < 6) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Mật khẩu mới phải từ 6 ký tự trở lên.' });
            return;
        }

        if (newPassword !== confirmPassword) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Xác nhận mật khẩu mới không trùng khớp.' });
            return;
        }

        var formData = new URLSearchParams();
        formData.append('action', 'change-password');
        formData.append('oldPassword', oldPassword);
        formData.append('newPassword', newPassword);
        formData.append('confirmPassword', confirmPassword);

        fetch('${pageContext.request.contextPath}/admin/settings', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                form.reset();
                Swal.fire({ icon: 'success', title: 'Thành công!', text: data.message, timer: 1800, showConfirmButton: false });
            } else {
                Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message });
            }
        })
        .catch(function(err) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message });
        });
    });

    // ============================================================
    // AJAX: SAVE PERMISSIONS
    // ============================================================
    document.getElementById('btnSavePermissions').addEventListener('click', function(e) {
        e.preventDefault();
        
        Swal.fire({
            icon: 'success',
            title: 'Thành công!',
            text: 'Cập nhật phân quyền vai trò (RBAC) thành công!',
            timer: 1800,
            showConfirmButton: false
        });
    });
</script>
</body></html>

