<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span class="material-symbols-outlined">tune</span>
                            Cài đặt chung
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span class="material-symbols-outlined">mail</span>
                            Cấu hình Email
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span class="material-symbols-outlined">admin_panel_settings</span>
                            Quản lý quyền
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span class="material-symbols-outlined">storefront</span>
                            Thông tin Shop
                        </a>
                    </nav>
                </div>
            </div>
            <!-- Right Column: Settings Forms -->
            <div class="col-12 col-lg-9">
                <!-- General Settings Card -->
                <div class="card p-4 p-md-5 mb-4 top-gradient-border">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-bittersweet">tune</span>
                        Cài đặt chung
                    </h3>
                    <form class="row g-4">
                        <!-- Logo Upload -->
                        <div class="col-12 mb-2">
                            <label class="form-label">Logo hệ thống</label>
                            <div class="logo-upload-container">
                                <div class="logo-preview">
                                    <img alt="Abstract modern logo concept" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAuOaCTIh8hRyZ-X3eDzUVRdxebzfq8qHd2fYg2pWUuhwMj29tjX_4ErvxkBsgewrBhTK7dGAWgee-RP8UsWBkzS_y0IjL2N_-zPRPALSjhnzlXl_iRi_S37jrqP3kgZ2ChwUDQqMusROFcexR3430KmNQpwJMydm-ovfybuyBEDEi2Vq8BoHCCZ6GTNIDGwY2hPGBqkmjWhjrE8g88MKvxoYQg1-dBLS83wrE4KOPb_fHlFjYhIMZ7CMcbt4Y54UCGFjJWV495n-L3">
                                </div>
                                <button class="btn-upload" type="button">
                                    <span class="material-symbols-outlined">upload</span>
                                    Tải ảnh lên
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên cửa hàng <span class="text-error">*</span></label>
                            <input class="form-control" type="text" value="BHD Sport Shoes">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Hotline <span class="text-error">*</span></label>
                            <input class="form-control" type="text" value="0123.456.789">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Địa chỉ</label>
                            <input class="form-control" type="text" value="123 Đường Thể Thao, Quận 1, TP. Hồ Chí Minh">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Email liên hệ</label>
                            <input class="form-control" type="email" value="contact@bhdsport.vn">
                        </div>
                    </form>
                </div>
                <!-- Email Config Card -->
                <div class="card p-4 p-md-5 mb-4 left-border-indicator">
                    <h3 class="card-header-custom">
                        <span class="material-symbols-outlined text-secondary-custom">mail</span>
                        Cấu hình Email (SMTP)
                    </h3>
                    <form class="row g-4">
                        <div class="col-12">
                            <label class="form-label">SMTP Host</label>
                            <input class="form-control" type="text" value="smtp.gmail.com">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">SMTP Port</label>
                            <input class="form-control" type="text" value="587">
                        </div>
                        <div class="col-md-6 d-none d-md-block"></div>
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <input class="form-control" type="text" value="admin@bhdsport.vn">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Password</label>
                            <div class="password-input-group">
                                <input class="form-control pe-5" type="password" value="********">
                                <button class="toggle-password" type="button">
                                    <span class="material-symbols-outlined" style="font-size: 20px;">visibility_off</span>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
                <!-- Action Area -->
                <div class="d-flex justify-content-end mb-4">
                    <button class="btn btn-bittersweet px-4 py-2 d-flex align-items-center gap-2 shadow-sm">
                        <span class="material-symbols-outlined" style="font-size: 20px;">save</span>
                        Lưu cài đặt
                    </button>
                </div>
            </div>
        </div>
    </main>
</div>
<!-- Bootstrap 5 JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>






</body></html>

