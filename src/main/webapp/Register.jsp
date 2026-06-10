<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE-edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng ký - BHD SPORT SHOES</title>

    <jsp:include page="head-resources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dangnhapvadangki.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/otp-verification.css" />
  </head>
  <body>
  <jsp:include page="Header.jsp" />
    <div class="container">
      <jsp:include page="Breadcrumb.jsp" />
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

  <!-- Loading Overlay -->
  <div id="registerLoadingOverlay" class="loading-overlay">
      <div class="loading-container">
          <div class="spinner"></div>
          <div class="loading-text">Đang đăng ký...</div>
      </div>
  </div>

  <jsp:include page="body-scripts.jsp"></jsp:include>
  <script src="${pageContext.request.contextPath}/assets/script/register.js?v=20260406-4"></script>

  <script>
    // Show loading popup when register form is submitted
    const registerForm = document.getElementById('register');
    if (registerForm) {
      registerForm.addEventListener('submit', function(e) {
        document.getElementById('registerLoadingOverlay').classList.add('active');
      });
    }
  </script>

  </body>
</html>
