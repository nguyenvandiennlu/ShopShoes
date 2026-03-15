<%--
  Created by IntelliJ IDEA.
  User: quy23
  Date: 16/01/2026
  Time: 6:26 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Đặt lại mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset-password.css" />

</head>
<body>
<jsp:include page="header.jsp"/>
<div class="reset-container">
    <div class="reset-box">

        <div class="reset-title">
            <h2>Đặt lại mật khẩu</h2>
        </div>

        <div class="reset-desc">
            Vui lòng nhập mật khẩu mới cho tài khoản của bạn
        </div>

        <% if (request.getAttribute("msg") != null) { %>
        <div class="reset-message">
            <%= request.getAttribute("msg") %>
        </div>
        <% } %>

        <form class="reset-form"
              action="${pageContext.request.contextPath}/forgot-password"
              method="post">

            <input type="hidden" name="action" value="reset-password"/>

            <label>Mật khẩu mới</label>
            <input type="password" name="password" required />

            <label>Xác nhận mật khẩu</label>
            <input type="password" name="confirmPassword" required />

            <button type="submit" class="reset-btn">Đổi mật khẩu</button>
        </form>


    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>
