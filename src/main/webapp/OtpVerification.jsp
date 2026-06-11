<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Xác thực OTP - BHD SPORT SHOES</title>

    <jsp:include page="head-resources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loading-overlay.css"/>
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

                            <input type="hidden" name="email" id="otpEmail" value="<%= email != null ? email : "" %>">
                            <input type="hidden" name="token" id="otpToken" value="<%= token != null ? token : "" %>">

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

                            <div class="resend-section" id="resendSection">
                                Chưa nhận được OTP? 
                                <a href="javascript:void(0);" id="resendBtn" onclick="resendOtp()">
                                    Gửi lại
                                </a>
                                <span id="resendCountdown" style="display:none; color:#888;"></span>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="Footer.jsp" />

    <jsp:include page="body-scripts.jsp" />

    <jsp:include page="LoadingOverlay.jsp"/>
    <script src="${pageContext.request.contextPath}/assets/script/loading-overlay.js"></script>

    <script>
        var CONTEXT_PATH = CONTEXT_PATH || "${pageContext.request.contextPath}";

        // Filter OTP input to only numbers
        document.getElementById('otp').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
        });

        // Show loading popup when form is submitted (verify action)
        document.getElementById('otpForm').addEventListener('submit', function(e) {
            var action = e.submitter.value;
            if (action === 'verify') {
                var otpValue = document.getElementById('otp').value;
                 
                if (!otpValue || otpValue.length !== 6) {
                    e.preventDefault();
                    document.getElementById('otpFeedback').textContent = 'Vui lòng nhập 6 chữ số OTP';
                    document.getElementById('otpFeedback').className = 'field-feedback is-invalid';
                    document.getElementById('otp').classList.add('input-invalid');
                    return;
                }
                
                showLoadingOverlay('loadingOverlay', 'Đang xác thực OTP...');
            }
        });

        document.getElementById('otp').addEventListener('input', function() {
            if (this.value.length > 0) {
                document.getElementById('otpFeedback').textContent = '';
                this.classList.remove('input-invalid');
            }
        });

        // Countdown timer for resend OTP
        var resendTimer = null;
        function startResendCountdown(seconds) {
            var resendLink = document.getElementById('resendBtn');
            var countdownSpan = document.getElementById('resendCountdown');
            resendLink.style.display = 'none';
            countdownSpan.style.display = 'inline';

            var remaining = seconds;
            countdownSpan.textContent = 'Gửi lại sau ' + remaining + 's';

            resendTimer = setInterval(function() {
                remaining--;
                if (remaining <= 0) {
                    clearInterval(resendTimer);
                    resendLink.style.display = 'inline';
                    countdownSpan.style.display = 'none';
                } else {
                    countdownSpan.textContent = 'Gửi lại sau ' + remaining + 's';
                }
            }, 1000);
        }

        // Start 60s countdown on page load
        startResendCountdown(120);

        // Resend OTP via AJAX
        function resendOtp() {
            var email = document.getElementById('otpEmail').value;
            var token = document.getElementById('otpToken').value;

            if (!email || !token) {
                alert('Thiếu thông tin email hoặc token');
                return;
            }

            var resendLink = document.getElementById('resendBtn');
            resendLink.textContent = 'Đang gửi...';
            resendLink.onclick = null;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', CONTEXT_PATH + '/verify-otp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            xhr.onload = function() {
                try {
                    var data = JSON.parse(xhr.responseText);
                    if (data.success) {
                        if (data.token) {
                            document.getElementById('otpToken').value = data.token;
                        }
                        alert(data.message);
                        startResendCountdown(120);
                    } else {
                        alert(data.message || 'Gửi lại OTP thất bại');
                        resendLink.textContent = 'Gửi lại';
                        resendLink.onclick = resendOtp;
                    }
                } catch (ex) {
                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                    resendLink.textContent = 'Gửi lại';
                    resendLink.onclick = resendOtp;
                }
            };

            xhr.onerror = function() {
                alert('Không thể kết nối server. Vui lòng thử lại.');
                resendLink.textContent = 'Gửi lại';
                resendLink.onclick = resendOtp;
            };

            xhr.send('action=resend&email=' + encodeURIComponent(email) + '&token=' + encodeURIComponent(token));
        }
    </script>
</body>
</html>