const editModal = new bootstrap.Modal(document.getElementById('editProductModal'));

const elEditLoading     = document.getElementById('edit-modal-loading');
const elEditForm        = document.getElementById('edit-modal-form');
const elEditId          = document.getElementById('edit-product-id');
const elEditName        = document.getElementById('edit-name');
const elEditPrice       = document.getElementById('edit-price');
const elEditBrand       = document.getElementById('edit-brand');
const elEditImgUrl      = document.getElementById('edit-img-url');
const elEditImgPrev     = document.getElementById('edit-img-preview');
const elEditImgNoPrev   = document.getElementById('edit-img-placeholder');
const elEditError       = document.getElementById('edit-error-alert');
const elEditErrorMsg    = document.getElementById('edit-error-msg');
const elBtnSave         = document.getElementById('btn-save-product');

function populateEditBrandSelect(brands) {
    elEditBrand.innerHTML = '<option value="">-- Chọn thương hiệu --</option>';
    if (!brands) return;
    brands.forEach(b => {
        const opt = document.createElement('option');
        opt.value       = b.id;
        opt.textContent = b.name;
        elEditBrand.appendChild(opt);
    });
}

async function openEditModal(productId) {
    elEditLoading.style.display = '';
    elEditForm.style.display    = 'none';
    elBtnSave.disabled          = true;
    hideEditError();
    editModal.show();

    try {
        const res  = await fetch(`${API}?action=productDetail&productId=${productId}`);
        const data = await res.json();

        if (data.error) { showEditError(data.error); return; }

        elEditId.value     = data.id         ?? '';
        elEditName.value   = data.name       ?? '';
        elEditPrice.value  = data.price      ?? '';
        elEditBrand.value  = data.brandId    ?? '';
        elEditImgUrl.value = data.mainImgUrl ?? '';

        updateImgPreview(elEditImgUrl.value);

        const radioVal = data.available ? '1' : '0';
        const radio = document.querySelector(`input[name="edit-available"][value="${radioVal}"]`);
        if (radio) radio.checked = true;

        elEditLoading.style.display = 'none';
        elEditForm.style.display    = '';
        elBtnSave.disabled          = false;

    } catch (err) {
        showEditError('Không thể tải thông tin sản phẩm. Vui lòng thử lại.');
        console.error(err);
    }
}

elEditImgUrl.addEventListener('input', () => {
    updateImgPreview(elEditImgUrl.value.trim());
});

function updateImgPreview(url) {
    if (url) {
        elEditImgNoPrev.style.display = 'none';
        elEditImgPrev.onerror = () => {
            elEditImgPrev.style.display   = 'none';
            elEditImgNoPrev.style.display = '';
        };
        elEditImgPrev.src           = url;
        elEditImgPrev.style.display = '';
    } else {
        elEditImgPrev.style.display   = 'none';
        elEditImgNoPrev.style.display = '';
    }
}

elBtnSave.addEventListener('click', async () => {
    hideEditError();

    let valid = true;
    elEditName.classList.remove('is-invalid');
    elEditPrice.classList.remove('is-invalid');
    elEditBrand.classList.remove('is-invalid');

    if (!elEditName.value.trim()) {
        elEditName.classList.add('is-invalid'); valid = false;
    }
    const price = parseFloat(elEditPrice.value);
    if (isNaN(price) || price <= 0) {
        elEditPrice.classList.add('is-invalid'); valid = false;
    }
    if (!elEditBrand.value) {
        elEditBrand.classList.add('is-invalid'); valid = false;
    }
    if (!valid) return;

    const isAvailable = document.querySelector('input[name="edit-available"]:checked')?.value ?? '1';

    const params = new URLSearchParams();
    params.set('action',      'updateProduct');
    params.set('productId',   elEditId.value);
    params.set('name',        elEditName.value.trim());
    params.set('price',       elEditPrice.value);
    params.set('brandId',     elEditBrand.value);
    params.set('isAvailable', isAvailable);

    const imgUrl = elEditImgUrl.value.trim();
    if (imgUrl) params.set('mainImgUrl', imgUrl);

    elBtnSave.disabled = true;
    elBtnSave.innerHTML = `
        <span class="spinner-border spinner-border-sm me-1"></span>
        Đang lưu...`;

    try {
        const res  = await fetch(API, { method: 'POST', body: params });
        const data = await res.json();

        if (data.success) {
            editModal.hide();
            fetchList();
            showToast('Cập nhật sản phẩm thành công!', 'success');
        } else {
            showEditError(data.error || 'Lưu thất bại. Vui lòng thử lại.');
        }
    } catch (err) {
        showEditError('Lỗi kết nối. Vui lòng thử lại.');
        console.error(err);
    } finally {
        elBtnSave.disabled = false;
        elBtnSave.innerHTML = `
            <span class="material-symbols-outlined me-1 align-middle" style="font-size:18px;">save</span>
            Lưu thay đổi`;
    }
});

function showEditError(msg) {
    elEditErrorMsg.textContent = msg;
    elEditError.classList.remove('d-none');
    elEditLoading.style.display = 'none';
    elEditForm.style.display    = '';
}

function hideEditError() {
    elEditError.classList.add('d-none');
}

function showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id        = 'toast-container';
        container.className = 'position-fixed bottom-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
    }
    const id      = 'toast-' + Date.now();
    const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
    const icon    = type === 'success' ? 'check_circle' : 'error';

    container.insertAdjacentHTML('beforeend', `
        <div id="${id}" class="toast align-items-center text-white ${bgClass} border-0"
             role="alert" data-bs-autohide="true" data-bs-delay="3000">
            <div class="d-flex">
                <div class="toast-body d-flex align-items-center gap-2">
                    <span class="material-symbols-outlined" style="font-size:20px;">${icon}</span>
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                        data-bs-dismiss="toast"></button>
            </div>
        </div>`);

    const toastEl = document.getElementById(id);
    new bootstrap.Toast(toastEl).show();
    toastEl.addEventListener('hidden.bs.toast', () => toastEl.remove());
}