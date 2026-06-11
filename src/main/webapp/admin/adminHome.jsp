<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "dashboard");
%>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BHD Sport Shoes - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="../assets/css/adminHome.css"/>
    <style>
        .order-status-item {
            padding: 12px;
            border-radius: 8px;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s;
        }
        .order-status-item:hover { background: #e9ecef; }
        .review-item {
            border-bottom: 1px dashed #eee;
            padding-bottom: 12px;
        }
        .review-item:last-child { border-bottom: none; padding-bottom: 0; }
        .rating-stars { color: #ffc107; font-size: 14px; }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<jsp:include page="topbar.jsp"/>

<main class="main-content">
    <h1 class="page-title font-headline">Bảng điều khiển</h1>

    <div class="d-flex flex-wrap align-items-center gap-3 mb-4">
        <div class="d-flex gap-1 flex-wrap" id="time-presets-group">
            <button type="button" class="control-chip" data-range="today">Hôm nay</button>
            <button type="button" class="control-chip" data-range="yesterday">Hôm qua</button>
            <button type="button" class="control-chip" data-range="7days">7 ngày qua</button>
            <button type="button" class="control-chip active" data-range="this-month">Tháng này</button>
            <button type="button" class="control-chip" data-range="this-year">Năm nay</button>
        </div>

        <div id="custom-date-picker-container" class="d-flex align-items-center gap-2 bg-white p-2 rounded border shadow-sm">
            <div class="d-flex align-items-center gap-1">
                <label for="input-start-date" class="small text-secondary m-0" style="white-space: nowrap;">Từ:</label>
                <input type="date" id="input-start-date" class="form-control form-control-sm" style="width: auto;">
            </div>
            <div class="d-flex align-items-center gap-1">
                <label for="input-end-date" class="small text-secondary m-0" style="white-space: nowrap;">Đến:</label>
                <input type="date" id="input-end-date" class="form-control form-control-sm" style="width: auto;">
            </div>
            <button type="button" id="btn-apply-custom" class="btn btn-sm btn-bittersweet px-3 py-1">Áp dụng</button>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">shopping_bag</span>
                </div>
                <p class="stat-label">Tổng đơn hàng</p>
                <p class="stat-value">
                    <span id="kpi-orders"></span>
                    <small id="growth-orders" class="text-success ms-1 fw-bold"></small>
                </p>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">payments</span>
                </div>
                <p class="stat-label">Doanh thu</p>
                <p class="stat-value">
                    <span id="kpi-revenue"></span>
                    <small id="growth-revenue" class="text-success ms-1 fw-bold"></small>
                </p>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">inventory_2</span>
                </div>
                <p class="stat-label">
                    Sản phẩm
                    <span id="kpi-lowstock-badge" class="badge bg-danger ms-1"></span>
                </p>
                <p class="stat-value">
                    <span id="kpi-products"></span>
                </p>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3">
            <div class="stat-card">
                <div class="stat-icon-wrapper">
                    <span class="material-symbols-outlined">group</span>
                </div>
                <p class="stat-label">Người dùng mới</p>
                <p class="stat-value">
                    <span id="kpi-customers"></span>
                    <small id="growth-users" class="text-danger ms-1 fw-bold"></small>
                </p>
            </div>
        </div>
    </div>

    <div class="custom-card mt-4" id="revenueCompareCard">
        <div class="custom-card-header d-flex justify-content-between align-items-center flex-wrap gap-3">
            <h2 class="custom-card-title m-0">Biểu đồ phân tích kinh doanh</h2>
            <div class="d-flex align-items-center gap-3 flex-wrap">
                <div class="d-flex align-items-center gap-2">
                    <label for="chartYAxisSelect" class="form-label m-0 text-secondary" style="font-size: 14px; white-space: nowrap;">Thống kê theo (Trục Y):</label>
                    <select id="chartYAxisSelect" class="form-select form-select-sm" style="width: auto; min-width: 160px;">
                        <option value="revenue" selected>Doanh thu (₫)</option>
                        <option value="quantity">Số lượng bán (Đôi)</option>
                        <option value="orders">Số lượng đơn hàng</option>
                    </select>
                </div>
                <button type="button" class="btn btn-bittersweet d-flex align-items-center gap-1" style="width: 186px; height: 40px;">
                    Thêm biểu đồ so sánh
                </button>
            </div>
        </div>
        <div class="p-3 p-md-4">
            <div style="height: 350px; width: 100%; position: relative;">
                <canvas id="dashboardAnalyticsChart"></canvas>
            </div>
        </div>
    </div>

    <div class="row g-4 mt-2">

        <div class="col-12 col-lg-8">
            <div class="custom-card mt-4" id="productStatsCard">
                <div class="custom-card-header flex-wrap gap-3">
                    <h2 class="custom-card-title m-0">Thống kê sản phẩm</h2>
                    <div class="d-flex align-items-center gap-3 flex-wrap">
                        <div class="d-flex gap-1" id="product-tab-group">
                            <button class="control-chip active" data-tab="sold">
                                <span class="material-symbols-outlined" style="font-size:15px;vertical-align:-3px">trending_up</span>
                                Bán chạy
                            </button>
                            <button class="control-chip" data-tab="unsold">
                                <span class="material-symbols-outlined" style="font-size:15px;vertical-align:-3px">trending_down</span>
                                Không bán được
                            </button>
                            <button class="control-chip" data-tab="lowstock">
                                <span class="material-symbols-outlined" style="font-size:15px;vertical-align:-3px">warning</span>
                                Sắp hết hàng
                            </button>
                        </div>
                        <a href="<%=request.getContextPath()%>/admin/quanlykhohang.jsp" class="text-decoration-none d-flex align-items-center gap-1"
                           style="font-size:13px; color: var(--color-bittersweet); font-weight:600; white-space:nowrap;">
                            Xem tất cả
                            <span class="material-symbols-outlined" style="font-size:16px;">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <div class="px-4 pt-3 pb-1">
                    <p id="product-tab-desc" class="text-secondary m-0" style="font-size:13px;">
                        Top 5 sản phẩm bán chạy nhất trong kỳ đã chọn.
                    </p>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle mb-0" id="product-stats-table">
                        <thead>
                        <tr>
                            <th style="width:40px">#</th>
                            <th>SẢN PHẨM</th>
                            <th>THƯƠNG HIỆU</th>
                            <th class="text-center" id="col-sold-header">SỐ LƯỢNG BÁN</th>
                            <th class="text-end"   id="col-revenue-header">DOANH THU</th>
                            <th class="text-center">TỒN KHO</th>
                        </tr>
                        </thead>
                        <tbody id="product-stats-tbody">
                        <tr>
                            <td colspan="6" class="text-center py-4">
                                <div class="spinner-border spinner-border-sm text-danger me-2"></div>
                                Đang tải...
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-12 col-lg-4 d-flex flex-column gap-4">

            <div class="custom-card mt-4 shadow-sm" style="margin-top: 0!important;">
                <div class="custom-card-header d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <span class="material-symbols-outlined text-primary">fiber_new</span>
                        <h2 class="custom-card-title m-0 text-primary fw-bold">Đơn hàng mới</h2>
                    </div>
                    <span class="badge bg-primary p-2" id="new-orders-count">0 đơn</span>
                </div>

                <div class="table-responsive" style="max-height: 350px; overflow-y: auto;">
                    <table class="table table-sm table-hover align-middle m-0" style="font-size: 0.85rem;">
                        <thead class="table-light position-sticky top-0" style="z-index: 1;">
                        <tr>
                            <th class="py-2">MÃ</th>
                            <th class="py-2">NGÀY ĐẶT</th>
                            <th class="py-2">TỔNG TIỀN</th>
                            <th class="text-center py-2">THANH TOÁN</th>
                            <th class="text-center py-2">XỬ LÝ</th>
                        </tr>
                        </thead>
                        <tbody id="new-orders-tbody">
                        <tr>
                            <td colspan="5" class="text-center py-4 text-secondary">
                                <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
                                Đang tải đơn hàng mới...
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white text-center py-2 border-top">
                    <a href="#" class="text-decoration-none text-primary fw-semibold d-inline-flex align-items-center gap-1" style="font-size: 0.9rem;">
                        Xem tất cả đơn hàng <span class="material-symbols-outlined" style="font-size: 16px;">arrow_forward</span>
                    </a>
                </div>
            </div>

            <div class="custom-card mt-0 shadow-sm">
                <div class="custom-card-header">
                    <h2 class="custom-card-title m-0" style="font-size: 16px;">Đánh giá mới nhất</h2>
                </div>
                <div class="p-3 d-flex flex-column gap-3" id="recent-reviews-container">
                    <div class="review-item">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-semibold text-dark" style="font-size: 14px;">Nguyễn Văn A</span>
                            <span class="text-secondary" style="font-size: 11px;">10 phút trước</span>
                        </div>
                        <div class="rating-stars mb-1">★★★★★</div>
                        <p class="text-secondary m-0 text-truncate" style="font-size: 13px;" title="Giày đi rất êm chân, form ôm sát, đáng đồng tiền bát gạo!">
                            Giày đi rất êm chân, form ôm sát...
                        </p>
                        <small class="text-muted" style="font-size: 11px;">Sản phẩm: Nike Air Zoom Pegasus 39</small>
                    </div>

                    <div class="review-item">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-semibold text-dark" style="font-size: 14px;">Trần Thị B</span>
                            <span class="text-secondary" style="font-size: 11px;">1 giờ trước</span>
                        </div>
                        <div class="rating-stars mb-1">★★★★☆</div>
                        <p class="text-secondary m-0 text-truncate" style="font-size: 13px;">
                            Đóng gói cẩn thận, tuy nhiên giao hàng hơi lâu...
                        </p>
                        <small class="text-muted" style="font-size: 11px;">Sản phẩm: Adidas Ultraboost 22</small>
                    </div>
                </div>
            </div>

        </div>
    </div>
</main>

<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-light">
                <h5 class="modal-title font-headline fw-bold text-primary" id="orderDetailModalLabel">
                    Chi tiết đơn hàng <span id="modalOrderId" class="text-dark"></span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-3 mb-4 p-3 bg-light rounded border border-light-subtle mx-0">
                    <div class="col-sm-7">
                        <p class="mb-2 text-secondary" style="font-size: 0.85rem;">
                            Mã đơn: <strong class="text-dark fs-6" id="modalOrderCode"></strong>
                        </p>
                        <p class="mb-2 text-secondary" style="font-size: 0.85rem;">
                            Khách hàng: <strong class="text-dark" id="modalCustomer"></strong>
                        </p>
                        <p class="mb-0 text-secondary" style="font-size: 0.85rem;">
                            Ngày tạo: <strong class="text-dark" id="modalOrderDate"></strong>
                        </p>
                    </div>
                    <div class="col-sm-5 text-sm-end">
                        <p class="mb-2 text-secondary" style="font-size: 0.85rem;">
                            Trạng thái: <span id="modalOrderStatus"></span>
                        </p>
                        <p class="mb-2 text-secondary" style="font-size: 0.85rem;">
                            Thanh toán: <strong class="text-dark" id="modalPaymentMethod"></strong>
                        </p>
                        <p class="mb-0 text-secondary" style="font-size: 0.85rem;">
                            Tổng tiền: <strong class="text-bittersweet fs-5" id="modalOrderTotal"></strong>
                        </p>
                    </div>
                </div>

                <h6 class="fw-bold mb-3 border-bottom pb-2" style="font-size: 15px;">Danh sách sản phẩm</h6>
                <div class="table-responsive">
                    <table class="table align-middle table-sm border" style="font-size: 0.875rem;">
                        <thead class="table-light text-secondary" style="font-size: 0.8rem;">
                        <tr>
                            <th class="ps-2" style="padding-left: 24px!important;">SẢN PHẨM</th>
                            <th class="text-center">PHÂN LOẠI</th>
                            <th class="text-center">SL</th>
                            <th class="text-end pe-2" style="padding-right: 24px!important;">ĐƠN GIÁ</th>
                        </tr>
                        </thead>
                        <tbody id="modalOrderItemsTbody">
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Đóng</button>

                <button type="button" class="btn btn-danger d-flex align-items-center gap-1" id="btnModalCancelOrder">
                    <span class="material-symbols-outlined" style="font-size: 18px;">cancel</span> Hủy đơn hàng
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/script/productStats.js"></script>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="../assets/script/adminHome.js"></script>
</body>
</html>