<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    request.setAttribute("adminActive", "reports");
%>
<!DOCTYPE html>
<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BHD Sport Admin - Báo cáo & Thống kê</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Icons+Outlined" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,1,0" rel="stylesheet"/>
    <style>
        :root { --bittersweet: #ff675c; --rich-black-fogra-29: #1c212c; --sidebar-width: 250px; --header-height: 70px; --body-bg: #f8fafb; --text-main: #191c1d; --text-muted: #585f6a; --font-heading: 'Josefin Sans', sans-serif; --font-body: 'Roboto', sans-serif; }
        body { font-family: var(--font-body); background-color: var(--body-bg); color: var(--text-main); font-size: 14px; margin: 0; padding: 0; }
        h1, h2, h3, h4, h5, h6, .navbar-brand, .nav-link, .btn { font-family: var(--font-heading); }
        .main-header { position: fixed; top: 0; right: 0; left: var(--sidebar-width); height: var(--header-height); background-color: #ffffff; z-index: 999; box-shadow: 0 1px 2px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: space-between; padding: 0 24px; }
        .search-bar { background-color: #F0F2F3; border-radius: 4px; padding: 8px 12px; display: flex; align-items: center; width: 300px; }
        .search-bar input { border: none; background: transparent; outline: none; width: 100%; margin-left: 8px; font-size: 14px; }
        .header-actions .btn-icon { background: transparent; border: none; color: var(--text-muted); padding: 8px; border-radius: 50%; position: relative; display: inline-flex; align-items: center; justify-content: center; }
        .header-actions .btn-icon:hover { background-color: #F0F2F3; }
        .notification-badge { position: absolute; top: 4px; right: 4px; width: 8px; height: 8px; background-color: var(--bittersweet); border-radius: 50%; }
        .main-content { margin-left: var(--sidebar-width); margin-top: var(--header-height); padding: 32px; min-height: calc(100vh - var(--header-height)); }
        .page-title { font-size: 28px; font-weight: 600; color: var(--rich-black-fogra-29); margin-bottom: 0; }
        .breadcrumb { margin-bottom: 8px; font-size: 14px; }
        .breadcrumb-item a { color: var(--text-muted); text-decoration: none; }
        .breadcrumb-item.active { color: var(--text-main); font-weight: 500; }
        .custom-card { background: #fff; border-radius: 8px; border: 1px solid rgba(220, 220, 220, 0.5); box-shadow: 0 1px 3px rgba(0,0,0,0.02); padding: 24px; height: 100%; position: relative; overflow: hidden; transition: box-shadow 0.2s; }
        .custom-card:hover { box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .stat-icon-wrapper { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .stat-bg-circle { position: absolute; top: -16px; right: -16px; width: 96px; height: 96px; border-radius: 50%; z-index: 0; transition: transform 0.5s; }
        .custom-card:hover .stat-bg-circle { transform: scale(1.1); }
        .card-content { position: relative; z-index: 1; }
        .stat-label { font-size: 14px; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .stat-value { font-size: 28px; font-weight: 600; color: var(--rich-black-fogra-29); margin-bottom: 0; }
        .table-card { background: #fff; border-radius: 8px; border: 1px solid rgba(220, 220, 220, 0.5); overflow: hidden; }
        .table-header { padding: 20px 24px; border-bottom: 1px solid #DCDCDC; display: flex; justify-content: space-between; align-items: center; }
        .table-header h3 { font-size: 22px; font-weight: 600; margin: 0; }
        .custom-table { margin-bottom: 0; }
        .custom-table th { font-family: var(--font-heading); font-size: 13px; font-weight: 700; color: var(--text-muted); text-transform: uppercase; padding: 16px 24px; background-color: #f8fafb; border-bottom: 1px solid #DCDCDC; }
        .custom-table td { padding: 16px 24px; vertical-align: middle; border-bottom: 1px solid #DCDCDC; }
        .custom-table tr:hover td { background-color: #F0F2F3; }
        .product-img { width: 60px; height: 60px; border-radius: 4px; object-fit: cover; background-color: #DCDCDC; }
        .text-bittersweet { color: var(--bittersweet); }
        .bg-bittersweet { background-color: var(--bittersweet); }
        .btn-bittersweet { background-color: var(--bittersweet); color: white; font-weight: 600; border: none; border-radius: 4px; }
        .btn-bittersweet:hover { background-color: #FF756B; color: white; }
        .status-done-bg { background-color: #d1fae5; }
        .status-done-text { color: #065f46; }
        .status-proc-bg { background-color: #dbeafe; }
        .status-proc-text { color: #1e40af; }
        .status-new-bg { background-color: #fee2e2; }
        .status-new-text { color: #991b1b; }
        .status-ship-bg { background-color: #e0f2fe; }
        .status-ship-text { color: #0284c7; }
        .date-filter { background: white; border: 1px solid #DCDCDC; border-radius: 4px; padding: 8px 12px; display: flex; align-items: center; }
        .date-filter input { border: none; outline: none; width: 110px; color: var(--text-muted); }
        .chart-placeholder { background-color: #F0F2F3; border-radius: 8px; min-height: 300px; display: flex; align-items: center; justify-content: center; color: var(--text-muted); text-align: center; padding: 20px; }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<jsp:include page="topbar.jsp"/>
<main class="main-content">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                    <li aria-current="page" class="breadcrumb-item active">Báo cáo</li>
                </ol>
            </nav>
            <h2 class="page-title">Báo cáo & Thống kê</h2>
        </div>
        <div class="d-flex flex-wrap align-items-center gap-2">
            <div class="date-filter shadow-sm">
                <span class="material-symbols-outlined text-muted me-2" style="font-size: 18px;">calendar_today</span>
                <input type="date" id="startDate"/>
                <span class="mx-2 text-muted">-</span>
                <input type="date" id="endDate"/>
                <button class="btn btn-bittersweet ms-2" id="applyDateFilter" style="font-weight: 600;">Lưu</button>
            </div>
        </div>
    </div>
    <div class="row g-4 mb-4">
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(255, 103, 92, 0.05);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Tổng doanh thu</div>
                        <div class="stat-value" id="statRevenue">--</div>
                    </div>
                    <div class="stat-icon-wrapper status-done-bg status-done-text"><span class="material-symbols-outlined">payments</span></div>
                </div>
                <div class="card-content d-flex align-items-center" id="statRevenueGrowth">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px;">trending_up</span>
                    <span class="fw-medium">--</span>
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">so với kỳ trước</span>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(219, 234, 254, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Tổng đơn hàng</div>
                        <div class="stat-value" id="statOrders">--</div>
                    </div>
                    <div class="stat-icon-wrapper status-proc-bg status-proc-text"><span class="material-symbols-outlined">local_shipping</span></div>
                </div>
                <div class="card-content d-flex align-items-center" id="statOrdersGrowth">
                    <span class="material-symbols-outlined me-1" style="font-size: 16px;">trending_up</span>
                    <span class="fw-medium">--</span>
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">so với kỳ trước</span>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(255, 218, 214, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Lợi nhuận ước tính</div>
                        <div class="stat-value" id="statProfit">--</div>
                    </div>
                    <div class="stat-icon-wrapper status-new-bg status-new-text"><span class="material-symbols-outlined">account_balance_wallet</span></div>
                </div>
                <div class="card-content d-flex align-items-center text-muted">
                    <span class="text-muted ms-2" style="color: var(--text-muted) !important;">Dựa trên giá nhập</span>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6 col-xl-3">
            <div class="custom-card">
                <div class="stat-bg-circle" style="background-color: rgba(224, 242, 254, 0.5);"></div>
                <div class="card-content d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div class="stat-label">Sản phẩm bán chạy</div>
                        <div class="stat-value" style="font-size: 20px;" id="statTopProduct">--</div>
                    </div>
                    <div class="stat-icon-wrapper status-ship-bg status-ship-text"><span class="material-symbols-outlined">stars</span></div>
                </div>
                <div class="card-content d-flex align-items-center text-dark">
                    <span class="fw-medium" id="statTopProductQty">--</span>
                    <span class="text-muted ms-1">đơn vị đã bán</span>
                </div>
            </div>
        </div>
    </div>
    <div class="row g-4 mb-4">
        <div class="col-12 col-lg-8">
            <div class="custom-card d-flex flex-column h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="m-0" style="font-size: 22px; font-weight: 600;">Biểu đồ doanh thu</h3>
                    <div class="d-flex gap-2">
                        <span class="badge bg-bittersweet rounded-pill px-3 py-2">Kỳ này</span>
                        <span class="badge bg-light text-secondary border rounded-pill px-3 py-2">Kỳ trước</span>
                    </div>
                </div>
                <div class="chart-placeholder flex-grow-1" id="revenueChart"><div class="text-center text-muted">Đang tải dữ liệu...</div></div>
            </div>
        </div>
        <div class="col-12 col-lg-4">
            <div class="custom-card d-flex flex-column h-100">
                <h3 class="mb-4" style="font-size: 22px; font-weight: 600;">Cơ cấu thương hiệu</h3>
                <div class="chart-placeholder mb-4" style="min-height: 220px;" id="categoryChart"><div class="text-center text-muted">Đang tải...</div></div>
                <div class="d-flex flex-column gap-3 mt-auto" id="categoryBreakdown"></div>
            </div>
        </div>
    </div>
    <div class="table-card mb-4 shadow-sm">
        <div class="table-header"><h3 class="">Top 5 Sản phẩm bán chạy nhất</h3></div>
        <div class="table-responsive">
            <table class="table custom-table mb-0">
                <thead>
                <tr class="bg-light">
                    <th class="px-4 py-3 border-bottom text-start" style="width: 40%;">Sản phẩm</th>
                    <th class="px-4 py-3 border-bottom text-center">Thương hiệu</th>
                    <th class="px-4 py-3 border-bottom text-end">Doanh số</th>
                    <th class="px-4 py-3 border-bottom text-end">Doanh thu</th>
                </tr>
                </thead>
                <tbody id="topProductsTableBody">
                    <tr class="align-middle">
                        <td class="px-4 py-3 text-center text-muted" colspan="4">Đang tải dữ liệu...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
window.contextPath = '${pageContext.request.contextPath}';

function formatCurrency(value) {
    if (value >= 1000000) return (value / 1000000).toFixed(1) + 'M ₫';
    if (value >= 1000) return (value / 1000).toFixed(0) + 'K ₫';
    return value.toFixed(0) + ' ₫';
}
function formatNumber(value) { return value.toLocaleString('vi-VN'); }

function renderGrowth(elementId, growthValue) {
    const el = document.getElementById(elementId);
    if (!el) return;
    const icon = el.querySelector('.material-symbols-outlined');
    const span = el.querySelector('.fw-medium');
    if (icon && span) {
        if (growthValue > 0) {
            icon.textContent = 'trending_up'; icon.style.color = '#065f46'; el.style.color = '#065f46';
            span.textContent = '+' + growthValue.toFixed(1) + '%';
        } else if (growthValue < 0) {
            icon.textContent = 'trending_down'; icon.style.color = '#991b1b'; el.style.color = '#991b1b';
            span.textContent = growthValue.toFixed(1) + '%';
        } else {
            icon.textContent = 'trending_flat'; icon.style.color = '#585f6a'; el.style.color = '#585f6a';
            span.textContent = '0%';
        }
    }
}

function renderTopProducts(products) {
    const tbody = document.getElementById('topProductsTableBody');
    if (!tbody) return;
    tbody.innerHTML = '';
    if (!products || products.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">Chưa có dữ liệu</td></tr>';
        return;
    }
    products.forEach(p => {
        const tr = document.createElement('tr');
        tr.className = 'align-middle';
        const imgHtml = p.imageUrl
            ? '<img alt="' + p.name + '" class="product-img" src="' + p.imageUrl + '" onerror="this.style.display=\'none\'">'
            : '<div class="product-img d-flex align-items-center justify-content-center text-muted"><span class="material-symbols-outlined">image</span></div>';
        tr.innerHTML = '<td class="px-4 py-3"><div class="d-flex align-items-center gap-3">' + imgHtml +
            '<span class="fw-medium text-dark">' + p.name + '</span></div></td>' +
            '<td class="px-4 py-3 text-center text-muted">' + (p.brandName || 'N/A') + '</td>' +
            '<td class="px-4 py-3 text-end fw-medium">' + formatNumber(p.totalQuantity) + '</td>' +
            '<td class="px-4 py-3 text-end fw-bold" style="color: var(--bittersweet);">' + formatCurrency(p.totalRevenue) + '</td>';
        tbody.appendChild(tr);
    });
}

// ====== PIE CHART FOR BRAND DISTRIBUTION ======
const PIE_COLORS = ['#ff675c', '#1e40af', '#0284c7', '#065f46', '#92400e', '#9333ea', '#0d9488', '#dc2626'];

function renderBrandPieChart(brands) {
    const chartContainer = document.getElementById('categoryChart');
    const breakdownContainer = document.getElementById('categoryBreakdown');
    if (!chartContainer || !breakdownContainer) return;

    // Remove flex centering from chart container
    chartContainer.style.display = 'block';
    chartContainer.style.alignItems = '';
    chartContainer.style.justifyContent = '';

    if (!brands || brands.length === 0) {
        chartContainer.innerHTML = '<div class="text-center text-muted" style="padding:40px 0;">Chưa có dữ liệu</div>';
        breakdownContainer.innerHTML = '';
        return;
    }

    const totalQty = brands.reduce((sum, b) => sum + (b.totalQuantity || 0), 0);
    if (totalQty === 0) {
        chartContainer.innerHTML = '<div class="text-center text-muted" style="padding:40px 0;">Chưa có dữ liệu</div>';
        breakdownContainer.innerHTML = '';
        return;
    }

    // Build conic-gradient for pie chart
    let gradientParts = [];
    let cumulativePercent = 0;
    brands.forEach((b, idx) => {
        const pct = ((b.totalQuantity || 0) / totalQty) * 100;
        const color = PIE_COLORS[idx % PIE_COLORS.length];
        gradientParts.push(color + ' ' + cumulativePercent.toFixed(1) + '% ' + (cumulativePercent + pct).toFixed(1) + '%');
        cumulativePercent += pct;
    });

    chartContainer.innerHTML = '<div style="display:flex;justify-content:center;padding:15px 0;">' +
        '<div style="width:180px;height:180px;border-radius:50%;background:conic-gradient(' + gradientParts.join(', ') + ');box-shadow:0 2px 8px rgba(0,0,0,0.15);border:2px solid #fff;"></div></div>';

    // Build breakdown list with percentages
    breakdownContainer.innerHTML = brands.map((b, idx) => {
        const pct = totalQty > 0 ? ((b.totalQuantity / totalQty) * 100).toFixed(1) : 0;
        const color = PIE_COLORS[idx % PIE_COLORS.length];
        return '<div class="d-flex justify-content-between align-items-center py-1">' +
            '<div class="d-flex align-items-center">' +
            '<span style="width:14px;height:14px;border-radius:50%;background:' + color + ';display:inline-block;margin-right:8px;"></span>' +
            '<span class="fw-medium">' + (b.brandName || 'Không rõ') + '</span></div>' +
            '<span><strong>' + pct + '%</strong> <small class="text-muted">(' + formatNumber(b.totalQuantity) + ' SP)</small></span></div>';
    }).join('');
}

// ====== REVENUE BAR CHART ======
function renderRevenueChart(chartData) {
    const container = document.getElementById('revenueChart');
    if (!container) return;
    if (!chartData || !chartData.labels || chartData.labels.length === 0) {
        container.innerHTML = '<div class="text-center text-muted">Không có dữ liệu</div>';
        return;
    }
    container.style.display = 'block';
    container.style.alignItems = '';
    container.style.justifyContent = '';

    const currentData = chartData.currentPeriodData || [];
    const prevData = chartData.lastYearPeriodData || [];
    const allValues = [...currentData, ...prevData].filter(v => v && v > 0);
    const maxVal = allValues.length > 0 ? Math.max(...allValues) : 1;
    const barGroupHeight = 220;

    let html = '<div style="width:100%;overflow-x:auto;padding:15px 5px;">';
    html += '<div style="display:flex;align-items:flex-end;gap:6px;min-width:' + Math.max(chartData.labels.length * 55, 300) + 'px;height:' + (barGroupHeight + 35) + 'px;">';
    chartData.labels.forEach((label, i) => {
        const curVal = currentData[i] || 0;
        const prevVal = prevData[i] || 0;
        const curH = Math.round((curVal / maxVal) * barGroupHeight);
        const prevH = Math.round((prevVal / maxVal) * barGroupHeight);
        html += '<div style="flex:1;display:flex;flex-direction:column;align-items:center;gap:2px;">' +
            '<div style="display:flex;align-items:flex-end;gap:2px;height:' + barGroupHeight + 'px;padding-top:5px;">' +
            '<div style="width:14px;height:' + Math.max(curH, 1) + 'px;background:#ff675c;border-radius:2px 2px 0 0;" title="Kỳ này: ' + formatCurrency(curVal) + '"></div>' +
            '<div style="width:14px;height:' + Math.max(prevH, 1) + 'px;background:#dcdcdc;border-radius:2px 2px 0 0;" title="Kỳ trước: ' + formatCurrency(prevVal) + '"></div></div>' +
            '<div style="font-size:10px;color:#585f6a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:45px;text-align:center;">' + label + '</div></div>';
    });
    html += '</div></div>';
    html += '<div class="d-flex gap-3 justify-content-center mt-2">' +
        '<div class="d-flex align-items-center gap-1"><div style="width:12px;height:12px;background:#ff675c;border-radius:2px;"></div><small>Kỳ này</small></div>' +
        '<div class="d-flex align-items-center gap-1"><div style="width:12px;height:12px;background:#dcdcdc;border-radius:2px;"></div><small>Kỳ trước</small></div></div>';
    container.innerHTML = html;
}

// ====== DATE HELPERS ======
function setDefaultDates() {
    const today = new Date();
    const y = today.getFullYear();
    const m = String(today.getMonth() + 1).padStart(2, '0');
    const d = String(today.getDate()).padStart(2, '0');
    document.getElementById('endDate').value = y + '-' + m + '-' + d;
    document.getElementById('startDate').value = y + '-01-01';
}

function getDates() {
    let s = document.getElementById('startDate').value;
    let e = document.getElementById('endDate').value;
    if (!s || !e) { setDefaultDates(); s = document.getElementById('startDate').value; e = document.getElementById('endDate').value; }
    return { startDate: s, endDate: e };
}

// ====== LOAD FUNCTIONS ======
function loadStatistics(startDate, endDate) {
    let url = window.contextPath + '/admin/api/statistics';
    if (startDate && endDate) url += '?startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate);
    fetch(url)
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                document.getElementById('statRevenue').textContent = 'Lỗi';
                document.getElementById('statOrders').textContent = 'Lỗi';
                document.getElementById('statProfit').textContent = 'Lỗi';
                return;
            }
            document.getElementById('statRevenue').textContent = formatCurrency(data.totalRevenue || 0);
            document.getElementById('statOrders').textContent = formatNumber(data.totalOrders || 0);
            document.getElementById('statProfit').textContent = formatCurrency(data.estimatedProfit || 0);
            if (data.topProducts && data.topProducts.length > 0) {
                document.getElementById('statTopProduct').textContent = data.topProducts[0].name || 'N/A';
                document.getElementById('statTopProductQty').textContent = formatNumber(data.topProducts[0].totalQuantity || 0);
            }
            renderGrowth('statRevenueGrowth', data.revenueGrowth || 0);
            renderGrowth('statOrdersGrowth', data.ordersGrowth || 0);
            renderTopProducts(data.topProducts);
            renderBrandPieChart(data.categorySales);
        })
        .catch(err => {
            console.error('Lỗi thống kê:', err);
            document.getElementById('statRevenue').textContent = 'Lỗi';
            document.getElementById('statOrders').textContent = 'Lỗi';
            document.getElementById('statProfit').textContent = 'Lỗi';
        });
}

function loadChart(startDate, endDate) {
    let url = window.contextPath + '/admin/api/chart-statistics?metric=revenue';
    if (startDate && endDate) url += '&startDate=' + encodeURIComponent(startDate) + '&endDate=' + encodeURIComponent(endDate);
    fetch(url)
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                document.getElementById('revenueChart').innerHTML = '<div class="text-center text-muted">Lỗi tải dữ liệu</div>';
                return;
            }
            renderRevenueChart(data);
        })
        .catch(err => {
            document.getElementById('revenueChart').innerHTML = '<div class="text-center text-muted">Lỗi: ' + err.message + '</div>';
        });
}

function refreshData() {
    const { startDate, endDate } = getDates();
    loadStatistics(startDate, endDate);
    loadChart(startDate, endDate);
}

// ====== INIT ======
document.addEventListener('DOMContentLoaded', function() {
    setDefaultDates();
    refreshData();
    document.getElementById('applyDateFilter').addEventListener('click', refreshData);
});
</script>
</body></html>