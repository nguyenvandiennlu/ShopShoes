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
    <style>
        .variant-accordion { background: #f8fafb; }
        .variant-table { font-size: 13px; margin-bottom: 0; }
        .variant-table th { font-size: 11px; text-transform: uppercase;
            color: #8a9bb0; font-weight: 700; }
        .variant-table td { vertical-align: middle; padding: 8px 12px; }

        .badge-instock  { background: #d1fae5; color: #065f46; }
        .badge-lowstock { background: #fef3c7; color: #92400e; }
        .badge-outstock { background: #fee2e2; color: #991b1b; }

        .product-row { cursor: pointer; transition: background 0.15s; }
        .product-row:hover { background: #f1f5f9; }
        .product-row.expanded { background: #f1f5f9; }

        .product-img {
            width: 44px; height: 44px;
            object-fit: cover; border-radius: 6px;
            border: 1px solid #e2e8f0;
        }
        .product-img-placeholder {
            width: 44px; height: 44px;
            border-radius: 6px; border: 1px solid #e2e8f0;
            background: #f1f5f9;
            display: flex; align-items: center; justify-content: center;
            color: #94a3b8;
        }

        .color-dot {
            width: 14px; height: 14px;
            border-radius: 50%; display: inline-block;
            border: 1px solid rgba(0,0,0,0.1);
            flex-shrink: 0;
        }

        #fab-add-product {
            position: fixed; bottom: 32px; right: 32px; z-index: 1050;
            width: 56px; height: 56px; border-radius: 50%;
            background: var(--color-bittersweet, #ff675c);
            color: white; border: none;
            box-shadow: 0 4px 16px rgba(255,103,92,0.4);
            display: flex; align-items: center; justify-content: center;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        #fab-add-product:hover {
            transform: scale(1.08);
            box-shadow: 0 6px 20px rgba(255,103,92,0.5);
        }

        .page-link { color: #ff675c; border-color: #e2e8f0; }
        .page-item.active .page-link {
            background-color: #ff675c; border-color: #ff675c; color: white;
        }
        .page-link:hover { color: #e55c52; background: #fff5f5; }

        .expand-icon { transition: transform 0.2s; font-size: 18px; color: #94a3b8; }
        .expand-icon.open { transform: rotate(180deg); }

        .form-select:focus, .form-control:focus {
            border-color: #ff675c; box-shadow: 0 0 0 .2rem rgba(255,103,92,.15);
        }
    </style>
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

            <div class="col-6 col-md-2">
                <label class="form-label small fw-semibold text-muted mb-1">Hiển thị</label>
                <select id="filter-visible" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="visible">Đang hiển thị</option>
                    <option value="hidden">Đang ẩn</option>
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

<div class="modal fade" id="editProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold" style="font-family:var(--heading-font,inherit);">
                    <span class="material-symbols-outlined me-2 align-middle"
                          style="color:#ff675c;font-size:22px;">edit</span>
                    Chỉnh sửa sản phẩm
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div id="edit-modal-loading" class="text-center py-5">
                    <div class="spinner-border" style="color:#ff675c;"></div>
                    <p class="text-muted mt-2 mb-0">Đang tải thông tin...</p>
                </div>
                <div id="edit-modal-form" style="display:none;">
                    <input type="hidden" id="edit-product-id"/>
                    <div class="row g-4">
                        <div class="col-12 col-md-4">
                            <label class="form-label fw-semibold small text-muted">Ảnh chính</label>
                            <div class="border rounded bg-light d-flex align-items-center
                                        justify-content-center overflow-hidden mb-2"
                                 style="width:100%;aspect-ratio:1;">
                                <img id="edit-img-preview" src="" alt=""
                                     style="width:100%;height:100%;object-fit:cover;display:none;"/>
                                <span id="edit-img-placeholder"
                                      class="material-symbols-outlined text-muted"
                                      style="font-size:48px;display:none;">image</span>
                            </div>
                            <label for="edit-img-url" class="form-label fw-semibold small text-muted">
                                URL ảnh
                            </label>
                            <input type="url" id="edit-img-url" class="form-control form-control-sm"
                                   placeholder="https://..."/>
                        </div>
                        <div class="col-12 col-md-8">
                            <div class="mb-3">
                                <label for="edit-name" class="form-label fw-semibold small text-muted">
                                    Tên sản phẩm <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="edit-name" class="form-control"
                                       placeholder="Nhập tên sản phẩm..." maxlength="255"/>
                                <div class="invalid-feedback">Tên không được để trống.</div>
                            </div>
                            <div class="mb-3">
                                <label for="edit-price" class="form-label fw-semibold small text-muted">
                                    Giá bán (₫) <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="number" id="edit-price" class="form-control"
                                           placeholder="0" min="0" step="1000"/>
                                    <span class="input-group-text">₫</span>
                                </div>
                                <div class="invalid-feedback">Giá bán phải lớn hơn 0.</div>
                            </div>
                            <div class="mb-3">
                                <label for="edit-brand" class="form-label fw-semibold small text-muted">
                                    Thương hiệu <span class="text-danger">*</span>
                                </label>
                                <select id="edit-brand" class="form-select">
                                    <option value="">-- Chọn thương hiệu --</option>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn thương hiệu.</div>
                            </div>
                            <div class="mb-1">
                                <label class="form-label fw-semibold small text-muted d-block">
                                    Trạng thái hiển thị
                                </label>
                                <div class="d-flex gap-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio"
                                               name="edit-available" id="edit-available-yes" value="1"/>
                                        <label class="form-check-label" for="edit-available-yes">
                                            <span class="badge bg-success bg-opacity-25 text-success px-2">Hiển thị</span>
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio"
                                               name="edit-available" id="edit-available-no" value="0"/>
                                        <label class="form-check-label" for="edit-available-no">
                                            <span class="badge bg-secondary bg-opacity-25 text-secondary px-2">Ẩn khỏi shop</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="edit-error-alert" class="alert alert-danger d-none mt-3 mb-0">
                        <span class="material-symbols-outlined me-1 align-middle" style="font-size:18px;">error</span>
                        <span id="edit-error-msg"></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-light border px-4"
                        data-bs-dismiss="modal">Hủy</button>
                <button type="button" id="btn-save-product"
                        class="btn px-4 fw-semibold"
                        style="background:#ff675c;color:white;border-color:#ff675c;" disabled>
                    <span class="material-symbols-outlined me-1 align-middle" style="font-size:18px;">save</span>
                    Lưu thay đổi
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/script/inventory.js"></script>
<script src="${pageContext.request.contextPath}/assets/script/editProduct.js"></script>
</body>
</html>
