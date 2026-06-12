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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="../assets/css/adminHome.css"/>
    <link rel="stylesheet" href="../assets/css/inventoryManage.css"/>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<jsp:include page="topbar.jsp"/>

<main class="main-content">
    <div class="mb-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item">
                    <a class="text-decoration-none text-muted"
                       href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Kho hàng</li>
            </ol>
        </nav>
        <h1 class="font-headline fw-bold mb-0">Quản lý Kho hàng</h1>
    </div>

    <div class="custom-card p-4 mb-4">
        <div class="row g-3 align-items-end">
            <div class="col-12 col-md-4">
                <label class="form-label small fw-semibold text-muted mb-1">Tên sản phẩm</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0">
                        <span class="material-symbols-outlined" style="font-size:18px;">search</span>
                    </span>
                    <input id="filter-keyword" type="text"
                           class="form-control border-start-0 ps-1"
                           placeholder="Nhập từ khóa..."/>
                </div>
            </div>

            <div class="col-6 col-md-2">
                <label class="form-label small fw-semibold text-muted mb-1">Thương hiệu</label>
                <select id="filter-brand" class="form-select">
                    <option value="">Tất cả</option>
                </select>
            </div>

            <div class="col-6 col-md-2">
                <label class="form-label small fw-semibold text-muted mb-1">Màu sắc</label>
                <select id="filter-color" class="form-select">
                    <option value="">Tất cả</option>
                </select>
            </div>

            <div class="col-6 col-md-2">
                <label class="form-label small fw-semibold text-muted mb-1">Kích cỡ</label>
                <select id="filter-size" class="form-select">
                    <option value="">Tất cả</option>
                </select>
            </div>

            <div class="col-6 col-md-2">
                <label class="form-label small fw-semibold text-muted mb-1">Tồn kho</label>
                <select id="filter-status" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="instock">Còn hàng</option>
                    <option value="lowstock">Sắp hết (≤5)</option>
                    <option value="outstock">Hết hàng</option>
                </select>
            </div>
        </div>

        <div class="d-flex gap-2 mt-3 justify-content-end">
            <button id="btn-reset-filter" class="btn btn-light border px-4">
                <span class="material-symbols-outlined me-1" style="font-size:16px;vertical-align:-3px;">restart_alt</span>
                Đặt lại
            </button>
            <button id="btn-apply-filter" class="btn px-4 fw-semibold"
                    style="background:#ff675c;color:white;border-color:#ff675c;">
                <span class="material-symbols-outlined me-1" style="font-size:16px;vertical-align:-3px;">filter_list</span>
                Lọc
            </button>
        </div>
    </div>

    <div class="d-flex align-items-center justify-content-between mb-3">
        <p id="result-summary" class="text-muted small mb-0">Đang tải...</p>
    </div>

    <div class="custom-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="inventory-table">
                <thead class="table-light">
                <tr>
                    <th class="py-3 px-3" style="width:36px;"></th>
                    <th class="py-3" style="width:52px;">Ảnh</th>
                    <th class="py-3">Tên sản phẩm</th>
                    <th class="py-3">Thương hiệu</th>
                    <th class="py-3 text-end">Giá bán</th>
                    <th class="py-3 text-center">Tổng tồn kho</th>
                    <th class="py-3 text-center">Trạng thái</th>
                    <th class="py-3 text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody id="inventory-tbody">
                <tr>
                    <td colspan="8" class="text-center py-5 text-muted">
                        <div class="spinner-border spinner-border-sm me-2" style="color:#ff675c;"></div>
                        Đang tải dữ liệu...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <div class="d-flex align-items-center justify-content-center px-4 py-3 border-top"
             id="pagination-wrapper" style="display:none!important;">
            <nav>
                <ul class="pagination pagination-sm mb-0" id="pagination-list"></ul>
            </nav>
        </div>
    </div>
</main>

<button id="fab-add-product" title="Thêm sản phẩm mới">
    <span class="material-symbols-outlined" style="font-size:26px;">add</span>
</button>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/script/inventory.js"></script>
</body>
</html>
