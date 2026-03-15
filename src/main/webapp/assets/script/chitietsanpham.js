
    document.addEventListener("DOMContentLoaded", () => {
    const popup = document.getElementById("cartPopup");
    const popupClose = document.querySelector(".cart-close");

    // Nút giỏ hàng chính ở chi tiết sản phẩm → chỉ toast
    const mainCartBtn = document.getElementById("btn-add-cart");
    mainCartBtn.addEventListener("click", () => {
    showToast("Đã thêm sản phẩm này vào Giỏ hàng!");
});

    // Nút wishlist ở chi tiết sản phẩm → toast
    document.getElementById("btn-wishlist").addEventListener("click", () => {
    showToast("Đã thêm sản phẩm này vào Yêu thích!");
});

    // Nút mua ngay → toast
    document.getElementById("btn-buy-now").addEventListener("click", () => {
    showToast("Đang chuyển đến trang thanh toán...");
});

    // ================== Sản phẩm gợi ý ==================
    document.querySelectorAll(".product-card .card-action-btn").forEach((btn) => {
    btn.addEventListener("click", (e) => {
    e.preventDefault();
    const icon = btn.querySelector("ion-icon");
    const iconName = icon.getAttribute("name");

    const card = btn.closest(".product-card");
    const productName = card.querySelector(".card-title a").textContent;
    const productImg = card.querySelector("img").src;
    const productPrice = card.querySelector(".card-price").textContent;

    if (iconName === "cart-outline") {
    // Chỉ mở popup
    showProductPopup({
    image: productImg,
    name: productName,
    price: productPrice,
    original: "",
    discount: "",
    colors: [
{ value: "Trắng", color: "#ffffff" },
{ value: "Đen", color: "#000000" },
{ value: "Xanh", color: "#007BFF" }
    ],
    sizes: [38, 39, 40]
});
} else if (iconName === "heart-outline") {
    // Wishlist → toast
    showToast(`Đã thêm sản phẩm vào mục Yêu thích!`);
}
});
});

    // ================== Popup ==================
    popupClose.addEventListener("click", () => popup.classList.remove("active"));
    window.addEventListener("click", (e) => {
    if (e.target === popup) popup.classList.remove("active");
});

    // Nút thêm vào giỏ trong popup → chỉ đóng popup
    document.querySelector(".popup-add-cart").addEventListener("click", () => {
    showToast(`Đã thêm sản phẩm vào Giỏ Hàng!`);
    popup.classList.remove("active");
});

    // ================== Popup màu & size & số lượng ==================
    const colorItems = document.querySelectorAll("#popupColors .popup-color-item");
    colorItems.forEach(item => item.addEventListener("click", () => {
    colorItems.forEach(i => i.classList.remove("selected"));
    item.classList.add("selected");
}));

    const sizeItems = document.querySelectorAll("#popupSizes .popup-size-item");
    sizeItems.forEach(item => item.addEventListener("click", () => {
    sizeItems.forEach(i => i.classList.remove("selected"));
    item.classList.add("selected");
}));

    const qtyInput = document.getElementById("popupQty");
    document.querySelector(".qty-btn.minus").addEventListener("click", () => {
    let val = parseInt(qtyInput.value);
    if (val > 1) qtyInput.value = val - 1;
});
    document.querySelector(".qty-btn.plus").addEventListener("click", () => {
    qtyInput.value = parseInt(qtyInput.value) + 1;
});
    qtyInput.addEventListener("input", () => { if (qtyInput.value < 1) qtyInput.value = 1; });

    // ================== Hàm toast & popup ==================
    window.showToast = (message) => {
    const toast = document.getElementById("toast-message");
    toast.querySelector("span").textContent = message;
    toast.classList.add("show");
    setTimeout(() => toast.classList.remove("show"), 3000);
};

    window.showProductPopup = (data) => {
    if (data.image) document.getElementById("popupImg").src = data.image;
    if (data.name) document.getElementById("popupName").textContent = data.name;
    if (data.price) document.getElementById("popupPrice").textContent = data.price;
    if (data.original) document.getElementById("popupOriginal").textContent = data.original;
    if (data.discount) document.getElementById("popupDiscount").textContent = data.discount;
    qtyInput.value = 1;

    popup.classList.add("active");
};

    // ================== Mobile menu, chọn size chi tiết sản phẩm ==================
    const navOpenBtn = document.querySelector(".nav-open-btn");
    const navCloseBtn = document.querySelector(".nav-close-btn");
    const navbar = document.querySelector(".navbar");
    const overlay = document.querySelector(".overlay");
    const toggleNav = () => { navbar.classList.toggle("active"); overlay.classList.toggle("active"); };
    if (navOpenBtn) navOpenBtn.addEventListener("click", toggleNav);
    if (navCloseBtn) navCloseBtn.addEventListener("click", toggleNav);
    if (overlay) overlay.addEventListener("click", toggleNav);

    const sizeBtns = document.querySelectorAll(".size-btn");
    sizeBtns.forEach(btn => btn.addEventListener("click", () => {
    sizeBtns.forEach(b => b.classList.remove("selected"));
    btn.classList.add("selected");
}));

    // Checkbox màu chi tiết sản phẩm chỉ chọn 1
    const checkboxes = document.querySelectorAll('.filter-list-color input[type="checkbox"]');
    checkboxes.forEach(checkbox => checkbox.addEventListener("change", function () {
    if (this.checked) {
    checkboxes.forEach(other => { if (other !== this) other.checked = false; });
}
}));
        document.addEventListener("DOMContentLoaded", () => {
            const actionButtons = document.querySelectorAll("[data-require-size]");
            const sizeButtons = document.querySelectorAll(".size-btn");
            const warning = document.querySelector(".size-warning");

            function triggerSizeError() {
                sizeButtons.forEach(btn => {
                    btn.classList.add("size-error");
                });

                if (warning) warning.classList.add("show");

                setTimeout(() => {
                    sizeButtons.forEach(btn => btn.classList.remove("size-error"));
                }, 900);
            }

            actionButtons.forEach(btn => {
                btn.addEventListener("click", e => {
                    const selectedSize = document.querySelector(".size-btn.selected");

                    if (!selectedSize) {
                        e.preventDefault();
                        triggerSizeError();
                    }
                });
            });
        });

    });
