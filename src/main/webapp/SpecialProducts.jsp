<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Ưu đãi đặc biệt - BHD SPORT SHOES</title>

            <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search-autocomplete.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css" />

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
                integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
                crossorigin="anonymous" referrerpolicy="no-referrer" />

            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
            <link
                href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
                rel="stylesheet" />

            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/collection.css" />
        </head>

        <body>
            <jsp:include page="Header.jsp" />

            <div class="container">
                <jsp:include page="Breadcrumb.jsp" />
            </div>

            <!-- Special Products Banner -->
            <div class="collection-header">
                <h1>Ưu đãi đặc biệt</h1>
                <p class="product-count">${totalProducts} sản phẩm</p>
            </div>

            <div class="collection-content">
                <c:choose>
                    <c:when test="${empty productList}">
                        <div class="empty-collection">
                            <i class="fas fa-box-open"></i>
                            <h2>Chưa có sản phẩm ưu đãi</h2>
                            <p>Hiện tại chưa có sản phẩm nào đang có ưu đãi đặc biệt.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="back-link">Quay lại trang chủ</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Product Grid -->
                        <div class="collection-grid">
                            <c:forEach items="${productList}" var="p">
                                <div class="product-item">
                                    <div class="product-card" tabindex="0">
                                        <!-- IMAGE -->
                                        <figure class="card-banner">
                                            <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                                <img src="${p.mainImageUrl}" loading="lazy" alt="${p.name}"
                                                    class="image-contain" />
                                            </a>
                                            <!-- BADGE NEW -->
                                            <c:if test="${p.isNew}">
                                                <div class="card-badge">New</div>
                                            </c:if>
                                        </figure>

                                        <!-- CONTENT -->
                                        <div class="card-content">
                                            <h3 class="h3 card-title">
                                                <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                                    ${p.name}
                                                </a>
                                            </h3>

                                            <div class="product-card-price">
                                                <c:choose>
                                                    <c:when test="${p.price eq p.finalPrice}">
                                                        <span class="discounted-price">${p.price}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="price-row">
                                                            <span class="discounted-price">${p.finalPrice}</span>
                                                            <span class="original-price">${p.price}</span>
                                                        </div>
                                                        <c:if test="${not empty p.discountValue}">
                                                            <div class="discount-badge-wrapper">
                                                                <span class="discount-value">Giảm:
                                                                    ${p.discountValue}</span>
                                                            </div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="collection-pagination">
                                <c:if test="${currentPage > 1}">
                                    <a
                                        href="${pageContext.request.contextPath}/special-products?page=${currentPage - 1}">
                                        ← Trước
                                    </a>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="active">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a
                                                href="${pageContext.request.contextPath}/special-products?page=${i}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a
                                        href="${pageContext.request.contextPath}/special-products?page=${currentPage + 1}">
                                        Sau →
                                    </a>
                                </c:if>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <jsp:include page="Footer.jsp" />

            <!--
        - ionicon link
        -->
            <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
            <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

            <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
            <script src="${pageContext.request.contextPath}/assets/script/product-popup.js"></script>
            <script>
                const CONTEXT_PATH = "${pageContext.request.contextPath}";
            </script>
            <script src="${pageContext.request.contextPath}/assets/script/search-autocomplete.js"></script>

        </body>

        </html>
