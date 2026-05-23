<%--
  Created by IntelliJ IDEA.
  User: quy23
  Date: 21/05/2026
  Time: 4:38 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "orders");
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Đơn hàng - BHD Sport Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <style>
        :root {
            --bs-font-sans-serif: 'Roboto', sans-serif;
            --bittersweet: #FF675C;
            --salmon: #FF756B;
            --rich-black: #101720;
            --cultured: #F0F2F3;
            --sidebar-width: 250px;
            --header-height: 70px;
        }

        body {
            background-color: var(--cultured);
            font-family: var(--bs-font-sans-serif);
        }

        h1, h2, h3, h4, h5, h6, .font-heading {
            font-family: 'Josefin Sans', sans-serif;
        }

        /* Custom Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 1000;
            width: var(--sidebar-width);
            background-color: var(--rich-black);
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }

        .sidebar .nav-link {
            color: #a0a0a0;
            font-family: 'Josefin Sans', sans-serif;
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            border-left: 4px solid transparent;
            transition: all 0.2s ease-in-out;
        }

        .sidebar .nav-link:hover {
            color: white;
            background-color: rgba(255,255,255,0.1);
        }

        .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255,255,255,0.05);
            border-left-color: var(--bittersweet);
        }

        /* Custom Header */
        .top-header {
            position: fixed;
            top: 0;
            right: 0;
            left: 0;
            height: var(--header-height);
            background-color: #ffffff;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            z-index: 999;
            display: flex;
            align-items: center;
            padding: 0 2rem;
        }

        @media (min-width: 768px) {
            .top-header {
                left: var(--sidebar-width);
            }
            .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        .main-content {
            margin-top: var(--header-height);
            padding: 2rem;
            min-height: calc(100vh - var(--header-height));
        }

        /* Buttons & Forms */
        .btn-bittersweet {
            background-color: var(--bittersweet);
            color: white;
            border: none;
            font-family: 'Josefin Sans', sans-serif;
            font-weight: 600;
        }
        .btn-bittersweet:hover {
            background-color: var(--salmon);
            color: white;
        }

        .form-control, .form-select {
            background-color: var(--cultured);
            border-color: #DCDCDC;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--bittersweet);
            box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25);
        }

        /* Cards */
        .card {
            border: none;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
        }

        /* Tables */
        .table th {
            font-family: 'Josefin Sans', sans-serif;
            text-transform: uppercase;
            font-size: 13px;
            font-weight: 700;
            color: #585f6a;
            border-top: none;
            border-bottom: 1px solid #DCDCDC;
            padding: 1rem 1.5rem;
            background-color: #f8fafb;
        }
        .table td {
            vertical-align: middle;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #DCDCDC;
        }

        /* Pagination */
        .page-link {
            color: #585f6a;
            border-color: #DCDCDC;
        }
        .page-item.active .page-link {
            background-color: var(--bittersweet);
            border-color: var(--bittersweet);
            color: white;
        }
        .page-link:hover {
            background-color: var(--cultured);
            color: var(--rich-black);
        }

        /* Utilities */
        .text-secondary-custom { color: #585f6a; }
        .bg-cultured { background-color: var(--cultured); }
        .material-symbols-outlined { vertical-align: middle; }

        /* Status Badges */
        .badge-new { background-color: #fee2e2; color: #991b1b; }
        .badge-processing { background-color: #dbeafe; color: #1e40af; }
        .badge-shipping { background-color: #e0f2fe; color: #0284c7; }
        .badge-completed { background-color: #d1fae5; color: #065f46; }
        .badge-cancelled { background-color: #f3f4f6; color: #374151; border: 1px solid #DCDCDC; }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<%--
<!-- SideNavBar -->
<nav class="sidebar d-none d-md-flex flex-column">
    <div class="px-4 mb-4 d-flex flex-column gap-1">
        <h1 class="font-heading fs-4 text-white text-uppercase tracking-wider m-0">BHD Sport</h1>
        <span class="text-secondary small font-heading">Admin Panel</span>
    </div>
    <div class="px-4 mb-4">
        <a class="btn btn-bittersweet w-100 d-flex align-items-center justify-content-center gap-2" href="${pageContext.request.contextPath}/admin/addproduct.jsp">
            <span class="material-symbols-outlined fs-6">add</span>
            Thêm sản phẩm mới
        </a>
    </div>
    <ul class="nav flex-column flex-grow-1 w-100">
        <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                Bảng điều khiển
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">shopping_cart</span>
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
                <span class="material-symbols-outlined">assessment</span>
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
    <div class="px-4 mt-auto">
        <a class="nav-link p-0" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            Đăng xuất
        </a>
    </div>
</nav>
--%>
<jsp:include page="topbar.jsp"/>
<%--
<!-- TopNavBar -->
<header class="top-header">
    <div class="d-flex align-items-center gap-3 d-md-none">
        <button class="btn btn-light p-1">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </div>
    <div class="flex-grow-1">
        <h2 class="font-heading fs-4 fw-bold m-0 d-none d-md-block text-dark">Quản lý Đơn hàng</h2>
    </div>
    <div class="d-flex align-items-center gap-3">
        <button class="btn btn-link text-secondary-custom p-0 position-relative">
            <span class="material-symbols-outlined">notifications</span>
            <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle">
<span class="visually-hidden">New alerts</span>
</span>
        </button>
        <button class="btn btn-link text-secondary-custom p-0 d-none d-sm-block">
            <span class="material-symbols-outlined">help</span>
        </button>
        <div class="ms-2">
            <img alt="Admin Profile" class="rounded-circle border" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDP2k8eeq0JTVQvhDO3LCTDGdjq66MSDO5NQuasE5h-TIT6U9ycypcLu8PYhT9lONhpDoHSm12bm7BQ33n-dhDZ_sTIu-ZaulGKN0akDAhBsNyjXBOxgGZi1IAbvt1OMCIp0HZxT_TF9wsV8FsTJJLuE-0t1pPYGoH1qks8PyCyqEj5oeQVxKqPqk1dv5bumF5s6fy9YatCzx-me4j8rcmWXFEFtR9PptPgggvNracVhbUe6HZqV4fRvxRil4xmv1t0XLm2s0rHrhf9" style="width: 32px; height: 32px; object-fit: cover; cursor: pointer;"/>
        </div>
    </div>
</header>
--%>
<!-- Main Content Canvas -->
<main class="main-content">
    <!-- Mobile Header Title -->
    <h2 class="font-heading fs-3 fw-bold mb-3 d-md-none text-dark">Quản lý Đơn hàng</h2>
    <!-- Filter & Search Section -->
    <div class="card p-4">
        <div class="row g-3 align-items-end">
            <!-- Search Input -->
            <div class="col-12 col-lg-4">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Tìm kiếm đơn hàng</label>
                <div class="input-group">
<span class="input-group-text bg-cultured border-end-0 text-secondary-custom">
<span class="material-symbols-outlined fs-6">search</span>
</span>
                    <input class="form-control border-start-0 ps-0" placeholder="Nhập mã đơn hoặc số điện thoại..." type="text"/>
                </div>
            </div>
            <!-- Status Filters -->
            <div class="col-12 col-sm-6 col-lg-3">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Trạng thái đơn</label>
                <select class="form-select">
                    <option value="all">Tất cả trạng thái</option>
                    <option value="new">Mới</option>
                    <option value="processing">Đang xử lý</option>
                    <option value="shipping">Đang giao</option>
                    <option value="completed">Hoàn thành</option>
                    <option value="cancelled">Đã hủy</option>
                </select>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Trạng thái thanh toán</label>
                <select class="form-select">
                    <option value="all">Tất cả</option>
                    <option value="paid">Đã thanh toán</option>
                    <option value="unpaid">Chưa thanh toán</option>
                    <option value="refunded">Đã hoàn tiền</option>
                </select>
            </div>
            <!-- Filter Actions -->
            <div class="col-12 col-lg-2 d-flex gap-2 justify-content-lg-end mt-3 mt-lg-0">
                <button class="btn btn-light font-heading fw-semibold text-dark border">
                    Đặt lại
                </button>
                <button class="btn btn-bittersweet d-flex align-items-center gap-1">
                    <span class="material-symbols-outlined fs-6">filter_list</span>
                    Lọc
                </button>
            </div>
        </div>
    </div>
    <!-- Data Table Section -->
    <div class="card d-flex flex-column" style="min-height: 500px;">
        <div class="card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
            <h3 class="font-heading fs-5 fw-semibold m-0 text-dark">Danh sách đơn hàng (1,245)</h3>
            <button class="btn btn-link text-secondary-custom text-decoration-none d-flex align-items-center gap-1 p-0 font-heading fw-semibold">
                <span class="material-symbols-outlined fs-6">download</span>
                Xuất CSV
            </button>
        </div>
        <div class="table-responsive flex-grow-1">
            <table class="table table-hover mb-0" style="min-width: 800px;">
                <thead>
                <tr>
                    <th>MÃ ĐƠN</th>
                    <th>KHÁCH HÀNG</th>
                    <th>TỔNG TIỀN</th>
                    <th>PHƯƠNG THỨC TT</th>
                    <th>TRẠNG THÁI ĐƠN</th>
                    <th>NGÀY TẠO</th>
                    <th class="text-end">THAO TÁC</th>
                </tr>
                </thead>
                <tbody>
                <!-- Row 1 -->
                <tr>
                    <td class="fw-semibold">#ORD-9823</td>
                    <td>
                        <div class="d-flex flex-column">
                            <span class="fw-medium">Nguyễn Văn A</span>
                            <span class="text-secondary small">0901234567</span>
                        </div>
                    </td>
                    <td class="fw-medium">1,250,000 ₫</td>
                    <td>COD</td>
                    <td>
                        <span class="badge rounded-pill badge-new px-3 py-2 text-uppercase">MỚI</span>
                    </td>
                    <td class="text-secondary-custom">24/10/2023 14:30</td>
                    <td class="text-end">
                        <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết">
                            <span class="material-symbols-outlined">visibility</span>
                        </button>
                    </td>
                </tr>
                <!-- Row 2 -->
                <tr>
                    <td class="fw-semibold">#ORD-9822</td>
                    <td>
                        <div class="d-flex flex-column">
                            <span class="fw-medium">Trần Thị B</span>
                            <span class="text-secondary small">0987654321</span>
                        </div>
                    </td>
                    <td class="fw-medium">3,400,000 ₫</td>
                    <td>Chuyển khoản</td>
                    <td>
                        <span class="badge rounded-pill badge-processing px-3 py-2 text-uppercase">ĐANG XỬ LÝ</span>
                    </td>
                    <td class="text-secondary-custom">24/10/2023 10:15</td>
                    <td class="text-end">
                        <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết">
                            <span class="material-symbols-outlined">visibility</span>
                        </button>
                    </td>
                </tr>
                <!-- Row 3 -->
                <tr>
                    <td class="fw-semibold">#ORD-9821</td>
                    <td>
                        <div class="d-flex flex-column">
                            <span class="fw-medium">Lê Văn C</span>
                            <span class="text-secondary small">0912345678</span>
                        </div>
                    </td>
                    <td class="fw-medium">890,000 ₫</td>
                    <td>VNPay</td>
                    <td>
                        <span class="badge rounded-pill badge-shipping px-3 py-2 text-uppercase">ĐANG GIAO</span>
                    </td>
                    <td class="text-secondary-custom">23/10/2023 16:45</td>
                    <td class="text-end">
                        <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết">
                            <span class="material-symbols-outlined">visibility</span>
                        </button>
                    </td>
                </tr>
                <!-- Row 4 -->
                <tr>
                    <td class="fw-semibold">#ORD-9820</td>
                    <td>
                        <div class="d-flex flex-column">
                            <span class="fw-medium">Phạm Thị D</span>
                            <span class="text-secondary small">0934567890</span>
                        </div>
                    </td>
                    <td class="fw-medium">5,200,000 ₫</td>
                    <td>Thẻ tín dụng</td>
                    <td>
                        <span class="badge rounded-pill badge-completed px-3 py-2 text-uppercase">HOÀN THÀNH</span>
                    </td>
                    <td class="text-secondary-custom">22/10/2023 09:20</td>
                    <td class="text-end">
                        <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết">
                            <span class="material-symbols-outlined">visibility</span>
                        </button>
                    </td>
                </tr>
                <!-- Row 5 -->
                <tr>
                    <td class="fw-semibold text-muted">#ORD-9819</td>
                    <td class="text-muted">
                        <div class="d-flex flex-column">
                            <span class="fw-medium">Hoàng Văn E</span>
                            <span class="small">0945678901</span>
                        </div>
                    </td>
                    <td class="fw-medium text-muted">1,500,000 ₫</td>
                    <td class="text-muted">COD</td>
                    <td>
                        <span class="badge rounded-pill badge-cancelled px-3 py-2 text-uppercase">ĐÃ HỦY</span>
                    </td>
                    <td class="text-secondary-custom text-muted">21/10/2023 11:10</td>
                    <td class="text-end">
                        <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết">
                            <span class="material-symbols-outlined">visibility</span>
                        </button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <!-- Pagination -->
        <div class="card-footer bg-white border-top p-4 d-flex flex-column flex-sm-row align-items-center justify-content-between mt-auto">
            <span class="text-secondary-custom small mb-3 mb-sm-0">Hiển thị 1 - 5 của 1.245 đơn hàng</span>
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm m-0">
                    <li class="page-item disabled">
                        <a aria-label="Previous" class="page-link" href="#">
                            <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_left</span>
                        </a>
                    </li>
                    <li aria-current="page" class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item disabled"><span class="page-link border-0 text-secondary-custom">...</span></li>
                    <li class="page-item"><a class="page-link" href="#">249</a></li>
                    <li class="page-item">
                        <a aria-label="Next" class="page-link" href="#">
                            <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_right</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</main>
<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
