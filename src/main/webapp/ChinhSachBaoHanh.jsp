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
              Chính sách bảo hành
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main class="ChinhSachBaoHanh">
      <div class="container policy-content">
        <h1 class="h2 policy-title" style="color: var(--rich-black-fogra-29)">
          QUY ĐỊNH BẢO HÀNH SẢN PHẨM CHÍNH HÃNG
        </h1>
        <p class="policy-date">
          Áp dụng cho mọi sản phẩm giày mua tại BHD - SPORT SHOES.
        </p>

        <p class="summary">
          Chúng tôi cam kết chất lượng sản phẩm chính hãng đi kèm chính sách bảo
          hành rõ ràng, minh bạch để đảm bảo quý khách yên tâm khi mua sắm.
        </p>

        <section class="policy-section">
          <h3 class="h3 section-heading">1. Điều kiện Bảo hành Tiêu chuẩn</h3>
          <p>Sản phẩm đủ điều kiện bảo hành khi đáp ứng các yêu cầu sau:</p>
          <ul>
            <li>
              Thời gian bảo hành: <strong>03 tháng (90 ngày)</strong> kể từ ngày
              mua hàng (ghi trên hóa đơn).
            </li>
            <li>
              Sản phẩm phải được mua trực tiếp từ hệ thống BHD hoặc các kênh
              phân phối chính thức.
            </li>
            <li>
              Khách hàng phải cung cấp hóa đơn/biên nhận hoặc thông tin mua hàng
              hợp lệ để xác minh.
            </li>
          </ul>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">2. Các Lỗi được Bảo hành Miễn phí</h3>
          <p>
            Chúng tôi áp dụng bảo hành miễn phí đối với các lỗi kỹ thuật phát
            sinh từ nhà sản xuất:
          </p>
          <ol>
            <li>
              <strong>Bung/Hở Keo:</strong> Keo dán bị bong tại các mối nối
              chính (mũi giày, gót giày, đế giày) không do tác động ngoại lực.
            </li>
            <li>
              <strong>Đứt/Sút Chỉ:</strong> Các đường chỉ may bị đứt tại các khu
              vực chịu lực hoặc trang trí.
            </li>
            <li>
              <strong>Lỗi kỹ thuật khác:</strong> Đệm khí bị xì hơi (nếu có), đế
              giày bị nứt vỡ không do va chạm mạnh hoặc sử dụng sai mục đích.
            </li>
          </ol>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">3. Các Trường hợp Từ chối Bảo hành</h3>
          <p>
            Bảo hành không áp dụng hoặc sẽ được tính phí sửa chữa trong các
            trường hợp sau:
          </p>
          <ul>
            <li>Sản phẩm bị hao mòn tự nhiên (mòn đế, phai màu, cũ).</li>
            <li>
              Lỗi do người sử dụng: Giày bị rách, thủng, trầy xước, cháy, tiếp
              xúc với hóa chất.
            </li>
            <li>
              Giày bị biến dạng do giặt, sấy, hoặc bảo quản không đúng theo
              hướng dẫn.
            </li>
            <li>
              Sản phẩm đã được sửa chữa hoặc can thiệp bởi bên thứ ba không phải
              BHD.
            </li>
            <li>Hết thời hạn bảo hành 03 tháng.</li>
          </ul>
        </section>

        <section class="policy-section">
          <h3 class="h3 section-heading">4. Quy trình Giải quyết Bảo hành</h3>
          <p>
            <strong>Bước 1:</strong> Khách hàng mang/gửi sản phẩm về cửa hàng
            kèm thông tin mua hàng.
          </p>
          <p>
            <strong>Bước 2:</strong> Bộ phận kỹ thuật BHD kiểm tra và đánh giá
            tình trạng lỗi. Thời gian kiểm tra: **3-5 ngày làm việc**.
          </p>
          <p>
            <strong>Bước 3:</strong> Thông báo kết quả và tiến hành sửa chữa.
            Trong trường hợp không thể sửa chữa, BHD có thể đề xuất phương án
            thay thế sản phẩm tương đương (tùy thuộc vào chính sách của từng
            hãng).
          </p>
        </section>

        <p class="final-note">
          Mọi thắc mắc vui lòng liên hệ Bộ phận Dịch vụ Khách hàng qua Hotline:
          0332536387.
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
