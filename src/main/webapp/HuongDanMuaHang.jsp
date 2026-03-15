<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <link rel="icon" href="/Nhom18_LTW/assets/favicon_io/favicon.ico" />

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

    <jsp:include page="header.jsp" />
    <div class="container">
      <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu">Trang Chủ</a></li>

            <li class="breadcrumb-item active" aria-current="page">
              Hướng dẫn mua hàng
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main class="HuongDanMuaHangPage">
      <div class="container guide-content">
        <h1 class="h2 guide-title" style="color: var(--rich-black-fogra-29)">
          HƯỚNG DẪN MUA HÀNG TẠI BHD - SPORT SHOES
        </h1>
        <p class="guide-subtitle">
          Thực hiện 4 bước đơn giản để sở hữu đôi giày yêu thích của bạn!
        </p>

        <p class="summary">
          Quy trình mua hàng tại BHD được thiết kế tối giản và nhanh chóng. Dưới
          đây là hướng dẫn chi tiết các bước đặt hàng trực tuyến trên website
          của chúng tôi.
        </p>

        <section class="guide-section">
          <h3 class="h3 step-heading">
            <span class="step-number">Bước 1:</span> Tìm Kiếm và Lựa Chọn Sản
            Phẩm
          </h3>

          <div class="step-detail">
            <p>
              Quý khách truy cập vào trang chủ hoặc sử dụng thanh tìm kiếm để
              tìm sản phẩm mong muốn.
            </p>
            <ul>
              <li>
                Duyệt qua các danh mục: Giày Nam, Giày Nữ, Bộ sưu tập mới,
                Khuyến mãi.
              </li>
              <li>Sử dụng bộ lọc theo kích cỡ, thương hiệu và mức giá.</li>
              <li>
                Truy cập trang chi tiết sản phẩm để xem ảnh, mô tả, và đánh giá.
              </li>
            </ul>
            <p>
              Sau khi chọn được sản phẩm ưng ý, quý khách chọn **Kích cỡ** và
              nhấn nút <strong>"THÊM VÀO GIỎ HÀNG"</strong>.
            </p>
          </div>
        </section>

        <hr class="guide-separator" />

        <section class="guide-section">
          <h3 class="h3 step-heading">
            <span class="step-number">Bước 2:</span> Kiểm Tra Giỏ Hàng & Cập
            Nhật Số Lượng
          </h3>

          <div class="step-detail">
            <p>
              Sau khi thêm sản phẩm, quý khách truy cập vào biểu tượng giỏ hàng
              (Cart) ở góc trên bên phải màn hình.
            </p>
            <ul>
              <li>
                Kiểm tra lại danh sách sản phẩm, kích cỡ và số lượng đã chọn.
              </li>
              <li>
                Có thể thay đổi số lượng hoặc xóa bỏ sản phẩm không mong muốn
                tại đây.
              </li>
            </ul>
            <p>
              Sau khi xác nhận, nhấn nút
              <strong>"TIẾN HÀNH THANH TOÁN"</strong>.
            </p>
          </div>
        </section>

        <hr class="guide-separator" />

        <section class="guide-section">
          <h3 class="h3 step-heading">
            <span class="step-number">Bước 3:</span> Điền Thông Tin Giao Hàng &
            Thanh Toán
          </h3>

          <div class="step-detail">
            <p>
              Đây là bước quan trọng nhất để chúng tôi gửi hàng đến quý khách:
            </p>
            <ol>
              <li>
                <strong>Thông tin nhận hàng:</strong> Điền chính xác Họ tên, Số
                điện thoại và Địa chỉ chi tiết (Tỉnh/Thành phố, Quận/Huyện,
                Phường/Xã).
              </li>
              <li>
                <strong>Chọn Phương thức thanh toán:</strong>
                <ul>
                  <li>Thanh toán khi nhận hàng (COD)</li>
                </ul>
              </li>
              <li>Kiểm tra lại tổng tiền hàng và phí vận chuyển.</li>
            </ol>
          </div>
        </section>

        <hr class="guide-separator" />

        <section class="guide-section">
          <h3 class="h3 step-heading">
            <span class="step-number">Bước 4:</span> Hoàn Tất Đặt Hàng & Nhận
            Thông Báo
          </h3>

          <div class="step-detail">
            <p>
              Sau khi kiểm tra mọi thông tin, quý khách nhấn nút
              <strong>"ĐẶT HÀNG"</strong> để hoàn tất quá trình.
            </p>
            <ul>
              <li>
                Hệ thống sẽ gửi email xác nhận đơn hàng đến địa chỉ email đã
                đăng ký.
              </li>
              <li>
                Nhân viên BHD sẽ liên hệ xác nhận đơn hàng qua điện thoại trong
                vòng 24 giờ.
              </li>
              <li>
                Đơn hàng sẽ được vận chuyển đến địa chỉ của quý khách trong thời
                gian dự kiến.
              </li>
            </ul>
            <p class="final-note" style="margin-top: 20px">
              <ion-icon
                name="alert-circle-outline"
                style="
                  vertical-align: middle;
                  margin-right: 5px;
                  color: var(--bittersweet);
                "
              ></ion-icon>
              Nếu có bất kỳ thắc mắc nào trong quá trình đặt hàng, vui lòng liên
              hệ Hotline: 0332536387 để được hỗ trợ.
            </p>
          </div>
        </section>
      </div>
    </main>
    <!--
- #FOOTER
-->
    <jsp:include page="footer.jsp" />

    <!--
- ionicon link
-->
    <script
      type="module"
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"
    ></script>
    <script
      nomodule
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"
    ></script>
    <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
  </body>
</html>
