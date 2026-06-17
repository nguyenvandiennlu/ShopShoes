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

        #tab-restock-qty:hover, #tab-new-variant:hover {
            color: #0d0d0d!important;
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
                    <input type="file" id="edit-img-file"
                           accept="image/jpeg,image/png,image/webp,image/gif"
                           style="display:none;"/>
                    <div class="row g-4">
                        <div class="col-12 col-md-4">
                            <label class="form-label fw-semibold small text-muted">Ảnh chính</label>

                            <div class="border rounded bg-light d-flex align-items-center
                                        justify-content-center overflow-hidden mb-2"
                                 style="width:100%;aspect-ratio:1;position:relative;">
                                <img id="edit-img-preview" src="" alt=""
                                     style="width:100%;height:100%;object-fit:cover;display:none;"/>
                                <span id="edit-img-placeholder"
                                      class="material-symbols-outlined text-muted"
                                      style="font-size:48px;">image</span>
                            </div>

                            <button type="button" id="btn-upload-image"
                                    class="btn btn-outline-secondary btn-sm w-100 mb-2">
                                <span class="spinner-border spinner-border-sm me-1"
                                      id="upload-spinner" style="display:none;"></span>
                                <span class="material-symbols-outlined me-1 align-middle"
                                      style="font-size:15px;">upload</span>
                                <span id="upload-label">Chọn ảnh</span>
                            </button>

                            <div id="edit-img-url-display"
                                 class="text-muted text-truncate"
                                 style="font-size:10px;word-break:break-all;line-height:1.4;"
                                 title=""></div>

                            <div id="upload-error"
                                 class="text-danger mt-1 d-none"
                                 style="font-size:12px;"></div>

                            <p class="text-muted mt-1 mb-0" style="font-size:11px;">
                                JPEG, PNG, WebP, GIF · Tối đa 5MB
                            </p>
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
<div class="modal fade" id="restockModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold" style="font-family:var(--heading-font,inherit);">
                    <span class="material-symbols-outlined me-2 align-middle" style="color:#ff675c;font-size:22px;">inventory</span>
                    Quản lý Kho & Biến thể: <span id="restock-product-name" class="text-primary"></span>
                </h5>
                <button type="button" class="btn-close" id="btn-close-restock-modal"></button>
            </div>

            <div class="modal-body p-0">
                <div id="restock-unavailable-warning" class="alert alert-warning m-3 d-none">
                    <span class="material-symbols-outlined align-middle me-1">warning</span>
                    Sản phẩm này hiện đang <strong>ẩn khỏi shop</strong>. Vui lòng chuyển trạng thái "Hiển thị" trước khi nhập thêm hàng.
                </div>

                <div id="restock-modal-loading" class="text-center py-5">
                    <div class="spinner-border" style="color:#ff675c;"></div>
                    <p class="text-muted mt-2 mb-0">Đang tải dữ liệu...</p>
                </div>

                <div id="restock-modal-content" style="display:none;">
                    <ul class="nav nav-tabs px-3 pt-3 bg-light" id="restockTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active fw-semibold" id="tab-restock-qty" data-bs-toggle="tab" data-bs-target="#pane-restock-qty" type="button" role="tab">
                                Nhập thêm số lượng
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link fw-semibold" id="tab-new-variant" data-bs-toggle="tab" data-bs-target="#pane-new-variant" type="button" role="tab">
                                Quản lý Biến thể
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content p-4">
                        <div class="tab-pane fade show active" id="pane-restock-qty" role="tabpanel">
                            <p class="text-muted small mb-3">Nhập số lượng hàng mới về. Hệ thống sẽ cộng dồn vào tồn kho hiện tại.</p>
                            <div class="table-responsive">
                                <table class="table align-middle variant-table border">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Kích cỡ</th>
                                        <th>Màu sắc</th>
                                        <th class="text-center">Tồn hiện tại</th>
                                        <th class="text-center" style="width: 150px;">+ Nhập thêm</th>
                                        <th class="text-center" style="width: 60px;"></th> </tr>
                                    </tr>
                                    </thead>
                                    <tbody id="restock-qty-tbody">
                                    </tbody>
                                </table>
                            </div>
                            <div class="text-end mt-3">
                                <button type="button" id="btn-save-restock" class="btn px-4 fw-semibold" style="background:#ff675c;color:white;">
                                    <span class="material-symbols-outlined me-1 align-middle" style="font-size:18px;">save</span> Lưu số lượng
                                </button>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pane-new-variant" role="tabpanel">
                            <div class="card card-body bg-light border-0 mb-4">
                                <h6 class="fw-bold mb-3">Thêm biến thể mới</h6>
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Màu sắc</label>
                                        <select id="new-variant-color" class="form-select"></select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Kích cỡ</label>
                                        <select id="new-variant-size" class="form-select"></select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-semibold">Tồn kho ban đầu</label>
                                        <input type="number" id="new-variant-stock" class="form-control" placeholder="0" min="0">
                                    </div>
                                    <div class="mt-3">
                                        <label class="form-label small fw-semibold">Ảnh biến thể (Theo màu sắc)</label>
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <label for="new-variant-images" class="btn btn-sm btn-outline-secondary d-flex align-items-center">
                                                <span class="material-symbols-outlined me-1" style="font-size: 18px;">cloud_upload</span>
                                                Chọn ảnh
                                            </label>
                                            <input type="file" id="new-variant-images" class="d-none" accept="image/*" multiple>
                                            <span class="text-muted small">Có thể chọn nhiều ảnh.</span>
                                        </div>
                                        <div id="variant-image-preview-container" class="d-flex flex-wrap gap-2"></div>
                                    </div>
                                </div>
                                <div class="text-end mt-3">
                                    <button type="button" id="btn-save-new-variant" class="btn btn-dark px-4">
                                        <span class="material-symbols-outlined me-1 align-middle" style="font-size:18px;">add</span> Thêm biến thể
                                    </button>
                                </div>
                            </div>

                            <h6 class="fw-bold mb-2 text-danger">Biến thể đã ngừng bán</h6>
                            <p class="small text-muted mb-2">Các biến thể dưới đây đã bị ngừng kinh doanh. Bạn có thể mở lại nếu có hàng.</p>
                            <div class="table-responsive">
                                <table class="table align-middle variant-table border text-muted">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Kích cỡ</th>
                                        <th>Màu sắc</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody id="restock-discontinued-tbody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Thêm Sản Phẩm Mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="add-product-form">
                    <h6 class="fw-bold text-primary mb-3">1. Thông tin cơ bản</h6>
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Tên sản phẩm <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm" id="add-prod-name" placeholder="" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control form-control-sm" id="add-prod-price" placeholder="Ví dụ: 250000" min="0" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Thương hiệu <span class="text-danger">*</span></label>
                            <select class="form-select form-select-sm" id="add-prod-brand" required>
                                <option value="">-- Chọn thương hiệu --</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label small fw-semibold">Ảnh đại diện <span class="text-danger">*</span></label>
                            <input type="file" class="form-control form-control-sm mb-2" id="add-prod-main-img" accept="image/*" required>
                            <div id="add-prod-main-img-preview" class="border rounded d-flex align-items-center justify-content-center bg-light" style="width: 100px; height: 100px; overflow: hidden; display: none !important;">
                                <span class="text-muted small">No image</span>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h6 class="fw-bold text-success mb-0">2. Biến thể ban đầu (Tùy chọn)</h6>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="toggle-optional-variant">
                            <label class="form-check-label small text-muted" for="toggle-optional-variant">Bật để thêm</label>
                        </div>
                    </div>

                    <div id="optional-variant-section" class="d-none p-3 bg-light border rounded mt-3">
                        <div id="variants-dynamic-container"></div>

                        <div class="text-center mt-3 border-top pt-3">
                            <button type="button" class="btn btn-dark btn-sm rounded-pill px-4" onclick="addNewVariantRow()">
                                <span class="material-symbols-outlined align-middle me-1" style="font-size: 18px;">add_circle</span> Thêm một biến thể khác
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary btn-sm" id="btn-submit-add-product">Lưu sản phẩm</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/script/inventory.js"></script>
<script src="${pageContext.request.contextPath}/assets/script/editProduct.js"></script>
</body>
</html>
