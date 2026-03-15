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
              Chính sách bảo mật
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main class="ChinhSachBaoMat">
      <div class="container policy-content">
        <h1 class="h2 policy-title" style="color: var(--rich-black-fogra-29)">
          CHÍNH SÁCH BẢO MẬT DỮ LIỆU CÁ NHÂN
        </h1>
        <p class="policy-date">Cập nhật lần cuối: 06/11/2025</p>

        <p class="summary">
          <strong>BHD - SPORT SHOES</strong> cam kết bảo vệ tuyệt đối quyền
          riêng tư và thông tin cá nhân của quý khách. Chính sách này mô tả cách
          chúng tôi xử lý thông tin cá nhân của bạn.
        </p>

        <section class="policy-section">
          <h3 class="h3 section-heading">1. Thu thập và Loại thông tin</h3>
          <p>
            Chúng tôi thu thập thông tin khi bạn đăng ký tài khoản, đặt hàng
            hoặc sử dụng dịch vụ. Các loại dữ liệu bao gồm:
          </p>
          <ul>
            <li>
              <strong>Thông tin nhận dạng:</strong> Họ tên, ngày sinh, giới
              tính.
            </li>
            <li>
              <strong>Thông tin liên hệ:</strong> Số điện thoại, Email, Địa chỉ
              giao hàng.
            </li>
            <li>
              <strong>Thông tin thanh toán:</strong> Dữ liệu giao dịch (Không
              bao gồm chi tiết thẻ tín dụng).
            </li>
            <li>
              <strong>Dữ liệu kỹ thuật:</strong> Địa chỉ IP, Cookie, lịch sử
              duyệt web trên BHD.
            </li>
          </ul>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">2. Mục đích sử dụng Thông tin</h3>
          <p>
            Thông tin của quý khách được sử dụng với mục đích chính đáng và đã
            được thông báo:
          </p>
          <ol>
            <li>Xử lý và hoàn tất các đơn hàng, giao dịch mua bán.</li>
            <li>
              Cung cấp hỗ trợ kỹ thuật và giải quyết các khiếu nại phát sinh.
            </li>
            <li>
              Quản lý tài khoản khách hàng, bao gồm điểm thưởng và ưu đãi.
            </li>
            <li>
              Cải thiện chất lượng dịch vụ và cá nhân hóa trải nghiệm người
              dùng.
            </li>
            <li>
              Gửi thông tin tiếp thị, khuyến mại (chỉ khi có sự đồng ý của khách
              hàng).
            </li>
          </ol>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">3. Bảo vệ và Chia sẻ Dữ liệu</h3>
          <p>
            Chúng tôi cam kết sử dụng các biện pháp bảo mật tiêu chuẩn ngành:
          </p>
          <ul>
            <li>
              <strong>Bảo mật:</strong> Sử dụng mã hóa SSL và các giao thức bảo
              mật tiên tiến để bảo vệ dữ liệu.
            </li>
            <li>
              <strong>Chia sẻ:</strong> Dữ liệu chỉ được chia sẻ với các bên thứ
              ba (nhà vận chuyển, đối tác thanh toán) khi cần thiết để hoàn
              thành dịch vụ của quý khách.
            </li>
            <li>
              <strong>Không bán dữ liệu:</strong> BHD tuyệt đối không bán, cho
              thuê hoặc trao đổi thông tin cá nhân của khách hàng vì mục đích
              thương mại.
            </li>
          </ul>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">4. Quyền của Chủ thể Dữ liệu</h3>
          <p>Theo Luật Bảo vệ Dữ liệu, quý khách có các quyền sau:</p>
          <ul>
            <li>
              Quyền truy cập và yêu cầu cung cấp bản sao dữ liệu cá nhân của
              mình.
            </li>
            <li>
              Quyền yêu cầu chỉnh sửa thông tin không chính xác hoặc đã lỗi
              thời.
            </li>
            <li>
              Quyền rút lại sự đồng ý nhận thông tin tiếp thị bất cứ lúc nào.
            </li>
          </ul>
        </section>

        <p class="final-note">
          Để thực hiện bất kỳ quyền nào ở trên hoặc nếu có thắc mắc, vui lòng
          liên hệ Bộ phận Bảo mật qua email:
          <a href="mailto:BHDsport@gmail.com">BHDsport@gmail.com</a>.
        </p>
      </div>
    </main>
    <!--
- #FOOTER
-->
    <jsp:include page="footer.jsp" />
    <!-
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
