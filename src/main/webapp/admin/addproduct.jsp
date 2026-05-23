<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "add-product");
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Thêm sản phẩm mới - BHD Sport Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bs-primary: #FF675C; /* Bittersweet */
            --bs-primary-rgb: 255, 103, 92;
            --surface-bright: #f8fafb;
            --rich-black: #101720;
            --gainsboro: #DCDCDC;
            --cultured: #F0F2F3;
            --on-surface: #191c1d;
            --secondary-text: #585f6a;
            --error: #ba1a1a;
            --bs-body-font-family: 'Roboto', sans-serif;
        }

        body {
            background-color: var(--cultured);
            color: var(--on-surface);
            font-family: var(--bs-body-font-family);
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6, .font-heading {
            font-family: 'Josefin Sans', sans-serif;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        .icon-fill {
            font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        /* Custom Colors & Utilities */
        .text-primary-custom { color: var(--bs-primary); }
        .bg-primary-custom { background-color: var(--bs-primary); color: white; }
        .btn-primary-custom {
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
            color: white;
        }
        .btn-primary-custom:hover {
            background-color: #FF756B; /* Salmon */
            border-color: #FF756B;
            color: white;
        }
        .text-error { color: var(--error); }
        .bg-surface { background-color: white; }
        .bg-sidebar { background-color: var(--rich-black); }
        .text-sidebar-muted { color: #a0a0a0; }
        .sidebar-link {
            color: var(--text-sidebar-muted);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            border-radius: 0.25rem;
            transition: all 0.2s;
            font-family: 'Josefin Sans', sans-serif;
            font-size: 16px;
            font-weight: 500;
        }
        .sidebar-link:hover {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .sidebar-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.05);
            border-left: 4px solid var(--bs-primary);
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1040;
            padding-top: 1.5rem;
            display: flex;
            flex-direction: column;
        }
        .topbar {
            height: 70px;
            width: calc(100% - 250px);
            position: fixed;
            top: 0;
            right: 0;
            z-index: 1030;
            background-color: white;
            border-bottom: 1px solid var(--gainsboro);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
        }
        .main-content {
            margin-left: 250px;
            margin-top: 70px;
            padding: 2rem;
        }

        .card-custom {
            background-color: white;
            border-radius: 0.5rem;
            border: 1px solid var(--gainsboro);
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-control, .form-select {
            background-color: var(--surface-bright);
            border-color: var(--gainsboro);
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--bs-primary);
            box-shadow: 0 0 0 0.25rem rgba(var(--bs-primary-rgb), 0.25);
        }

        .upload-area {
            border: 2px dashed var(--gainsboro);
            border-radius: 0.5rem;
            background-color: var(--surface-bright);
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        .upload-area:hover {
            border-color: var(--bs-primary);
        }
        .upload-area:hover .material-symbols-outlined,
        .upload-area:hover p {
            color: var(--bs-primary) !important;
        }

        .upload-area-sm {
            aspect-ratio: 1;
            border: 1px dashed var(--gainsboro);
            border-radius: 0.5rem;
            background-color: var(--surface-bright);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        .upload-area-sm:hover {
            border-color: var(--bs-primary);
        }
        .upload-area-sm:hover .material-symbols-outlined {
            color: var(--bs-primary) !important;
        }

        .table > :not(caption) > * > * {
            padding: 0.75rem 1rem;
        }
        .table-header-custom th {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 13px;
            font-weight: 700;
            color: var(--secondary-text);
            text-transform: uppercase;
            border-bottom-width: 1px;
        }

        .breadcrumb-item a {
            color: var(--secondary-text);
            text-decoration: none;
        }
        .breadcrumb-item a:hover {
            color: var(--bs-primary);
        }
        .breadcrumb-item.active {
            color: var(--on-surface);
        }
        .breadcrumb-item + .breadcrumb-item::before {
            content: "\e5cc"; /* chevron_right */
            font-family: 'Material Symbols Outlined';
            vertical-align: middle;
            color: var(--secondary-text);
            font-size: 18px;
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- SideNavBar -->
<nav class="sidebar bg-sidebar">
    <div class="px-4 mb-4 text-center">
        <h1 class="font-heading text-white text-uppercase fs-4 fw-semibold tracking-wider mb-0">BHD Sport</h1>
        <p class="text-sidebar-muted small mb-0">Admin Panel</p>
    </div>
    <div class="px-3 mb-4">
        <button class="btn btn-primary-custom w-100 d-flex align-items-center justify-content-center gap-2 fw-semibold" style="font-family: 'Josefin Sans', sans-serif;">
            <span class="material-symbols-outlined fs-5">add</span> Thêm sản phẩm mới
        </button>
    </div>
    <ul class="nav flex-column flex-grow-1 px-2 gap-1">
        <li class="nav-item">
            <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Bảng điều khiển</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
                <span class="material-symbols-outlined">shopping_cart</span>
                <span>Đơn hàng</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
                <span class="material-symbols-outlined">inventory_2</span>
                <span>Kho hàng</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/admin/quanlykhachhang.jsp">
                <span class="material-symbols-outlined">group</span>
                <span>Khách hàng</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                <span class="material-symbols-outlined">assessment</span>
                <span>Báo cáo</span>
            </a>
        </li>
        <li class="nav-item">
            <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
                <span class="material-symbols-outlined">settings</span>
                <span>Cài đặt</span>
            </a>
        </li>
    </ul>
    <div class="px-2 mt-auto mb-3">
        <a class="sidebar-link text-sidebar-muted" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</nav>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- TopNavBar -->
<header class="topbar">
    <div class="d-flex align-items-center">
        <!-- Search on left -->
        <div class="position-relative">
            <span class="material-symbols-outlined position-absolute top-50 start-0 translate-middle-y ms-3 text-secondary">search</span>
            <input class="form-control ps-5" placeholder="Tìm kiếm..." style="width: 250px;" type="text"/>
        </div>
    </div>
    <div class="d-flex align-items-center gap-4">
        <div class="d-flex gap-3">
            <button class="btn btn-link text-secondary p-0 text-decoration-none hover-primary">
                <span class="material-symbols-outlined">notifications</span>
            </button>
            <button class="btn btn-link text-secondary p-0 text-decoration-none hover-primary">
                <span class="material-symbols-outlined">help</span>
            </button>
        </div>
        <div class="vr bg-secondary" style="height: 32px;"></div>
        <div class="d-flex align-items-center gap-2" role="button">
            <div class="rounded-circle bg-secondary overflow-hidden border border-secondary" style="width: 40px; height: 40px;">
                <img alt="Admin User Profile" class="w-100 h-100 object-fit-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA-T4cgk4BFp_A1VS2tPgZj0GiCl-TbvP6BHjdQmbNDWrItZ9NpGz4QgjeOTijV2cHIHj3unV3FNzvjHvQEPdNy3Ttas7qiixFtIi8VuT1SgKzR2cowIQZ8pxO2WpCkiNZoQCM0f_GzbII5pC4MsuKxmZmpCdFHsLMsFaZOXC_43DcQTxPeA6se0wzJU7RWYfC9_CAz5KeDZd3H9ZdU8Y_ZAsRRBJHom8ohAg4vk5ybRJzLcjZJDN4vVKUhZOjkslU3iQ3gEzEpHEhw"/>
            </div>
            <div class="d-flex flex-column">
                <span class="fw-semibold font-heading" style="font-size: 14px;">Quản trị viên</span>
                <span class="text-secondary" style="font-size: 12px;">Quản lý</span>
            </div>
        </div>
    </div>
</header>
--%>
<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb & Title -->
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-2 small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">Quản lý Sản phẩm</a></li>
                <li aria-current="page" class="breadcrumb-item active">Thêm mới</li>
            </ol>
        </nav>
        <h2 class="font-heading fw-semibold mb-0 fs-3">Thêm sản phẩm mới</h2>
    </div>
    <form action="#" method="POST">
        <div class="row g-4">
            <!-- Left Column (Main Info & Variants) -->
            <div class="col-lg-8">
                <!-- 1. Thông tin cơ bản -->
                <div class="card-custom">
                    <h3 class="font-heading fw-semibold fs-5 mb-4 pb-3 border-bottom">Thông tin cơ bản</h3>
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label font-heading fw-semibold mb-1" for="product_name">Tên sản phẩm <span class="text-error">*</span></label>
                            <input class="form-control" id="product_name" name="product_name" placeholder="Nhập tên sản phẩm" type="text"/>
                        </div>
                        <div class="col-12">
                            <label class="form-label font-heading fw-semibold mb-1" for="description">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" placeholder="Nhập mô tả sản phẩm" rows="4"></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label font-heading fw-semibold mb-1" for="price">Giá (VNĐ) <span class="text-error">*</span></label>
                            <input class="form-control" id="price" name="price" placeholder="0" type="number"/>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label font-heading fw-semibold mb-1" for="brand">Thương hiệu</label>
                            <select class="form-select" id="brand" name="brand">
                                <option value="">Chọn thương hiệu</option>
                                <option value="nike">Nike</option>
                                <option value="adidas">Adidas</option>
                                <option value="puma">Puma</option>
                            </select>
                        </div>
                        <div class="col-md-6 pt-2">
                            <label class="form-label font-heading fw-semibold mb-1" for="status">Trạng thái</label>
                            <select class="form-select" id="status" name="status">
                                <option value="active">Đang bán</option>
                                <option value="inactive">Ngừng bán</option>
                            </select>
                        </div>
                        <div class="col-md-6 pt-2 d-flex align-items-end pb-2">
                            <div class="form-check">
                                <input class="form-check-input" id="discontinued" name="discontinued" type="checkbox"/>
                                <label class="form-check-label" for="discontinued">
                                    Đánh dấu ngừng bán toàn bộ
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 2. Biến thể sản phẩm (Variants) -->
                <div class="card-custom">
                    <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                        <h3 class="font-heading fw-semibold fs-5 mb-0">Biến thể sản phẩm</h3>
                        <button class="btn btn-link text-primary-custom text-decoration-none p-0 font-heading fw-semibold d-flex align-items-center gap-1" type="button">
                            <span class="material-symbols-outlined fs-5">add_circle</span>
                            Thêm biến thể
                        </button>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead>
                            <tr class="table-header-custom">
                                <th>Size</th>
                                <th>Màu sắc</th>
                                <th>Tồn kho</th>
                                <th class="text-center">Ngừng bán</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td>
                                    <select class="form-select form-select-sm">
                                        <option>40</option>
                                        <option>41</option>
                                        <option>42</option>
                                    </select>
                                </td>
                                <td>
                                    <select class="form-select form-select-sm">
                                        <option>Đen</option>
                                        <option>Trắng</option>
                                        <option>Đỏ</option>
                                    </select>
                                </td>
                                <td>
                                    <input class="form-control form-control-sm" style="width: 80px;" type="number" value="10"/>
                                </td>
                                <td class="text-center">
                                    <input class="form-check-input" type="checkbox"/>
                                </td>
                                <td class="text-end">
                                    <button class="btn btn-link text-secondary p-0 text-decoration-none" type="button">
                                        <span class="material-symbols-outlined fs-5">delete</span>
                                    </button>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Right Column (Images & Actions) -->
            <div class="col-lg-4">
                <!-- 3. Hình ảnh sản phẩm -->
                <div class="card-custom">
                    <h3 class="font-heading fw-semibold fs-5 mb-4 pb-3 border-bottom">Hình ảnh sản phẩm</h3>
                    <!-- Main Image -->
                    <div class="mb-4">
                        <label class="form-label font-heading fw-semibold mb-2">Ảnh chính <span class="text-error">*</span></label>
                        <div class="upload-area">
                            <span class="material-symbols-outlined display-4 text-secondary mb-2">cloud_upload</span>
                            <p class="mb-1 text-secondary small">Kéo thả hoặc click để tải lên</p>
                            <p class="mb-0 text-secondary" style="font-size: 0.75rem;">PNG, JPG lên đến 5MB</p>
                        </div>
                    </div>
                    <!-- Sub Images -->
                    <div>
                        <label class="form-label font-heading fw-semibold mb-2">Ảnh phụ (Tối đa 4 ảnh)</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <div class="upload-area-sm">
                                    <span class="material-symbols-outlined text-secondary fs-4">add_photo_alternate</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="upload-area-sm">
                                    <span class="material-symbols-outlined text-secondary fs-4">add_photo_alternate</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Action Buttons -->
                <div class="card-custom d-flex flex-column gap-3">
                    <button class="btn btn-primary-custom w-100 py-2 font-heading fw-semibold d-flex align-items-center justify-content-center gap-2" type="submit">
                        <span class="material-symbols-outlined icon-fill">save</span>
                        Lưu sản phẩm
                    </button>
                    <button class="btn btn-light w-100 py-2 font-heading fw-semibold border" style="background-color: var(--gainsboro);" type="button">
                        Hủy
                    </button>
                </div>
            </div>
        </div>
    </form>
</main>
<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>

