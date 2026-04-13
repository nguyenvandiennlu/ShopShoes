<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - BHD SPORT SHOES</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forgotpass.css" />
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

    <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    <style>
        .step-panel { display: none; }
        .step-panel.active { display: block; }

        .alert-msg {
            display: none;
            margin-bottom: 14px;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
        }

        .alert-msg.success {
            display: block;
            background: #e8f8ee;
            color: #1f7a3d;
        }

        .alert-msg.error {
            display: block;
            background: #fdecec;
            color: #b42318;
        }
    </style>
</head>

<body>
<jsp:include page="Header.jsp" />

<div class="container">
    <div class="breadcrumb-container">
        <nav>
            <ol class="breadcrumb">
                <li><a href="${pageContext.request.contextPath}/Home.jsp">Trang Chủ</a></li>
                <li>Quên mật khẩu</li>
            </ol>
        </nav>
    </div>
</div>

<main>
    <section>
        <div class="containers">
            <div class="wrap-background">

                <div class="heading-bar">
                    <h1>Quên mật khẩu</h1>
                    <p>Thực hiện các bước để đặt lại mật khẩu</p>
                </div>

                <div id="messageBox" class="alert-msg"></div>

                <!-- STEP 1 -->
                <div id="stepEmail" class="step-panel active">
                    <form class="page-auth" onsubmit="return false;">
                        <fieldset class="form-auth">
                            <label>Email</label>
                            <input type="email" id="email" placeholder="Nhập email" required>
                        </fieldset>

                        <div style="margin: 15px 0;">
                            <div class="g-recaptcha"
                                 data-sitekey="<%= utils.RecaptchaVerifier.getSiteKey() %>">
                            </div>
                        </div>

                        <button type="button" class="btn-primary" onclick="sendOtp()">Gửi OTP</button>
                    </form>
                </div>

                <!-- STEP 2 -->
                <div id="stepOtp" class="step-panel">
                    <form class="page-auth" onsubmit="return false;">
                        <fieldset class="form-auth">
                            <label>Nhập OTP</label>
                            <input type="text" id="otp" maxlength="6" placeholder="6 số" required>
                        </fieldset>

                        <button type="button" class="btn-primary" onclick="verifyOtp()">Xác thực OTP</button>
                    </form>
                </div>

                <!-- STEP 3 -->
                <div id="stepReset" class="step-panel">
                    <form class="page-auth" onsubmit="return false;">
                        <fieldset class="form-auth">
                            <label>Mật khẩu mới</label>
                            <input type="password" id="password" required>
                        </fieldset>

                        <fieldset class="form-auth">
                            <label>Xác nhận mật khẩu</label>
                            <input type="password" id="confirmPassword" required>
                        </fieldset>

                        <button type="button" class="btn-primary" onclick="resetPassword()">Đổi mật khẩu</button>
                    </form>
                </div>

                <p>
                    Quay lại <a href="${pageContext.request.contextPath}/Login.jsp">Đăng nhập</a>
                </p>

            </div>
        </div>
    </section>
</main>

<jsp:include page="Footer.jsp" />

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";

    function showMessage(msg, ok) {
        const box = document.getElementById("messageBox");
        box.className = "alert-msg " + (ok ? "success" : "error");
        box.innerText = msg || "";
    }

    function showStep(id) {
        document.querySelectorAll(".step-panel").forEach(s => s.classList.remove("active"));
        document.getElementById(id).classList.add("active");
    }

    function sendOtp() {
        const email = document.getElementById("email").value.trim();

        if (!email) {
            showMessage("Vui lòng nhập email", false);
            return;
        }

        const data = new URLSearchParams();
        data.append("action", "send-otp");
        data.append("email", email);

        if (typeof grecaptcha !== "undefined") {
            data.append("g-recaptcha-response", grecaptcha.getResponse());
        }

        fetch(CONTEXT_PATH + "/forgot-password", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: data.toString()
        })
            .then(r => r.json())
            .then(d => {
                showMessage(d.message, d.success);

                if (typeof grecaptcha !== "undefined") {
                    grecaptcha.reset();
                }

                if (d.success) {
                    showStep("stepOtp");
                }
            })
            .catch(() => {
                showMessage("Không thể gửi OTP. Vui lòng thử lại.", false);
            });
    }

    function verifyOtp() {
        const otp = document.getElementById("otp").value.trim();

        if (!otp) {
            showMessage("Vui lòng nhập mã OTP", false);
            return;
        }

        const data = new URLSearchParams();
        data.append("action", "verify-otp");
        data.append("otp", otp);

        fetch(CONTEXT_PATH + "/forgot-password", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: data.toString()
        })
            .then(r => r.json())
            .then(d => {
                showMessage(d.message, d.success);
                if (d.success) {
                    showStep("stepReset");
                }
            })
            .catch(() => {
                showMessage("Không thể xác thực OTP. Vui lòng thử lại.", false);
            });
    }

    function resetPassword() {
        const pass = document.getElementById("password").value;
        const confirm = document.getElementById("confirmPassword").value;

        if (!pass || !confirm) {
            showMessage("Vui lòng nhập đầy đủ mật khẩu", false);
            return;
        }

        const data = new URLSearchParams();
        data.append("action", "reset-password");
        data.append("password", pass);
        data.append("confirmPassword", confirm);

        fetch(CONTEXT_PATH + "/forgot-password", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
            },
            body: data.toString()
        })
            .then(r => r.json())
            .then(d => {
                showMessage(d.message, d.success);
                if (d.success && d.redirect) {
                    showMessage("Đổi mật khẩu thành công. Đang chuyển về trang đăng nhập...", true);

                    setTimeout(() => {
                        location.href = d.redirect;
                    }, 3000);
                }
            })
            .catch(() => {
                showMessage("Không thể đổi mật khẩu. Vui lòng thử lại.", false);
            });
    }
</script>

</body>
</html>