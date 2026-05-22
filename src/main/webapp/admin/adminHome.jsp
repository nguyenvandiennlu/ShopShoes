<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "dashboard");
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BHD Sport Shoes - Admin Dashboard</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <!-- Material Symbols -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        :root {
            --bs-body-font-family: 'Roboto', sans-serif;
            --font-headline: 'Josefin Sans', sans-serif;
            --color-cultured: #F0F2F3;
            --color-bittersweet: #FF675C;
            --color-salmon: #FF756B;
            --color-rich-black: #101720;
            --color-surface: #ffffff;
            --color-secondary: #585f6a;
            --color-gainsboro: #DCDCDC;
            --color-on-surface: #191c1d;
            --sidebar-width: 250px;
            --header-height: 70px;
        }

        html {
            font-size: 16px !important;
        }

        body {
            background-color: var(--color-cultured);
            color: var(--color-on-surface);
            font-family: var(--bs-body-font-family);
            font-size: 16px;
            line-height: 1.4;
        }

        h1, h2, h3, h4, h5, h6, .font-headline {
            font-family: var(--font-headline);
        }

        /* Sidebar Styling */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: var(--color-rich-black);
            z-index: 1040;
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .sidebar-brand h1 {
            color: #fff;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .sidebar-brand span {
            color: #a0a0a0;
            font-size: 14px;
        }

        .nav-link {
            color: #a0a0a0;
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-family: var(--font-headline);
            font-size: 16px;
            font-weight: 500;
            transition: all 0.2s;
            border-radius: 0.25rem;
            margin: 0 1rem 0.5rem 1rem;
        }

        .nav-link:hover {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .nav-link.active {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.05);
            border-left: 4px solid var(--color-bittersweet);
            border-radius: 0 0.25rem 0.25rem 0;
            margin-left: 0;
            padding-left: calc(1.5rem + 1rem - 4px); /* compensate for margin and border */
        }

        .sidebar-footer {
            margin-top: auto;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .btn-bittersweet {
            background-color: var(--color-bittersweet);
            color: white;
            font-family: var(--font-headline);
            font-weight: 600;
            border: none;
            transition: background-color 0.2s;
        }

        .btn-bittersweet:hover {
            background-color: var(--color-salmon);
            color: white;
        }

        /* Top Header Styling */
        .top-header {
            position: fixed;
            top: 0;
            right: 0;
            height: var(--header-height);
            width: calc(100% - var(--sidebar-width));
            background-color: var(--color-surface);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            z-index: 1030;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .search-wrapper {
            position: relative;
            width: 250px;
        }

        .search-wrapper .material-symbols-outlined {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--color-secondary);
        }

        .search-input {
            background-color: var(--color-cultured);
            border: none;
            border-radius: 50rem;
            padding: 0.5rem 1rem 0.5rem 2.5rem;
            width: 100%;
        }

        .search-input:focus {
            outline: none;
            box-shadow: 0 0 0 2px var(--color-bittersweet);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .icon-btn {
            background: none;
            border: none;
            color: var(--color-secondary);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s;
        }

        .icon-btn:hover {
            background-color: var(--color-cultured);
        }

        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            cursor: pointer;
            transition: box-shadow 0.2s;
        }

        .profile-img:hover {
            box-shadow: 0 0 0 2px var(--color-bittersweet);
        }

        /* Main Content Styling */
        .main-content {
            margin-left: var(--sidebar-width);
            margin-top: var(--header-height);
            padding: 2rem;
        }

        .page-title {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        /* Stats Cards */
        .stat-card {
            background-color: var(--color-surface);
            border-radius: 0.75rem;
            padding: 1.5rem;
            box-shadow: 0 15px 15px rgba(0,0,0,0.05);
            transition: box-shadow 0.3s;
            height: 100%;
            border: none;
        }

        .stat-card:hover {
            box-shadow: 0 30px 30px rgba(0,0,0,0.1);
        }

        .stat-icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background-color: rgba(255, 103, 92, 0.1); /* bittersweet with opacity */
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .stat-icon-wrapper .material-symbols-outlined {
            color: var(--color-bittersweet);
        }

        .stat-label {
            color: var(--color-secondary);
            font-size: 14px;
            margin-bottom: 0.25rem;
        }

        .stat-value {
            font-family: var(--font-headline);
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        /* Table Styling */
        .custom-card {
            background-color: var(--color-surface);
            border-radius: 0.75rem;
            box-shadow: 0 15px 15px rgba(0,0,0,0.05);
            border: none;
            overflow: hidden;
            margin-top: 2rem;
        }

        .custom-card-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--color-gainsboro);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: var(--color-surface);
        }

        .custom-card-title {
            font-family: var(--font-headline);
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        .btn-light-gray {
            background-color: var(--color-gainsboro);
            color: var(--color-rich-black);
            font-family: var(--font-headline);
            font-weight: 600;
            font-size: 14px;
            border: none;
        }

        .btn-light-gray:hover {
            background-color: #e1e3e4; /* surface-variant */
        }

        .table-responsive {
            width: 100%;
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            font-family: var(--font-headline);
            font-size: 13px;
            font-weight: 700;
            color: var(--color-secondary);
            text-transform: uppercase;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--color-gainsboro);
            background-color: var(--color-surface);
        }

        .table td {
            padding: 1rem 1.5rem;
            vertical-align: middle;
            border-bottom: 1px solid var(--color-gainsboro);
        }

        .table tbody tr {
            transition: background-color 0.2s;
        }

        .table tbody tr:hover {
            background-color: var(--color-cultured);
        }

        .table tbody tr:last-child td {
            border-bottom: none;
        }

        .badge-status {
            font-family: 'Roboto', sans-serif;
            font-size: 12px;
            font-weight: 700;
            padding: 0.25em 0.6em;
            border-radius: 50rem;
        }

        .status-done {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status-new {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .text-secondary-custom {
            color: var(--color-secondary);
        }

        .control-chip {
            border: 1px solid var(--color-gainsboro);
            background: #fff;
            color: var(--color-secondary);
            border-radius: 999px;
            padding: 0.45rem 0.9rem;
            font-size: 13px;
            font-weight: 600;
        }

        .control-chip.active {
            background: var(--color-bittersweet);
            color: #fff;
            border-color: var(--color-bittersweet);
        }

        .chart-wrap {
            height: 340px;
            position: relative;
        }

        .toolbar-select,
        .toolbar-input {
            border: 1px solid var(--color-gainsboro);
            border-radius: 10px;
            background: #fff;
            color: var(--color-on-surface);
            padding: 0.5rem 0.75rem;
            font-size: 14px;
        }

        .toolbar-input {
            min-width: 220px;
        }

        .compare-layout {
            display: grid;
            gap: 1rem;
            width: 100%;
            min-height: 360px;
        }

        .compare-layout-1 {
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
        }

        .compare-layout-2 {
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr;
        }

        .compare-layout-3 {
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
        }

        .compare-layout-3 .compare-panel[data-slot="0"] {
            grid-column: 1;
            grid-row: 1;
        }

        .compare-layout-3 .compare-panel[data-slot="1"] {
            grid-column: 2;
            grid-row: 1;
        }

        .compare-layout-3 .compare-panel[data-slot="2"] {
            grid-column: 1 / span 2;
            grid-row: 2;
        }

        .compare-panel {
            background: #fff;
            border: 1px solid var(--color-gainsboro);
            border-radius: 12px;
            padding: 0.75rem;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .compare-panel-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .compare-panel-title {
            font-family: var(--font-headline);
            font-size: 16px;
            margin: 0;
            font-weight: 600;
        }

        .compare-chart-wrap {
            height: 260px;
        }

    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- Sidebar -->
<aside class="sidebar">
    <!-- Brand Header -->
    <div class="sidebar-brand">
        <h1 class="font-headline">BHD Sport</h1>
        <span>Admin Panel</span>
    </div>
    <!-- Navigation Links -->
    <nav class="nav flex-column flex-grow-1">
        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Bảng điều khiển</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
            <span class="material-symbols-outlined">shopping_cart</span>
            <span>Đơn hàng</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
            <span class="material-symbols-outlined">inventory_2</span>
            <span>Kho hàng</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/quanlykhachhang.jsp">
            <span class="material-symbols-outlined">group</span>
            <span>Khách hàng</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/thongke.jsp">
            <span class="material-symbols-outlined">assessment</span>
            <span>Báo cáo</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/admin/settingadmin.jsp">
            <span class="material-symbols-outlined">settings</span>
            <span>Cài đặt</span>
        </a>
    </nav>
    <!-- CTA & Footer -->
    <div class="sidebar-footer">
        <a class="btn btn-bittersweet w-100 py-2" href="${pageContext.request.contextPath}/admin/addproduct.jsp">Thêm sản phẩm mới</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout" style="margin:0; padding: 0.5rem 0;">
            <span class="material-symbols-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- Top Header -->
<header class="top-header">
    <!-- Left: Brand / Search -->
    <div class="d-flex align-items-center gap-4">
        <h2 class="font-headline d-md-none m-0" style="font-size: 22px; font-weight: bold;">BHD Sport Shoes</h2>
        <div class="search-wrapper d-none d-md-block">
            <span class="material-symbols-outlined">search</span>
            <input class="search-input" placeholder="Tìm kiếm..." type="text"/>
        </div>
    </div>
    <!-- Right: Actions & Profile -->
    <div class="header-actions">
        <button class="icon-btn">
            <span class="material-symbols-outlined">notifications</span>
        </button>
        <button class="icon-btn">
            <span class="material-symbols-outlined">help</span>
        </button>
        <div style="width: 1px; height: 32px; background-color: var(--color-gainsboro); margin: 0 0.5rem;"></div>
        <img alt="Admin User Profile" class="profile-img" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAMp0kgdk0DeGlgBivcAkZG-40tKGlG-JRdll_ATLdVN4kTdQWYSBcZGxaOLWJsN95YvnMFqbFYMzGrZetbZz0s4xQ5HmxZOA76hdrnh9XWPn2HPOdEoltpvm31wv4gJR1TSS3WN6INJgFBgvll3ldPjWAQ6ck7UA4vF8F7Q-shsCxm25rzKnelI2Pqe47bv9GniqUQgpskt6ID-EnvGkPoNkSe3J1-LMwiNY1ANYml3VhpmZskksvJ1ToQ8cRU6c2rJiLLWdFpTEa2"/>
    </div>
</header>
--%>
<!-- Main Content -->
<main class="main-content">
    <!-- Page Header -->
    <h1 class="page-title font-headline">Bảng điều khiển</h1>
    <!-- Stat Cards Grid -->
    <div class="row g-4">
        <!-- Card 1 -->
        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">shopping_bag</span>
                </div>
                <p class="stat-label">Tổng đơn hàng</p>
                <p class="stat-value">128</p>
            </div>
        </div>
        <!-- Card 2 -->
        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">payments</span>
                </div>
                <p class="stat-label">Doanh thu hôm nay</p>
                <p class="stat-value">5.200.000 VNĐ</p>
            </div>
        </div>
        <!-- Card 3 -->
        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">inventory_2</span>
                </div>
                <p class="stat-label">Sản phẩm</p>
                <p class="stat-value">450</p>
            </div>
        </div>
        <!-- Card 4 -->
        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">group</span>
                </div>
                <p class="stat-label">Người dùng</p>
                <p class="stat-value">1.024</p>
            </div>
        </div>
    </div>
    <div class="custom-card" id="revenueCompareCard">
        <div class="custom-card-header flex-wrap gap-3">
            <h2 class="custom-card-title">So s&aacute;nh doanh thu song song</h2>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="text-secondary-custom" style="font-size:13px;">B&#7889; c&#7909;c 1/2/3 panel ki&#7875;u Chrome split-view</span>
                <button type="button" class="btn btn-bittersweet d-flex align-items-center gap-1" id="addRevenuePanelBtn">
                    <span class="material-symbols-outlined" style="font-size:18px;">add</span>
                    Th&ecirc;m b&#7843;ng th&#7889;ng k&ecirc;
                </button>
            </div>
        </div>
        <div class="p-3 p-md-4">
            <div id="revenueCompareLayout" class="compare-layout compare-layout-1">
                <section class="compare-panel" data-slot="0">
                    <div class="compare-panel-head">
                        <h3 class="compare-panel-title">Th&#7889;ng k&ecirc; ng&agrave;y</h3>
                    </div>
                    <div class="chart-wrap compare-chart-wrap"><canvas id="revenueChartPanel0"></canvas></div>
                </section>
                <section class="compare-panel" data-slot="1"></section>
                <section class="compare-panel" data-slot="2"></section>
            </div>
        </div>
    </div>

    <div class="custom-card">
        <div class="custom-card-header flex-wrap gap-3">
            <h2 class="custom-card-title">Thống kê sản phẩm</h2>
            <div class="d-flex flex-wrap gap-2">
                <button type="button" class="control-chip active" data-product-tab="sold">Bán chạy</button>
                <button type="button" class="control-chip" data-product-tab="unsold">Không bán được</button>
                <button type="button" class="control-chip" data-product-tab="lowstock">Sắp hết hàng</button>
            </div>
        </div>
        <div class="px-3 px-md-4 pt-3">
            <div class="d-flex flex-wrap gap-2 justify-content-between align-items-center">
                <input id="productSearch" class="toolbar-input" type="text" placeholder="Tìm sản phẩm theo tên / SKU"/>
                <div class="d-flex gap-2">
                    <select id="productLimit" class="toolbar-select">
                        <option value="5">Hiển thị 5 dòng</option>
                        <option value="10" selected>Hiển thị 10 dòng</option>
                        <option value="20">Hiển thị 20 dòng</option>
                    </select>
                    <select id="productSort" class="toolbar-select">
                        <option value="revenue">Sắp xếp theo doanh thu</option>
                        <option value="quantity">Sắp xếp theo số lượng</option>
                        <option value="stock">Sắp xếp theo tồn kho</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="table-responsive mt-3">
            <table class="table" id="productStatsTable">
                <thead>
                <tr>
                    <th>TÊN SẢN PHẨM</th>
                    <th>SKU</th>
                    <th>DANH MỤC</th>
                    <th>SỐ LƯỢNG BÁN</th>
                    <th>DOANH THU</th>
                    <th>TỒN KHO</th>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="custom-card">
        <div class="custom-card-header">
            <h2 class="custom-card-title">Đơn hàng gần đây</h2>
            <button class="btn btn-light-gray py-2 px-4 rounded">Xem tất cả</button>
        </div>
        <div class="table-responsive">
            <table class="table">
                <thead>
                <tr>
                    <th>MÃ ĐƠN</th>
                    <th>KHÁCH HÀNG</th>
                    <th>TỔNG TIỀN</th>
                    <th>TRẠNG THÁI</th>
                    <th>NGÀY TẠO</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="fw-bold">#ORD-9021</td>
                    <td>Nguyen Van A</td>
                    <td>1.250.000 VNĐ</td>
                    <td>
                        <span class="badge badge-status status-done">Hoàn thành</span>
                    </td>
                    <td class="text-secondary-custom">24 Thg 10, 2023</td>
                </tr>
                <tr>
                    <td class="fw-bold">#ORD-9022</td>
                    <td>Tran Thi B</td>
                    <td>850.000 VNĐ</td>
                    <td>
                        <span class="badge badge-status status-new">Chờ xử lý</span>
                    </td>
                    <td class="text-secondary-custom">24 Thg 10, 2023</td>
                </tr>
                <tr>
                    <td class="fw-bold">#ORD-9023</td>
                    <td>Le Minh C</td>
                    <td>3.100.000 VNĐ</td>
                    <td>
                        <span class="badge badge-status status-done">Hoàn thành</span>
                    </td>
                    <td class="text-secondary-custom">23 Thg 10, 2023</td>
                </tr>
                <tr>
                    <td class="fw-bold">#ORD-9024</td>
                    <td>Pham Thu D</td>
                    <td>450.000 VNĐ</td>
                    <td>
                        <span class="badge badge-status status-new">Chờ xử lý</span>
                    </td>
                    <td class="text-secondary-custom">23 Thg 10, 2023</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<div class="modal fade" id="addPanelModal" tabindex="-1" aria-labelledby="addPanelModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title font-headline" id="addPanelModalLabel">Th&ecirc;m b&#7843;ng th&#7889;ng k&ecirc;</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <label for="panelTypeSelect" class="form-label">Ch&#7885;n lo&#7841;i b&#7843;ng th&#7889;ng k&ecirc;</label>
                <select id="panelTypeSelect" class="form-select">
                    <option value="day">Th&#7889;ng k&ecirc; ng&agrave;y</option>
                    <option value="month" selected>Th&#7889;ng k&ecirc; th&aacute;ng</option>
                    <option value="year">Th&#7889;ng k&ecirc; n&#259;m</option>
                    <option value="rolling">12 th&aacute;ng g&#7847;n nh&#7845;t</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">H&#7911;y</button>
                <button type="button" class="btn btn-bittersweet" id="confirmAddPanelBtn">Th&ecirc;m</button>
            </div>
        </div>
    </div>
</div>
</div>
<!-- Bootstrap Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script>
    const VND = new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND", maximumFractionDigits: 0 });

    const revenueSeries = {
        day: {
            key: "day",
            title: "Thong ke ngay",
            labels: ["00h", "03h", "06h", "09h", "12h", "15h", "18h", "21h"],
            values: [1200000, 1900000, 800000, 3600000, 5100000, 4200000, 6900000, 5400000]
        },
        month: {
            key: "month",
            title: "Thong ke thang",
            labels: ["Tuan 1", "Tuan 2", "Tuan 3", "Tuan 4"],
            values: [35200000, 49700000, 41200000, 58900000]
        },
        year: {
            key: "year",
            title: "Thong ke nam",
            labels: ["Q1", "Q2", "Q3", "Q4"],
            values: [318000000, 362000000, 405000000, 441000000]
        },
        rolling: {
            key: "rolling",
            title: "12 thang gan nhat",
            labels: ["T6", "T7", "T8", "T9", "T10", "T11", "T12", "T1", "T2", "T3", "T4", "T5"],
            values: [122000000, 143000000, 135000000, 157000000, 148000000, 166000000, 172000000, 160000000, 184000000, 179000000, 193000000, 201000000]
        }
    };

    const revenueCompareLayout = document.getElementById("revenueCompareLayout");
    const addRevenuePanelBtn = document.getElementById("addRevenuePanelBtn");
    const revenuePanels = [];
    const revenuePanelTypes = ["day"]; // panel m?c ??nh

    function buildPanelMarkup(slot, type) {
        const canvasId = `revenueChartPanel${slot}`;
        return `
            <div class="compare-panel-head">
                <h3 class="compare-panel-title">${revenueSeries[type].title}</h3>
            </div>
            <div class="chart-wrap compare-chart-wrap"><canvas id="${canvasId}"></canvas></div>
        `;
    }

    function chartOptions() {
        return {
            responsive: true,
            maintainAspectRatio: false,
            interaction: { mode: "index", intersect: false },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: (ctx) => `Doanh thu: ${VND.format(ctx.parsed.y)}`
                    }
                }
            },
            scales: {
                y: {
                    ticks: { callback: (value) => `${Math.round(value / 1000000)}M` },
                    grid: { color: "#f1f3f5" }
                },
                x: { grid: { display: false } }
            }
        };
    }

    function mountChart(slot, type) {
        const ctx = document.getElementById(`revenueChartPanel${slot}`);
        if (!ctx) return;
        const series = revenueSeries[type];
        const chart = new Chart(ctx, {
            type: "line",
            data: {
                labels: series.labels,
                datasets: [{
                    label: "Doanh thu",
                    data: series.values,
                    borderColor: "#FF675C",
                    backgroundColor: "rgba(255, 103, 92, 0.12)",
                    borderWidth: 3,
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    tension: 0.35,
                    fill: true
                }]
            },
            options: chartOptions()
        });
        revenuePanels.push(chart);
    }

    function destroyAllRevenueCharts() {
        while (revenuePanels.length) {
            const chart = revenuePanels.pop();
            chart.destroy();
        }
    }

    function applyLayout() {
        const count = revenuePanelTypes.length;
        revenueCompareLayout.classList.remove("compare-layout-1", "compare-layout-2", "compare-layout-3");
        revenueCompareLayout.classList.add(`compare-layout-${count}`);

        const slots = revenueCompareLayout.querySelectorAll(".compare-panel");
        slots.forEach((slot, index) => {
            if (index < count) {
                slot.style.display = "flex";
                slot.innerHTML = buildPanelMarkup(index, revenuePanelTypes[index]);
            } else {
                slot.style.display = "none";
                slot.innerHTML = "";
            }
        });

        destroyAllRevenueCharts();
        revenuePanelTypes.forEach((type, slot) => mountChart(slot, type));
    }

    if (revenueCompareLayout && addRevenuePanelBtn) {
        const panelTypeSelect = document.getElementById("panelTypeSelect");
        const confirmAddPanelBtn = document.getElementById("confirmAddPanelBtn");
        const addPanelModalEl = document.getElementById("addPanelModal");
        const addPanelModal = new bootstrap.Modal(addPanelModalEl);

        applyLayout();

        addRevenuePanelBtn.addEventListener("click", () => {
            if (revenuePanelTypes.length >= 3) {
                alert("Da dat toi da 3 bang thong ke song song.");
                return;
            }
            addPanelModal.show();
        });

        confirmAddPanelBtn.addEventListener("click", () => {
            const picked = panelTypeSelect.value;
            if (!picked) {
                alert("Lua chon khong hop le. Vui long nhap: day / month / year / rolling.");
                return;
            }

            // B? c?c theo y?u c?u: panel th? 3 ?u ti?n Day/Month ? tr?n v? Year ? d??i.
            if (revenuePanelTypes.length === 2) {
                const ordered = ["day", "month", "year"];
                const unique = new Set([...revenuePanelTypes, picked]);
                if (unique.size === 3 && unique.has("day") && unique.has("month") && unique.has("year")) {
                    revenuePanelTypes.splice(0, revenuePanelTypes.length, ...ordered);
                } else {
                    revenuePanelTypes.push(picked);
                }
            } else {
                revenuePanelTypes.push(picked);
            }

            applyLayout();
            addPanelModal.hide();
        });
    }

    const productsByTab = {
        sold: [
            { name: "Nike Air Max 270", sku: "NK-270-BK-42", category: "Giày chạy bộ", sold: 342, revenue: 1026000000, stock: 24 },
            { name: "Adidas Ultraboost 22", sku: "AD-UB22-WH-41", category: "Giày chạy bộ", sold: 285, revenue: 855000000, stock: 17 },
            { name: "Air Jordan 1 Mid", sku: "AJ1-MID-RD-43", category: "Giày bóng rổ", sold: 195, revenue: 780000000, stock: 12 },
            { name: "Puma RS-X", sku: "PM-RSX-GY-40", category: "Giày training", sold: 164, revenue: 492000000, stock: 31 },
            { name: "Nike Metcon 8", sku: "NK-MT8-BL-42", category: "Giày training", sold: 150, revenue: 450000000, stock: 8 }
        ],
        unsold: [
            { name: "Asics Gel Kayano 29", sku: "AS-KY29-OR-41", category: "Giày chạy bộ", sold: 0, revenue: 0, stock: 44 },
            { name: "Li-Ning D Wade 10", sku: "LN-WD10-BK-42", category: "Giày bóng rổ", sold: 0, revenue: 0, stock: 21 },
            { name: "Reebok Nano X2", sku: "RB-NX2-GN-40", category: "Giày training", sold: 1, revenue: 2300000, stock: 39 },
            { name: "Converse Run Star", sku: "CV-RS-HI-39", category: "Giày thời trang", sold: 2, revenue: 3600000, stock: 28 }
        ],
        lowstock: [
            { name: "Nike Metcon 8", sku: "NK-MT8-BL-42", category: "Giày training", sold: 150, revenue: 450000000, stock: 8 },
            { name: "Jordan Zion 3", sku: "AJ-ZN3-BK-43", category: "Giày bóng rổ", sold: 74, revenue: 296000000, stock: 6 },
            { name: "New Balance 550", sku: "NB-550-WH-42", category: "Giày thời trang", sold: 96, revenue: 307200000, stock: 5 },
            { name: "Adidas Adizero SL", sku: "AD-AZSL-RD-41", category: "Giày chạy bộ", sold: 112, revenue: 336000000, stock: 4 }
        ]
    };

    const tableBody = document.querySelector("#productStatsTable tbody");
    if (tableBody) {
        let productTab = "sold";
        const productSearch = document.getElementById("productSearch");
        const productLimit = document.getElementById("productLimit");
        const productSort = document.getElementById("productSort");

        function renderProducts() {
            const keyword = productSearch.value.trim().toLowerCase();
            const limit = parseInt(productLimit.value, 10);
            const sortType = productSort.value;
            let rows = [...productsByTab[productTab]];

            rows = rows.filter((item) =>
                item.name.toLowerCase().includes(keyword) || item.sku.toLowerCase().includes(keyword)
            );

            rows.sort((a, b) => {
                if (sortType === "quantity") return b.sold - a.sold;
                if (sortType === "stock") return a.stock - b.stock;
                return b.revenue - a.revenue;
            });

            rows = rows.slice(0, limit);
            tableBody.innerHTML = rows.map((item) => `
                <tr>
                    <td class="fw-semibold">${item.name}</td>
                    <td>${item.sku}</td>
                    <td>${item.category}</td>
                    <td>${item.sold}</td>
                    <td>${VND.format(item.revenue)}</td>
                    <td>${item.stock}</td>
                </tr>
            `).join("");
        }

        document.querySelectorAll("[data-product-tab]").forEach((btn) => {
            btn.addEventListener("click", () => {
                document.querySelectorAll("[data-product-tab]").forEach((item) => item.classList.remove("active"));
                btn.classList.add("active");
                productTab = btn.dataset.productTab;
                renderProducts();
            });
        });

        [productSearch, productLimit, productSort].forEach((el) => el.addEventListener("input", renderProducts));
        renderProducts();
    }
</script>
</body></html>

