<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="utils.EmailConfigLoader" %>
<%@ page import="model.user.User" %>
<%
    request.setAttribute("adminActive", "settings");
    User currentUser = (User) session.getAttribute("currentUser");
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

    #permission-roles-list .list-group-item.active {
        background-color: var(--bittersweet) !important;
        border-color: var(--bittersweet) !important;
        color: white !important;
    }
    #permissions-matrix-table .form-check-input:checked {
        background-color: var(--bittersweet) !important;
        border-color: var(--bittersweet) !important;
    }
    #permissions-matrix-table .form-check-input:focus {
        border-color: var(--bittersweet-hover) !important;
        box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25) !important;
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
                    <% if (currentUser != null && currentUser.getFirebaseUID() != null && !currentUser.getFirebaseUID().isBlank()) { %>
                        <div class="alert alert-info d-flex align-items-center gap-3 mt-4" role="alert" style="background-color: #e8f4fd; border: 1px solid #b3d7f7; color: #1d548f; border-radius: 8px;">
                            <span class="material-symbols-outlined text-info" style="font-size: 32px; color: #1d548f !important;">info</span>
                            <div>
                                <h5 class="alert-heading font-heading mb-1" style="font-weight: 600; color: #1d548f;">Tài khoản đăng nhập bằng Google</h5>
                                <p class="mb-0" style="font-size: 13px;">Tài khoản quản trị của bạn hiện đang liên kết và đăng nhập thông qua Google OAuth2. Bạn không có mật khẩu cục bộ trên hệ thống này và không thể đổi mật khẩu tại đây.</p>
                            </div>
                        </div>
                    <% } else { %>
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
                    <% } %>
                </div>

                <!-- Permissions Management Card -->
                <div class="card p-4 p-md-5 mb-4 left-border-indicator settings-card d-none" id="permissions-card">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-secondary-custom">admin_panel_settings</span>
                        Quản lý phân quyền (RBAC)
                    </h3>
                    <p class="text-secondary mb-4" style="font-size: 13px;">Thiết lập và phân quyền chi tiết cho từng nhóm vai trò truy cập hệ thống quản trị.</p>
                    
                    <div class="row g-4">
                        <!-- Left Column: Role List Selector -->
                        <div class="col-md-4 col-lg-3">
                            <div class="list-group" id="permission-roles-list">
                                <button type="button" class="list-group-item list-group-item-action disabled bg-light text-muted py-2" style="cursor: not-allowed;" title="Chủ cửa hàng - Toàn quyền hệ thống">
                                    <small class="text-uppercase fw-bold d-block text-secondary" style="font-size: 9px; letter-spacing: 0.5px;">Hệ thống (Toàn quyền)</small>
                                    Super Admin
                                </button>
                                <button type="button" class="list-group-item list-group-item-action disabled bg-light text-muted py-2" style="cursor: not-allowed;" title="Quản trị viên vận hành - Full quyền trừ Cài đặt">
                                    <small class="text-uppercase fw-bold d-block text-secondary" style="font-size: 9px; letter-spacing: 0.5px;">Hệ thống (Quản lý vận hành)</small>
                                    Admin
                                </button>
                                <button type="button" class="list-group-item list-group-item-action active fw-semibold" data-role="SALES_STAFF">
                                    Nhân viên đơn hàng
                                </button>
                                <button type="button" class="list-group-item list-group-item-action fw-semibold" data-role="WAREHOUSE_STAFF">
                                    Nhân viên kho
                                </button>
                                <button type="button" class="list-group-item list-group-item-action disabled bg-light text-muted py-2" style="cursor: not-allowed;" title="Khách hàng mua sắm - Không được phép truy cập Admin">
                                    <small class="text-uppercase fw-bold d-block text-secondary" style="font-size: 9px; letter-spacing: 0.5px;">Client-side (Không có quyền)</small>
                                    Khách hàng (User)
                                </button>
                            </div>
                        </div>

                        <!-- Right Column: Checkbox Matrix -->
                        <div class="col-md-8 col-lg-9">
                            <div class="p-3 border rounded bg-white shadow-sm">
                                <h4 class="fs-6 fw-bold mb-3 text-dark border-bottom pb-2" id="selected-role-title">
                                    Cấu hình quyền: Nhân viên đơn hàng
                                </h4>
                                
                                <div class="table-responsive">
                                    <table class="table align-middle table-hover" id="permissions-matrix-table" style="font-size:14px;">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="35%">Danh mục quản lý</th>
                                                <th width="65%">Hành động cho phép</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Row: Dashboard -->
                                            <tr data-module="dashboard">
                                                <td class="fw-semibold">Tổng quan</td>
                                                <td>
                                                    <div class="form-check form-check-inline">
                                                        <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="db_view">
                                                        <label class="form-check-label" for="db_view">Xem</label>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Row: Statistics -->
                                            <tr data-module="statistics">
                                                <td class="fw-semibold">Thống kê / Báo cáo</td>
                                                <td>
                                                    <div class="form-check form-check-inline">
                                                        <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="stats_view">
                                                        <label class="form-check-label" for="stats_view">Xem</label>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Row: Orders -->
                                            <tr data-module="orders">
                                                <td class="fw-semibold">Quản lý đơn hàng</td>
                                                <td>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="ord_view">
                                                            <label class="form-check-label" for="ord_view">Xem</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="2" id="ord_add">
                                                            <label class="form-check-label" for="ord_add">Thêm</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="4" id="ord_edit">
                                                            <label class="form-check-label" for="ord_edit">Sửa</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="8" id="ord_delete">
                                                            <label class="form-check-label" for="ord_delete">Khóa/Xóa</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Row: Products -->
                                            <tr data-module="products">
                                                <td class="fw-semibold">Quản lý sản phẩm & Kho</td>
                                                <td>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="prod_view">
                                                            <label class="form-check-label" for="prod_view">Xem</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="2" id="prod_add">
                                                            <label class="form-check-label" for="prod_add">Thêm</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="4" id="prod_edit">
                                                            <label class="form-check-label" for="prod_edit">Sửa</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="8" id="prod_delete">
                                                            <label class="form-check-label" for="prod_delete">Khóa/Xóa</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Row: Users -->
                                            <tr data-module="users">
                                                <td class="fw-semibold">Quản lý khách hàng & nhân viên</td>
                                                <td>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="usr_view">
                                                            <label class="form-check-label" for="usr_view">Xem</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="2" id="usr_add">
                                                            <label class="form-check-label" for="usr_add">Thêm</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="4" id="usr_edit">
                                                            <label class="form-check-label" for="usr_edit">Sửa</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="8" id="usr_delete">
                                                            <label class="form-check-label" for="usr_delete">Khóa/Xóa</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <!-- Row: Settings -->
                                            <tr data-module="settings">
                                                <td class="fw-semibold">Cài đặt hệ thống</td>
                                                <td>
                                                    <div class="d-flex flex-wrap gap-3">
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="1" id="set_view">
                                                            <label class="form-check-label" for="set_view">Xem</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="2" id="set_add">
                                                            <label class="form-check-label" for="set_add">Thêm</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="4" id="set_edit">
                                                            <label class="form-check-label" for="set_edit">Sửa</label>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input perm-cb" type="checkbox" data-mask="8" id="set_delete">
                                                            <label class="form-check-label" for="set_delete">Khóa/Xóa</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="d-flex justify-content-end mt-3 border-top pt-3">
                                    <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm" type="button" id="btnSavePermissions">
                                        <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                                        Lưu phân quyền
                                    </button>
                                </div>
                            </div>
                        </div>
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

    let activePermissionRole = "SALES_STAFF";

    const rolePermissionsData = {
        "SALES_STAFF": {
            "dashboard": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("dashboard", 0) : 0 %>,
            "statistics": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("statistics", 0) : 0 %>,
            "orders": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("orders", 0) : 0 %>,
            "products": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("products", 0) : 0 %>,
            "users": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("users", 0) : 0 %>,
            "settings": <%= request.getAttribute("salesPermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("salesPermissions")).getOrDefault("settings", 0) : 0 %>
        },
        "WAREHOUSE_STAFF": {
            "dashboard": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("dashboard", 0) : 0 %>,
            "statistics": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("statistics", 0) : 0 %>,
            "orders": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("orders", 0) : 0 %>,
            "products": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("products", 0) : 0 %>,
            "users": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("users", 0) : 0 %>,
            "settings": <%= request.getAttribute("warehousePermissions") != null ? ((java.util.Map<String, Integer>)request.getAttribute("warehousePermissions")).getOrDefault("settings", 0) : 0 %>
        }
    };

    function renderPermissions(role) {
        activePermissionRole = role;
        const perms = rolePermissionsData[role] || {};
        
        const roleTitles = {
            "SALES_STAFF": "Nhân viên đơn hàng (CSKH)",
            "WAREHOUSE_STAFF": "Nhân viên kho"
        };
        document.getElementById("selected-role-title").textContent = "Cấu hình quyền: " + (roleTitles[role] || role);

        document.querySelectorAll("#permissions-matrix-table tbody tr").forEach(function(row) {
            const moduleName = row.getAttribute("data-module");
            const bitmask = perms[moduleName] || 0;

            row.querySelectorAll(".perm-cb").forEach(function(cb) {
                const mask = parseInt(cb.getAttribute("data-mask"));
                cb.checked = (bitmask & mask) === mask;
            });
        });
    }

    document.querySelectorAll("#permission-roles-list button").forEach(function(btn) {
        btn.addEventListener("click", function(e) {
            e.preventDefault();
            
            document.querySelectorAll("#permission-roles-list button").forEach(function(b) {
                b.classList.remove("active");
            });
            btn.classList.add("active");
            
            const role = btn.getAttribute("data-role");
            renderPermissions(role);
        });
    });

    renderPermissions("SALES_STAFF");

    document.getElementById('btnSavePermissions').addEventListener('click', function(e) {
        e.preventDefault();
        
        const dataToSave = {
            action: "save-permissions",
            role: activePermissionRole
        };

        document.querySelectorAll("#permissions-matrix-table tbody tr").forEach(function(row) {
            const moduleName = row.getAttribute("data-module");
            let moduleBitmaskSum = 0;

            row.querySelectorAll(".perm-cb").forEach(function(cb) {
                if (cb.checked) {
                    moduleBitmaskSum += parseInt(cb.getAttribute("data-mask"));
                }
            });
            dataToSave[moduleName] = moduleBitmaskSum;
        });

        const params = new URLSearchParams();
        for (const key in dataToSave) {
            params.append(key, dataToSave[key]);
        }

        Swal.fire({
            title: 'Đang xử lý...',
            html: 'Đang lưu phân quyền vào cơ sở dữ liệu.',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });

        fetch('${pageContext.request.contextPath}/admin/settings', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            Swal.close();
            if (data.success) {
                rolePermissionsData[activePermissionRole] = {
                    dashboard: dataToSave.dashboard,
                    statistics: dataToSave.statistics,
                    orders: dataToSave.orders,
                    products: dataToSave.products,
                    users: dataToSave.users,
                    settings: dataToSave.settings
                };

                Swal.fire({
                    icon: 'success',
                    title: 'Thành công!',
                    text: data.message,
                    timer: 1800,
                    showConfirmButton: false
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại!',
                    text: data.message
                });
            }
        })
        .catch(function(err) {
            Swal.close();
            Swal.fire({
                icon: 'error',
                title: 'Lỗi hệ thống!',
                text: err.message
            });
        });
    });
</script>
</body></html>

