document.addEventListener("DOMContentLoaded", () => {
    console.log("[JS] chitietsanpham.js DOMContentLoaded fired");

    const infoBox       = document.querySelector(".product-info-box");
    console.log("[JS] infoBox:", infoBox);

    if (!infoBox) {
        console.error("[JS] FATAL: .product-info-box not found! JS will not work.");
        return;
    }

    const productId     = infoBox.dataset.productId;
    const contextPath   = infoBox.dataset.contextPath;
    console.log("[JS] productId:", productId, "| contextPath:", contextPath);

    const stockEl           = document.querySelector("[data-stock]");
    const sizeListEl        = document.querySelector(".size-list");
    const subImgContainer   = document.querySelector(".sub-img-container");
    const mainImg           = document.getElementById("main-image");
    const hiddenColorId     = document.querySelector("input[name='colorId']");
    const hiddenSizeId      = document.querySelector("input[name='sizeId']");
    const btnAddCart        = document.querySelector(".btn-add-cart");
    const btnBuyNow         = document.querySelector(".btn-buy-now");
    console.log("[JS] btnAddCart:", btnAddCart);

    let currentColorId = document.querySelector(".color-dot.selected")?.dataset.colorId ?? null;
    let currentSizeId  = document.querySelector(".size-btn.selected")?.dataset.sizeId  ?? null;

    if (btnAddCart) {
        btnAddCart.addEventListener("click", (e) => {
            console.log("[JS] btnAddCart clicked! Calling preventDefault...");
            e.preventDefault();

            const colorId  = hiddenColorId.value;
            const sizeId   = hiddenSizeId.value;
            const quantity = document.querySelector("input[name='quantity']").value;

            if (!sizeId) {
                showToast("⚠️ Vui lòng chọn size!");
                return;
            }

            const params = new URLSearchParams();
            params.append("productId", productId);
            params.append("colorId",   colorId);
            params.append("sizeId",    sizeId);
            params.append("quantity",  quantity);

            fetch(`${contextPath}/cart/add`, {
                method:  "POST",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: params
            })
                .then(res => {
                    if (!res.ok) throw new Error();
                    return res.json();
                })
                .then(data => {
                    if (data.success) {
                        showToast("🛒 Đã thêm sản phẩm vào Giỏ hàng thành công!");

                        // Cập nhật badge giỏ hàng
                        const addedQty = parseInt(quantity) || 1;
                        const existingBadges = document.querySelectorAll(".cart-badge");
                        const currentCount = parseInt(existingBadges[0]?.textContent) || 0;

                        console.log("[Cart] data.cartCount:", data.cartCount, "| currentCount:", currentCount, "| addedQty:", addedQty);

                        // Dùng server count nếu lớn hơn current, nếu không thì cộng local
                        const newCount = (data.cartCount && data.cartCount > currentCount)
                            ? data.cartCount
                            : currentCount + addedQty;

                        console.log("[Cart] newCount →", newCount);

                        if (existingBadges.length > 0) {
                            existingBadges.forEach(b => { b.textContent = newCount; });
                        } else {
                            document.querySelectorAll(".cart-btn").forEach(cartBtn => {
                                const b = document.createElement("span");
                                b.className = "cart-badge";
                                b.textContent = newCount;
                                cartBtn.appendChild(b);
                            });
                        }
                    }
                })


                .catch(() => {
                    showToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                });
        });
    }

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
        if(btnAddCart) btnAddCart.disabled = !enabled;
        if(btnBuyNow) btnBuyNow.disabled  = !enabled;
    }

    function updateStock(stock) {
        if(stockEl) {
            stockEl.textContent      = stock;
            stockEl.dataset.stock    = stock;
        }
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
        if(toast) {
            toast.querySelector("span").textContent = message;
            toast.classList.add("show");
            setTimeout(() => toast.classList.remove("show"), 3000);
        }
    };

    // WISHLIST TOGGLE – thêm/hủy yêu thích không reload trang
    const btnWishlistToggle = document.getElementById("btn-wishlist-toggle");
    if (btnWishlistToggle) {
        btnWishlistToggle.addEventListener("click", () => {
            const action = btnWishlistToggle.dataset.action; // "add" hoặc "remove"

            const params = new URLSearchParams();
            params.append("productId", productId);
            params.append("action",    action);

            // Disable tạm để tránh double click
            btnWishlistToggle.disabled = true;

            fetch(`${contextPath}/wishlist`, {
                method:  "POST",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: params
            })
                .then(res => {
                    if (res.status === 401) {
                        window.location.href = `${contextPath}/login`;
                        return null;
                    }
                    return res.json().catch(() => ({}));
                })
                .then(data => {
                    if (!data || !data.success) {
                        showToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                        btnWishlistToggle.disabled = false;
                        return;
                    }

                    if (data.action === "added") {
                        // Vừa thêm vào → đổi sang trạng thái "đã yêu thích"
                        btnWishlistToggle.dataset.action = "remove";
                        btnWishlistToggle.classList.add("active");
                        btnWishlistToggle.title = "Bỏ yêu thích";
                        btnWishlistToggle.querySelector("ion-icon").setAttribute("name", "heart");
                        showToast("❤️ Đã thêm vào danh sách yêu thích!");
                    } else {
                        // Vừa xóa → đổi sang trạng thái "chưa yêu thích"
                        btnWishlistToggle.dataset.action = "add";
                        btnWishlistToggle.classList.remove("active");
                        btnWishlistToggle.title = "Thêm vào yêu thích";
                        btnWishlistToggle.querySelector("ion-icon").setAttribute("name", "heart-outline");
                        showToast("💔 Đã bỏ khỏi danh sách yêu thích!");
                    }
                    btnWishlistToggle.disabled = false;
                })
                .catch(() => {
                    showToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                    btnWishlistToggle.disabled = false;
                });
        });
    }



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

    const btnWriteReview    = document.querySelector(".btn-write-review");
    const btnCancelReview   = document.getElementById("btn-cancel-review");
    const reviewFormWrapper = document.getElementById("review-form-wrapper");
    const commentForm       = document.getElementById("commentForm");
    const stars             = document.querySelectorAll(".rating-input-stars i");
    const ratingInput       = document.getElementById("selected-rating");
    const ratingText        = document.getElementById("rating-text");

    const ratingLabels = {
        1: "Tệ",
        2: "Không hài lòng",
        3: "Bình thường",
        4: "Hài lòng",
        5: "Tuyệt vời quá!"
    };

    if (btnWriteReview) {
        btnWriteReview.addEventListener("click", () => {
            reviewFormWrapper.style.display = "block";
            reviewFormWrapper.scrollIntoView({ behavior: "smooth", block: "center" });
        });
    }

    if (btnCancelReview) {
        btnCancelReview.addEventListener("click", () => {
            reviewFormWrapper.style.display = "none";
            commentForm.reset();
            resetStars();
        });
    }

    stars.forEach(star => {
        star.addEventListener("mouseover", function () {
            const val = parseInt(this.dataset.value);
            highlightStars(val, "hovered");
        });

        star.addEventListener("mouseout", () => {
            stars.forEach(s => s.classList.remove("hovered"));
        });

        star.addEventListener("click", function () {
            const val = parseInt(this.dataset.value);
            ratingInput.value = val;
            ratingText.innerText = ratingLabels[val];
            ratingText.style.color = "#ffb800";
            ratingText.style.fontWeight = "bold";

            stars.forEach((s, idx) => {
                s.className = idx < val ? "fas fa-star" : "far fa-star";
            });
        });
    });

    function highlightStars(val, className) {
        stars.forEach((star, idx) => {
            if (idx < val) star.classList.add(className);
            else star.classList.remove(className);
        });
    }

    function resetStars() {
        if(ratingInput) ratingInput.value = "";
        if(ratingText) {
            ratingText.innerText = "Vui lòng chọn số sao";
            ratingText.style.color = "#888";
            ratingText.style.fontWeight = "normal";
        }
        stars.forEach(star => star.className = "far fa-star");
    }

    if (commentForm) {
        commentForm.addEventListener("submit", (e) => {
            e.preventDefault();

            const rating  = ratingInput.value;
            const content = commentForm.querySelector("textarea[name='content']").value.trim();

            if (!rating) {
                showToast("⚠️ Vui lòng chọn số sao đánh giá!");
                ratingText.style.color = "#d90429";
                ratingText.innerText = "Bắt buộc phải chọn số sao!";
                return;
            }

            if (!content) {
                showToast("⚠️ Vui lòng nhập nội dung nhận xét!");
                return;
            }

            const params = new URLSearchParams();
            params.append("productId", productId);
            params.append("rating",    rating);
            params.append("content",   content);

            fetch(`${contextPath}/add-review`, {
                method: "POST",
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: params
            })
                .then(async res => {
                    const data = await res.json();
                    if (!res.ok) {
                        throw new Error(data.message || data.error || "Có lỗi xảy ra!");
                    }
                    return data;
                })
                .then(data => {
                    if (data.success) {
                        showToast("🎉 " + data.message);

                        const topScoreEl    = document.querySelector(".product-rating-overview .rating-score");
                        const topCountEl    = document.querySelector(".product-rating-overview .review-count");
                        const summaryScoreEl = document.querySelector(".average-score-box .score");
                        const summaryCountEl = document.querySelector(".average-score-box p");

                        if (topScoreEl && topCountEl) {
                            let currentTotal = parseInt(topCountEl.innerText.replace(/[^0-9]/g, '')) || 0;
                            let currentScore = parseFloat(summaryScoreEl ? summaryScoreEl.innerText.split('/')[0] : topScoreEl.innerText) || 0.0;

                            let newTotal = currentTotal + 1;
                            let newScore = ((currentScore * currentTotal) + parseInt(rating)) / newTotal;
                            newScore = Math.round(newScore * 10) / 10; // Làm tròn 1 chữ số thập phân

                            topScoreEl.innerText = newScore.toFixed(1);
                            topCountEl.innerText = `(${newTotal} đánh giá)`;
                            if (summaryScoreEl) summaryScoreEl.innerHTML = `${newScore.toFixed(1)}<span>/5</span>`;
                            if (summaryCountEl) summaryCountEl.innerText = `${newTotal} đánh giá`;

                            const barItems = document.querySelectorAll(".rating-bars .bar-item");
                            let starCounts = [0, 0, 0, 0, 0, 0]; // Mảng chứa số lượng review của từng sao từ 1->5

                            barItems.forEach(bar => {
                                const starLabel = parseInt(bar.querySelector(".star-label").innerText);
                                const percentText = bar.querySelector(".percent").innerText;
                                let oldPercent = parseInt(percentText.replace('%', '')) || 0;
                                let oldCount = Math.round((oldPercent * currentTotal) / 100);

                                if (starLabel === parseInt(rating)) {
                                    oldCount += 1;
                                }
                                starCounts[starLabel] = oldCount;
                            });

                            barItems.forEach(bar => {
                                const starLabel = parseInt(bar.querySelector(".star-label").innerText);
                                let newPercent = newTotal > 0 ? Math.round((starCounts[starLabel] / newTotal) * 100) : 0;

                                bar.querySelector(".progress-fill").style.width = `${newPercent}%`;
                                bar.querySelector(".percent").innerText = `${newPercent}%`;
                            });
                        }

                        const reviewsContainer = document.querySelector(".reviews-list");

                        if (reviewsContainer) {
                            const noReviewEl = reviewsContainer.querySelector(".no-reviews");
                            if (noReviewEl) noReviewEl.remove();

                            let starsHtml = "";
                            for (let i = 1; i <= 5; i++) {
                                starsHtml += (i <= rating)
                                    ? '<i class="fas fa-star" style="color: #ffb800; margin-right: 2px;"></i>'
                                    : '<i class="far fa-star" style="color: #ccc; margin-right: 2px;"></i>';
                            }

                            const now = new Date();
                            const formattedDate = `${String(now.getDate()).padStart(2, '0')}/${String(now.getMonth() + 1).padStart(2, '0')}/${now.getFullYear()}`;

                            let verifiedBadgeHtml = "";
                            if (data.verifiedPurchase) {
                                verifiedBadgeHtml = '<span class="verified"><i class="fas fa-check-circle"></i> Đã mua hàng</span>';
                            }

                            const newReviewHtml = `
                            <div class="review-item" style="animation: fadeIn 0.6s ease; background-color: #fffdb51a; padding: 15px; border-radius: 8px; margin-bottom: 15px; border: 1px dashed #ffb800;">
                                <div class="review-header">
                                    <div class="user-info">
                                        <div class="avatar"><i class="fas fa-user" style="font-size: 0.8em; color: #fff;"></i></div>
                                        <div class="user-meta">
                                            <strong class="name" style="color: #2b2d42;">Bạn (Vừa đánh giá)</strong>
                                            <span class="verified"><i class="fas fa-check-circle"></i> Đã mua hàng</span>
                                        </div>
                                    </div>
                                    <span class="date">${formattedDate}</span>
                                </div>
                                <div class="review-stars" style="margin-bottom: 8px;">
                                    ${starsHtml}
                                </div>
                                <div class="review-content" style="white-space: pre-wrap;">${content}</div>
                            </div>
                        `;

                            reviewsContainer.insertAdjacentHTML("afterbegin", newReviewHtml);
                            reviewsContainer.scrollIntoView({ behavior: "smooth", block: "nearest" });
                        }

                        reviewFormWrapper.style.display = "none";
                        commentForm.reset();
                        resetStars();
                    }
                })
                .catch(err => {
                    showToast("❌ " + err.message);
                });
        });
    }
});