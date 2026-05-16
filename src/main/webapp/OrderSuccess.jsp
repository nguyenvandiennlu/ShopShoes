<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Đặt Hàng Thành Công</title>
<link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw=="
        crossorigin="anonymous"
        referrerpolicy="no-referrer"
/>

<!--
- favicon
-->
<link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

<!--
-  css link
-->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-success.css"/>
<!--
- google font link
-->
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link
        href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap"
        rel="stylesheet"
/>

<jsp:include page="Header.jsp"/>

<div class="message-box success">
    <h2>${empty successMessage ? 'Đặt hàng thành công!' : successMessage}</h2>
    <p>Cảm ơn bạn đã mua hàng ❤️</p>

    <a href="${pageContext.request.contextPath}/menu" class="btn-primary">
        Về trang chủ
    </a>
</div>

<jsp:include page="Footer.jsp"/>

</body>
</html>
