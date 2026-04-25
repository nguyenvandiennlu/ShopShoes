<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BHD - SPORT SHOES</title>
    <!--
    - favicon
  -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

    <!--
    -  css link
  -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />

    <!--
    - google font link
  -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
      rel="stylesheet"
    />
  </head>

  <body id="top">
    <!--
- #HEADER
-->

    <jsp:include page="Header.jsp" />

    <div class="container">
      <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a href="${pageContext.request.contextPath}/menu"
                >Trang Chủ</a
              >
            </li>

            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
          </ol>
        </nav>
      </div>
    </div>
    <!--
   - #CartContent
   -->
    <main class="cart-page-content">
      <div class="container">
        <h1 class="cart-header">Giỏ hàng</h1>

        <div class="cart-items-list">
          <c:if test="${empty cartItems}">
            <p style="text-align:center">Giỏ hàng của bạn đang trống</p>
          </c:if>
          <c:forEach var="item" items="${cartItems}">
            <div class="product-item">

              <div class="product-details">
                <img
                        src="${item.image}"
                        alt="${item.name}"
                        class="product-image"
                />
                <div class="product-info">
                  <h2 class="product-name">
                    <a href="${pageContext.request.contextPath}/product?id=${item.productId}"
                       class="product-link">
                        ${item.name}
                    </a>
                  </h2>
                  <div class="product-attributes-line-2">
                    <p class="product-size">Size: ${item.sizeName}</p>

                    <div class="product-color">
                      <span class="color-name">${item.colorName}</span>
                    </div>
                  </div>
                  <div class="product-price-line-3c">
                    <div class="discounted-price-group">
            <span class="discounted-price">
                ${item.finalPrice}
            </span>
                      <c:if test="${not empty item.discountValue}">
              <span class="original-price">
                  ${item.originalPrice}
              </span>
                      </c:if>
                    </div>
                    <c:if test="${not empty item.discountValue}">
                      <p class="discount-value">
                        Giảm: ${item.discountValue}
                      </p>
                    </c:if>
                  </div>
                </div>
              </div>
              <div class="product-actions">
                <div class="quantity-control">
                  <form action="${pageContext.request.contextPath}/cart/update"
                        method="post">

                    <input type="hidden" name="key"
                           value="${item.productId}-${item.colorId}-${item.sizeId}" />

                    <button type="submit"
                            name="action"
                            value="minus"
                            class="quantity-btn minus-btn">-</button>

                    <input type="number"
                           value="${item.quantity}"
                           min="1"
                           readonly
                           class="quantity-input" />

                    <button type="submit"
                            name="action"
                            value="plus"
                            class="quantity-btn plus-btn">+</button>
                  </form>
                </div>
                <form action="${pageContext.request.contextPath}/cart/remove"
                      method="post"
                      class="delete-item-form"
                      data-product-name="${item.name}">
                  <input type="hidden" name="key"
                         value="${item.productId}-${item.colorId}-${item.sizeId}" />
                  <button class="action-btn delete-btn">Xoá</button>
                </form>
                <form action="${pageContext.request.contextPath}/buy-now"
                      method="post">
                  <input type="hidden" name="productId" value="${item.productId}" />
                  <input type="hidden" name="colorId" value="${item.colorId}" />
                  <input type="hidden" name="sizeId" value="${item.sizeId}" />
                  <input type="hidden" name="quantity" value="${item.quantity}" />
                  <button class="action-btn buy-now-btn">Mua ngay</button>
                </form>

              </div>
            </div>
            <hr class="separator" />
          </c:forEach>
          <div class="cart-summary-section">
          <div class="total-line">
            <span class="total-label">Tổng cộng:</span>
            <span class="total-price">${cartTotal}</span>
          </div>
            <form action="${pageContext.request.contextPath}/buy-all"
                  method="get">
              <button class="checkout-btn">Tiến Hành Đặt hàng</button>
            </form>
          </div>
      </div>
      </div>
    </main>

    <!--- #FOOTER-->
    <jsp:include page="Footer.jsp"/>
    <!-- ionicon link -->
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const deleteForms = document.querySelectorAll('.delete-item-form');

        deleteForms.forEach(function(form) {
          form.addEventListener('submit', function(event) {
            event.preventDefault();

            const productName = this.getAttribute('data-product-name');

            Swal.fire({
              title: 'Xác nhận xóa?',
              html: 'Bạn có chắc chắn muốn xóa <b>' + productName + '</b> khỏi giỏ hàng?',
              icon: 'warning',
              showCancelButton: true,
              confirmButtonColor: '#d33',
              cancelButtonColor: '#3085d6',
              confirmButtonText: 'Có, xóa ngay!',
              cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
              if (result.isConfirmed) {
                this.submit();
              }
            });
          });
        });
      });
    </script>
  </body>
</html>
