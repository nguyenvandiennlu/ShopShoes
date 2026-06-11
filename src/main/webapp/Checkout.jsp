<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8"/>
  <title>Thanh toán</title>
  <jsp:include page="head-resources.jsp"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loading-overlay.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-success.css"/>
</head>

<body>

<jsp:include page="Header.jsp"/>

<div class="container">
  <jsp:include page="Breadcrumb.jsp" />
</div>

<c:if test="${not empty errorMessage}">
  <div class="checkout-alert">
  <strong>Không thể đặt hàng:</strong><br>
  ${errorMessage}
  </div>
</c:if>

<div class="checkout-container container">

  <form action="${pageContext.request.contextPath}/checkout"
        method="post"
        class="checkout-form">

    <div class="checkout-main-content">
      <div class="col-info">
        <h2>Thông tin nhận hàng</h2>
        <div class="form-group">
          <label>Email</label>
          <input type="text" name="email" value="${currentUser.email}"/>
        </div>
        <div class="form-group">
          <label>Họ và tên</label>
          <input type="text" name="fullName" value="${currentUser.fullName}"/>
        </div>
        <div class="form-group">
          <label>Số điện thoại</label>
          <input type="text" name="phone" value="${currentUser.phoneNumber}"/>
        </div>
        <div class="form-group">
          <label>Tỉnh/Thành phố <span style="color:red">*</span></label>
          <select id="province" required>
            <option value="">Chọn Tỉnh/Thành phố</option>
          </select>
        </div>

        <div class="form-group">
          <label>Quận/Huyện <span style="color:red">*</span></label>
          <select id="district" disabled required>
            <option value="">Chọn Quận/Huyện</option>
          </select>
        </div>

        <div class="form-group">
          <label>Phường/Xã <span style="color:red">*</span></label>
          <select id="ward" disabled required>
            <option value="">Chọn Phường/Xã</option>
          </select>
        </div>

        <div class="form-group">
          <label>Địa chỉ cụ thể (Số nhà, Tên đường) <span style="color:red">*</span></label>
          <input type="text" id="street" placeholder="VD: 123 Đường Kha Vạn Cân" required/>
        </div>

        <input type="hidden" name="address" id="fullAddress" value=""/>
        <div class="form-group">
          <label>Ghi chú</label>
          <input type="text" name="note"/>
        </div>
      </div>

      <div class="col-products">
        <h3>Đơn hàng (${cart.size()} sản phẩm)</h3>
        <div class="order-items-list">
          <c:forEach var="item" items="${cart.values()}">
            <div class="order-item">
              <img src="${item.image}" class="item-image"/>
              <div class="item-info">
                <p class="item-name">${item.name}</p>
                <p class="item-variant">${item.colorName} / ${item.sizeName}</p>
                <p class="item-qty">Số lượng: ${item.quantity}</p>
              </div>
              <div class="item-price">${item.finalPrice}</div>
            </div>
          </c:forEach>
        </div>
      </div>

      <div class="col-summary">
        <h3>Thanh toán</h3>
        <div class="payment-box">
          <div class="payment-method-container">
            <label>
              <input type="radio" name="paymentMethod" value="COD" checked/>
              Thanh toán khi nhận hàng (COD)
            </label>
            <label>
              <input type="radio" name="paymentMethod" value="MOMO"/>
              Thanh toán MoMo
            </label>
          </div>

          <div class="summary-details">
            <div class="summary-row">
              <span>Tạm tính</span>
              <span>${subTotal}</span>
            </div>
            <div class="summary-row">
              <span>Phí vận chuyển</span>
              <span id="shippingFeeDisplay">${shippingFee}</span>
            </div>
            <div class="summary-row total">
              <strong>Tổng cộng</strong>
              <strong id="grandTotalDisplay">${grandTotal}</strong>
            </div>
          </div>
          <button type="submit" class="btn-submit">ĐẶT HÀNG</button>
          <a href="${pageContext.request.contextPath}/menu" class="btn-link">Quay lại</a>
        </div>
      </div>
    </div>
  </form>
</div>

<jsp:include page="Footer.jsp"/>

<jsp:include page="body-scripts.jsp"/>

<jsp:include page="LoadingOverlay.jsp"/>
<script src="${pageContext.request.contextPath}/assets/script/loading-overlay.js"></script>

<script>
  const contextPath = '${pageContext.request.contextPath}';
  const subTotalRaw = parseFloat('${subTotalRaw != null ? subTotalRaw : 0}') || 0;

  // Show loading overlay when checkout form is submitted
  document.addEventListener('DOMContentLoaded', function() {
    var checkoutForm = document.querySelector('.checkout-form');
    if (checkoutForm) {
      checkoutForm.addEventListener('submit', function(e) {
        showLoadingOverlay('loadingOverlay', 'Đang xử lý đơn hàng...');
      });
    }
  });
</script>

<script src="${pageContext.request.contextPath}/assets/script/checkout.js"></script>
</body>
</html>
