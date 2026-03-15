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
    <link rel="stylesheet" href="assets/css/style.css" />

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
              Câu hỏi thường gặp
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main class="FAQPage">
      <div class="container faq-content">
        <h1 class="h2 faq-title" style="color: var(--rich-black-fogra-29)">
          CÂU HỎI THƯỜNG GẶP (FAQ)
        </h1>
        <p class="faq-subtitle">
          Giải đáp mọi thắc mắc của quý khách về sản phẩm và dịch vụ của BHD -
          SPORT SHOES.
        </p>

        <section class="faq-category">
          <h3 class="h3 category-title">
            <ion-icon name="shirt-outline"></ion-icon> VỀ SẢN PHẨM & CHẤT LƯỢNG
          </h3>

          <div class="faq-item">
            <button class="faq-question">
              Làm sao tôi biết giày tại BHD là hàng chính hãng?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                BHD - SPORT SHOES cam kết
                <strong>chỉ bán giày thể thao chính hãng 100%</strong> được nhập
                trực tiếp từ các nhà phân phối lớn của Nike, Adidas, Puma, v.v.
                Chúng tôi cam kết <strong>HOÀN TIỀN GẤP ĐÔI</strong> nếu quý
                khách phát hiện sản phẩm là hàng giả, hàng nhái (Fake).
              </p>
            </div>
          </div>

          <div class="faq-item">
            <button class="faq-question">
              Tôi có thể xem các đánh giá về chất lượng sản phẩm ở đâu?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                Quý khách có thể xem các đánh giá chân thật từ khách hàng đã mua
                sản phẩm ở ngay dưới phần mô tả của từng đôi giày. Ngoài ra, quý
                khách có thể tham khảo thêm trên Fanpage chính thức của BHD.
              </p>
            </div>
          </div>
        </section>

        <section class="faq-category">
          <h3 class="h3 category-title">
            <ion-icon name="cart-outline"></ion-icon> ĐẶT HÀNG & HỦY ĐƠN HÀNG
          </h3>

          <div class="faq-item">
            <button class="faq-question">
              Tôi có thể đặt hàng qua điện thoại không?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                Có. Quý khách hoàn toàn có thể đặt hàng trực tiếp qua Hotline:
                <strong>0332536387</strong>. Nhân viên chăm sóc khách hàng của
                chúng tôi sẽ hỗ trợ quý khách kiểm tra size, xác nhận thông tin
                và tạo đơn hàng trên hệ thống.
              </p>
            </div>
          </div>

          <div class="faq-item">
            <button class="faq-question">
              Làm sao để hủy một đơn hàng đã đặt?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                Quý khách vui lòng liên hệ ngay với BHD trong vòng
                <strong>1 giờ</strong> kể từ khi đặt hàng. Nếu đơn hàng chưa
                được chuyển giao cho đơn vị vận chuyển, chúng tôi sẽ hỗ trợ hủy
                đơn hàng mà không phát sinh phí.
              </p>
            </div>
          </div>
        </section>

        <section class="faq-category">
          <h3 class="h3 category-title">
            <ion-icon name="airplane-outline"></ion-icon> GIAO HÀNG & PHÍ VẬN
            CHUYỂN
          </h3>

          <div class="faq-item">
            <button class="faq-question">
              Thời gian giao hàng dự kiến là bao lâu?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>Thời gian giao hàng phụ thuộc vào địa chỉ nhận hàng:</p>
              <ul>
                <li>
                  <strong>Nội thành TP.HCM/Hà Nội:</strong> 1-2 ngày làm việc.
                </li>
                <li>
                  <strong>Các tỉnh thành khác:</strong> 3-5 ngày làm việc.
                </li>
              </ul>
              <p>Thời gian này không bao gồm Chủ nhật và các ngày lễ, Tết.</p>
            </div>
          </div>

          <div class="faq-item">
            <button class="faq-question">
              Phí vận chuyển được tính như thế nào?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                Phí vận chuyển sẽ được tính tự động dựa trên tổng trọng lượng
                đơn hàng và địa chỉ nhận hàng của quý khách. BHD thường xuyên có
                các chương trình <strong>Miễn phí vận chuyển</strong> cho đơn
                hàng đạt giá trị nhất định (ví dụ: trên 2.000.000 VNĐ).
              </p>
            </div>
          </div>
        </section>

        <section class="faq-category">
          <h3 class="h3 category-title">
            <ion-icon name="repeat-outline"></ion-icon> ĐỔI, TRẢ HÀNG & BẢO HÀNH
          </h3>

          <div class="faq-item">
            <button class="faq-question">
              Chính sách đổi trả hàng hóa của BHD như thế nào?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                BHD áp dụng chính sách đổi hàng trong vòng
                <strong>7 ngày</strong> kể từ ngày nhận hàng với điều kiện:
              </p>
              <ul>
                <li>Giày còn nguyên tem, mác, chưa qua sử dụng.</li>
                <li>Sản phẩm còn nguyên vẹn hộp đựng và phụ kiện đi kèm.</li>
                <li>
                  Chỉ chấp nhận đổi size hoặc đổi sang mẫu khác có giá trị bằng
                  hoặc lớn hơn.
                </li>
              </ul>
            </div>
          </div>

          <div class="faq-item">
            <button class="faq-question">
              Giày mua online có được bảo hành không?
              <ion-icon
                name="chevron-down-outline"
                class="toggle-icon"
              ></ion-icon>
            </button>
            <div class="faq-answer">
              <p>
                Có. Mọi sản phẩm giày chính hãng mua tại BHD đều được bảo hành
                <strong>03 tháng</strong> đối với các lỗi kỹ thuật từ nhà sản
                xuất (bung keo, đứt chỉ). Vui lòng xem chi tiết tại trang
                <strong>Chính sách Bảo hành</strong>.
              </p>
            </div>
          </div>
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
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const faqItems = document.querySelectorAll(".faq-item");

        faqItems.forEach((item) => {
          const question = item.querySelector(".faq-question");
          const answer = item.querySelector(".faq-answer");

          question.addEventListener("click", () => {
            faqItems.forEach((otherItem) => {
              if (otherItem !== item) {
                otherItem
                  .querySelector(".faq-question")
                  .classList.remove("active");
                otherItem.querySelector(".faq-answer").classList.remove("open");
              }
            });
            question.classList.toggle("active");
            answer.classList.toggle("open");
          });
        });
      });
    </script>
    <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
  </body>
</html>
