<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "reports");
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BHD Sport Admin - Báo cáo &amp; Thống kê</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons+Outlined" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,1,0" rel="stylesheet"/>
    <style>
        :root {
            --bittersweet: #ff675c;
            --rich-black-fogra-29: #1c212c;
            --sidebar-width: 250px;
            --header-height: 70px;
            --body-bg: #f8fafb;
            --text-main: #191c1d;
            --text-muted: #585f6a;

            --font-heading: 'Josefin Sans', sans-serif;
            --font-body: 'Roboto', sans-serif;
        }

        body {
            font-family: var(--font-body);
            background-color: var(--body-bg);
            color: var(--text-main);
            font-size: 14px;
            margin: 0;
            padding: 0;
        }

        h1, h2, h3, h4, h5, h6, .navbar-brand, .nav-link, .btn {
            font-family: var(--font-heading);
        }

        /* Sidebar dung file chung sidebar.jsp */

        /* Header Styles */
        .main-header {
            position: fixed;
            top: 0;
            right: 0;
            left: var(--sidebar-width);
            height: var(--header-height);
            background-color: #ffffff;
            z-index: 999;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
        }

        .search-bar {
            background-color: #F0F2F3;
            border-radius: 4px;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            width: 300px;
        }

        .search-bar input {
            border: none;
            background: transparent;
            outline: none;
            width: 100%;
            margin-left: 8px;
            font-size: 14px;
        }

        .header-actions .btn-icon {
            background: transparent;
            border: none;
            color: var(--text-muted);
            padding: 8px;
            border-radius: 50%;
            position: relative;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .header-actions .btn-icon:hover {
            background-color: #F0F2F3;
        }

        .notification-badge {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 8px;
            height: 8px;
            background-color: var(--bittersweet);
            border-radius: 50%;
        }

        /* Main Content Styles */
        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--header-height);
            padding: 32px;
            min-height: calc(100vh - var(--header-height));
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            color: var(--rich-black-fogra-29);
            margin-bottom: 0;
        }

        .breadcrumb {
            margin-bottom: 8px;
            font-size: 14px;
        }

        .breadcrumb-item a {
            color: var(--text-muted);
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: var(--text-main);
            font-weight: 500;
        }

        /* Card Styles */
        .custom-card {
            background: #fff;
            border-radius: 8px;
            border: 1px solid rgba(220, 220, 220, 0.5);
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            padding: 24px;
            height: 100%;
            position: relative;
            overflow: hidden;
            transition: box-shadow 0.2s;
        }

        .custom-card:hover {
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }

        .stat-icon-wrapper {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .stat-bg-circle {
            position: absolute;
            top: -16px;
            right: -16px;
            width: 96px;
            height: 96px;
            border-radius: 50%;
            z-index: 0;
            transition: transform 0.5s;
        }

        .custom-card:hover .stat-bg-circle {
            transform: scale(1.1);
        }

        .card-content {
            position: relative;
            z-index: 1;
        }

        .stat-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 600;
            color: var(--rich-black-fogra-29);
            margin-bottom: 0;
        }

        /* Table Styles */
        .table-card {
            background: #fff;
            border-radius: 8px;
            border: 1px solid rgba(220, 220, 220, 0.5);
            overflow: hidden;
        }

        .table-header {
            padding: 20px 24px;
            border-bottom: 1px solid #DCDCDC;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        .custom-table {
            margin-bottom: 0;
        }

        .custom-table th {
            font-family: var(--font-heading);
            font-size: 13px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            padding: 16px 24px;
            background-color: #f8fafb;
            border-bottom: 1px solid #DCDCDC;
        }

        .custom-table td {
            padding: 16px 24px;
            vertical-align: middle;
            border-bottom: 1px solid #DCDCDC;
        }

        .custom-table tr:hover td {
            background-color: #F0F2F3;
        }

        .product-img {
            width: 60px;
            height: 60px;
            border-radius: 4px;
            object-fit: cover;
            background-color: #DCDCDC;
        }

        /* Utilities */
        .text-bittersweet { color: var(--bittersweet); }
        .bg-bittersweet { background-color: var(--bittersweet); }
        .btn-bittersweet {
            background-color: var(--bittersweet);
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 4px;
        }
        .btn-bittersweet:hover {
            background-color: #FF756B;
            color: white;
        }

        .status-done-bg { background-color: #d1fae5; }
        .status-done-text { color: #065f46; }
        .status-proc-bg { background-color: #dbeafe; }
        .status-proc-text { color: #1e40af; }
        .status-new-bg { background-color: #fee2e2; }
        .status-new-text { color: #991b1b; }
        .status-ship-bg { background-color: #e0f2fe; }
        .status-ship-text { color: #0284c7; }

        .date-filter {
            background: white;
            border: 1px solid #DCDCDC;
            border-radius: 4px;
            padding: 8px 12px;
            display: flex;
            align-items: center;
        }
        .date-filter input {
            border: none;
            outline: none;
            width: 110px;
            color: var(--text-muted);
        }

        .chart-placeholder {
            background-color: #F0F2F3;
            border-radius: 8px;
            min-height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- Sidebar -->
<nav class="sidebar">
    <div class="d-flex align-items-center p-4">
        <div class="brand-logo me-3">
            <img alt="BHD Sport Logo" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBTVRa31A-Fk1-C98AP9SKwgqPg_0QV0OInG6ajvoJxJYDOKr94HhlxNGEW8s7xhK_qWGCybPQGokoR60ODMrGaJ-rCVYP7jUZElWTU_vDi6oYtQn-hVmkTNT35qmIb8sQjnXAjRvIJGAkHTqRXpTpoRevEGd3U1HztmzmKF9biglP-pjzvZaDM8hxEXmfg6GmL12Gyelp2L4n7_2SebOWikeFSimC0Aoixzk16-IYn234wJfuFRsHNBWEJD__qxNKPT9JS0kpX-ITQ"/>
        </div>
        <div>
            <h4 class="mb-0 text-white" style="font-size: 22px;">BHD Sport</h4>
            <small class="text-secondary" style="font-size: 12px;">Admin Panel</small>
        </div>
    </div>
    <div class="flex-grow-1 overflow-auto">
        <ul class="nav flex-column mt-2">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                    <span class="material-symbols-outlined">analytics</span>
                    Báo cáo
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
                    <span class="material-symbols-outlined">settings</span>
                    Cài đặt
                </a>
            </li>
        </ul>
    </div>
    <div class="sidebar-footer">
        <a class="btn btn-bittersweet w-100 py-2 mb-3" href="${pageContext.request.contextPath}/admin/addproduct.jsp">Thêm sản phẩm mới</a>
        <a class="nav-link logout-link p-0 m-0" href="${pageContext.request.contextPath}/logout">
            <span class="material-icons-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</nav>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- Header -->
<header class="main-header">
    <div class="search-bar">
        <span class="material-symbols-outlined text-muted" style="font-size: 20px;">search</span>
        <input placeholder="Tìm kiếm báo cáo..." type="text"/>
    </div>
    <div class="header-actions d-flex align-items-center gap-3">
        <button class="btn-icon">
            <span class="material-symbols-outlined">notifications</span>
            <span class="notification-badge"></span>
        </button>
        <button class="btn-icon d-flex align-items-center gap-2">
            <span class="material-symbols-outlined">account_circle</span>
            <span class="d-none d-sm-block fw-semibold text-dark" style="font-family: var(--font-heading); font-size: 14px;">Admin User</span>
            <span class="material-symbols-outlined" style="font-size: 16px;">arrow_drop_down</span>
        </button>
    </div>
</header>
--%>
<!-- Main Content -->
<main class="main-content">
    <!-- Page Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                    <li aria-current="page" class="breadcrumb-item active">Báo cáo</li>
                </ol>
            </nav>
            <h2 class="page-title">Báo cáo &amp; Thống kê</h2>
        </div>
        <div class="d-flex flex-wrap align-items-center gap-2">
            <div class="date-filter shadow-sm">
                <span class="material-symbols-outlined text-muted me-2" style="font-size: 18px;">calendar_today</span>
                <input type="date" value="2023-10-01"/>
                <span class="mx-2 text-muted">-</span>
                <input type="date" value="2023-10-31"/>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-light border shadow-sm d-flex align-items-center gap-2" style="font-weight: 600;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">download</span>
                    Xuất Excel
                </button>
                <button class="btn btn-light border shadow-sm d-flex align-items-center gap-2" style="font-weight: 600;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">picture_as_pdf</span>
                    Xuất PDF
                </button>
            </div>
        </div>
    </div>
    <!-- Stats Row -->
    <div class="row g-4 mb-4">
        <!-- Stat Card 1 -->
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(255, 103, 92, 0.05);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Tổng doanh thu</div>
                        <div class="stat-value">452.8M ₫</div>
                    </div>
                    <div class="stat-icon-wrapper status-done-bg status-done-text">
                        <span class="material-symbols-outlined">payments</span>
                    </div>
                </div>
                <div class="card-content d-flex align-items-center status-done-text">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px;">trending_up</span>
                    <span class="fw-medium">+12.5%</span>
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">so với tháng trước</span>
                </div>
            </div>
        </div>
        <!-- Stat Card 2 -->
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(219, 234, 254, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Tổng đơn hàng</div>
                        <div class="stat-value">1,248</div>
                    </div>
                    <div class="stat-icon-wrapper status-proc-bg status-proc-text">
                        <span class="material-symbols-outlined">local_shipping</span>
                    </div>
                </div>
                <div class="card-content d-flex align-items-center status-done-text">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px;">trending_up</span>
                    <span class="fw-medium">+8.2%</span>
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">so với tháng trước</span>
                </div>
            </div>
        </div>
        <!-- Stat Card 3 -->
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(255, 218, 214, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Lợi nhuận ước tính</div>
                        <div class="stat-value">128.5M ₫</div>
                    </div>
                    <div class="stat-icon-wrapper status-new-bg status-new-text">
                        <span class="material-symbols-outlined">account_balance_wallet</span>
                    </div>
                </div>
                <div class="card-content d-flex align-items-center text-danger">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px;">trending_down</span>
                    <span class="fw-medium">-2.1%</span>
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">so với tháng trước</span>
                </div>
            </div>
        </div>
        <!-- Stat Card 4 -->
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(224, 242, 254, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Sản phẩm bán chạy</div>
                        <div class="stat-value" style="font-size: 22px;">Nike Air Max...</div>
                    </div>
                    <div class="stat-icon-wrapper status-ship-bg status-ship-text">
                        <span class="material-symbols-outlined">stars</span>
                    </div>
                </div>
                <div class="card-content d-flex align-items-center text-dark">
                    <span class="fw-medium">342</span>
                    <span class="text-muted ms-1">đơn vị đã bán</span>
                </div>
            </div>
        </div>
    </div>
    <!-- Charts Row -->
    <div class="row g-4 mb-4">
        <!-- Main Chart -->
        <div class="col-12 col-lg-8">
            <div class="custom-card d-flex flex-column h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0" style="font-size: 22px; font-weight: 600;">Biểu đồ doanh thu theo tháng</h3>
                    <div class="d-flex gap-2">
                        <span class="badge bg-bittersweet rounded-pill px-3 py-2">Năm nay</span>
                        <span class="badge bg-light text-secondary border rounded-pill px-3 py-2">Năm ngoái</span>
                    </div>
                </div>
                <div class="chart-placeholder flex-grow-1">
                    [Chart Placeholder - Revenue Line/Bar Chart]
                </div>
            </div>
        </div>
        <!-- Secondary Chart -->
        <div class="col-12 col-lg-4">
            <div class="custom-card d-flex flex-column h-100">
                <h3 class="mb-4" style="font-size: 22px; font-weight: 600;">Cơ cấu danh mục</h3>
                <div class="chart-placeholder mb-4" style="min-height: 200px;">
                    [Chart Placeholder - Donut Chart]
                </div>
                <div class="d-flex flex-column gap-3 mt-auto">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <div style="width: 12px; height: 12px; border-radius: 50%; background-color: var(--bittersweet); margin-right: 8px;"></div>
                            Giày chạy bộ
                        </div>
                        <span class="fw-medium">45%</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <div style="width: 12px; height: 12px; border-radius: 50%; background-color: #1e40af; margin-right: 8px;"></div>
                            Giày bóng rổ
                        </div>
                        <span class="fw-medium">25%</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <div style="width: 12px; height: 12px; border-radius: 50%; background-color: #0284c7; margin-right: 8px;"></div>
                            Giày training
                        </div>
                        <span class="fw-medium">20%</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <div style="width: 12px; height: 12px; border-radius: 50%; background-color: #065f46; margin-right: 8px;"></div>
                            Khác
                        </div>
                        <span class="fw-medium">10%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Top Products Table -->
    <div class="table-card mb-4 shadow-sm">
        <div class="table-header">
            <h3 class="">Top 5 Sản phẩm bán chạy nhất</h3>
            <a class="text-bittersweet text-decoration-none fw-semibold" href="${pageContext.request.contextPath}/admin/adminHome.jsp" style="font-family: var(--font-heading);">Xem tất cả</a>
        </div>
        <div class="table-responsive">
            <table class="table custom-table mb-0">
                <thead>
                <tr class="bg-light">
                    <th class="px-4 py-3 border-bottom text-start" style="width: 40%;">Sản phẩm</th>
                    <th class="px-4 py-3 border-bottom text-center">Phân loại</th>
                    <th class="px-4 py-3 border-bottom text-end">Doanh số</th>
                    <th class="px-4 py-3 border-bottom text-end">Doanh thu</th>
                </tr>
                </thead>
                <tbody>
                <tr class="align-middle">
                    <td class="px-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <img alt="Nike Air Max" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCWRXRx79APkRy89OC0xJqj38gNBQ9TnZSIWAcHtueZuKALSiQZZedNA_7VE1BdR_diMsvvk79n-vvKvrjdwowpdN3fX3VALYN5JpbBchZfIZlzBHyxpxR_m-ABn1XXCAMI3HK-F93hRBNgX0V_vkLCgv7rN8qyf-05EV885HPcetVO1yqe-Nf0ISH0nP04zwQdW4J-anP4GzAZeVThtRpVsy-iy0HUzHr9QXYXup_4MR6cZhJ1XY_bEF_g8WGMFGwVSxg8hPm7GTDj"/>
                            <span class="fw-medium text-dark">Nike Air Max 270 React</span>
                        </div>
                    </td>
                    <td class="px-4 py-3 text-center text-muted">Giày chạy bộ</td>
                    <td class="px-4 py-3 text-end fw-medium">342</td>
                    <td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">1,026,000,000 ₫</td>
                </tr>
                <tr class="align-middle">
                    <td class="px-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <img alt="Adidas Ultraboost" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAvaiIGda3IsdcPGas1Sj2JQXKnuJYz2MILT5f7uPLdRBiwTidRmlTe4xE_izfRN4-Vu4rQRY2ORgRwKYrQ5j8S4Qnpfj2UG5spWni7NXP0PgaGMkkLmdflkj-_L4r3Q_YwHumgOVYKq7V8w55JcsmGPux5PGnQrKko9qySMTFb8Neu10MTwq7Mq27HM6vgtOu-WdUgA1jb_BRdlINwF_Mvu32b-Dzan36m274k0txhX0z_-eEk4WfQ28r6MaqsqFm6NQzHy2wj00pl"/>
                            <span class="fw-medium text-dark">Adidas Ultraboost 22</span>
                        </div>
                    </td>
                    <td class="px-4 py-3 text-center text-muted">Giày chạy bộ</td>
                    <td class="px-4 py-3 text-end fw-medium">285</td>
                    <td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">855,000,000 ₫</td>
                </tr>
                <tr class="align-middle">
                    <td class="px-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <img alt="Puma RS-X" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCE7W0USjPXxm3_kp9XwCq8jWMMiNEO5JrWm_HFbCX7EXXCwG16QK7aMlVsUZwucL3Ttx3i6hvZrDAkbio6vJoitneMMqtOg8ZQzLpjCAGrGo2iK1MLHt63zawp4FdMfNOJCNl87XSjhVZtX2v6lHvo3YZ_S13wATspvO2inayUjJPGYrUUw8e3Lhhpd6fdUU357OsVsi-AflDaOkjnmRAuKmolWAqDAFYD-xIpYi8TK6V80lpK2MPs4dlMbrf8ZIa300fvWYDR30jT"/>
                            <span class="fw-medium text-dark">Puma RS-X³ Puzzle</span>
                        </div>
                    </td>
                    <td class="px-4 py-3 text-center text-muted">Giày thời trang</td>
                    <td class="px-4 py-3 text-end fw-medium">210</td>
                    <td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">525,000,000 ₫</td>
                </tr>
                <tr class="align-middle">
                    <td class="px-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <img alt="Jordan 1" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAoxbxyDFscUFng-CJgbqEBE4e9TBTUEkQxdg_SsHewFCDi8Hh1dlvm10_w2zTeuSRA53ifmkiJ6JB6ifyknDTSMc6MzMIVZOm_jNt0VDLUQ2OITLItfucdUf7amgh_MkqbbEbv6oJj_sk3tOTN2EW5-at8AiHEvGJzMz1F_PVqPOa1JmSkIF_-uLoT2kRgOCLG2jP70jIzvycvyFmnSvP6eqdOaTcsUyvWr0uqtBr2o2AzdhCS2uMIQwwfCmBUBBV-7Yw7jd4sYOnI"/>
                            <span class="fw-medium text-dark">Air Jordan 1 Retro High</span>
                        </div>
                    </td>
                    <td class="px-4 py-3 text-center text-muted">Giày bóng rổ</td>
                    <td class="px-4 py-3 text-end fw-medium">195</td>
                    <td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">780,000,000 ₫</td>
                </tr>
                <tr class="align-middle">
                    <td class="px-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <img alt="Nike Metcon" class="product-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAEoI1R_H84gTB8jf46NYH44-7GxjODdZwltmI_lunMfqjSrxyBd34sidt-D31iJV6ZEQNGaJmyeyDnOnhpUTAfglpx8ObYSo7cHyYdZJIMBpv_5Nmh8NSexOJWDbkYCEZTNZwrOj8VrCRIgx1LZGB87wL3E11GhOKDRLeMi6KzPUWU4PAoCHiG9rs5pk8wmSFqsXEEZlLLP5I6otitmnBp3QDH3vDdLo1ZqLSVcHqdzN2rxd929mbWEMia-1I_S_fz6-G9YmljLnTz"/>
                            <span class="fw-medium text-dark">Nike Metcon 8</span>
                        </div>
                    </td>
                    <td class="px-4 py-3 text-center text-muted">Giày training</td>
                    <td class="px-4 py-3 text-end fw-medium">150</td>
                    <td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">450,000,000 ₫</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>

