document.addEventListener("DOMContentLoaded", () => {

    const infoBox       = document.querySelector(".product-info-box");
    const productId     = infoBox.dataset.productId;
    const contextPath   = infoBox.dataset.contextPath;

    const stockEl           = document.querySelector("[data-stock]");
    const sizeListEl        = document.querySelector(".size-list");
    const subImgContainer   = document.querySelector(".sub-img-container");
    const mainImg           = document.getElementById("main-image");
    const hiddenColorId     = document.querySelector("input[name='colorId']");
    const hiddenSizeId      = document.querySelector("input[name='sizeId']");
    const btnAddCart        = document.querySelector(".btn-add-cart");
    const btnBuyNow         = document.querySelector(".btn-buy-now");

    let currentColorId = document.querySelector(".color-dot.selected")?.dataset.colorId ?? null;
    let currentSizeId  = document.querySelector(".size-btn.selected")?.dataset.sizeId  ?? null;

    document.querySelectorAll(".color-dot").forEach(btn => {
        btn.addEventListener("click", () => {
            const newColorId = btn.dataset.colorId;
            if (newColorId === currentColorId) return;

            const prevColorId = currentColorId;
            const prevSizeId  = currentSizeId;

            currentColorId = newColorId;
            currentSizeId  = null;

            document.querySelectorAll(".color-dot")
                .forEach(b => b.classList.remove("selected"));
            btn.classList.add("selected");

            hiddenColorId.value = newColorId;
            hiddenSizeId.value  = "";
            setActionButtons(false);

            fetch(`${contextPath}/product?id=${productId}&colorId=${newColorId}`, {
                headers: { "X-Requested-With": "XMLHttpRequest" }
            })
                .then(res => {
                    if (!res.ok) throw new Error();
                    return res.json();
                })
                .then(data => {
                    updateGallery(data.images);
                    updateSizeList(data.sizes);
                    updateStock(data.stock);
                })
                .catch(() => {
                    currentColorId = prevColorId;
                    currentSizeId  = prevSizeId;

                    document.querySelectorAll(".color-dot")
                        .forEach(b => b.classList.toggle("selected", b.dataset.colorId === prevColorId));

                    hiddenColorId.value = prevColorId ?? "";
                    hiddenSizeId.value  = prevSizeId  ?? "";
                    if (prevSizeId) setActionButtons(true);

                    showToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                });
        });
    });

    function attachSizeListeners() {
        document.querySelectorAll(".size-btn").forEach(btn => {
            btn.addEventListener("click", () => {
                const newSizeId = btn.dataset.sizeId;
                if (newSizeId === currentSizeId) return;

                const prevSizeId = currentSizeId;

                currentSizeId = newSizeId;

                document.querySelectorAll(".size-btn")
                    .forEach(b => b.classList.remove("selected"));
                btn.classList.add("selected");

                hiddenSizeId.value = newSizeId;
                setActionButtons(true);

                fetch(`${contextPath}/product?id=${productId}&colorId=${currentColorId}&sizeId=${newSizeId}`, {
                    headers: { "X-Requested-With": "XMLHttpRequest" }
                })
                    .then(res => {
                        if (!res.ok) throw new Error();
                        return res.json();
                    })
                    .then(data => {
                        updateStock(data.stock);

                        if (!data.available) {
                            currentSizeId = prevSizeId;

                            document.querySelectorAll(".size-btn")
                                .forEach(b => b.classList.toggle("selected", b.dataset.sizeId === prevSizeId));

                            hiddenSizeId.value = prevSizeId ?? "";
                            if (!prevSizeId) setActionButtons(false);

                            showToast("❌ Size này đã hết hàng!");
                        }
                    })
                    .catch(() => {
                        showToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                    });
            });
        });
    }

    attachSizeListeners();


    function setActionButtons(enabled) {
        btnAddCart.disabled = !enabled;
        btnBuyNow.disabled  = !enabled;
    }

    function updateStock(stock) {
        stockEl.textContent      = stock;
        stockEl.dataset.stock    = stock;
    }

    function updateGallery(images) {
        if (!images?.length) return;

        mainImg.src = images[0];

        subImgContainer.innerHTML = "";
        images.forEach(url => {
            const img = document.createElement("img");
            img.src     = url;
            img.onclick = () => changeImage(img);
            subImgContainer.appendChild(img);
        });
    }

    function updateSizeList(sizes) {
        if (!sizes) return;

        sizeListEl.innerHTML = "";
        sizes.forEach(size => {
            const btn       = document.createElement("button");
            btn.type        = "button";
            btn.className   = "size-btn";
            btn.dataset.sizeId = size.id;
            btn.textContent = size.name;
            sizeListEl.appendChild(btn);
        });

        attachSizeListeners();
    }


    window.changeImage = (img) => {
        mainImg.src = img.src;
    };

    window.showToast = (message) => {
        const toast = document.getElementById("toast-message");
        toast.querySelector("span").textContent = message;
        toast.classList.add("show");
        setTimeout(() => toast.classList.remove("show"), 3000);
    };

    const navOpenBtn  = document.querySelector(".nav-open-btn");
    const navCloseBtn = document.querySelector(".nav-close-btn");
    const navbar      = document.querySelector(".navbar");
    const overlay     = document.querySelector(".overlay");

    const toggleNav = () => {
        navbar?.classList.toggle("active");
        overlay?.classList.toggle("active");
    };

    navOpenBtn?.addEventListener("click", toggleNav);
    navCloseBtn?.addEventListener("click", toggleNav);
    overlay?.addEventListener("click", toggleNav);

    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get("msg");

    if (msg === "cart_added") {
        showToast("🛒 Đã thêm sản phẩm vào Giỏ hàng thành công!");
    } else if (msg === "wishlist_added") {
        showToast("❤️ Đã thêm sản phẩm vào Yêu thích thành công!");
    }

    if (msg) {
        urlParams.delete("msg");
        const newUrl = window.location.pathname + (urlParams.toString() ? "?" + urlParams.toString() : "");
        window.history.replaceState({}, document.title, newUrl);
    }

});