<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    request.setAttribute("adminActive", "orders");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Đơn hàng - BHD Sport Admin</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
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
        body { background-color: var(--cultured); font-family: var(--bs-font-sans-serif); }
        h1, h2, h3, h4, h5, h6, .font-heading { font-family: 'Josefin Sans', sans-serif; }
        .main-content { margin-left: var(--sidebar-width); margin-top: var(--header-height); padding: 2rem; min-height: calc(100vh - var(--header-height)); }
        .btn-bittersweet { background-color: var(--bittersweet); color: white; border: none; font-family: 'Josefin Sans', sans-serif; font-weight: 600; }
        .btn-bittersweet:hover { background-color: var(--salmon); color: white; }
        .form-control, .form-select { background-color: var(--cultured); border-color: #DCDCDC; }
        .form-control:focus, .form-select:focus { border-color: var(--bittersweet); box-shadow: 0 0 0 0.25rem rgba(255, 103, 92, 0.25); }
        .card { border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-radius: 0.75rem; margin-bottom: 1.5rem; }
        .table th { font-family: 'Josefin Sans', sans-serif; text-transform: uppercase; font-size: 13px; font-weight: 700; color: #585f6a; border-top: none; border-bottom: 1px solid #DCDCDC; padding: 1rem 1.5rem; background-color: #f8fafb; }
        .table td { vertical-align: middle; padding: 1rem 1.5rem; border-bottom: 1px solid #DCDCDC; }
        .page-link { color: #585f6a; border-color: #DCDCDC; }
        .page-item.active .page-link { background-color: var(--bittersweet); border-color: var(--bittersweet); color: white; }
        .page-link:hover { background-color: var(--cultured); color: var(--rich-black); }
        .text-secondary-custom { color: #585f6a; }
        .bg-cultured { background-color: var(--cultured); }
        .material-symbols-outlined { vertical-align: middle; }
        .badge-new { background-color: #fee2e2; color: #991b1b; }
        .badge-processing { background-color: #dbeafe; color: #1e40af; }
        .badge-shipping, .badge-shipped { background-color: #e0f2fe; color: #0284c7; }
        .badge-completed, .badge-delivered { background-color: #d1fae5; color: #065f46; }
        .badge-cancelled { background-color: #f3f4f6; color: #374151; border: 1px solid #DCDCDC; }
        .badge-unpaid { background-color: #fef3c7; color: #92400e; }
        .badge-paid { background-color: #d1fae5; color: #065f46; }
        .badge-refunded { background-color: #e0e7ff; color: #3730a3; }
        .badge-pending { background-color: #fef3c7; color: #92400e; }
        .status-select { min-width: 130px; font-size: 13px; }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<jsp:include page="topbar.jsp"/>

<main class="main-content">
    <h2 class="font-heading fs-3 fw-bold mb-3 d-md-none text-dark">Quản lý Đơn hàng</h2>

    <!-- Filter & Search Section -->
    <div class="card p-4">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-lg-4">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Tìm kiếm đơn hàng</label>
                <div class="input-group">
                    <span class="input-group-text bg-cultured border-end-0 text-secondary-custom">
                        <span class="material-symbols-outlined fs-6">search</span>
                    </span>
                    <input class="form-control border-start-0 ps-0" id="searchInput" placeholder="Nhập mã đơn hoặc số điện thoại..." type="text" value="${search}"/>
                </div>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Trạng thái đơn</label>
                <select class="form-select" id="statusFilter">
                    <option value="all" ${status == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="NEW" ${status == 'NEW' ? 'selected' : ''}>Mới</option>
                    <option value="PROCESSING" ${status == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                    <option value="SHIPPED" ${status == 'SHIPPED' ? 'selected' : ''}>Đang giao</option>
                    <option value="DELIVERED" ${status == 'DELIVERED' ? 'selected' : ''}>Đã giao</option>
                    <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                </select>
            </div>
            <div class="col-12 col-sm-6 col-lg-3">
                <label class="form-label font-heading fw-semibold text-secondary-custom mb-1">Trạng thái thanh toán</label>
                <select class="form-select" id="paymentStatusFilter">
                    <option value="all" ${paymentStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                    <option value="PAID" ${paymentStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="UNPAID" ${paymentStatus == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                    <option value="REFUNDED" ${paymentStatus == 'REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                    <option value="FAILED" ${paymentStatus == 'FAILED' ? 'selected' : ''}>Thất bại</option>
                </select>
            </div>
            <div class="col-12 col-lg-2 d-flex gap-2 justify-content-lg-end mt-3 mt-lg-0">
                <button class="btn btn-light font-heading fw-semibold text-dark border" onclick="resetFilters()">Đặt lại</button>
                <button class="btn btn-bittersweet d-flex align-items-center gap-1" onclick="applyFilters()">
                    <span class="material-symbols-outlined fs-6">filter_list</span>
                    Lọc
                </button>
            </div>
        </div>
    </div>

    <!-- Data Table Section -->
    <div class="card d-flex flex-column" style="min-height: 500px;">
        <div class="card-header bg-white border-bottom p-4 d-flex justify-content-between align-items-center">
            <h3 class="font-heading fs-5 fw-semibold m-0 text-dark">Danh sách đơn hàng (<span id="totalCountDisplay">${totalCount}</span>)</h3>
        </div>
        <div class="table-responsive flex-grow-1">
            <table class="table table-hover mb-0" style="min-width: 900px;">
                <thead>
                <tr>
                    <th>MÃ ĐƠN</th>
                    <th>KHÁCH HÀNG</th>
                    <th>TỔNG TIỀN</th>
                    <th>THANH TOÁN</th>
                    <th>TRẠNG THÁI ĐƠN</th>
                    <th>NGÀY TẠO</th>
                    <th class="text-end">XEM CHI TIẾT</th>
                </tr>
                </thead>
                <tbody id="ordersTableBody">
                <c:choose>
                    <c:when test="${empty orders}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">Không có đơn hàng nào</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td class="fw-semibold">${order.ordersId != null ? order.ordersId : '#ORD-'}${order.id}</td>
                                <td>
                                    <div class="d-flex flex-column">
                                        <span class="fw-medium">${order.recipientName != null ? order.recipientName : 'N/A'}</span>
                                        <span class="text-secondary small">${order.recipientPhone != null ? order.recipientPhone : order.phoneNumber}</span>
                                    </div>
                                </td>
                                <td class="fw-medium">
                                    <fmt:formatNumber value="${order.grandTotal}" pattern="#,###"/> ₫
                                </td>
                                <td>
                                    <span class="badge rounded-pill px-3 py-2 text-uppercase
                                        ${order.paymentStatus == 'PAID' ? 'badge-paid' :
                                          order.paymentStatus == 'UNPAID' ? 'badge-unpaid' :
                                          order.paymentStatus == 'REFUNDED' ? 'badge-refunded' : 'badge-pending'}">
                                            ${order.paymentStatus == 'PAID' ? 'Đã thanh toán' :
                                              order.paymentStatus == 'UNPAID' ? 'Chưa TT' :
                                              order.paymentStatus == 'REFUNDED' ? 'Hoàn tiền' : 'Đang xử lý'}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge rounded-pill px-3 py-2 text-uppercase
                                        ${order.orderStatus == 'NEW' ? 'badge-new' :
                                          order.orderStatus == 'PROCESSING' ? 'badge-processing' :
                                          order.orderStatus == 'SHIPPED' ? 'badge-shipping' :
                                          order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' ? 'badge-delivered' : 'badge-cancelled'}">
                                        ${order.orderStatus == 'NEW' ? 'MỚI' :
                                          order.orderStatus == 'PROCESSING' ? 'ĐANG XL' :
                                          order.orderStatus == 'SHIPPED' ? 'ĐANG GIAO' :
                                          order.orderStatus == 'DELIVERED' ? 'ĐÃ GIAO' :
                                          order.orderStatus == 'COMPLETED' ? 'HOÀN THÀNH' : 'ĐÃ HỦY'}
                                    </span>
                                </td>
                                <td class="text-secondary-custom">
                                    <fmt:formatDate value="${order.createdAtTimestamp}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="text-end">
                                    <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết" onclick="showOrderDetail(${order.id})">
                                        <span class="material-symbols-outlined">visibility</span>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
        <!-- Pagination -->
        <div class="card-footer bg-white border-top p-4 d-flex flex-column flex-sm-row align-items-center justify-content-between mt-auto">
            <span class="text-secondary-custom small mb-3 mb-sm-0">Hiển thị 1 - ${orders.size()} của ${totalCount} đơn hàng</span>
            <nav aria-label="Page navigation">
                <ul class="pagination pagination-sm m-0" id="pagination">
                    <c:if test="${totalPages > 1}">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="goToPage(${currentPage - 1})" aria-label="Previous">
                                <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_left</span>
                            </a>
                        </li>
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="#" onclick="goToPage(${p})">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="#" onclick="goToPage(${currentPage + 1})" aria-label="Next">
                                <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_right</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>
</main>

<!-- Order Detail Modal -->
<div class="modal fade" id="orderDetailModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title font-heading fw-bold">Chi tiết đơn hàng #<span id="detailOrderId"></span></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" id="detailModalBody">
                <div class="text-center py-5 text-muted">Đang tải...</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
let currentPage = parseInt('${currentPage}') || 1;
let currentSearch = '${search}';
let currentStatus = '${status}' === '' ? 'all' : '${status}';
let currentPaymentStatus = '${paymentStatus}' === '' ? 'all' : '${paymentStatus}';

function applyFilters() {
    currentSearch = document.getElementById('searchInput').value;
    currentStatus = document.getElementById('statusFilter').value;
    currentPaymentStatus = document.getElementById('paymentStatusFilter').value;
    currentPage = 1;
    loadOrders();
}

function resetFilters() {
    document.getElementById('searchInput').value = '';
    document.getElementById('statusFilter').value = 'all';
    document.getElementById('paymentStatusFilter').value = 'all';
    currentSearch = '';
    currentStatus = 'all';
    currentPaymentStatus = 'all';
    currentPage = 1;
    loadOrders();
}

function goToPage(page) {
    if (page < 1) return;
    currentPage = page;
    loadOrders();
}

function loadOrders() {
    const params = new URLSearchParams();
    params.append('page', currentPage);
    params.append('search', currentSearch);
    params.append('status', currentStatus);
    params.append('paymentStatus', currentPaymentStatus);

    fetch(contextPath + '/admin/orders?' + params.toString(), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(res => res.json())
    .then(data => {
        const tbody = document.getElementById('ordersTableBody');
        tbody.innerHTML = '';
        document.getElementById('totalCountDisplay').textContent = data.totalCount;

        if (!data.orders || data.orders.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-5">Không có đơn hàng nào</td></tr>';
            updatePagination(1, 1);
            return;
        }

        data.orders.forEach(order => {
            const statusBadgeClass = getStatusBadgeClass(order.orderStatus);
            const statusText = getStatusText(order.orderStatus);
            const paymentBadgeClass = getPaymentBadgeClass(order.paymentStatus);
            const paymentText = getPaymentText(order.paymentStatus);

            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td class="fw-semibold">\${order.ordersId || '#ORD-' + order.id}</td>
                <td>
                    <div class="d-flex flex-column">
                        <span class="fw-medium">\${order.recipientName || 'N/A'}</span>
                        <span class="text-secondary small">\${order.recipientPhone || order.phoneNumber || ''}</span>
                    </div>
                </td>
                <td class="fw-medium">\${order.grandTotal} ₫</td>
                <td><span class="badge rounded-pill px-3 py-2 text-uppercase \${paymentBadgeClass}">\${paymentText}</span></td>
                <td><span class="badge rounded-pill px-3 py-2 text-uppercase \${statusBadgeClass}">\${statusText}</span></td>
                <td class="text-secondary-custom">\${order.createdAt}</td>
                <td class="text-end">
                    <button class="btn btn-link text-secondary-custom p-1" title="Xem chi tiết" onclick="showOrderDetail(\${order.id})">
                        <span class="material-symbols-outlined">visibility</span>
                    </button>
                </td>
            `;
            tbody.appendChild(tr);
        });

        updatePagination(data.currentPage, data.totalPages);
    })
    .catch(err => console.error('Lỗi tải đơn hàng:', err));
}

function getStatusBadgeClass(status) {
    switch(status) {
        case 'NEW': return 'badge-new';
        case 'PROCESSING': return 'badge-processing';
        case 'SHIPPED': return 'badge-shipping';
        case 'DELIVERED':
        case 'COMPLETED': return 'badge-delivered';
        case 'CANCELLED': return 'badge-cancelled';
        default: return 'badge-pending';
    }
}

function getStatusText(status) {
    switch(status) {
        case 'NEW': return 'MỚI';
        case 'PROCESSING': return 'ĐANG XL';
        case 'SHIPPED': return 'ĐANG GIAO';
        case 'DELIVERED': return 'ĐÃ GIAO';
        case 'COMPLETED': return 'HOÀN THÀNH';
        case 'CANCELLED': return 'ĐÃ HỦY';
        default: return status;
    }
}

function getPaymentBadgeClass(status) {
    switch(status) {
        case 'PAID': return 'badge-paid';
        case 'UNPAID': return 'badge-unpaid';
        case 'REFUNDED': return 'badge-refunded';
        default: return 'badge-pending';
    }
}

function getPaymentText(status) {
    switch(status) {
        case 'PAID': return 'Đã thanh toán';
        case 'UNPAID': return 'Chưa TT';
        case 'REFUNDED': return 'Hoàn tiền';
        default: return 'Đang xử lý';
    }
}

function updatePagination(currentPage, totalPages) {
    const pagination = document.getElementById('pagination');
    pagination.innerHTML = '';

    if (totalPages <= 1) return;

    // Previous button
    const prevLi = document.createElement('li');
    prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
    prevLi.innerHTML = `<a class="page-link" href="#" onclick="goToPage(\${currentPage - 1})" aria-label="Previous">
        <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_left</span></a>`;
    pagination.appendChild(prevLi);

    // Page numbers
    let start = Math.max(1, currentPage - 2);
    let end = Math.min(totalPages, currentPage + 2);
    if (start > 1) {
        pagination.innerHTML += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(1)">1</a></li>`;
        if (start > 2) pagination.innerHTML += `<li class="page-item disabled"><span class="page-link border-0 text-secondary-custom">...</span></li>`;
    }
    for (let i = start; i <= end; i++) {
        const li = document.createElement('li');
        li.className = 'page-item' + (i === currentPage ? ' active' : '');
        li.innerHTML = `<a class="page-link" href="#" onclick="goToPage(\${i})">\${i}</a>`;
        pagination.appendChild(li);
    }
    if (end < totalPages) {
        if (end < totalPages - 1) pagination.innerHTML += `<li class="page-item disabled"><span class="page-link border-0 text-secondary-custom">...</span></li>`;
        pagination.innerHTML += `<li class="page-item"><a class="page-link" href="#" onclick="goToPage(\${totalPages})">\${totalPages}</a></li>`;
    }

    // Next button
    const nextLi = document.createElement('li');
    nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
    nextLi.innerHTML = `<a class="page-link" href="#" onclick="goToPage(\${currentPage + 1})" aria-label="Next">
        <span aria-hidden="true" class="material-symbols-outlined fs-6">chevron_right</span></a>`;
    pagination.appendChild(nextLi);
}

function showOrderDetail(orderId) {
    const modal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
    document.getElementById('detailOrderId').textContent = orderId;
    document.getElementById('detailModalBody').innerHTML = '<div class="text-center py-5 text-muted">Đang tải...</div>';
    modal.show();

    const params = new URLSearchParams();
    params.append('action', 'getDetail');
    params.append('orderId', orderId);

    fetch(contextPath + '/admin/orders', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success) {
            document.getElementById('detailModalBody').innerHTML = '<div class="alert alert-danger">' + data.message + '</div>';
            return;
        }

        const d = data.data;
        let itemsHtml = '';
        if (d.items && d.items.length > 0) {
            itemsHtml = '<h6 class="font-heading fw-bold mt-3 mb-2">Sản phẩm trong đơn:</h6><div class="table-responsive"><table class="table table-sm">' +
                '<thead><tr><th style="width:60px">Ảnh</th><th>Sản phẩm</th><th>Phân loại</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr></thead><tbody>';
            d.items.forEach(item => {
                const imgHtml = item.imageUrl
                    ? '<img src="' + item.imageUrl + '" alt="' + item.productName + '" style="width:50px;height:50px;object-fit:cover;border-radius:4px;" onerror="this.style.display=\'none\'">'
                    : '<span class="text-muted"><span class="material-symbols-outlined fs-5">image</span></span>';
                itemsHtml += '<tr><td>' + imgHtml + '</td><td>' + item.productName + '</td><td>' +
                    (item.colorName || '') + (item.sizeName ? ' / ' + item.sizeName : '') + '</td><td>' +
                    item.quantity + '</td><td>' + item.unitPrice + ' ₫</td><td>' + item.subtotal + ' ₫</td></tr>';
            });
            itemsHtml += '</tbody></table></div>';
        }

        const statusBadge = getStatusBadgeClass(d.orderStatus) || 'badge-pending';
        const statusText = getStatusText(d.orderStatus) || d.orderStatus;
        const paymentBadge = getPaymentBadgeClass(d.paymentStatus) || 'badge-pending';
        const paymentText = getPaymentText(d.paymentStatus) || d.paymentStatus;

        // Build address display
        let addressParts = [];
        if (d.street) addressParts.push(d.street);
        if (d.ward) addressParts.push(d.ward);
        if (d.district) addressParts.push(d.district);
        if (d.province) addressParts.push(d.province);
        const fullAddr = addressParts.length > 0 ? addressParts.join(', ') : (d.shippingAddress || 'N/A');

        document.getElementById('detailModalBody').innerHTML = `
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Người nhận</label>
                        <p class="mb-0 fw-medium">\${d.recipientName || 'N/A'}</p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Số điện thoại</label>
                        <p class="mb-0">\${d.recipientPhone || d.phoneNumber || 'N/A'}</p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Địa chỉ giao hàng</label>
                        <p class="mb-0">\${fullAddr}</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Trạng thái đơn</label>
                        <br><span class="badge rounded-pill px-3 py-2 text-uppercase \${statusBadge}">\${statusText}</span>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Thanh toán</label>
                        <br><span class="badge rounded-pill px-3 py-2 text-uppercase \${paymentBadge}">\${paymentText}</span>
                        <p class="mb-0 mt-1 small text-muted">Phương thức: \${d.paymentMethod || 'N/A'}</p>
                    </div>
                    <div class="mb-3">
                        <label class="fw-bold text-secondary-custom small text-uppercase">Ngày đặt</label>
                        <p class="mb-0">\${d.createdAt || 'N/A'}</p>
                    </div>
                </div>
            </div>
            <hr>
            <div class="row g-3">
                <div class="col-12">
                    \${itemsHtml}
                </div>
            </div>
            <hr>
            <div class="row g-3">
                <div class="col-sm-4">
                    <span class="text-secondary-custom small">Tạm tính:</span>
                    <span class="fw-medium">\${d.subTotal} ₫</span>
                </div>
                <div class="col-sm-4">
                    <span class="text-secondary-custom small">Phí vận chuyển:</span>
                    <span class="fw-medium">\${d.shippingFee} ₫</span>
                </div>
                <div class="col-sm-4">
                    <span class="fw-bold">Tổng cộng:</span>
                    <span class="fw-bold text-danger">\${d.grandTotal} ₫</span>
                </div>
            </div>
            \${d.orderNote ? '<hr><div><label class="fw-bold text-secondary-custom small text-uppercase">Ghi chú</label><p class="mb-0">' + d.orderNote + '</p></div>' : ''}
            \${d.cancelReason ? '<hr><div><label class="fw-bold text-danger small text-uppercase">Lý do hủy</label><p class="mb-0 text-danger">' + d.cancelReason + '</p></div>' : ''}
        `;
    })
    .catch(err => {
        document.getElementById('detailModalBody').innerHTML = '<div class="alert alert-danger">Lỗi tải chi tiết đơn hàng</div>';
        console.error(err);
    });
}

// Enter key triggers search
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('searchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            applyFilters();
        }
    });
    // Load orders via AJAX on initial page load
    loadOrders();
});
</script>
</body>
</html>