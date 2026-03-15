<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - BHD SPORT SHOES</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forgotpass.css" />
      <!--
    - favicon
  -->
      <link rel="icon" href="/Nhom18_LTW/assets/favicon_io/favicon.ico" />
  </head>
  <body>
  <jsp:include page="header.jsp" />

    <div class="container">
      <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu.jsp">Trang Chủ</a></li>

            <li class="breadcrumb-item active" aria-current="page">
              Quên mật khẩu
            </li>
          </ol>
        </nav>
      </div>
    </div>
    <main>
      <section>
        <div class="containers">
          <div class="wrap-background" id="forgot-password-view">
            <div class="heading-bar">
              <h1>Quên mật khẩu</h1>
              <p>
                Nhập địa chỉ email của bạn để nhận hướng dẫn đặt lại mật khẩu.
              </p>
            </div>
            <div class="rows">

                  <% String msg = (String) request.getAttribute("msg"); %>
                  <% if (msg != null) { %>
                  <div class="alert-msg" style="margin-bottom: 14px; padding: 10px 12px; border-radius: 8px; background:#fff3cd; border:1px solid #ffeeba; color:#856404;">
                      <%= msg %>
                  </div>
                  <% } %>


                  <form class="page-auth"
                        action="${pageContext.request.contextPath}/forgot-password"
                        method="post">

                      <input type="hidden" name="action" value="send-otp"/>

                      <fieldset class="form-auth">
                          <label for="email">Email</label>
                          <input
                                  type="email"
                                  id="email"
                                  name="email"
                                  placeholder="Nhập địa chỉ email của bạn"
                                  required
                          />
                      </fieldset>

                      <button type="submit" class="btn-primary">
                          Gửi yêu cầu
                      </button>
                  </form>

                  <p>Quay lại <a class="as" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a></p>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

  <jsp:include page="footer.jsp" />
  </body>
    <script
      type="module"
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"
    ></script>
    <script
      nomodule
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"
    ></script>

  <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
</html>
