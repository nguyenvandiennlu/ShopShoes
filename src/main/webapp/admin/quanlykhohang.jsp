<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "inventory");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>BHD Sport Admin - Quản lý Kho hàng</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect"/>
<link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
<link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
<!-- Material Symbols -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<style>
    :root {
        --bs-primary: #ff675c;
        --bs-primary-rgb: 255, 103, 92;
        --bs-body-font-family: 'Roboto', sans-serif;
        --heading-font: 'Josefin Sans', sans-serif;
        --bg-color: #f8fafb;
        --sidebar-bg: #101720;
        --sidebar-width: 250px;
        --header-height: 70px;
    }

    body {
        font-family: var(--bs-body-font-family);
        background-color: var(--bg-color);
        overflow-x: hidden;
    }

    h1, h2, h3, h4, h5, h6, .navbar-brand, .font-heading {
        font-family: var(--heading-font);
    }

    .text-primary {
        color: var(--bs-primary) !important;
    }

    .bg-primary {
        background-color: var(--bs-primary) !important;
    }

    .btn-primary {
        background-color: var(--bs-primary);
        border-color: var(--bs-primary);
    }
    .btn-primary:hover {
        background-color: #e55c52;
        border-color: #e55c52;
    }

    /* Sidebar Styles */
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        width: var(--sidebar-width);
        background-color: var(--sidebar-bg);
        color: white;
        z-index: 1000;
        display: flex;
        flex-direction: column;
        border-right: 1px solid #dee2e6;
    }

    .sidebar-header {
        padding: 1.5rem;
    }

    .sidebar-brand {
        font-family: var(--heading-font);
        font-size: 1.5rem;
        font-weight: 600;
        color: white;
        text-decoration: none;
    }

    .sidebar-subtitle {
        font-size: 0.875rem;
        color: #6c757d;
    }

    .sidebar-nav {
        flex-grow: 1;
        padding-left: 0;
        list-style: none;
    }

    .sidebar-link {
        display: flex;
        align-items: center;
        padding: 0.75rem 1.5rem;
        color: #a0a0a0;
        text-decoration: none;
        font-family: var(--heading-font);
        font-weight: 500;
        transition: all 0.2s;
    }

    .sidebar-link:hover, .sidebar-link.active {
        color: white;
        background-color: rgba(255, 255, 255, 0.05);
    }

    .sidebar-link.active {
        border-left: 4px solid var(--bs-primary);
        background-color: rgba(255, 255, 255, 0.1);
    }

    .sidebar-link .material-symbols-outlined {
        margin-right: 0.75rem;
    }

    .sidebar-footer {
        padding: 1.5rem;
    }

    /* Header Styles */
    .header {
        position: fixed;
        top: 0;
        right: 0;
        width: calc(100% - var(--sidebar-width));
        height: var(--header-height);
        background-color: white;
        border-bottom: 1px solid #dee2e6;
        z-index: 999;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 2rem;
    }

    .search-bar {
        background-color: #f0f2f3;
        border-radius: 50rem;
        padding: 0.5rem 1rem;
        display: flex;
        align-items: center;
        width: 100%;
        max-width: 400px;
    }

    .search-bar input {
        border: none;
        background: transparent;
        outline: none;
        width: 100%;
        margin-left: 0.5rem;
    }

    /* Main Content */
    .main-content {
        margin-left: var(--sidebar-width);
        margin-top: var(--header-height);
        padding: 2rem;
        min-height: calc(100vh - var(--header-height));
    }

    .card-custom {
        background: white;
        border-radius: 0.5rem;
        border: 1px solid #dee2e6;
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        margin-bottom: 2rem;
    }

    .table-custom th {
        font-family: var(--heading-font);
        font-size: 13px;
        text-transform: uppercase;
        color: #6c757d;
        font-weight: 700;
        border-top: none;
    }

    .table-custom td {
        vertical-align: middle;
    }

    .product-img {
        width: 48px;
        height: 48px;
        object-fit: cover;
        border-radius: 0.25rem;
        border: 1px solid #dee2e6;
    }

    .badge-status {
        font-weight: 600;
        padding: 0.4em 0.8em;
    }

    .action-btns .btn {
        padding: 0.25rem 0.5rem;
        color: #6c757d;
    }

    .action-btns .btn:hover {
        color: var(--bs-primary);
        background-color: #f8f9fa;
    }

    .color-dot {
        width: 16px;
        height: 16px;
        border-radius: 50%;
        display: inline-block;
        border: 1px solid #dee2e6;
    }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- Sidebar -->
<nav class="sidebar">
    <div class="sidebar-header">
        <a class="sidebar-brand d-block" href="${pageContext.request.contextPath}/admin/adminHome.jsp">BHD Sport</a>
        <span class="sidebar-subtitle">Admin Panel</span>
    </div>
    <ul class="sidebar-nav">
        <li class="">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                Bảng điều khiển
            </a>
        </li>
        <li class="">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                <span class="material-symbols-outlined">shopping_cart</span>
                Đơn hàng
            </a>
        </li>
        <li class="">
            <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">inventory_2</span>
                Kho hàng
            </a>
        </li>
        <li class="">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/quanlykhachhang.jsp">
                <span class="material-symbols-outlined">group</span>
                Khách hàng
            </a>
        </li>
        <li class="">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                <span class="material-symbols-outlined">analytics</span>
                Báo cáo
            </a>
        </li>
        <li class="">
            <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
                <span class="material-symbols-outlined">settings</span>
                Cài đặt
            </a>
        </li>
    </ul>
    <div class="sidebar-footer"><a class="btn btn-bittersweet w-100 py-2 d-flex align-items-center justify-content-center gap-2 mb-3" href="${pageContext.request.contextPath}/admin/addproduct.jsp" style="background-color: var(--bs-primary); border-color: var(--bs-primary); color: white; font-family: var(--heading-font); font-weight: 600;">
        <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
        Thêm sản phẩm mới
    </a>
        <a class="nav-link d-flex align-items-center px-0" href="${pageContext.request.contextPath}/logout" style="color: rgb(160, 160, 160); font-family: var(--heading-font); font-weight: 500;">
            <span class="material-symbols-outlined me-2">logout</span>
            Đăng xuất
        </a></div>
</nav>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- Header -->
<header class="header">
    <div class="search-bar">
        <span class="material-symbols-outlined text-muted">search</span>
        <input placeholder="Tìm kiếm nhanh..." type="text">
    </div>
    <div class="d-flex align-items-center gap-3">
        <button class="btn btn-link text-muted p-0 position-relative">
            <span class="material-symbols-outlined">notifications</span>
            <span class="position-absolute top-0 start-100 translate-middle p-1 bg-primary border border-light rounded-circle">
<span class="visually-hidden">New alerts</span>
</span>
        </button>
        <button class="btn btn-link text-muted p-0">
            <span class="material-symbols-outlined">account_circle</span>
        </button>
    </div>
</header>
--%>
<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb & Title -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a class="text-decoration-none text-muted" href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                <li aria-current="page" class="breadcrumb-item active">Kho hàng</li>
            </ol>
        </nav>
        <h1 class="font-heading fw-bold mb-0">Quản lý Kho hàng</h1>
    </div>
    <!-- Filters -->
    <div class="card-custom p-4 mb-4">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label font-heading fw-semibold text-muted small">Tên / Mã sản phẩm</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><span class="material-symbols-outlined fs-6">search</span></span>
                    <input class="form-control border-start-0 ps-0" placeholder="Nhập từ khóa..." type="text">
                </div>
            </div>
            <div class="col-md-3">
                <label class="form-label font-heading fw-semibold text-muted small">Danh mục</label>
                <select class="form-select">
                    <option value="">Tất cả danh mục</option>
                    <option value="running">Giày chạy bộ</option>
                    <option value="training">Giày tập luyện</option>
                    <option value="football">Giày bóng đá</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label font-heading fw-semibold text-muted small">Trạng thái tồn kho</label>
                <select class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="instock">Còn hàng</option>
                    <option value="lowstock">Sắp hết</option>
                    <option value="outstock">Hết hàng</option>
                </select>
            </div>
            <div class="col-md-2">
                <button class="btn btn-light border w-100 d-flex align-items-center justify-content-center gap-2 font-heading fw-semibold">
                    <span class="material-symbols-outlined fs-6">filter_list</span> Lọc
                </button>
            </div>
        </div>
    </div>
    <!-- Data Table -->
    <div class="card-custom">
        <div class="table-responsive">
            <table class="table table-hover table-custom mb-0">
                <thead class="table-light">
                <tr>
                    <th class="py-3 px-4">#</th>
                    <th class="py-3 px-4">Ảnh</th>
                    <th class="py-3 px-4">Tên sản phẩm</th>
                    <th class="py-3 px-4">Size</th>
                    <th class="py-3 px-4">Màu</th>
                    <th class="py-3 px-4 text-end">Tồn kho</th>
                    <th class="py-3 px-4 text-end">Giá bán</th>
                    <th class="py-3 px-4">Trạng thái</th>
                    <th class="py-3 px-4 text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="py-3 px-4 text-muted">1</td>
                    <td class="py-3 px-4">
                        <img alt="Shoe" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA5V2loONY-d4ifWXL_1dW7Ekz7utVQ2tvAa_YRcoZ-dZcBAfHCqIw3M5kX1AuNsm88pC5BvYD1GYIMyGCldC9516tbyclM3es1Y8bIobB_wjrLScruA9WwrJbIvU5ckth4m1nxrkxHSnn4IjStKxcsppTFlaG7dnocUX1hraIm-O_BY_ZNxGUvOnFv9e42phoJMyQR5t3yumlKf9Dra5SO4QBYjHWQlMx-Vp8PMAzTosdmfSrB2FUtS-nqtARC7uPJdOZq-qIsu8RP">
                    </td>
                    <td class="py-3 px-4">
                        <div class="font-heading fw-semibold text-dark">Nike Air Zoom Pegasus 39</div>
                        <div class="small text-muted mt-1">SP-NKE-001</div>
                    </td>
                    <td class="py-3 px-4">42</td>
                    <td class="py-3 px-4">
                        <div class="d-flex align-items-center gap-2">
                            <span class="color-dot bg-danger"></span> Đỏ
                        </div>
                    </td>
                    <td class="py-3 px-4 text-end fw-medium">124</td>
                    <td class="py-3 px-4 text-end">2,850,000 ₫</td>
                    <td class="py-3 px-4">
                        <span class="badge rounded-pill bg-success bg-opacity-25 text-success badge-status">Còn hàng</span>
                    </td>
                    <td class="py-3 px-4 text-center action-btns">
                        <button class="btn btn-link border-0 p-1" title="Sửa"><span class="material-symbols-outlined fs-5">edit</span></button>
                        <button class="btn btn-link border-0 p-1" title="Nhập thêm hàng"><span class="material-symbols-outlined fs-5">add_shopping_cart</span></button>
                    </td>
                </tr>
                <tr>
                    <td class="py-3 px-4 text-muted">2</td>
                    <td class="py-3 px-4">
                        <img alt="Shoe" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCpTDL88Hg9NjybIuXg3QMPzPuuFutrbT0ylrRDXiWp0JjD4rpbNGhXWCIupuK-2lPkhjB_8PIjZsqETliTHM9M-TirAsZz0Lc0mYzNqlSGYRVWM4b5S_Lx4R4MQ9mUPveo7iyebjl9_hH2SwGzouVnud_KP0Cv1y5jdwIt0YyoWpSnGzgT38HKCw-82w0xitjXoIccjGLrRJYzsr_dz5m3I5FiSPGui9upcNxN8oqqNCnfGy6_f5D3gjwQRl7IudySSs3R_5fJ-s2k">
                    </td>
                    <td class="py-3 px-4">
                        <div class="font-heading fw-semibold text-dark">Adidas Ultraboost 22</div>
                        <div class="small text-muted mt-1">SP-ADD-045</div>
                    </td>
                    <td class="py-3 px-4">40</td>
                    <td class="py-3 px-4">
                        <div class="d-flex align-items-center gap-2">
                            <span class="color-dot bg-dark"></span> Đen
                        </div>
                    </td>
                    <td class="py-3 px-4 text-end fw-medium text-danger">8</td>
                    <td class="py-3 px-4 text-end">4,200,000 ₫</td>
                    <td class="py-3 px-4">
                        <span class="badge rounded-pill bg-warning bg-opacity-25 text-warning badge-status" style="color: #856404!important;">Sắp hết</span>
                    </td>
                    <td class="py-3 px-4 text-center action-btns">
                        <button class="btn btn-link border-0 p-1" title="Sửa"><span class="material-symbols-outlined fs-5">edit</span></button>
                        <button class="btn btn-link border-0 p-1" title="Nhập thêm hàng"><span class="material-symbols-outlined fs-5">add_shopping_cart</span></button>
                    </td>
                </tr>
                <tr>
                    <td class="py-3 px-4 text-muted">3</td>
                    <td class="py-3 px-4">
                        <div class="product-img bg-light d-flex align-items-center justify-content-center text-muted">
                            <span class="material-symbols-outlined">image</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-muted">
                        <div class="font-heading fw-semibold">Puma RS-X³ Puzzle</div>
                        <div class="small mt-1">SP-PMA-012</div>
                    </td>
                    <td class="py-3 px-4 text-muted">41</td>
                    <td class="py-3 px-4 text-muted">
                        <div class="d-flex align-items-center gap-2">
                            <span class="color-dot bg-primary"></span> Xanh
                        </div>
                    </td>
                    <td class="py-3 px-4 text-end fw-bold text-danger">0</td>
                    <td class="py-3 px-4 text-end text-muted">2,100,000 ₫</td>
                    <td class="py-3 px-4">
                        <span class="badge rounded-pill bg-danger bg-opacity-25 text-danger badge-status">Hết hàng</span>
                    </td>
                    <td class="py-3 px-4 text-center action-btns">
                        <button class="btn btn-link border-0 p-1" title="Sửa"><span class="material-symbols-outlined fs-5">edit</span></button>
                        <button class="btn btn-link border-0 p-1" title="Nhập thêm hàng"><span class="material-symbols-outlined fs-5">add_shopping_cart</span></button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <!-- Pagination -->
        <div class="card-footer bg-white border-top py-3 px-4 d-flex align-items-center justify-content-between">
            <span class="text-muted small">Hiển thị 1 - 3 của 45 sản phẩm</span>
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item disabled">
                        <a aria-label="Previous" class="page-link border-0 text-muted" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_left</span>
                        </a>
                    </li>
                    <li aria-current="page" class="page-item active"><a class="page-link border-0 rounded mx-1 bg-primary text-white font-heading" href="${pageContext.request.contextPath}/admin/adminHome.jsp">1</a></li>
                    <li class="page-item"><a class="page-link border-0 rounded mx-1 text-dark font-heading" href="${pageContext.request.contextPath}/admin/adminHome.jsp">2</a></li>
                    <li class="page-item"><a class="page-link border-0 rounded mx-1 text-dark font-heading" href="${pageContext.request.contextPath}/admin/adminHome.jsp">3</a></li>
                    <li class="page-item">
                        <a aria-label="Next" class="page-link border-0 text-muted" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                            <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_right</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</main>
<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>






</body></html>

