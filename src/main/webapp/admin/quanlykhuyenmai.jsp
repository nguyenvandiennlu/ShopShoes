<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    request.setAttribute("adminActive", "promotions");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    DateTimeFormatter dtfInput = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    request.setAttribute("dtf", dtf);
    request.setAttribute("dtfInput", dtfInput);
    
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }
    LocalDateTime now = LocalDateTime.now();
    request.setAttribute("now", now);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>BHD Sport Admin - Quản lý Khuyến mãi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="../assets/css/adminHome.css"/>
    <style>
        .form-select:focus, .form-control:focus {
            border-color: #ff675c; box-shadow: 0 0 0 .2rem rgba(255,103,92,.15);
        }
        .btn-bittersweet {
            background-color: #ff675c; color: white; border: none;
        }
        .btn-bittersweet:hover {
            background-color: #e55c52; color: white;
        }
        .text-bittersweet {
            color: #ff675c;
        }
        .promo-status-badge {
            display: inline-block;
            white-space: nowrap;
            font-size: 12px;
            font-weight: 600;
            padding: 6px 12px;
            border-radius: 50px;
        }
        .status-active { background: #d1fae5; color: #065f46; }
        .status-scheduled { background: #fef3c7; color: #92400e; }
        .status-expired { background: #e2e8f0; color: #475569; }
        .status-disabled { background: #fee2e2; color: #991b1b; }
        
        .product-select-container {
            max-height: 250px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 10px;
            background-color: #f8fafc;
        }
        .product-select-item {
            display: flex;
            align-items: center;
            padding: 6px 10px;
            border-radius: 6px;
            transition: background 0.2s;
            cursor: pointer;
        }
        .product-select-item:hover {
            background-color: #f1f5f9;
        }
        .product-select-item img {
            width: 36px;
            height: 36px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 10px;
            border: 1px solid #e2e8f0;
        }
        .product-select-item-placeholder {
            width: 36px;
            height: 36px;
            border-radius: 4px;
            margin-right: 10px;
            border: 1px solid #e2e8f0;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-size: 14px;
        }
        /* Custom Switch */
        .form-switch .form-check-input {
            width: 2.5em;
            height: 1.25em;
            cursor: pointer;
        }
        .form-switch .form-check-input:checked {
            background-color: #ff675c;
            border-color: #ff675c;
        }
    </style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<jsp:include page="topbar.jsp"/>

<main class="main-content">
    <div class="mb-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item">
                        <a class="text-decoration-none text-muted" href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Khuyến mãi</li>
                </ol>
            </nav>
            <h1 class="font-headline fw-bold mb-0">Quản lý Khuyến mãi</h1>
        </div>
        <button class="btn btn-bittersweet d-flex align-items-center gap-1 px-3 py-2" onclick="openAddModal()">
            <span class="material-symbols-outlined">add_circle</span>
            Thêm khuyến mãi mới
        </button>
    </div>

    <%-- Success & Error Alerts --%>
    <% if (successMsg != null) { %>
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <span class="material-symbols-outlined align-middle me-2">check_circle</span>
            <%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <span class="material-symbols-outlined align-middle me-2">error</span>
            <%= errorMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <%-- Filter Section --%>
    <div class="custom-card p-4 mb-4">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-md-6">
                <label class="form-label small fw-semibold text-muted mb-1">Tìm kiếm chương trình</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0">
                        <span class="material-symbols-outlined" style="font-size:18px;">search</span>
                    </span>
                    <input id="filter-keyword" type="text" class="form-control border-start-0 ps-1" placeholder="Nhập tên đợt khuyến mãi..."/>
                </div>
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label small fw-semibold text-muted mb-1">Trạng thái</label>
                <select id="filter-status" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="ACTIVE">Đang chạy</option>
                    <option value="SCHEDULED">Sắp diễn ra</option>
                    <option value="EXPIRED">Đã hết hạn</option>
                    <option value="DISABLED">Đã tắt</option>
                </select>
            </div>
        </div>
    </div>

    <%-- Promotions List --%>
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="promotions-table">
                <thead class="table-light">
                    <tr>
                        <th style="width: 5%">ID</th>
                        <th style="width: 25%">Tên chương trình</th>
                        <th style="width: 15%">Loại giảm giá</th>
                        <th style="width: 15%">Mức giảm</th>
                        <th style="width: 15%">Thời gian</th>
                        <th style="width: 10%">Trạng thái</th>
                        <th style="width: 8%">Kích hoạt</th>
                        <th style="width: 7%">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="promo" items="${promotionsList}">
                        <c:set var="status" value="" />
                        <c:set var="statusLabel" value="" />
                        <c:set var="statusClass" value="" />
                        
                        <c:choose>
                            <c:when test="${not promo.isActive()}">
                                <c:set var="status" value="DISABLED" />
                                <c:set var="statusLabel" value="Đã tắt" />
                                <c:set var="statusClass" value="status-disabled" />
                            </c:when>
                            <c:when test="${promo.startDate != null && promo.startDate.isAfter(now)}">
                                <c:set var="status" value="SCHEDULED" />
                                <c:set var="statusLabel" value="Sắp chạy" />
                                <c:set var="statusClass" value="status-scheduled" />
                            </c:when>
                            <c:when test="${promo.endDate != null && promo.endDate.isBefore(now)}">
                                <c:set var="status" value="EXPIRED" />
                                <c:set var="statusLabel" value="Hết hạn" />
                                <c:set var="statusClass" value="status-expired" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="status" value="ACTIVE" />
                                <c:set var="statusLabel" value="Đang chạy" />
                                <c:set var="statusClass" value="status-active" />
                            </c:otherwise>
                        </c:choose>
                        
                        <tr class="promo-row" data-name="${promo.name.toLowerCase()}" data-status="${status}">
                            <td><strong>#${promo.getId()}</strong></td>
                            <td>
                                <div class="fw-bold">${promo.name}</div>
                                <small class="text-muted">Slug: ${promo.slug}</small>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${'PERCENT'.equalsIgnoreCase(promo.discountType)}">
                                        <span class="badge bg-primary">Phần trăm (%)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Số tiền cố định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${'PERCENT'.equalsIgnoreCase(promo.discountType)}">
                                        <span class="fs-6 fw-bold text-bittersweet">
                                            <fmt:formatNumber value="${promo.discountValue}" maxFractionDigits="1"/>%
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="fs-6 fw-bold text-bittersweet">
                                            <fmt:formatNumber value="${promo.discountValue}" pattern="#,###"/>₫
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="small">
                                    <strong>Từ:</strong> 
                                    <c:choose>
                                        <c:when test="${promo.startDate != null}">${promo.startDate.format(dtf)}</c:when>
                                        <c:otherwise>Không giới hạn</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="small mt-1">
                                    <strong>Đến:</strong> 
                                    <c:choose>
                                        <c:when test="${promo.endDate != null}">${promo.endDate.format(dtf)}</c:when>
                                        <c:otherwise>Không giới hạn</c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td>
                                <span class="promo-status-badge ${statusClass}">${statusLabel}</span>
                            </td>
                            <td>
                                <div class="form-check form-switch">
                                    <input class="form-check-input toggle-active-switch" type="checkbox" 
                                           data-id="${promo.getId()}" ${promo.isActive() ? 'checked' : ''} />
                                </div>
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-outline-primary d-flex align-items-center p-1" 
                                            title="Chỉnh sửa"
                                            onclick="openEditModal({
                                                id: '${promo.getId()}',
                                                name: '${promo.name}',
                                                discountType: '${promo.discountType}',
                                                discountValue: '${promo.discountValue}',
                                                startDate: '${promo.startDate != null ? promo.startDate.format(dtfInput) : ""}',
                                                endDate: '${promo.endDate != null ? promo.endDate.format(dtfInput) : ""}',
                                                isActive: ${promo.isActive()}
                                            })">
                                        <span class="material-symbols-outlined" style="font-size:18px;">edit</span>
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger d-flex align-items-center p-1" 
                                            title="Xóa"
                                            onclick="confirmDelete('${promo.getId()}', '${promo.name}')">
                                        <span class="material-symbols-outlined" style="font-size:18px;">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty promotionsList}">
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">Chưa có đợt khuyến mãi nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>

<%-- Promotion Form Modal --%>
<div class="modal fade" id="promotionModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="promotionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <form id="promotionForm" action="${pageContext.request.contextPath}/admin/promotions" method="POST">
                <input type="hidden" name="action" id="form-action" value="add" />
                <input type="hidden" name="id" id="promo-id" />

                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="promotionModalLabel">Thêm Khuyến mãi mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label for="input-name" class="form-label small fw-semibold">Tên chương trình khuyến mãi <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name" id="input-name" required placeholder="Ví dụ: Giảm giá hè 2026" />
                        </div>
                        
                        <div class="col-md-6">
                            <label for="input-discount-type" class="form-label small fw-semibold">Loại giảm giá <span class="text-danger">*</span></label>
                            <select class="form-select" name="discount_type" id="input-discount-type" required onchange="updateValuePlaceholder()">
                                <option value="PERCENT">Giảm theo phần trăm (%)</option>
                                <option value="FIXED">Giảm số tiền cố định (VND)</option>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="input-discount-value" class="form-label small fw-semibold">Mức giảm <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="discount_value" id="input-discount-value" min="0" required placeholder="Nhập mức giảm..." />
                        </div>
                        
                        <div class="col-md-6">
                            <label for="input-start-date" class="form-label small fw-semibold">Ngày bắt đầu</label>
                            <input type="datetime-local" class="form-control" name="start_date" id="input-start-date" />
                        </div>
                        
                        <div class="col-md-6">
                            <label for="input-end-date" class="form-label small fw-semibold">Ngày kết thúc</label>
                            <input type="datetime-local" class="form-control" name="end_date" id="input-end-date" />
                        </div>

                        <div class="col-12 mt-2">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="is_active" id="input-is-active" value="true" checked />
                                <label class="form-check-label small fw-semibold ms-2" for="input-is-active">Kích hoạt chương trình ngay lập tức</label>
                            </div>
                        </div>

                        <hr class="my-4"/>

                        <%-- Applicable Products Checkbox List --%>
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-label small fw-semibold mb-0">Sản phẩm áp dụng khuyến mãi</label>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-sm btn-outline-secondary py-1" onclick="toggleAllProducts(true)">Chọn tất cả</button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary py-1" onclick="toggleAllProducts(false)">Bỏ chọn tất cả</button>
                                </div>
                            </div>
                            
                            <div class="input-group mb-2">
                                <span class="input-group-text bg-light border-end-0 py-1">
                                    <span class="material-symbols-outlined" style="font-size:16px;">search</span>
                                </span>
                                <input id="product-search" type="text" class="form-control form-control-sm border-start-0 ps-1 py-1" 
                                       placeholder="Tìm sản phẩm nhanh..." onkeyup="filterProductsInModal()"/>
                            </div>
                            
                            <div class="product-select-container">
                                <c:forEach var="prod" items="${productsList}">
                                    <div class="product-select-item" data-prod-name="${prod.name.toLowerCase()}" onclick="toggleCheckbox('prod-${prod.getId()}')">
                                        <input class="form-check-input me-2 product-checkbox" type="checkbox" name="productIds" 
                                               value="${prod.getId()}" id="prod-${prod.getId()}" onclick="event.stopPropagation()"/>
                                        <div class="product-select-item-placeholder">
                                            <span class="material-symbols-outlined">image</span>
                                        </div>
                                        <div>
                                            <div class="fw-semibold text-dark small">${prod.name}</div>
                                            <small class="text-muted">Giá: <fmt:formatNumber value="${prod.price}" pattern="#,###"/>₫</small>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty productsList}">
                                    <div class="text-center text-muted small py-3">Không có sản phẩm nào khả dụng.</div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-bittersweet px-4">Lưu thông tin</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- Delete Confirmation Form (Hidden) --%>
<form id="deleteForm" action="${pageContext.request.contextPath}/admin/promotions" method="POST" style="display: none;">
    <input type="hidden" name="action" value="delete" />
    <input type="hidden" name="id" id="delete-id" />
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const promotionModal = new bootstrap.Modal(document.getElementById('promotionModal'));
    const form = document.getElementById('promotionForm');
    const formAction = document.getElementById('form-action');
    const promoId = document.getElementById('promo-id');
    const modalTitle = document.getElementById('promotionModalLabel');
    
    const inputName = document.getElementById('input-name');
    const inputDiscountType = document.getElementById('input-discount-type');
    const inputDiscountValue = document.getElementById('input-discount-value');
    const inputStartDate = document.getElementById('input-start-date');
    const inputEndDate = document.getElementById('input-end-date');
    const inputIsActive = document.getElementById('input-is-active');

    function updateValuePlaceholder() {
        const type = inputDiscountType.value;
        if (type === 'PERCENT') {
            inputDiscountValue.placeholder = "Ví dụ: 10, 20 (%)";
            inputDiscountValue.max = 100;
        } else {
            inputDiscountValue.placeholder = "Ví dụ: 50000, 100000 (₫)";
            inputDiscountValue.removeAttribute('max');
        }
    }

    function toggleCheckbox(id) {
        const cb = document.getElementById(id);
        if (cb) {
            cb.checked = !cb.checked;
        }
    }

    function toggleAllProducts(checked) {
        document.querySelectorAll('.product-checkbox').forEach(cb => {
            cb.checked = checked;
        });
    }

    function filterProductsInModal() {
        const keyword = document.getElementById('product-search').value.toLowerCase().trim();
        document.querySelectorAll('.product-select-item').forEach(item => {
            const name = item.getAttribute('data-prod-name');
            if (name.includes(keyword)) {
                item.style.setProperty('display', 'flex', 'important');
            } else {
                item.style.setProperty('display', 'none', 'important');
            }
        });
    }

    function openAddModal() {
        form.reset();
        formAction.value = 'add';
        promoId.value = '';
        modalTitle.textContent = 'Thêm Khuyến mãi mới';
        inputIsActive.checked = true;
        toggleAllProducts(false);
        updateValuePlaceholder();
        promotionModal.show();
    }

    function openEditModal(promo) {
        formAction.value = 'edit';
        promoId.value = promo.id;
        modalTitle.textContent = `Chỉnh sửa Khuyến mãi #${promo.id}`;
        
        inputName.value = promo.name;
        inputDiscountType.value = promo.discountType;
        inputDiscountValue.value = promo.discountValue;
        inputStartDate.value = promo.startDate;
        inputEndDate.value = promo.endDate;
        inputIsActive.checked = promo.isActive;
        updateValuePlaceholder();

        // Clear all checkboxes
        toggleAllProducts(false);

        // Fetch linked products via AJAX
        fetch(`${pageContext.request.contextPath}/admin/promotions?action=get-linked-products&id=${promo.id}`)
            .then(res => res.json())
            .then(productIds => {
                if (Array.isArray(productIds)) {
                    productIds.forEach(id => {
                        const cb = document.getElementById(`prod-${id}`);
                        if (cb) cb.checked = true;
                    });
                }
            })
            .catch(err => console.error("Error loading linked products:", err));

        promotionModal.show();
    }

    function confirmDelete(id, name) {
        if (confirm(`Bạn có chắc chắn muốn xóa chương trình khuyến mãi "${name}"? Hành động này sẽ gỡ bỏ khuyến mãi khỏi toàn bộ sản phẩm liên quan.`)) {
            document.getElementById('delete-id').value = id;
            document.getElementById('deleteForm').submit();
        }
    }

    // AJAX Toggle Switch
    document.querySelectorAll('.toggle-active-switch').forEach(el => {
        el.addEventListener('change', function() {
            const id = this.getAttribute('data-id');
            const isActive = this.checked;
            
            const params = new URLSearchParams();
            params.append('action', 'toggle');
            params.append('id', id);
            params.append('is_active', isActive);

            fetch(`${pageContext.request.contextPath}/admin/promotions`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Quick reload status classes
                    location.reload();
                } else {
                    alert("Cập nhật trạng thái thất bại: " + data.error);
                    this.checked = !isActive; // Rollback
                }
            })
            .catch(err => {
                console.error(err);
                alert("Đã xảy ra lỗi khi kết nối máy chủ");
                this.checked = !isActive; // Rollback
            });
        });
    });

    // Frontend List Filters
    const filterKeyword = document.getElementById('filter-keyword');
    const filterStatus = document.getElementById('filter-status');

    function filterPromotionsTable() {
        const keyword = filterKeyword.value.toLowerCase().trim();
        const status = filterStatus.value;
        
        document.querySelectorAll('.promo-row').forEach(row => {
            const name = row.getAttribute('data-name');
            const rStatus = row.getAttribute('data-status');
            
            const matchKeyword = name.includes(keyword);
            const matchStatus = status === "" || rStatus === status;
            
            if (matchKeyword && matchStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    filterKeyword.addEventListener('input', filterPromotionsTable);
    filterStatus.addEventListener('change', filterPromotionsTable);
</script>
</body>
</html>
