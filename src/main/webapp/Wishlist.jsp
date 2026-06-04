<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Yêu thích - BHD SPORT SHOES</title>
    <jsp:include page="head-resources.jsp" />
</head>

<body id="top">

<jsp:include page="Header.jsp" />

<!-- TOAST NOTIFICATION -->
<div id="wishlist-toast" style="
    display:none; position:fixed; bottom:30px; left:50%; transform:translateX(-50%);
    background:#222; color:#fff; padding:14px 24px; border-radius:10px;
    font-size:15px; z-index:9999; box-shadow:0 4px 20px rgba(0,0,0,0.3);
    opacity:1; white-space:nowrap; transition:opacity 0.3s ease;
"></div>

<div class="container">
    <jsp:include page="Breadcrumb.jsp" />
</div>

<main class="cart-page-content wishlist-page-content">
    <div class="container">
        <h1 class="cart-header">Danh sách yêu thích</h1>

        <div class="cart-items-list wishlist-items-list" id="wishlist-items-list">

            <c:if test="${empty wishlistProducts}">
                <p id="empty-wishlist-msg" style="text-align:center; padding:40px">
                    Danh sách yêu thích của bạn đang trống 💔
                </p>
            </c:if>

            <c:forEach items="${wishlistProducts}" var="p">
                <div class="product-item" id="wishlist-item-${p.id}">
                    <div class="product-details">
                        <img src="${p.mainImageUrl}"
                             alt="${p.name}"
                             class="product-image" />
                        <div class="product-info">
                            <h2 class="product-name">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                                   class="product-link">${p.name}</a>
                            </h2>
                            <div class="product-price-line-3c">
                                <div class="discounted-price-group">
                                    <span class="discounted-price">${p.finalPrice}</span>
                                    <c:if test="${p.price ne p.finalPrice}">
                                        <span class="original-price">${p.price}</span>
                                    </c:if>
                                </div>
                                <c:if test="${not empty p.discountValue}">
                                    <p class="discount-value">Giảm: ${p.discountValue}</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="product-actions wishlist-actions">
                        <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                           class="action-btn view-product-btn">
                            Xem sản phẩm
                        </a>
                        <button type="button" class="action-btn delete-btn"
                                onclick="removeWishlistItem(this, ${p.id})">
                            Xoá
                        </button>
                    </div>
                </div>
                <hr class="separator" id="wishlist-sep-${p.id}" />
            </c:forEach>

        </div>
    </div>
</main>

<jsp:include page="Footer.jsp" />
<jsp:include page="body-scripts.jsp" />

<script>
    // Lấy context path từ thẻ meta trong head-resources hoặc từ URL hiện tại
    const WISHLIST_URL = window.location.pathname; // luôn là /ShopShoes/wishlist

    function showWishlistToast(msg) {
        const toast = document.getElementById("wishlist-toast");
        toast.textContent = msg;
        toast.style.display = "block";
        toast.style.opacity = "1";
        setTimeout(() => {
            toast.style.opacity = "0";
            setTimeout(() => { toast.style.display = "none"; }, 300);
        }, 2500);
    }

    function updateWishlistBadgeHeader(count) {
        const badges = document.querySelectorAll(".wishlist-badge");
        const wishlistBtns = document.querySelectorAll(".wishlist-btn");
        if (count > 0) {
            if (badges.length > 0) {
                badges.forEach(b => { b.textContent = count; });
            } else {
                wishlistBtns.forEach(btn => {
                    const b = document.createElement("span");
                    b.className = "cart-badge wishlist-badge";
                    b.textContent = count;
                    btn.appendChild(b);
                });
            }
        } else {
            badges.forEach(b => b.remove());
        }
    }

    function removeWishlistItem(btn, productId) {
        btn.disabled = true;
        btn.textContent = "Đang xoá...";

        const params = new URLSearchParams();
        params.append("productId", productId);
        params.append("action", "remove");

        fetch(WISHLIST_URL, {
            method: "POST",
            headers: {
                "X-Requested-With": "XMLHttpRequest",
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: params
        })
        .then(res => {
            console.log("[Wishlist] response status:", res.status);
            if (res.status === 401) {
                window.location.href = WISHLIST_URL.replace('/wishlist', '') + "/login";
                return null;
            }
            return res.json();
        })
        .then(data => {
            if (data && data.success) {
                const item = document.getElementById("wishlist-item-" + productId);
                const sep  = document.getElementById("wishlist-sep-"  + productId);
                if (item) item.remove();
                if (sep)  sep.remove();

                showWishlistToast("💔 Đã xoá khỏi danh sách yêu thích!");

                // Cập nhật badge trên header
                updateWishlistBadgeHeader(data.wishlistCount || 0);

                const remaining = document.querySelectorAll(".product-item");
                if (remaining.length === 0) {
                    document.getElementById("wishlist-items-list").innerHTML =
                        '<p style="text-align:center;padding:40px">Danh sách yêu thích của bạn đang trống 💔</p>';
                }
            } else {
                showWishlistToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
                btn.disabled = false;
                btn.textContent = "Xoá";
            }
        })
        .catch(() => {
            showWishlistToast("❌ Có lỗi xảy ra, vui lòng thử lại!");
            btn.disabled = false;
            btn.textContent = "Xoá";
        });
    }
</script>

</body>
</html>