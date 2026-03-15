<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Liên Hệ - BHD SPORT SHOES</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/lienhe.css" />

    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
</head>

<body>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="breadcrumb-container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/menu">Trang Chủ</a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
            </ol>
        </nav>
    </div>
</div>

<div class="contact-wrapper">
    <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.2312403776427!2d106.8008654145899!3d10.86991836043216!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317527587e9ad5bf%3A0xafa66f9c8be3c91!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBDw7RuZyBuZ2jhu4cgVGjDtG5nIHRpbiAtIMSQSFFHIFRQLkhDTQ!5e0!3m2!1svi!2s!4v1679069438063!5m2!1svi!2s"
            class="bando" allowfullscreen="" loading="lazy"></iframe>

    <div class="info-container">
        <h3>LIÊN HỆ</h3>
        <div class="info-item">
            <i class="fa-solid fa-map"></i>
            <div class="info-text">
                <strong>Địa chỉ:</strong><br />
                Khu phố 6, phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh
            </div>
        </div>
        <div class="info-item">
            <i class="fa-solid fa-phone"></i>
            <div class="info-text">
                <strong>Hotline:</strong><br />
                028 3896 6780
            </div>
        </div>
        <div class="info-item">
            <i class="fa-solid fa-clock"></i>
            <div class="info-text">
                <strong>Thời gian làm việc:</strong> <br />
                Thứ 2 - Thứ 7: 7:30 - 17:00
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

<script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>

</body>
</html>