<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE-edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Xác thực OTP - ShopShoes</title>

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
                <div class="heading-bar">
                    <h1>Xác thực OTP</h1>
                    <p>Vui lòng nhập mã OTP được gửi tới email của bạn</p>
                </div>

                <div class="rows">
                    <div class="cols">
                        <% 
                            String successMsg = (String) request.getAttribute("success");
                            String errorMsg = (String) request.getAttribute("error");
                            String email = (String) request.getAttribute("email");
                            String token = (String) request.getAttribute("token");
                        %>

                        <% if (successMsg != null) { %>
                            <div style="
                                color: #155724;
                                margin-bottom: 15px;
                                padding: 12px;
                                background-color: #d4edda;
                                border: 1px solid #c3e6cb;
                                border-radius: 4px;
                                text-align: center;
                                font-weight: 500;
                            ">
                                <%= successMsg %>
                            </div>
                        <% } %>

                        <% if (errorMsg != null) { %>
                            <div style="
                                color: #721c24;
                                margin-bottom: 15px;
                                padding: 10px;
                                background-color: #f8d7da;
                                border: 1px solid #f5c6cb;
                                border-radius: 4px;
                                text-align: center;
                            ">
                                <%= errorMsg %>
                            </div>
                        <% } %>

                        <form id="otpForm" method="POST" action="${pageContext.request.contextPath}/verify-otp" novalidate>
                            <div class="info-box">
                                OTP đã được gửi tới email: <strong><%= email != null ? email : "" %></strong>
                            </div>

                            <input type="hidden" name="email" value="<%= email != null ? email : "" %>">
                            <input type="hidden" name="token" value="<%= token != null ? token : "" %>">

                            <fieldset class="form-auth">
                                <label for="otp">Mã OTP (6 chữ số)</label>
                                <input 
                                    type="text" 
                                    id="otp" 
                                    name="otp" 
                                    class="otp-input-field"
                                    placeholder="000000"
                                    maxlength="6"
                                    inputmode="numeric"
                                    required
                                    autofocus
                                />
                                <small id="otpFeedback" class="field-feedback" aria-live="polite"></small>
                            </fieldset>

                            <fieldset class="form-auth">
                                <label for="fullEmail">Email của bạn</label>
                                <input 
                                    type="email" 
                                    id="fullEmail"
                                    value="<%= email != null ? email : "" %>"
                                    disabled
                                    style="background-color: #f5f5f5; cursor: not-allowed;"
                                />
                            </fieldset>

                            <div class="otp-button-group">
                                <button type="submit" name="action" value="skip" class="btn-skip">Bỏ qua</button>
                                <button type="submit" name="action" value="verify" class="btn-primary">Xác thực OTP</button>
                            </div>

                            <div class="resend-section">
                                Chưa nhận được OTP? 
                                <a href="javascript:void(0);" onclick="alert('Tính năng gửi lại OTP sẽ sớm được cập nhật')">
                                    Gửi lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="Footer.jsp" />

    <div id="loadingOverlay" class="loading-overlay">
        <div class="loading-container">
            <div class="spinner"></div>
            <div class="loading-text">Đang tải...</div>
        </div>
    </div>

    <script>
        // Filter OTP input to only numbers
        document.getElementById('otp').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
        });

        // Show loading popup when form is submitted
        document.getElementById('otpForm').addEventListener('submit', function(e) {
            const action = e.submitter.value;
            if (action === 'verify') {
                const otpValue = document.getElementById('otp').value;
                 
                if (!otpValue || otpValue.length !== 6) {
                    e.preventDefault();
                    document.getElementById('otpFeedback').textContent = 'Vui lòng nhập 6 chữ số OTP';
                    document.getElementById('otpFeedback').className = 'field-feedback is-invalid';
                    document.getElementById('otp').classList.add('input-invalid');
                    return;
                }
                
                document.getElementById('loadingOverlay').classList.add('active');
            }
        });

        document.getElementById('otp').addEventListener('input', function() {
            if (this.value.length > 0) {
                document.getElementById('otpFeedback').textContent = '';
                this.classList.remove('input-invalid');
            }
        });
    </script>
</body>
</html>
