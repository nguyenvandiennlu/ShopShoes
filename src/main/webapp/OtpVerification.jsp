<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - ShopShoes</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 500px;
        }

        .modal {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            padding: 40px;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .modal-header h2 {
            color: #333;
            font-size: 24px;
            margin-bottom: 10px;
        }

        .modal-header p {
            color: #666;
            font-size: 14px;
        }

        .modal-body {
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .otp-input {
            letter-spacing: 15px;
            text-align: center;
            font-size: 20px;
            font-weight: bold;
        }

        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .modal-footer {
            display: flex;
            gap: 15px;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background-color: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background-color: #e9ecef;
            color: #333;
        }

        .btn-secondary:hover {
            background-color: #dee2e6;
            transform: translateY(-2px);
        }

        .resend-link {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }

        .resend-link a {
            color: #667eea;
            text-decoration: none;
            cursor: pointer;
        }

        .resend-link a:hover {
            text-decoration: underline;
        }

        .info-text {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
            border-left: 4px solid #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="modal">
            <div class="modal-header">
                <h2>Xác thực OTP</h2>
                <p>Vui lòng nhập OTP được gửi tới email của bạn</p>
            </div>

            <div class="modal-body">
                <% 
                    String successMsg = (String) request.getAttribute("success");
                    String errorMsg = (String) request.getAttribute("error");
                    String email = (String) request.getAttribute("email");
                    String token = (String) request.getAttribute("token");
                %>

                <% if (successMsg != null) { %>
                    <div class="alert alert-success">
                        <%= successMsg %>
                    </div>
                <% } %>

                <% if (errorMsg != null) { %>
                    <div class="alert alert-danger">
                        <%= errorMsg %>
                    </div>
                <% } %>

                <div class="info-text">
                    📧 OTP đã được gửi tới email: <strong><%= email != null ? email : "" %></strong>
                </div>

                <form id="otpForm" method="POST" action="${pageContext.request.contextPath}/verify-otp">
                    <input type="hidden" name="email" value="<%= email != null ? email : "" %>">
                    <input type="hidden" name="token" value="<%= token != null ? token : "" %>">

                    <div class="form-group">
                        <label for="otp">Mã OTP (6 chữ số)</label>
                        <input 
                            type="text" 
                            id="otp" 
                            name="otp" 
                            class="otp-input"
                            placeholder="000000"
                            maxlength="6"
                            inputmode="numeric"
                            required
                            autofocus
                        >
                    </div>

                    <div class="form-group">
                        <label for="fullEmail">Email của bạn</label>
                        <input 
                            type="email" 
                            id="fullEmail"
                            value="<%= email != null ? email : "" %>"
                            disabled
                        >
                    </div>

                    <div class="modal-footer">
                        <button type="submit" name="action" value="skip" class="btn btn-secondary">
                            Bỏ qua
                        </button>
                        <button type="submit" name="action" value="verify" class="btn btn-primary">
                            Xác thực OTP
                        </button>
                    </div>

                    <div class="resend-link">
                        Chưa nhận được OTP? 
                        <a href="javascript:void(0);" onclick="alert('Tính năng gửi lại OTP sẽ sớm được cập nhật')">
                            Gửi lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('otp').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
        });

        document.getElementById('otp').addEventListener('input', function(e) {
            if (e.target.value.length === 6) {
            }
        });
    </script>
</body>
</html>
