<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Sản phẩm - BHD SPORT SHOES</title>
                <link rel="stylesheet" href="https://unpkg.com/swiper@8/swiper-bundle.min.css" />

                <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search-autocomplete.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dangnhapvadangki.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/products.css" />

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
                    integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
                    crossorigin="anonymous" referrerpolicy="no-referrer" />

                <link rel="preconnect" href="https://fonts.googleapis.com" />
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                <link
                    href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
                    rel="stylesheet" />
            </head>

            <body>
                <jsp:include page="Header.jsp" />
                <div class="banner-slide">
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <div class="swiper-slide">
                                <a href="#" class="banner-link">
                                    <img src="https://cdn.shopify.com/s/files/1/0456/5070/6581/files/HP_BACKFRI_KV_DESK_VN.jpg?v=1763548181&width=1440"
                                        alt="Banner Slide 1" class="banner-img" width="1200" height="300" />
                                </a>
                            </div>

                            <div class="swiper-slide">
                                <a href="#" class="banner-link">
                                    <img src="https://cdn.shopify.com/s/files/1/0456/5070/6581/files/LP_NIKE_FOOTBALL_KV.jpg?v=1746584732"
                                        alt="Banner Slide 2" class="banner-img" width="1200" height="300" />
                                </a>
                            </div>

                            <div class="swiper-slide">
                                <a href="#" class="banner-link">
                                    <img src="https://cdn.shopify.com/s/files/1/0456/5070/6581/files/LP_NIKE_RUNNING_KV.jpg?v=1746584732"
                                        alt="Banner Slide 3" class="banner-img" width="1200" height="300" />
                                </a>
                            </div>
                            <div class="swiper-slide">
                                <a href="#" class="banner-link">
                                    <img src="https://cdn.shopify.com/s/files/1/0456/5070/6581/files/LP_NIKE_TRAIN_KV.jpg?v=1746584732"
                                        alt="Banner Slide 4" class="banner-img" width="1200" height="300" />
                                </a>
                            </div>
                        </div>

                        <div class="swiper-button-prev"></div>
                        <div class="swiper-button-next"></div>

                        <div class="swiper-pagination"></div>
                    </div>
                </div>
                <div class="shop-layout">
                    <aside class="filter-sidebar">
                        <form id="filter-form" action="${pageContext.request.contextPath}/products" method="get">
                            <div class="sidebar-header">
                                <h2>Bộ Lọc</h2>
                                <button type="button" class="clear-all" id="clear-all-btn">XÓA TẤT CẢ</button>
                            </div>

                            <div class="filter-group">
                                <div class="filter-search-wrapper">
                                    <input type="search" name="q" placeholder="Tìm kiếm theo tên..."
                                        class="filter-search" id="filter-search-input" value="${searchQuery}" />
                                </div>
                                <div class="filter-group-header">
                                    <h3>Hãng</h3>
                                    <button type="button" class="toggle-btn">-</button>
                                </div>
                                <div class="filter-group-body">
                                    <ul class="filter-list scrollable">
                                        <c:forEach var="brand" items="${brands}">
                                            <li>
                                                <input type="checkbox" id="brand-${brand.id}" name="brand"
                                                    value="${brand.id}" <c:if
                                                    test="${selectedBrands != null && selectedBrands.contains(brand.id)}">checked
                                                </c:if> />
                                                <label for="brand-${brand.id}" class="brand-label">
                                                    <img src="${brand.logoURL}" alt="${brand.name}" class="brand-icon"
                                                        onerror="this.style.display='none'" />
                                                    <span>${brand.name}</span>
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>


                            <div class="filter-group">
                                <div class="filter-group-header">
                                    <h3>Size</h3>
                                    <button type="button" class="toggle-btn">-</button>
                                </div>
                                <div class="filter-group-body">
                                    <ul class="filter-list-grid" id="size-filter-list">
                                        <c:forEach var="size" items="${sizes}">
                                            <li>
                                                <input type="checkbox" id="size-${size.id}" name="size"
                                                    value="${size.id}" <c:if
                                                    test="${selectedSizes != null && selectedSizes.contains(size.id)}">checked
                                                </c:if> />
                                                <label for="size-${size.id}">${size.name}</label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>

                            <div class="filter-group">
                                <div class="filter-group-header">
                                    <h3>Khoảng giá</h3>
                                    <button type="button" class="toggle-btn">-</button>
                                </div>
                                <div class="filter-group-body">
                                    <div class="price-filter">
                                        <div class="slider-container">
                                            <div class="slider-track"></div>
                                            <input type="range" min="0" max="10000000"
                                                value="${minPrice != null ? minPrice : 0}" id="slider-1"
                                                oninput="slideOne()" />
                                            <input type="range" min="0" max="10000000"
                                                value="${maxPrice != null ? maxPrice : 10000000}" id="slider-2"
                                                oninput="slideTwo()" />
                                        </div>
                                        <div class="price-input">
                                            <div class="field">
                                                <span>Từ</span>
                                                <input type="text" id="range1" value="0đ" readonly />
                                            </div>
                                            <div class="separator">-</div>
                                            <div class="field">
                                                <span>Đến</span>
                                                <input type="text" id="range2" value="10.000.000đ" readonly />
                                            </div>
                                        </div>
                                        <!-- Hidden inputs để submit giá -->
                                        <input type="hidden" name="minPrice" id="minPriceInput" value="${minPrice}" />
                                        <input type="hidden" name="maxPrice" id="maxPriceInput" value="${maxPrice}" />
                                    </div>
                                </div>
                            </div>

                            <div class="filter-group">
                                <div class="filter-group-header">
                                    <h3>Màu sắc</h3>
                                    <button type="button" class="toggle-btn">-</button>
                                </div>
                                <div class="filter-group-body">
                                    <ul class="filter-list-color">
                                        <c:forEach var="color" items="${colors}">
                                            <li style="--color-swatch: ${color.hexCode};">
                                                <input type="checkbox" id="color-${color.id}" name="color"
                                                    value="${color.id}" <c:if
                                                    test="${selectedColors != null && selectedColors.contains(color.id)}">checked
                                                </c:if> />
                                                <label for="color-${color.id}">${color.name}</label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </form>
                    </aside>

                    <main class="product-content">
                        <c:if test="${not empty searchQuery}">
                            <div class="search-result-info">
                                <p>Kết quả tìm kiếm cho: <strong>"${searchQuery}"</strong></p>
                                <a href="${pageContext.request.contextPath}/products" class="clear-search">Xóa tìm
                                    kiếm</a>
                            </div>
                        </c:if>
                        <div class="sort-toolbar">
                            <label for="sort-select">Sắp xếp theo:</label>
                            <select id="sort-select" name="sort" class="sort-dropdown">
                                <option value="default" ${sortBy=='default' || sortBy==null ? 'selected' : '' }>Mặc định
                                </option>
                                <option value="newest" ${sortBy=='newest' ? 'selected' : '' }>Sản phẩm mới nhất</option>
                                <option value="bestseller" ${sortBy=='bestseller' ? 'selected' : '' }>Sản phẩm bán chạy
                                </option>
                                <option value="price-asc" ${sortBy=='price-asc' ? 'selected' : '' }>Giá từ thấp đến cao
                                </option>
                                <option value="price-desc" ${sortBy=='price-desc' ? 'selected' : '' }>Giá từ cao đến
                                    thấp
                                </option>
                            </select>
                        </div>
                        <div id="productsContainer">
                            <jsp:include page="/ProductsFragment.jsp" />
                        </div>

                    </main>
                </div>

                <div id="toast-message" class="toast-message">
                    <i class="fas fa-check-circle"></i> <span></span>
                </div>

                <jsp:include page="Footer.jsp" />

                <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
                <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
                <script>
                    const CONTEXT_PATH = "${pageContext.request.contextPath}";
                </script>
                <script src="${pageContext.request.contextPath}/assets/script/ajax.js"></script>
                <script src="https://unpkg.com/swiper@8/swiper-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>

                <script src="${pageContext.request.contextPath}/assets/script/product-popup.js"></script>
                <script src="${pageContext.request.contextPath}/assets/script/SliderBanner.js"></script>
                <script src="${pageContext.request.contextPath}/assets/script/filter.js"></script>
                <script src="${pageContext.request.contextPath}/assets/script/search-autocomplete.js"></script>

            </body>

            </html>