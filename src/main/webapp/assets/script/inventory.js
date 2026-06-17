const API = window.contextPath + '/admin/api/inventory';

const state = {
    keyword:     '',
    brandId:     '',
    colorId:     '',
    sizeId:      '',
    stockStatus: '',
    visible:     '',
    page:        1,
    totalPages:  1,
    totalCount:  0,
};

const expandedRows = new Set();

const elKeyword    = document.getElementById('filter-keyword');
const elBrand      = document.getElementById('filter-brand');
const elColor      = document.getElementById('filter-color');
const elSize       = document.getElementById('filter-size');
const elStatus     = document.getElementById('filter-status');
const elVisible    = document.getElementById('filter-visible');
const elApply      = document.getElementById('btn-apply-filter');
const elReset      = document.getElementById('btn-reset-filter');
const elTbody      = document.getElementById('inventory-tbody');
const elSummary    = document.getElementById('result-summary');
const elPagWrapper = document.getElementById('pagination-wrapper');
const elPagList    = document.getElementById('pagination-list');
const newVariantFileInput = document.getElementById('new-variant-images');
const variantPreviewContainer = document.getElementById('variant-image-preview-container');
const debouncedApply = debounce(applyFilters, 400);


let addProdMainFile = null;

let currentRestockProductId = null;
let currentRestockData = { active: [], discontinued: [] };
let hasUnsavedRestockChanges = false;
let globalSizes = [];
let globalColors = [];
let variantSelectedFiles = [];

function debounce(fn, delay) {
    let timer;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => fn(...args), delay);
    };
}

function applyFilters() {
    state.keyword     = elKeyword.value.trim();
    state.brandId     = elBrand.value;
    state.colorId     = elColor.value;
    state.sizeId      = elSize.value;
    state.stockStatus = elStatus.value;
    state.visible     = elVisible.value;
    state.page        = 1;
    expandedRows.clear();
    fetchList();
}

document.addEventListener('DOMContentLoaded', () => {
    loadFilterOptions();
    fetchList();

    elKeyword.addEventListener('input', debouncedApply);

    elBrand.addEventListener('change',   applyFilters);
    elColor.addEventListener('change',   applyFilters);
    elSize.addEventListener('change',    applyFilters);
    elStatus.addEventListener('change',  applyFilters);
    elVisible.addEventListener('change', applyFilters);

    elApply.addEventListener('click', applyFilters);

    elReset.addEventListener('click', () => {
        elKeyword.value = '';
        elBrand.value   = '';
        elColor.value   = '';
        elSize.value    = '';
        elStatus.value  = '';
        elVisible.value = '';
        Object.assign(state, {
            keyword: '', brandId: '', colorId: '', sizeId: '',
            stockStatus: '', visible: '', page: 1
        });
        expandedRows.clear();
        fetchList();
    });
});

function populateSelect(selectEl, items, valKey, labelKey) {
    if (!items) return;
    items.forEach(item => {
        const opt = document.createElement('option');
        opt.value       = item[valKey];
        opt.textContent = item[labelKey];
        selectEl.appendChild(opt);
    });
}

async function fetchList() {
    elTbody.innerHTML = `
        <tr>
          <td colspan="8" class="text-center py-5 text-muted">
            <div class="spinner-border spinner-border-sm me-2" style="color:#ff675c;"></div>
            Đang tải dữ liệu...
          </td>
        </tr>`;

    const params = new URLSearchParams();
    if (state.keyword)     params.set('keyword',  state.keyword);
    if (state.brandId)     params.set('brandId',  state.brandId);
    if (state.colorId)     params.set('colorId',  state.colorId);
    if (state.sizeId)      params.set('sizeId',   state.sizeId);
    if (state.stockStatus) params.set('status',   state.stockStatus);
    if (state.visible)     params.set('visible',  state.visible);
    params.set('page', state.page);

    try {
        const res  = await fetch(`${API}?${params}`);
        const data = await res.json();

        state.totalCount = data.totalCount;
        state.totalPages = data.totalPages;

        renderTable(data.rows);
        renderSummary();
        renderPagination();
    } catch (err) {
        console.error('Lỗi tải danh sách:', err);
        elTbody.innerHTML = `
            <tr><td colspan="8" class="text-center py-4 text-danger">
                Có lỗi xảy ra khi tải dữ liệu.
            </td></tr>`;
    }
}

function renderTable(rows) {
    if (!rows || rows.length === 0) {
        elTbody.innerHTML = `
            <tr><td colspan="8" class="text-center py-5 text-muted">
                <span class="material-symbols-outlined d-block mb-2" style="font-size:40px;color:#cbd5e1;">
                    inventory_2
                </span>
                Không tìm thấy sản phẩm nào.
            </td></tr>`;
        return;
    }

    elTbody.innerHTML = '';
    rows.forEach((row, idx) => {
        const isExpanded = expandedRows.has(row.productId);
        elTbody.insertAdjacentHTML('beforeend', buildProductRow(row, idx, isExpanded));
        if (isExpanded) {
            elTbody.insertAdjacentHTML('beforeend', buildVariantPlaceholder(row.productId));
        }
    });

    elTbody.querySelectorAll('.product-row').forEach(tr => {
        tr.addEventListener('click', (e) => {
            if (e.target.closest('.action-btns')) return;
            const pid = parseInt(tr.dataset.productId);
            toggleAccordion(pid, tr);
        });
    });
}

function buildProductRow(row, idx, expanded) {
    const stockBadge = stockBadgeHtml(row.stockStatus, row.totalStock);
    const imgHtml = row.mainImageUrl
        ? `<img src="${escHtml(row.mainImageUrl)}" class="product-img" alt="${escHtml(row.productName)}">`
        : `<div class="product-img-placeholder">
               <span class="material-symbols-outlined" style="font-size:20px;">image</span>
           </div>`;

    const priceFormatted = formatVND(row.price);

    return `
    <tr class="product-row${expanded ? ' expanded' : ''}" data-product-id="${row.productId}">
        <td class="px-3">
            <span class="material-symbols-outlined expand-icon${expanded ? ' open' : ''}">
                expand_more
            </span>
        </td>
        <td>${imgHtml}</td>
        <td>
            <div class="fw-semibold" style="font-family:var(--heading-font,inherit);">
                ${escHtml(row.productName)}
            </div>
            <div class="text-muted" style="font-size:12px;">ID: ${row.productId}</div>
        </td>
        <td class="text-muted">${escHtml(row.brandName)}</td>
        <td class="text-end fw-medium">${priceFormatted}</td>
        <td class="text-center fw-bold ${row.totalStock <= 5 ? 'text-danger' : ''}">${row.totalStock}</td>
        <td class="text-center">${stockBadge}</td>
        <td class="text-center action-btns">
            <button class="btn btn-sm btn-link p-1 text-secondary"
                    title="Chỉnh sửa sản phẩm"
                    onclick="openEditModal(${row.productId})">
                <span class="material-symbols-outlined" style="font-size:20px;">edit</span>
            </button>
            <button class="btn btn-sm btn-link p-1 text-secondary"
                    title="Nhập thêm hàng"
                    onclick="openRestockModal(${row.productId}, '${escHtml(row.productName)}', ${row.available})">
                <span class="material-symbols-outlined" style="font-size:20px;">add_shopping_cart</span>
            </button>
        </td>
    </tr>`;
}

function buildVariantPlaceholder(productId) {
    return `
    <tr class="variant-accordion" id="variant-row-${productId}">
        <td colspan="8" class="p-0">
            <div class="px-4 py-3" id="variant-content-${productId}">
                <div class="text-center py-3 text-muted" style="font-size:13px;">
                    <div class="spinner-border spinner-border-sm me-1" style="color:#ff675c;"></div>
                    Đang tải variants...
                </div>
            </div>
        </td>
    </tr>`;
}

function toggleAccordion(productId, tr) {
    const existingRow = document.getElementById(`variant-row-${productId}`);

    if (existingRow) {
        existingRow.remove();
        tr.classList.remove('expanded');
        tr.querySelector('.expand-icon').classList.remove('open');
        expandedRows.delete(productId);
    } else {
        tr.insertAdjacentHTML('afterend', buildVariantPlaceholder(productId));
        tr.classList.add('expanded');
        tr.querySelector('.expand-icon').classList.add('open');
        expandedRows.add(productId);
        loadVariants(productId);
    }
}

async function loadVariants(productId) {
    const container = document.getElementById(`variant-content-${productId}`);
    if (!container) return;

    try {
        const res  = await fetch(`${API}?action=variants&productId=${productId}`);
        const data = await res.json();

        if (!data.variants || data.variants.length === 0) {
            container.innerHTML = `<p class="text-muted text-center py-2 mb-0" style="font-size:13px;">
                Chưa có variant nào.
            </p>`;
            return;
        }

        container.innerHTML = buildVariantTable(data.variants);
    } catch (err) {
        container.innerHTML = `<p class="text-danger text-center py-2 mb-0" style="font-size:13px;">
            Lỗi tải variants.
        </p>`;
    }
}

function buildVariantTable(variants) {
    const rows = variants.map(v => {
        const dot = v.hexcode
            ? `<span class="color-dot me-1" style="background:${escHtml(v.hexcode)};"></span>`
            : '';
        const badge = stockBadgeHtml(
            v.stock === 0 ? 'outstock' : v.stock <= 5 ? 'lowstock' : 'instock',
            v.stock
        );
        return `
        <tr>
            <td>${escHtml(v.sizeName)}</td>
            <td>
                <div class="d-flex align-items-center gap-1">
                    ${dot}${escHtml(v.colorName)}
                </div>
            </td>
            <td class="text-center fw-medium ${v.stock <= 5 ? 'text-danger' : ''}">${v.stock}</td>
            <td class="text-center">${badge}</td>
        </tr>`;
    }).join('');

    return `
    <table class="table variant-table table-bordered table-sm mb-0 bg-white rounded">
        <thead class="table-light">
            <tr>
                <th class="px-3 py-2">Kích cỡ</th>
                <th class="px-3 py-2">Màu sắc</th>
                <th class="px-3 py-2 text-center">Tồn kho</th>
                <th class="px-3 py-2 text-center">Trạng thái</th>
            </tr>
        </thead>
        <tbody>${rows}</tbody>
    </table>`;
}

function renderSummary() {
    const start = (state.page - 1) * 10 + 1;
    const end   = Math.min(state.page * 10, state.totalCount);
    elSummary.textContent = state.totalCount === 0
        ? 'Không có kết quả nào.'
        : `Hiển thị ${start}–${end} trong tổng ${state.totalCount} sản phẩm`;
}

function renderPagination() {
    if (state.totalPages <= 1) {
        elPagWrapper.style.display = 'none';
        return;
    }
    elPagWrapper.style.display = '';

    const p = state.page, tp = state.totalPages;

    let html = '';
    html += `<li class="page-item ${p === 1 ? 'disabled' : ''}">
        <a class="page-link" href="#" data-page="${p - 1}">
            <span class="material-symbols-outlined" style="font-size:16px;vertical-align:-4px;">chevron_left</span>
        </a></li>`;

    const range = pagRange(p, tp);
    range.forEach(n => {
        if (n === '...') {
            html += `<li class="page-item disabled"><span class="page-link">…</span></li>`;
        } else {
            html += `<li class="page-item ${n === p ? 'active' : ''}">
                <a class="page-link" href="#" data-page="${n}">${n}</a></li>`;
        }
    });

    html += `<li class="page-item ${p === tp ? 'disabled' : ''}">
        <a class="page-link" href="#" data-page="${p + 1}">
            <span class="material-symbols-outlined" style="font-size:16px;vertical-align:-4px;">chevron_right</span>
        </a></li>`;

    elPagList.innerHTML = html;

    elPagList.querySelectorAll('[data-page]').forEach(a => {
        a.addEventListener('click', e => {
            e.preventDefault();
            const pg = parseInt(a.dataset.page);
            if (pg < 1 || pg > tp || pg === p) return;
            state.page = pg;
            fetchList();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    });
}

function pagRange(current, total) {
    if (total <= 7) return Array.from({length: total}, (_, i) => i + 1);
    const pages = [];
    pages.push(1);
    if (current > 3) pages.push('...');
    for (let i = Math.max(2, current - 1); i <= Math.min(total - 1, current + 1); i++) {
        pages.push(i);
    }
    if (current < total - 2) pages.push('...');
    pages.push(total);
    return pages;
}

function stockBadgeHtml(status, count) {
    const map = {
        instock:  ['badge-instock',  'Còn hàng'],
        lowstock: ['badge-lowstock', 'Sắp hết'],
        outstock: ['badge-outstock', 'Hết hàng'],
    };
    const [cls, label] = map[status] || map['instock'];
    return `<span class="badge rounded-pill px-3 py-1 fw-semibold ${cls}">${label}</span>`;
}

function formatVND(amount) {
    if (amount == null) return '—';
    return Number(amount).toLocaleString('vi-VN', { style:'currency', currency:'VND' });
}

function escHtml(str) {
    if (str == null) return '';
    return String(str)
        .replace(/&/g,'&amp;').replace(/</g,'&lt;')
        .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function getRestockModalInstance() {
    return bootstrap.Modal.getOrCreateInstance(document.getElementById('restockModal'));
}

async function openRestockModal(productId, productName, isAvailable) {
    currentRestockProductId = productId;
    hasUnsavedRestockChanges = false;

    document.getElementById('restock-product-name').textContent = productName;
    const warningEl = document.getElementById('restock-unavailable-warning');
    const btnSaveQty = document.getElementById('btn-save-restock');

    if (!isAvailable) {
        warningEl.classList.remove('d-none');
        btnSaveQty.disabled = true;
    } else {
        warningEl.classList.add('d-none');
        btnSaveQty.disabled = false;
    }

    document.getElementById('restock-modal-loading').style.display = 'block';
    document.getElementById('restock-modal-content').style.display = 'none';

    getRestockModalInstance().show();

    try {
        const res = await fetch(`${API}?action=variants&productId=${productId}&all=true`);
        const data = await res.json();

        if (data.variants) {
            currentRestockData.active = data.variants.filter(v => !v.isDiscontinued);
            currentRestockData.discontinued = data.variants.filter(v => v.isDiscontinued);

            renderRestockActiveTab(currentRestockData.active);
            renderRestockDiscontinuedTab(currentRestockData.discontinued);
        }

        document.getElementById('restock-modal-loading').style.display = 'none';
        document.getElementById('restock-modal-content').style.display = 'block';

    } catch (err) {
        console.error('Lỗi tải thông tin biến thể:', err);
    }
}

function renderRestockActiveTab(activeVariants) {
    const tbody = document.getElementById('restock-qty-tbody');
    if (activeVariants.length === 0) {
        tbody.innerHTML = `<tr><td colspan="5" class="text-center text-muted py-3">Chưa có biến thể nào đang bán.</td></tr>`;
        return;
    }

    tbody.innerHTML = activeVariants.map(v => {
        const dot = v.hexcode ? `<span class="color-dot me-1" style="background:${escHtml(v.hexcode)};"></span>` : '';
        return `
        <tr>
            <td class="align-middle">${escHtml(v.sizeName)}</td>
            <td class="align-middle"><div class="d-flex align-items-center gap-1">${dot}${escHtml(v.colorName)}</div></td>
            <td class="align-middle text-center fw-medium">${v.stock}</td>
            <td class="align-middle text-center" style="width: 100px;">
                <input type="number" class="form-control form-control-sm text-center restock-input" 
                       data-variant-id="${v.variantId}" placeholder="+0" min="0">
            </td>
            <td class="align-middle text-center">
                <button class="btn btn-sm btn-outline-danger p-1 border-0" title="Ngừng bán"
                        onclick="toggleVariantStatus(${v.variantId}, true)">
                    <span class="material-symbols-outlined align-middle" style="font-size:18px;">block</span>
                </button>
            </td>
        </tr>`;
    }).join('');
}

function renderRestockDiscontinuedTab(discontinuedVariants) {
    const tbody = document.getElementById('restock-discontinued-tbody');
    if (discontinuedVariants.length === 0) {
        tbody.innerHTML = `<tr><td colspan="3" class="text-center text-muted py-3">Không có biến thể nào đang ngừng bán.</td></tr>`;
        return;
    }

    tbody.innerHTML = discontinuedVariants.map(v => {
        const dot = v.hexcode ? `<span class="color-dot me-1" style="background:${escHtml(v.hexcode)};"></span>` : '';
        return `
        <tr>
            <td>${escHtml(v.sizeName)}</td>
            <td><div class="d-flex align-items-center gap-1">${dot}${escHtml(v.colorName)}</div></td>
            <td class="text-center">
                <button class="btn btn-sm btn-outline-success py-1 px-2" 
                        onclick="reactivateVariant(${v.variantId})">
                    <span class="material-symbols-outlined align-middle" style="font-size:16px;">restore</span> Mở lại
                </button>
            </td>
        </tr>`;
    }).join('');
}

document.getElementById('restock-qty-tbody').addEventListener('input', (e) => {
    if (e.target.classList.contains('restock-input')) {
        const allInputs = document.querySelectorAll('.restock-input');
        hasUnsavedRestockChanges = Array.from(allInputs).some(input => (parseInt(input.value) || 0) > 0);
    }
});

async function saveRestock(closeModalOnSuccess = true) {
    const inputs = document.querySelectorAll('.restock-input');
    const updateList = [];

    inputs.forEach(input => {
        const val = parseInt(input.value) || 0;
        if (val > 0) {
            updateList.push({
                variantId: parseInt(input.dataset.variantId),
                quantity: val
            });
        }
    });

    if (updateList.length === 0) {
        Swal.fire({ icon: 'info', title: 'Thông báo', text: 'Vui lòng nhập số lượng cho ít nhất một biến thể.' });
        return false;
    }

    Swal.fire({ title: 'Đang lưu...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        const res = await fetch(`${API}?action=saveRestock`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                productId: currentRestockProductId,
                updates: updateList
            })
        });

        const result = await res.json();

        if (result.success) {
            Swal.fire({ icon: 'success', title: 'Thành công!', text: 'Đã cập nhật tồn kho.', timer: 1500 });
            hasUnsavedRestockChanges = false;

            document.querySelectorAll('.restock-input').forEach(input => input.value = '');

            if (closeModalOnSuccess) {
                getRestockModalInstance().hide();
            }
            fetchList();
            return true;
        } else {
            Swal.fire({ icon: 'error', title: 'Lỗi', text: result.message || 'Không thể lưu dữ liệu.' });
            return false;
        }
    } catch (err) {
        Swal.fire({ icon: 'error', title: 'Lỗi', text: err.message });
        return false;
    }
}

document.getElementById('btn-save-restock').addEventListener('click', () => saveRestock(true));

document.getElementById('btn-close-restock-modal').addEventListener('click', async () => {
    if (!hasUnsavedRestockChanges) {
        getRestockModalInstance().hide();
        return;
    }

    const result = await Swal.fire({
        title: 'Bạn có thay đổi chưa lưu!',
        text: "Bạn có muốn lưu các thay đổi này không?",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Lưu',
        cancelButtonText: 'Không lưu'
    });

    if (result.isConfirmed) {
        await saveRestock(true);
    } else if (result.dismiss === Swal.DismissReason.cancel) {
        hasUnsavedRestockChanges = false;
        document.querySelectorAll('.restock-input').forEach(input => input.value = '');
        getRestockModalInstance().hide();
    }
});

document.querySelectorAll('#restockModal button[data-bs-toggle="tab"]').forEach(tabBtn => {
    tabBtn.addEventListener('hide.bs.tab', async (e) => {
        if (hasUnsavedRestockChanges) {
            e.preventDefault();

            const targetTab = e.relatedTarget;

            const result = await Swal.fire({
                title: 'Dữ liệu chưa lưu',
                text: 'Bạn có muốn lưu số lượng nhập hàng trước khi chuyển tab không?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Lưu',
                cancelButtonText: 'Không lưu'
            });

            if (result.isConfirmed) {
                const saved = await saveRestock(false);
                if (saved) {
                    hasUnsavedRestockChanges = false;
                    bootstrap.Tab.getOrCreateInstance(targetTab).show();
                }
            } else if (result.dismiss === Swal.DismissReason.cancel) {
                hasUnsavedRestockChanges = false;
                document.querySelectorAll('.restock-input').forEach(input => input.value = '');
                bootstrap.Tab.getOrCreateInstance(targetTab).show();
            }
        }
    });
});

document.getElementById('fab-add-product').addEventListener('click', () => {
    const addModal = new bootstrap.Modal(document.getElementById('addProductModal'));
    addModal.show();
});

function reactivateVariant(variantId) {
    toggleVariantStatus(variantId, false);
}

async function toggleVariantStatus(variantId, isDiscontinued) {
    const actionText = isDiscontinued ? "ngừng bán" : "mở lại";

    if (isDiscontinued) {
        const confirm = await Swal.fire({
            title: 'Xác nhận ngừng bán?',
            text: 'Biến thể này sẽ bị ẩn khỏi danh sách bán hàng.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Ngừng bán',
            cancelButtonText: 'Hủy'
        });
        if (!confirm.isConfirmed) return;
    }

    Swal.fire({ title: 'Đang xử lý...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        const formData = new URLSearchParams();
        formData.append('variantId', variantId);
        formData.append('isDiscontinued', isDiscontinued);

        const res = await fetch(`${API}?action=toggleVariantStatus`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData.toString()
        });

        const result = await res.json();

        if (result.success) {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: `Đã ${actionText} biến thể.`,
                timer: 1500,
                showConfirmButton: false
            });

            const reloadRes = await fetch(`${API}?action=variants&productId=${currentRestockProductId}&all=true`);
            const reloadData = await reloadRes.json();

            if (reloadData.variants) {
                currentRestockData.active = reloadData.variants.filter(v => !v.isDiscontinued);
                currentRestockData.discontinued = reloadData.variants.filter(v => v.isDiscontinued);

                renderRestockActiveTab(currentRestockData.active);
                renderRestockDiscontinuedTab(currentRestockData.discontinued);
            }

            fetchList();
        } else {
            Swal.fire({ icon: 'error', title: 'Lỗi', text: result.message || 'Không thể xử lý dữ liệu.' });
        }
    } catch (err) {
        Swal.fire({ icon: 'error', title: 'Lỗi', text: err.message });
    }
}

if (newVariantFileInput) {
    newVariantFileInput.addEventListener('change', function(e) {
        const files = Array.from(e.target.files);
        if (files.length === 0) return;

        variantSelectedFiles = variantSelectedFiles.concat(files);
        renderVariantImagePreviews();

        newVariantFileInput.value = '';
    });
}

function renderVariantImagePreviews() {
    if (!variantPreviewContainer) return;
    variantPreviewContainer.innerHTML = '';

    variantSelectedFiles.forEach((file, index) => {
        const blobUrl = URL.createObjectURL(file);

        const imgWrapper = document.createElement('div');
        imgWrapper.className = 'position-relative border rounded p-1 bg-white';
        imgWrapper.style.width = '70px';
        imgWrapper.style.height = '70px';

        imgWrapper.innerHTML = `
            <img src="${blobUrl}" class="w-100 h-100 object-fit-cover rounded" alt="preview">
            <button type="button" class="btn btn-danger btn-sm position-absolute rounded-circle p-0 d-flex align-items-center justify-content-center" 
                    style="top: -5px; right: -5px; width: 20px; height: 20px;"
                    onclick="removeVariantFile(${index})">
                <span class="material-symbols-outlined" style="font-size: 14px;">close</span>
            </button>
        `;
        variantPreviewContainer.appendChild(imgWrapper);
    });
}

window.removeVariantFile = function(index) {
    variantSelectedFiles.splice(index, 1);
    renderVariantImagePreviews();
};

async function loadFilterOptions() {
    try {
        const res  = await fetch(`${API}?action=filterOptions`);
        const data = await res.json();

        // 1. Lưu data vào biến toàn cục để dùng cho phần tạo Form động
        globalSizes = data.sizes || [];
        globalColors = data.colors || [];

        // 2. Đổ data cho thanh Bộ lọc (Filter) bên ngoài bảng
        populateSelect(elBrand, data.brands, 'id', 'name');
        populateSelect(elColor, globalColors, 'id', 'name');
        populateSelect(elSize,  globalSizes,  'id', 'name');

        // 3. Đổ data cho Modal Thêm Sản Phẩm (Bây giờ chỉ cần Brand)
        populateSelect(document.getElementById('add-prod-brand'), data.brands, 'id', 'name');

        // 4. Đổ data cho tab "Thêm biến thể mới" trong Modal Nhập hàng (Restock)
        const newColorSelect = document.getElementById('new-variant-color');
        const newSizeSelect = document.getElementById('new-variant-size');

        if (newColorSelect && newSizeSelect) {
            newColorSelect.innerHTML = '<option value="">-- Chọn Màu --</option>';
            newSizeSelect.innerHTML = '<option value="">-- Chọn Size --</option>';
            populateSelect(newColorSelect, globalColors, 'id', 'name');
            populateSelect(newSizeSelect, globalSizes, 'id', 'name');
        }

        // 5. Đổ data cho Modal Chỉnh sửa sản phẩm (Nếu bạn có file editProduct.js riêng)
        if (typeof populateEditBrandSelect === 'function') {
            populateEditBrandSelect(data.brands);
        }
    } catch (err) {
        console.error('Lỗi tải filter options:', err);
    }
}

document.getElementById('btn-save-new-variant').addEventListener('click', async () => {
    const colorId = document.getElementById('new-variant-color').value;
    const sizeId = document.getElementById('new-variant-size').value;
    const stock = document.getElementById('new-variant-stock').value || 0;

    if (!colorId || !sizeId) {
        Swal.fire({ icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng chọn cả Màu sắc và Kích cỡ.' });
        return;
    }
    if (stock < 0) {
        Swal.fire({ icon: 'warning', title: 'Lỗi', text: 'Số lượng tồn kho không được âm.' });
        return;
    }

    Swal.fire({ title: 'Đang xử lý...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        let uploadedImageUrls = [];

        if (variantSelectedFiles.length > 0) {
            Swal.update({ title: `Đang tải lên ${variantSelectedFiles.length} ảnh...` });

            for (const file of variantSelectedFiles) {
                const formData = new FormData();
                formData.append('file', file);
                formData.append('folder', 'variants');

                const uploadRes = await fetch(window.contextPath + '/admin/upload-image', {
                    method: 'POST', body: formData
                });

                const uploadData = await uploadRes.json();
                if (uploadData.success) {
                    uploadedImageUrls.push(uploadData.url);
                } else {
                    throw new Error(`Lỗi upload ảnh: ${uploadData.error}`);
                }
            }
        }

        Swal.update({ title: 'Đang lưu biến thể mới...' });

        const params = new URLSearchParams();
        params.append('productId', currentRestockProductId);
        params.append('colorId', colorId);
        params.append('sizeId', sizeId);
        params.append('stock', stock);

        if (uploadedImageUrls.length > 0) {
            params.append('imageUrls', JSON.stringify(uploadedImageUrls));
        }

        const res = await fetch(`${API}?action=addVariant`, {
            method: 'POST',
            body: params
        });

        const result = await res.json();

        if (result.success) {
            Swal.fire({ icon: 'success', title: 'Thành công!', text: 'Đã thêm biến thể mới.', timer: 1500 });

            document.getElementById('new-variant-color').value = '';
            document.getElementById('new-variant-size').value = '';
            document.getElementById('new-variant-stock').value = '';
            variantSelectedFiles = [];
            renderVariantImagePreviews();

            const reloadRes = await fetch(`${API}?action=variants&productId=${currentRestockProductId}&all=true`);
            const reloadData = await reloadRes.json();

            if (reloadData.variants) {
                currentRestockData.active = reloadData.variants.filter(v => !v.isDiscontinued);
                currentRestockData.discontinued = reloadData.variants.filter(v => v.isDiscontinued);
                renderRestockActiveTab(currentRestockData.active);
                renderRestockDiscontinuedTab(currentRestockData.discontinued);
            }
            fetchList();
        } else {
            Swal.fire({ icon: 'error', title: 'Lỗi', text: result.message || 'Không thể tạo biến thể.' });
        }
    } catch (err) {
        Swal.fire({ icon: 'error', title: 'Lỗi hệ thống', text: err.message });
    }
});

const toggleVariantCheckbox = document.getElementById('toggle-optional-variant');
if (toggleVariantCheckbox) {
    toggleVariantCheckbox.addEventListener('change', function() {
        const optionalSection = document.getElementById('optional-variant-section');
        if (this.checked) {
            optionalSection.classList.remove('d-none');

            const container = document.getElementById('variants-dynamic-container');
            if (container && container.children.length === 0) {
                addNewVariantRow();
            }
        } else {
            optionalSection.classList.add('d-none');
        }
    });
}

document.getElementById('btn-submit-add-product').addEventListener('click', async () => {
    const name = document.getElementById('add-prod-name').value.trim();
    const price = document.getElementById('add-prod-price').value;
    const brandId = document.getElementById('add-prod-brand').value;
    const mainImgInput = document.getElementById('add-prod-main-img');

    if (!name || !price || !brandId || !mainImgInput.files[0]) {
        Swal.fire({ icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng điền đầy đủ thông tin cơ bản.' });
        return;
    }

    Swal.fire({ title: 'Đang xử lý...', allowOutsideClick: false, didOpen: () => Swal.showLoading() });

    try {
        const formData = new FormData();
        formData.append('file', mainImgInput.files[0]);
        formData.append('folder', 'products');

        const uploadRes = await fetch(window.contextPath + '/admin/upload-image', { method: 'POST', body: formData });
        const uploadData = await uploadRes.json();
        if (!uploadData.success) throw new Error('Lỗi upload ảnh đại diện');

        const productPayload = {
            name: name,
            price: price,
            brandId: brandId,
            mainImageUrl: uploadData.url,
            variants: []
        };

        const isVariantEnabled = document.getElementById('toggle-optional-variant').checked;
        if (isVariantEnabled) {
            const variantRows = document.querySelectorAll('.variant-row-item');

            if (variantRows.length === 0) {
                throw new Error("Bạn đã bật thêm biến thể nhưng chưa có dòng dữ liệu nào.");
            }

            for (const row of variantRows) {
                const rowId = row.id;
                const colorId = row.querySelector('.variant-color').value;
                const sizeId = row.querySelector('.variant-size').value;
                const stock = row.querySelector('.variant-stock').value || 0;

                if (!colorId || !sizeId) {
                    throw new Error("Vui lòng chọn đầy đủ Màu sắc và Kích cỡ cho các biến thể.");
                }

                let imageUrls = [];
                const files = window.addProdVariantFilesMap[rowId] || [];
                for (const file of files) {
                    const vForm = new FormData();
                    vForm.append('file', file);
                    vForm.append('folder', 'variants');
                    const vRes = await fetch(window.contextPath + '/admin/upload-image', { method: 'POST', body: vForm });
                    const vData = await vRes.json();
                    if (vData.success) imageUrls.push(vData.url);
                }

                productPayload.variants.push({
                    colorId: parseInt(colorId),
                    sizeId: parseInt(sizeId),
                    stock: parseInt(stock),
                    imageUrls: imageUrls
                });
            }
        }

        const res = await fetch(`${API}?action=addProduct`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(productPayload)
        });

        const result = await res.json();

        if (result.success) {
            Swal.fire({ icon: 'success', title: 'Thành công!', text: 'Đã thêm sản phẩm mới.', timer: 1500 });
            bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
            document.getElementById('add-product-form').reset();
            document.getElementById('variants-dynamic-container').innerHTML = '';
            window.addProdVariantFilesMap = {};
            document.getElementById('add-prod-main-img-preview').style.display = 'none';
            fetchList();
        } else {
            Swal.fire({ icon: 'error', title: 'Lỗi', text: result.message });
        }
    } catch (err) {
        Swal.fire({ icon: 'error', title: 'Lỗi', text: err.message });
    }
});

let variantRowIndex = 0;
window.addProdVariantFilesMap = {};

window.addNewVariantRow = function() {
    const container = document.getElementById('variants-dynamic-container');
    if (!container) return;

    const rowId = `row-${variantRowIndex++}`;
    window.addProdVariantFilesMap[rowId] = [];

    const colorOptions = '<option value="">-- Chọn Màu --</option>' + globalColors.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
    const sizeOptions = '<option value="">-- Chọn Size --</option>' + globalSizes.map(s => `<option value="${s.id}">${s.name}</option>`).join('');

    const rowHtml = `
        <div class="position-relative variant-row-item mb-4" id="${rowId}">
            <div class="card card-body bg-light border-0">
                <button type="button" class="btn btn-sm btn-outline-danger position-absolute bg-white shadow-sm" 
                        style="top: 15px; right: 15px; padding: 4px; display: flex; z-index: 10;" 
                        onclick="removeVariantRow('${rowId}')" title="Xóa biến thể này">
                    <span class="material-symbols-outlined" style="font-size: 18px;">delete</span>
                </button>
                
                <h6 class="fw-bold mb-3">Thông tin biến thể</h6>
                
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Màu sắc <span class="text-danger">*</span></label>
                        <select class="form-select variant-color">${colorOptions}</select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Kích cỡ <span class="text-danger">*</span></label>
                        <select class="form-select variant-size">${sizeOptions}</select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold">Tồn kho ban đầu <span class="text-danger">*</span></label>
                        <input type="number" class="form-control variant-stock" placeholder="0" min="0">
                    </div>
                    
                    <div class="col-12 mt-3">
                        <label class="form-label small fw-semibold">Ảnh biến thể (Theo màu sắc)</label>
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <label for="file-${rowId}" class="btn btn-sm btn-outline-secondary d-flex align-items-center bg-white">
                                <span class="material-symbols-outlined me-1" style="font-size: 18px;">cloud_upload</span>
                                Chọn ảnh
                            </label>
                            <input type="file" id="file-${rowId}" class="d-none" accept="image/*" multiple onchange="handleVariantRowFiles(this, '${rowId}')">
                            <span class="text-muted small">Có thể chọn nhiều ảnh.</span>
                        </div>
                        <div id="preview-${rowId}" class="d-flex flex-wrap gap-2"></div>
                    </div>
                </div>
            </div>
            
            <hr class="text-secondary opacity-25 mt-4 mb-0">
        </div>
    `;

    container.insertAdjacentHTML('beforeend', rowHtml);
};

window.removeVariantRow = function(rowId) {
    const rowEl = document.getElementById(rowId);
    if (rowEl) rowEl.remove();
    delete window.addProdVariantFilesMap[rowId];
};

window.handleVariantRowFiles = function(inputEl, rowId) {
    const files = Array.from(inputEl.files);
    if (files.length === 0) return;

    window.addProdVariantFilesMap[rowId] = window.addProdVariantFilesMap[rowId].concat(files);
    inputEl.value = '';
    renderVariantRowPreviews(rowId);
};

window.removeRowFile = function(rowId, fileIndex) {
    window.addProdVariantFilesMap[rowId].splice(fileIndex, 1);
    renderVariantRowPreviews(rowId);
};

function renderVariantRowPreviews(rowId) {
    const previewContainer = document.getElementById(`preview-${rowId}`);
    if (!previewContainer) return;
    previewContainer.innerHTML = '';

    window.addProdVariantFilesMap[rowId].forEach((file, index) => {
        const blobUrl = URL.createObjectURL(file);
        previewContainer.insertAdjacentHTML('beforeend', `
            <div class="position-relative border rounded p-1 bg-white" style="width: 70px; height: 70px;">
                <img src="${blobUrl}" class="w-100 h-100 object-fit-cover rounded" alt="preview">
                <button type="button" class="btn btn-danger btn-sm position-absolute rounded-circle p-0 d-flex align-items-center justify-content-center" 
                        style="top: -5px; right: -5px; width: 20px; height: 20px;"
                        onclick="removeRowFile('${rowId}', ${index})">
                    <span class="material-symbols-outlined" style="font-size: 14px;">close</span>
                </button>
            </div>
        `);
    });
}
