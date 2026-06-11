
    document.addEventListener("DOMContentLoaded", function () {
    const navLinks = document.querySelectorAll(".account-nav-list a");
    const tabContents = document.querySelectorAll(".tab-content");

    navLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
    e.preventDefault();

    const targetTab = this.getAttribute("data-tab");

    navLinks.forEach((nav) =>
    nav.closest("li").classList.remove("active")
    );
    tabContents.forEach((content) =>
    content.classList.remove("active")
    );

    this.closest("li").classList.add("active");

    const activeContent = document.querySelector(
    `[data-content="${targetTab}"]`
    );
    if (activeContent) {
    activeContent.classList.add("active");
}
});
});

    const modal = document.getElementById("addressModal");
    const closeBtn = modal ? modal.querySelector(".close-btn") : null;
    const addAddressBtn = document.querySelector(".btn-add-address");
    const editBtns = document.querySelectorAll(".edit-btn");
    const removeBtns = document.querySelectorAll(".remove-btn");

    function openAddressModal(isEdit = false) {
    if (!modal) return;
    const modalTitle = modal.querySelector(".modal-title");
    const addressForm = modal.querySelector(".address-modal-form");
    if (modalTitle) modalTitle.textContent = isEdit ? "Chỉnh Sửa Địa Chỉ" : "Thêm Địa Chỉ Mới";
    if (addressForm) addressForm.reset();
    modal.style.display = "block";
}

    if (addAddressBtn) addAddressBtn.addEventListener("click", () => openAddressModal(false));

    editBtns.forEach((btn) => {
    btn.addEventListener("click", (e) => {
    e.preventDefault();
    openAddressModal(true);
});
});

    removeBtns.forEach((btn) => {
    btn.addEventListener("click", (e) => {
    e.preventDefault();
    confirm("Bạn có chắc chắn muốn xóa địa chỉ này không?");
});
});

    if (closeBtn) {
    closeBtn.addEventListener("click", () => { modal.style.display = "none"; });
}

    window.addEventListener("click", (event) => {
    if (modal && event.target === modal) modal.style.display = "none";
});

    if (modal) {
    const addressForm = modal.querySelector(".address-modal-form");
    if (addressForm) {
    addressForm.addEventListener("submit", (e) => {
    e.preventDefault();
    modal.style.display = "none";
});
}
}

    // ─── AVATAR UPLOAD ────────────────────────────────────────────────────────
    const avatarWrapper = document.getElementById("avatarWrapper");
    const avatarInput   = document.getElementById("avatarInput");
    const avatarPreview = document.getElementById("avatarPreview");
    const avatarLoading = document.getElementById("avatarLoading");

    if (avatarWrapper && avatarInput) {
        // Click vào wrapper mở file picker
        avatarWrapper.addEventListener("click", () => avatarInput.click());

        avatarInput.addEventListener("change", function () {
            const file = this.files[0];
            if (!file) return;

            // Validate phía client
            const allowed = ["image/jpeg", "image/png", "image/webp", "image/gif"];
            if (!allowed.includes(file.type)) {
                showAvatarToast("Chỉ chấp nhận ảnh JPG, PNG, WEBP hoặc GIF.", "error");
                return;
            }
            if (file.size > 5 * 1024 * 1024) {
                showAvatarToast("Ảnh không được vượt quá 5MB.", "error");
                return;
            }

            // Preview tức thời
            const reader = new FileReader();
            reader.onload = (e) => { avatarPreview.src = e.target.result; };
            reader.readAsDataURL(file);

            // Hiện loading
            avatarLoading.style.display = "flex";
            avatarWrapper.style.pointerEvents = "none";

            // AJAX upload
            const formData = new FormData();
            formData.append("action", "upload-avatar");
            formData.append("avatar", file);

            // Dùng CONTEXT_PATH được inject từ JSP
            const uploadUrl = (typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "") + "/account";

            fetch(uploadUrl, {
                method: "POST",
                body: formData
            })
            .then(r => {
                if (!r.ok) {
                    return r.text().then(text => { throw new Error("Server lỗi " + r.status + ": " + text.substring(0, 200)); });
                }
                return r.json();
            })
            .then(data => {
                if (data.success) {
                    avatarPreview.src = data.avatarUrl;
                    updateHeaderAvatar(data.avatarUrl);
                    showAvatarToast("Cập nhật ảnh đại diện thành công!", "success");
                } else {
                    showAvatarToast(data.message || "Upload thất bại!", "error");
                }
            })
            .catch(err => showAvatarToast("Lỗi: " + (err.message || "Không xác định"), "error"))
            .finally(() => {
                avatarLoading.style.display = "none";
                avatarWrapper.style.pointerEvents = "auto";
                avatarInput.value = ""; // reset để chọn lại cùng file được
            });
        });
    }

    function updateHeaderAvatar(avatarUrl) {
        if (!avatarUrl) return;

        document.querySelectorAll(".header-avatar").forEach(img => {
            img.src = avatarUrl;
            img.style.display = "block";
        });

        document.querySelectorAll(".nav-action-dropdown .nav-action-btn").forEach(btn => {
            const existingAvatar = btn.querySelector(".header-avatar");
            const icon = btn.querySelector('ion-icon[name="person-outline"]');

            if (existingAvatar) {
                if (icon) icon.style.display = "none";
                return;
            }

            if (!icon) return;

            const img = document.createElement("img");
            img.src = avatarUrl;
            img.alt = "Avatar";
            img.className = btn.querySelector(".nav-action-text")
                ? "header-avatar header-avatar-mobile"
                : "header-avatar";
            img.onerror = function () {
                this.style.display = "none";
                icon.style.display = "block";
            };

            icon.style.display = "none";
            btn.insertBefore(img, icon);
        });
    }

    function showAvatarToast(message, type) {
        // Dùng SweetAlert2 nếu có, fallback alert
        if (typeof Swal !== "undefined") {
            Swal.fire({
                toast: true,
                position: "top-end",
                icon: type === "success" ? "success" : "error",
                title: message,
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
        } else {
            alert(message);
        }
    }

    // ─── PROFILE UPDATE AJAX ───────────────────────────────────────────────────
    const profileForm = document.getElementById("profileForm");
    if (profileForm) {
        profileForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const submitBtn = profileForm.querySelector("button[type='submit']");
            if (submitBtn) submitBtn.disabled = true;

            const formData = new URLSearchParams(new FormData(profileForm));
            const actionUrl = profileForm.getAttribute("action") || ((typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "") + "/account");

            fetch(actionUrl, {
                method: "POST",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: formData.toString()
            })
            .then(r => {
                if (!r.ok) {
                    throw new Error("Server trả về mã lỗi: " + r.status);
                }
                return r.json();
            })
            .then(data => {
                if (data.success) {
                    // Cập nhật tên hiển thị ở sidebar và lời chào
                    const nameStrong = document.querySelector(".user-name-display strong");
                    if (nameStrong) nameStrong.textContent = data.fullName;

                    showAvatarToast(data.message || "Cập nhật thông tin thành công!", "success");
                } else {
                    showAvatarToast(data.message || "Cập nhật thất bại!", "error");
                }
            })
            .catch(err => {
                showAvatarToast("Lỗi kết nối: " + err.message, "error");
            })
            .finally(() => {
                if (submitBtn) submitBtn.disabled = false;
            });
        });
    }

    // ─── PASSWORD CHANGE AJAX ──────────────────────────────────────────────────
    const passwordForm = document.getElementById("passwordForm");
    if (passwordForm) {
        passwordForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const newPass = document.getElementById("new-password").value;
            const confirmPass = document.getElementById("confirm-password").value;

            if (newPass !== confirmPass) {
                showAvatarToast("Xác nhận mật khẩu mới không khớp!", "error");
                return;
            }

            const submitBtn = passwordForm.querySelector("button[type='submit']");
            if (submitBtn) submitBtn.disabled = true;

            const formData = new URLSearchParams(new FormData(passwordForm));
            const actionUrl = passwordForm.getAttribute("action") || ((typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "") + "/account");

            fetch(actionUrl, {
                method: "POST",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: formData.toString()
            })
            .then(r => {
                if (!r.ok) {
                    throw new Error("Server trả về mã lỗi: " + r.status);
                }
                return r.json();
            })
            .then(data => {
                if (data.success) {
                    showAvatarToast(data.message || "Đổi mật khẩu thành công!", "success");
                    passwordForm.reset(); // Clear all password fields upon success
                } else {
                    showAvatarToast(data.message || "Đổi mật khẩu thất bại!", "error");
                }
            })
            .catch(err => {
                showAvatarToast("Lỗi kết nối: " + err.message, "error");
            })
            .finally(() => {
                if (submitBtn) submitBtn.disabled = false;
            });
        });
    }
});
