<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE-edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký - BHD SPORT SHOES</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dangnhapvadangki.css" />
    <!--
          - favicon
        -->
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

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
            <li class="breadcrumb-item">
              <a href="${pageContext.request.contextPath}/Home.jsp"
                >Trang Chủ</a
              >
            </li>

            <li class="breadcrumb-item active" aria-current="page">Đăng ký</li>
          </ol>
        </nav>
      </div>
    </div>
    <main>
      <section>
        <div class="containers">
          <div class="wrap-background" id="register-view">
            <div class="heading-bar">
              <h1>Đăng ký tài khoản</h1>
              <p>
                Bạn đã có tài khoản ?
                <a
                  class="as"
                  href="${pageContext.request.contextPath}/Login.jsp"
                  >Đăng nhập tại đây</a
                >
              </p>
            </div>

            <div class="rows">
              <div class="cols">
                <form
                  class="page-auth"
                  id="register"
                  action="${pageContext.request.contextPath}/register"
                  method="post"
                  novalidate
                >
                  <% if (request.getAttribute("error") != null) { %>
                  <div
                    style="
                      color: #721c24;
                      margin-bottom: 15px;
                      padding: 10px;
                      background-color: #f8d7da;
                      border: 1px solid #f5c6cb;
                      border-radius: 4px;
                      text-align: center;
                    "
                  >
                    <%= request.getAttribute("error") %>
                  </div>
                  <% } %> <% if (request.getAttribute("success") != null) { %>
                  <div
                    style="
                      color: #155724;
                      margin-bottom: 15px;
                      padding: 12px;
                      background-color: #d4edda;
                      border: 1px solid #c3e6cb;
                      border-radius: 4px;
                      text-align: center;
                      font-weight: 500;
                    "
                  >
                    <%= request.getAttribute("success") %>
                  </div>
                  <% } %>

                  <fieldset class="form-auth">
                    <label for="fullName">Họ và tên</label>
                    <input
                      type="text"
                      id="fullName"
                      name="fullName"
                      placeholder="Nhập họ và tên"
                      required
                      autocomplete="name"
                    />
                    <small id="fullNameFeedback" class="field-feedback" aria-live="polite"></small>
                  </fieldset>

                  <fieldset class="form-auth">
                    <label for="email">Email</label>
                    <input
                      type="email"
                      id="email"
                      name="email"
                      placeholder="Nhập địa chỉ email"
                      required
                      autocomplete="email"
                    />
                    <small id="emailFeedback" class="field-feedback" aria-live="polite"></small>
                  </fieldset>
                  <fieldset class="form-auth">
                    <label>Số điện thoại</label>
                    <input
                      type="text"
                      id="phone"
                      name="phone"
                      placeholder="Số điện thoại"
                      required
                      autocomplete="tel"
                    />
                    <small id="phoneFeedback" class="field-feedback" aria-live="polite"></small>
                  </fieldset>
                    <fieldset class="form-auth">
                        <label for="address">Địa chỉ</label>
                        <input
                                type="text"
                                id="address"
                                name="address"
                                placeholder="Nhập địa chỉ của bạn"
                                required
                                autocomplete="street-address"
                        />
                      <small id="addressFeedback" class="field-feedback" aria-live="polite"></small>
                    </fieldset>
                  <fieldset class="form-auth">
                    <label>Mật khẩu</label>
                    <div class="password-field">
                      <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Tạo mật khẩu"
                        required
                      />
                      <button
                        type="button"
                        class="password-toggle"
                        data-password-toggle
                        data-target="password"
                        aria-label="Hiện mật khẩu"
                        aria-pressed="false"
                      >
                        <ion-icon name="eye-outline"></ion-icon>
                      </button>
                    </div>
                    <div class="password-rules" aria-live="polite">
                      <p class="rule-title">Mật khẩu hợp lệ cần có đầy đủ:</p>
                      <ul>
                        <li data-rule="minLength">Tối thiểu 8 ký tự.</li>
                        <li data-rule="hasUpper">Ít nhất 1 chữ hoa (A-Z).</li>
                        <li data-rule="hasLower">Ít nhất 1 chữ thường (a-z).</li>
                        <li data-rule="hasDigit">Ít nhất 1 chữ số (0-9).</li>
                        <li data-rule="hasSpecial">Ít nhất 1 ký tự đặc biệt (ví dụ: !@#$...).</li>
                        <li data-rule="noSpace">Không chứa khoảng trắng.</li>
                      </ul>
                    </div>
                    <small id="passwordFeedback" class="field-feedback" aria-live="polite"></small>
                  </fieldset>

                  <fieldset class="form-auth">
                    <label>Xác nhận mật khẩu</label>
                    <div class="password-field">
                      <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Nhập lại mật khẩu"
                        required
                      />
                      <button
                        type="button"
                        class="password-toggle"
                        data-password-toggle
                        data-target="confirmPassword"
                        aria-label="Hiện mật khẩu xác nhận"
                        aria-pressed="false"
                      >
                        <ion-icon name="eye-outline"></ion-icon>
                      </button>
                    </div>
                    <small id="confirmPasswordFeedback" class="field-feedback" aria-live="polite"></small>
                  </fieldset>

                  <div>
                    <button type="submit" class="btn-primary">Đăng ký</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  <jsp:include page="Footer.jsp" />

    <script
      type="module"
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"
    ></script>
    <script
      nomodule
      src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"
    ></script>

  <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
  <script src="${pageContext.request.contextPath}/assets/script/register.js?v=20260406-4"></script>

  </body>
</html>
