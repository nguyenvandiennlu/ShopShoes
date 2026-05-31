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

              <div class="product-rating-overview">
                <div class="stars">
                  <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                      <c:when test="${i <= averageRating}">
                        <i class="fas fa-star" style="color: #ffb800;"></i>
                      </c:when>
                      <c:when test="${i - 0.5 <= averageRating}">
                        <i class="fas fa-star-half-alt" style="color: #ffb800;"></i>
                      </c:when>
                      <c:otherwise>
                        <i class="far fa-star" style="color: #ccc;"></i>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
                </div>
                <span class="rating-score">${totalReviews > 0 ? averageRating : "0.0"}</span>
                <a href="#review-section" class="review-count">(${totalReviews} đánh giá)</a>
              </div>

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
                      <li>
                        <button type="button"
                                class="color-dot ${product.currentColorId == c.id ? 'selected' : ''}"
                                style="background:${c.hexCode}"
                                title="${c.name}"
                                data-color-id="${c.id}">
                        </button>
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
                    <button type="button"
                            class="size-btn ${product.currentSizeId == s.id ? 'selected' : ''}"
                            data-size-id="${s.id}">
                        ${s.name}
                    </button>
                  </c:forEach>
                </div>
              </div>
              <!-- ACTION -->
              <form action="${pageContext.request.contextPath}/cart/add" method="post" class="action-area">

                <input type="hidden" name="productId" value="${product.productDTO.id}" />
                <input type="hidden" name="colorId" value="${product.currentColorId}" />

<%--                <c:if test="${not empty product.currentSizeId}">--%>
                  <input type="hidden" name="sizeId" value="${product.currentSizeId}" />
<%--                </c:if>--%>

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

          <section id="review-section" class="product-reviews-section">
            <h2 class="section-title-desc">Đánh giá & Nhận xét</h2>

            <div class="reviews-container">
              <div class="reviews-summary">
                <div class="average-score-box">
                  <div class="score">${totalReviews > 0 ? averageRating : "0.0"}<span>/5</span></div>
                  <div class="stars">
                    <c:forEach begin="1" end="5" var="i">
                      <c:choose>
                        <c:when test="${i <= averageRating}">
                          <i class="fas fa-star" style="color: #ffb800;"></i>
                        </c:when>
                        <c:when test="${i - 0.5 <= averageRating}">
                          <i class="fas fa-star-half-alt" style="color: #ffb800;"></i>
                        </c:when>
                        <c:otherwise>
                          <i class="far fa-star" style="color: #ccc;"></i>
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                  </div>
                  <p>${totalReviews} đánh giá</p>
                </div>

                <div class="rating-bars">
                  <c:forEach begin="1" end="5" var="idx">
                    <c:set var="starLevel" value="${6 - idx}" />
                    <div class="bar-item">
                      <span class="star-label">${starLevel} <i class="fas fa-star"></i></span>
                      <div class="progress">
                        <div class="progress-fill" style="width: ${starPercentages[starLevel]}%"></div>
                      </div>
                      <span class="percent">${starPercentages[starLevel]}%</span>
                    </div>
                  </c:forEach>
                </div>

                <div class="review-action">
                  <p>Bạn đã trải nghiệm sản phẩm này?</p>
                  <button class="btn-write-review">Viết đánh giá</button>
                </div>
              </div>

              <div class="reviews-list">
                <c:if test="${empty reviews}">
                  <div class="no-reviews" style="text-align: center; padding: 30px; color: #888;">
                    <i class="far fa-comment-dots" style="font-size: 3em; margin-bottom: 10px; color: #ddd;"></i>
                    <p>Chưa có đánh giá nào cho sản phẩm này. Hãy là người đầu tiên đánh giá!</p>
                  </div>
                </c:if>

                <c:forEach var="review" items="${reviews}">
                  <div class="review-item">
                    <div class="review-header">
                      <div class="user-info">
                        <div class="avatar">
                          <i class="fas fa-user" style="font-size: 0.8em; color: #fff;"></i>
                        </div>
                        <div class="user-meta">
                          <span class="name">Khách hàng #${review.userId}</span>

                          <c:if test="${review.verifiedPurchase}">
                            <span class="verified"><i class="fas fa-check-circle"></i> Đã mua hàng</span>
                          </c:if>
                        </div>
                      </div>

                      <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                      <span class="date">${review.createdAt.toLocalDate()}</span>
                    </div>

                    <div class="review-stars">
                      <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                          <c:when test="${i <= review.rating}">
                            <i class="fas fa-star" style="color: #ffb800;"></i>
                          </c:when>
                          <c:otherwise>
                            <i class="far fa-star" style="color: #ccc;"></i>
                          </c:otherwise>
                        </c:choose>
                      </c:forEach>
                    </div>

                    <div class="review-content">
                        ${review.content}
                    </div>
                  </div>
                </c:forEach>
              </div>
            </div>

            <div id="review-form-wrapper" class="review-form-wrapper" style="display: none;">
              <h3>Viết đánh giá của bạn</h3>
              <form id="commentForm" action="${pageContext.request.contextPath}/add-review" method="POST">
                <input type="hidden" name="productId" value="${product.productDTO.id}">

                <div class="form-group">
                  <label>Mức độ hài lòng của bạn: <span style="display: inline" class="required">*</span></label>
                  <div class="rating-input-stars">
                    <i class="far fa-star" data-value="1"></i>
                    <i class="far fa-star" data-value="2"></i>
                    <i class="far fa-star" data-value="3"></i>
                    <i class="far fa-star" data-value="4"></i>
                    <i class="far fa-star" data-value="5"></i>
                  </div>
                  <input type="hidden" id="selected-rating" name="rating" value="0" required>
                  <span id="rating-text" class="rating-hint-text">Vui lòng chọn số sao</span>
                </div>

                <div class="form-group">
                  <label for="review-content">Nội dung nhận xét: <span style="display: inline" class="required">*</span></label>
                  <textarea id="review-content" name="content" rows="4" placeholder="Chia sẻ trải nghiệm thực tế của bạn về sản phẩm này (chất lượng, form dáng, dịch vụ giao hàng...)" required></textarea>
                </div>

                <div class="form-form-actions">
                  <button type="submit" class="btn-submit-review">Gửi đánh giá</button>
                  <button type="button" id="btn-cancel-review" class="btn-cancel-review">Hủy bỏ</button>
                </div>
              </form>
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