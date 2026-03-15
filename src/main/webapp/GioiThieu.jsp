<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.user.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
%>

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
            <li class="breadcrumb-item">
              <a href="${pageContext.request.contextPath}/menu"
                >Trang Chủ</a
              >
            </li>

            <li class="breadcrumb-item active" aria-current="page">
              Giới thiệu
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main class="GioiThieuPage">
      <div class="gioithieu-container container">
        <header class="page-header">
          <h1 class="h1">Về BHD - SPORT SHOES</h1>
          <p class="subtitle">Cùng Bạn Chinh Phục Mọi Hành Trình</p>
        </header>

        <hr class="header-divider" />

        <section class="section-content">
          <h2 class="h2 section-title">👟 Câu Chuyện Của Chúng Tôi</h2>

          <p>
            <strong>BHD - SPORT SHOES</strong> được thành lập với niềm đam mê
            cháy bỏng dành cho thể thao và văn hóa đường phố. Chúng tôi tin
            rằng, một đôi giày không chỉ là vật dụng bảo vệ đôi chân, mà còn là
            **người bạn đồng hành** trên mỗi chặng đường chinh phục mục tiêu, từ
            sân cỏ đến đường chạy marathon, hay đơn giản chỉ là những bước đi tự
            tin trong cuộc sống hàng ngày.
          </p>

          <p>
            Khởi nguồn từ một cửa hàng nhỏ, BHD đã phát triển thành thương hiệu
            đáng tin cậy, chuyên cung cấp **giày thể thao chính hãng 100%** từ
            các thương hiệu hàng đầu thế giới như Nike, Adidas, Puma, New
            Balance và nhiều hơn nữa.
          </p>
        </section>

        <section class="section-content">
          <h2 class="h2 section-title">✅ Cam Kết Chất Lượng</h2>

          <h3 class="h3">1. Chính Hãng Tuyệt Đối</h3>
          <p>
            Chúng tôi cam kết <strong>HOÀN TIỀN GẤP ĐÔI</strong> nếu phát hiện
            sản phẩm là hàng giả, hàng nhái. Mỗi đôi giày tại BHD đều có tem,
            mác, và giấy tờ chứng minh nguồn gốc rõ ràng.
          </p>

          <h3 class="h3">2. Giá Trị Thực</h3>
          <p>
            BHD luôn nỗ lực tối ưu hóa chi phí để mang đến mức giá cạnh tranh
            nhất, đảm bảo khách hàng nhận được **giá trị tốt nhất** đi kèm với
            chất lượng sản phẩm chính hãng.
          </p>

          <h3 class="h3">3. Dịch Vụ Tận Tâm</h3>
          <p>
            Đội ngũ chuyên viên tư vấn của chúng tôi luôn sẵn sàng hỗ trợ bạn
            tìm được đôi giày **phù hợp nhất** với nhu cầu, sở thích và phong
            cách cá nhân, đi kèm với chính sách bảo hành, đổi trả và bảo mật
            thông tin rõ ràng.
          </p>
        </section>
          <h2 class="h2 section-title">🌟 Sứ Mệnh & Tầm Nhìn</h2>
        <section class="section-content section-mission">
          <div class="mission-block">
            <h3 class="h3">Sứ Mệnh</h3>
            <p>
              Trở thành cầu nối tin cậy, cung cấp những sản phẩm giày thể thao
              chất lượng cao, giúp người Việt **nâng tầm phong cách sống** và
              đạt được hiệu suất tốt nhất trong hoạt động thể thao.
            </p>
          </div>

          <div class="mission-block">
            <h3 class="h3">Tầm Nhìn</h3>
            <p>
              Trong 5 năm tới, BHD - SPORT SHOES sẽ là hệ thống bán lẻ giày thể
              thao chính hãng hàng đầu Việt Nam với mạng lưới cửa hàng rộng khắp
              và nền tảng thương mại điện tử vững mạnh.
            </p>
          </div>

          <p class="final-cta">
            **BHD - SPORT SHOES:** Hãy bắt đầu hành trình của bạn ngay hôm nay!
          </p>
        </section>
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
  </body>
  <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
</html>
