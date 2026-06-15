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

const debouncedApply = debounce(applyFilters, 400);

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

async function loadFilterOptions() {
    try {
        const res  = await fetch(`${API}?action=filterOptions`);
        const data = await res.json();

        populateSelect(elBrand, data.brands, 'id', 'name');
        populateSelect(elColor, data.colors, 'id', 'name');
        populateSelect(elSize,  data.sizes,  'id', 'name');

        if (typeof populateEditBrandSelect === 'function') {
            populateEditBrandSelect(data.brands);
        }
    } catch (err) {
        console.error('Lỗi tải filter options:', err);
    }
}

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
                    onclick="openRestockModal(${row.productId}, '${escHtml(row.productName)}')">
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

function openEditModal(productId) {
    console.log('Edit product:', productId);
    // TODO: implement
}

function openRestockModal(productId, productName) {
    console.log('Restock product:', productId, productName);
    // TODO: implement
}

document.getElementById('fab-add-product').addEventListener('click', () => {
    console.log('Open add product modal');
    // TODO: implement
});