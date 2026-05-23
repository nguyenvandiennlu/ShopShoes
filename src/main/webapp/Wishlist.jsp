<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Wishlist - BHD SPORT SHOES</title>
    <jsp:include page="head-resources.jsp" />
</head>

<body id="top">

<jsp:include page="Header.jsp" />

<div class="container">
    <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu">Trang Chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Danh sách yêu thích của bạn</li>
            </ol>
        </nav>
    </div>
</div>

<main class="cart-page-content wishlist-page-content">
    <div class="container">
        <h1 class="cart-header">Danh sách yêu thích</h1>

        <div class="cart-items-list wishlist-items-list">

            <c:if test="${empty wishlistProducts}">
                <p style="text-align:center; padding:40px">
                    Danh sách yêu thích của bạn đang trống 💔
                </p>
            </c:if>
            <c:forEach items="${wishlistProducts}" var="p">
                <div class="product-item">
                    <div class="product-details">
                        <img src="${p.mainImageUrl}"
                             alt="${p.name}"
                             class="product-image" />
                        <div class="product-info">
                            <h2 class="product-name">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                                   class="product-link">
                                        ${p.name}
                                </a>
                            </h2>
                            <div class="product-price-line-3c">
                                <div class="discounted-price-group">
                            <span class="discounted-price">
                                    ${p.finalPrice}
                            </span>
                                    <c:if test="${p.price ne p.finalPrice}">
                                <span class="original-price">
                                        ${p.price}
                                </span>
                                    </c:if>
                                </div>
                                <c:if test="${not empty p.discountValue}">
                                    <p class="discount-value">
                                        Giảm: ${p.discountValue}
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="product-actions wishlist-actions">
                        <a href="${pageContext.request.contextPath}/product?id=${p.id}"
                           class="action-btn view-product-btn">
                            Xem sản phẩm
                        </a>
                        <form action="${pageContext.request.contextPath}/wishlist"
                              method="post">
                            <input type="hidden" name="action" value="remove" />
                            <input type="hidden" name="productId" value="${p.id}" />
                            <button type="submit" class="action-btn delete-btn">
                                Xoá
                            </button>
                        </form>
                    </div>
                </div>
                <hr class="separator" />
            </c:forEach>
        </div>
    </div>
</main>
<jsp:include page="Footer.jsp" />
<jsp:include page="body-scripts.jsp" />
<script src="${pageContext.request.contextPath}/assets/script/product-popup.js"></script>
</body>
</html>