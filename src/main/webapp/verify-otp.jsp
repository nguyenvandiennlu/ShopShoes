<%--
  Created by IntelliJ IDEA.
  User: quy23
  Date: 16/01/2026
  Time: 6:00 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Xác thực OTP</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/verify-otp.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/verify-otp.css" />

</head>
<body>
<jsp:include page="header.jsp"/>
    <% if (request.getAttribute("msg") != null) { %>
<p style="color:darkorange"><%= request.getAttribute("msg") %></p>
    <% } %>

<div class="otp-container">
    <div class="otp-box">

        <div class="otp-title">
            <h2>Xác thực OTP</h2>
        </div>

        <% if (request.getAttribute("msg") != null) { %>
        <div class="otp-message">
            <%= request.getAttribute("msg") %>
        </div>
        <% } %>

        <form class="otp-form"
              action="${pageContext.request.contextPath}/forgot-password"
              method="post">

            <input type="hidden" name="action" value="verify-otp"/>

            <label>Mã OTP</label>
            <input type="text" name="otp" placeholder="Nhập OTP 6 số" required>

            <button type="submit" class="otp-btn">Xác thực</button>
        </form>

        <form class="otp-resend"
              action="${pageContext.request.contextPath}/forgot-password"
              method="post">
            <input type="hidden" name="action" value="send-otp"/>
            <button type="submit">Gửi lại OTP</button>
        </form>

    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>