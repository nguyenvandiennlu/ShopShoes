<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>${product.productDTO.name} - BHD SPORT SHOES</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

      <!--
    - favicon
  -->
      <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

      <!--
    -  css link
  -->
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search-autocomplete.css" />
      <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chitietsanpham.css" />
      <!--
    - google font link
  -->
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
        rel="stylesheet" />
    </head>

    <body id="top">
      <jsp:include page="Header.jsp" />

      <main>
        <div class="container">

          <!-- BREADCRUMB -->
          <div class="breadcrumb-container">
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu">Trang Chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products">Sản Phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.productDTO.name}</li>
              </ol>
            </nav>
          </div>

          <!-- PRODUCT DETAIL -->
          <div class="product-detail-wrapper">

            <!-- IMAGE -->
            <div class="product-gallery-box">
              <div class="sub-img-container">
                <c:forEach var="img" items="${product.productImg}">
                  <img src="${img}" onclick="changeImage(this)" />
                </c:forEach>
              </div>

              <div class="main-img-container">
                <img id="main-image" src="${product.productImg[0]}" alt="${product.productDTO.name}" />
              </div>
            </div>

            <!-- INFO -->
            <div class="product-info-box" data-product-id="${product.productDTO.id}" data-context-path="${pageContext.request.contextPath}">
              <h1 class="product-title">${product.productDTO.name}</h1>

              <div class="product-meta">
                <p class="brand-info">
                  Thương hiệu:
                  <strong>${product.brand.name}</strong>
                </p>
                <p class="stock-info">
                  Kho:
                  <strong data-stock="${product.stock}">
                    ${product.stock}
                  </strong>
                </p>
              </div>

              <div class="price-row">
                <span class="current-price">
                  ${product.productDTO.finalPrice}
                </span>

                <c:if test="${not empty product.productDTO.discountValue}">
                  <del class="original-price">
                    ${product.productDTO.price}
                  </del>
                  <span class="discount-tag">
                    ${product.productDTO.discountValue}
                  </span>
                </c:if>
              </div>
              <!-- COLOR -->
              <div class="option-block">
                <label>Màu sắc:</label>
                <div class="filter-group-body">
                  <ul class="filter-list-color">
                    <c:forEach var="c" items="${product.productColorList}">
                      <c:url var="colorUrl" value="/product">
                        <c:param name="id" value="${product.productDTO.id}" />
                        <c:param name="colorId" value="${c.id}" />
                        <c:if test="${not empty param.sizeId}">
                          <c:param name="sizeId" value="${param.sizeId}" />
                        </c:if>
                      </c:url>
                      <c:set var="colorClass" value="color-dot" />
                      <c:if test="${product.currentColorId == c.id}">
                        <c:set var="colorClass" value="${colorClass} selected" />
                      </c:if>
                      <li>
                        <a href="${colorUrl}">
                          <span class="${colorClass}"
                            style="background-color: ${c.hexCode};" title="${c.name}">
                          </span>
                        </a>
                      </li>
                    </c:forEach>
                  </ul>
                </div>
              </div>
              <!-- SIZE -->
              <div class="option-block">
                <label>Kích thước:</label>
                <div class="size-list">
                  <c:forEach var="s" items="${product.productSizeList}">
                    <c:url var="sizeUrl" value="/product">
                      <c:param name="id" value="${product.productDTO.id}" />
                      <c:param name="colorId" value="${product.currentColorId}" />
                      <c:param name="sizeId" value="${s.id}" />
                    </c:url>
                    <a href="${sizeUrl}" class="size-btn ${product.currentSizeId == s.id ? 'selected' : ''}">
                      ${s.name}
                    </a>
                  </c:forEach>
                </div>
              </div>
              <!-- ACTION -->
              <form action="${pageContext.request.contextPath}/cart/add" method="post" class="action-area">

                <input type="hidden" name="productId" value="${product.productDTO.id}" />
                <input type="hidden" name="colorId" value="${product.currentColorId}" />

                <c:if test="${not empty product.currentSizeId}">
                  <input type="hidden" name="sizeId" value="${product.currentSizeId}" />
                </c:if>

                <!-- QUANTITY -->
                <div class="qty-row">
                  <label>Số lượng:</label>
                  <div class="qty-input-group">
                    <button type="button" onclick="this.nextElementSibling.stepDown()">-</button>
                    <input type="number" name="quantity" value="1" min="1" />
                    <button type="button" onclick="this.previousElementSibling.stepUp()">+</button>
                  </div>
                </div>
                <!-- BUTTONS -->
                <div class="action-buttons">
                  <button type="submit" class="btn-main btn-add-cart" <c:if
                    test="${empty product.currentSizeId}">disabled</c:if>>
                    <ion-icon name="cart-outline"></ion-icon> THÊM VÀO GIỎ HÀNG
                  </button>

                  <button type="submit" formaction="${pageContext.request.contextPath}/buy-now"
                    class="btn-main btn-buy-now" <c:if test="${empty product.currentSizeId}">disabled</c:if>>
                    MUA NGAY
                  </button>

                  <!-- WISHLIST -->
                  <c:choose>
                    <c:when test="${isInWishlist}">
                      <button class="btn-wishlist active" disabled>
                        <ion-icon name="heart"></ion-icon>
                      </button>
                    </c:when>
                    <c:otherwise>
                      <button type="submit" formaction="${pageContext.request.contextPath}/wishlist"
                        class="btn-wishlist">
                        <ion-icon name="heart-outline"></ion-icon>
                      </button>
                    </c:otherwise>
                  </c:choose>
                </div>
              </form>
            </div>
          </div>

          <!-- DESCRIPTION -->
          <section class="product-desc-full">
            <h2 class="section-title-desc">Mô tả sản phẩm</h2>
            <div class="desc-content">
              ${product.productDes}
            </div>
          </section>

          <!-- RELATED -->
          <section class="related-products section">
            <h2 class="h2 section-title" style="text-align: center; margin-bottom: 40px">
              Sản phẩm gợi ý
            </h2>
            <ul class="product-list" id="productList">
              <c:forEach items="${product.relatedProduct}" var="p">
                <li class="product-item">
                  <div class="product-card" tabindex="0">

                    <!-- IMAGE -->
                    <figure class="card-banner">
                      <img src="${p.mainImageUrl}" loading="lazy" alt="${p.name}" class="image-contain" />
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
                                <span class="discount-value">Giảm: ${p.discountValue}</span>
                              </div>
                            </c:if>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </li>
              </c:forEach>
            </ul>
          </section>

        </div>
        <div id="toast-message" class="toast-message">
          <i class="fas fa-check-circle"></i> <span></span>
        </div>
      </main>

      <jsp:include page="Footer.jsp" />

      <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
      <script src="${pageContext.request.contextPath}/assets/script/chitietsanpham.js"></script>
      <script>
        window.CONTEXT_PATH = window.CONTEXT_PATH || "${pageContext.request.contextPath}";
      </script>
      <script src="${pageContext.request.contextPath}/assets/script/search-autocomplete.js"></script>
      <script>
        // Hàm hiển thị toast
        function showToast(message) {
          const toast = document.getElementById("toast-message");
          toast.querySelector("span").textContent = message;
          toast.classList.add("show");
          setTimeout(() => toast.classList.remove("show"), 3000);
        }

        // Kiểm tra tham số msg để hiển thị thông báo
        document.addEventListener("DOMContentLoaded", () => {
          const urlParams = new URLSearchParams(window.location.search);
          const msg = urlParams.get("msg");

          if (msg === "cart_added") {
            showToast("🛒 Đã thêm sản phẩm vào Giỏ hàng thành công!");
            // Xóa tham số msg khỏi URL để tránh hiển thị lại khi refresh
            urlParams.delete("msg");
            const newUrl = window.location.pathname + (urlParams.toString() ? "?" + urlParams.toString() : "");
            window.history.replaceState({}, document.title, newUrl);
          } else if (msg === "wishlist_added") {
            showToast("❤️ Đã thêm sản phẩm vào Yêu thích thành công!");
            urlParams.delete("msg");
            const newUrl = window.location.pathname + (urlParams.toString() ? "?" + urlParams.toString() : "");
            window.history.replaceState({}, document.title, newUrl);
          }
        });
      </script>

      <!--
    - ionicon link
  -->
      <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
      <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

      <script src="${pageContext.request.contextPath}/assets/script/product-popup.js"></script>
      <script>
        window.CONTEXT_PATH = window.CONTEXT_PATH || "${pageContext.request.contextPath}";
      </script>
      <script src="${pageContext.request.contextPath}/assets/script/search-autocomplete.js"></script>
    </body>

    </html>