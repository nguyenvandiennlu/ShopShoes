
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
    const closeBtn = modal.querySelector(".close-btn");
    const addAddressBtn = document.querySelector(".btn-add-address");
    const editBtns = document.querySelectorAll(".edit-btn");
    const removeBtns = document.querySelectorAll(".remove-btn");
    const modalTitle = modal.querySelector(".modal-title");
    const addressForm = modal.querySelector(".address-modal-form");
    const saveAddressBtn = modal.querySelector(".btn-save-address");

    function openAddressModal(isEdit = false) {
    modalTitle.textContent = isEdit
    ? "Chỉnh Sửa Địa Chỉ"
    : "Thêm Địa Chỉ Mới";
    addressForm.reset();
    modal.style.display = "block";
}

    addAddressBtn.addEventListener("click", () => {
    openAddressModal(false);
});

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

    closeBtn.addEventListener("click", () => {
    modal.style.display = "none";
});

    window.addEventListener("click", (event) => {
    if (event.target === modal) {
    modal.style.display = "none";
}
});

    addressForm.addEventListener("submit", (e) => {
    e.preventDefault();
    modal.style.display = "none";
});
});
