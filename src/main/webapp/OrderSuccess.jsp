<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Đặt Hàng Thành Công</title>
<jsp:include page="head-resources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-success.css"/>
</head>
<body>

<jsp:include page="Header.jsp"/>

<div class="message-box success">
    <h2>${empty successMessage ? 'Đặt hàng thành công!' : successMessage}</h2>
    <p>Cảm ơn bạn đã mua hàng ❤️</p>

    <a href="${pageContext.request.contextPath}/menu" class="btn-primary">
        Về trang chủ
    </a>
</div>

<jsp:include page="Footer.jsp"/>
<jsp:include page="body-scripts.jsp"/>

</body>
</html>