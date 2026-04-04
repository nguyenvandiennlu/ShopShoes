    <%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="model.user.User" %>
    <%
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null ) {
            response.sendRedirect(request.getContextPath() + "/Home.jsp");
            return;
        }
    %>


    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đăng nhập - BHD SPORT SHOES</title>
          <base href="${pageContext.request.contextPath}/">

        <link rel="stylesheet" href="assets/css/style.css" />

        <link rel="stylesheet" href="./assets/css/dangnhapvadangki.css" />
          <!--
              - favicon
            -->
          <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />
        <!-- Google reCAPTCHA v2 -->
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
          integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
          crossorigin="anonymous"
          referrerpolicy="no-referrer"
        />

        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
          href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
          rel="stylesheet"
        />
      </head>

      <body>
      <jsp:include page="Header.jsp" />
        <div class="container">
          <div class="breadcrumb-container">
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/menu">Trang Chủ</a></li>

                <li class="breadcrumb-item active" aria-current="page">
                  Đăng nhập
                </li>
              </ol>
            </nav>
          </div>
        </div>
        <main>
          <section>
            <div class="containers">
              <div class="wrap-background" id="login-view">
                <div class="heading-bar">
                  <h1>Đăng nhập tài khoản</h1>
                  <p>
                    Bạn chưa có tài khoản ?
                    <a class="as" href="${pageContext.request.contextPath}/register">Đăng ký tại đây</a>
                  </p>
                </div>
                <div class="rows">
                    <div class="cols">

                        <%
                            String activated = request.getParameter("activated");
                            if ("1".equals(activated)) {
                        %>
                        <div style="color: green; margin-bottom: 15px; padding: 10px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                            Kích hoạt tài khoản thành công! Bạn có thể đăng nhập.
                        </div>
                        <%
                        } else if ("0".equals(activated)) {
                        %>
                        <div class="auth-error">
                            Kích hoạt thất bại hoặc link không hợp lệ / đã hết hạn.
                        </div>
                        <%
                            }
                        %>

                        <% if (request.getAttribute("error") != null) { %>
                        <div class="auth-error">
                            <%= request.getAttribute("error") %>
                        </div>
                        <% } %>

                        <% if (request.getAttribute("success") != null) { %>
                        <div style="color: green; margin-bottom: 15px; padding: 10px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                            <%= request.getAttribute("success") %>
                        </div>
                        <% } %>

                        <form class="page-auth" method="post" action="${pageContext.request.contextPath}/login">
                            <fieldset class="form-auth">
                                <label for="email">Email</label>
                                <input
                                        type="email"
                                        id="email"
                                        name="email"
                                        placeholder="Nhập email"
                                        required
                                />
                            </fieldset>

                            <fieldset class="form-auth">
                                <label for="password">Mật khẩu</label>
                                <input
                                        type="password"
                                        id="password"
                                        name="password"
                                        placeholder="Mật khẩu"
                                        required
                                />
                            </fieldset>

                            <%-- Chỉ hiển thị reCAPTCHA khi đã sai >= 3 lần --%>
                            <% if (Boolean.TRUE.equals(request.getAttribute("showRecaptcha"))) { %>
                            <fieldset class="form-auth" id="recaptcha-container">
                                <div class="g-recaptcha" data-sitekey="<%= utils.RecaptchaVerifier.getSiteKey() %>"></div>
                            </fieldset>
                            <% } %>

                            <p id="login-error" class="auth-error-message"></p>
                            <input type="hidden" name="redirect" value="${param.redirect}" />
                            <div id="login-submit">
                                <button type="submit" id="btn-primary" class="btn-primary">
                                    Đăng nhập
                                </button>
                                <small>
                                    <span>
                                        Quên mật khẩu ? Nhấn vào <a class="as" href="${pageContext.request.contextPath}/forgot-password">đây</a>
                                    </span>
                                </small>
                            </div>
                        </form>

                        <div class="social-auth">
                            <p>Hoặc đăng nhập bằng</p>
                            <div class="wrap-social-auth">
                                <button type="button" id="google-login-btn" aria-label="Đăng nhập bằng Google">
                                    <div class="btn-google">
                                        <i class="fa-brands fa-google"></i>
                                    </div>
                                    <div>Đăng nhập Google</div>
                                </button>
                            </div>
                        </div>

                    </div>

                </div>
              </div>
            </div>
          </section>
        </main>
        <jsp:include page="Footer.jsp" />
        <%-- Truyền config reCAPTCHA cho JavaScript --%>
        <script>
            window.RECAPTCHA_SITE_KEY = "<%= utils.RecaptchaVerifier.getSiteKey() %>";
            window.SHOW_RECAPTCHA = <%= Boolean.TRUE.equals(request.getAttribute("showRecaptcha")) %>;
        </script>
        <script
          type="module"
          src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"
        ></script>
        <script
          nomodule
          src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"
        ></script>
      <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
        <script type="module" src="assets/script/auth.js"></script>
      </body>
    </html>
