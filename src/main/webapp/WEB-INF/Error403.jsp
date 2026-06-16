<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>403 - Truy Cập Bị Chặn | BHD Sport Shoes</title>

    <jsp:include page="/head-resources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error403.css" />

</head>

<body id="top">
<jsp:include page="/Header.jsp" />

<main>
    <div class="error-page-wrapper">
        <div class="error-card">

            <!-- ILLUSTRATION -->
            <div class="error-illustration">
                <svg viewBox="0 0 260 200" xmlns="http://www.w3.org/2000/svg">

                    <!-- Shadow ellipse -->
                    <ellipse cx="120" cy="185" rx="60" ry="8" fill="#d90429" opacity="0.12"/>

                    <!-- Floating shoe group -->
                    <g class="shoe-group" transform="translate(30, 20) rotate(-6, 90, 90)">
                        <!-- Sole -->
                        <ellipse cx="90" cy="148" rx="72" ry="14" fill="#1a1a1a"/>
                        <!-- Midsole -->
                        <rect x="22" y="130" width="136" height="22" rx="6" fill="#2d2d2d"/>
                        <!-- Upper body -->
                        <path d="M 30 130 Q 28 90 55 75 Q 80 62 110 68 L 150 72 Q 165 74 162 90 L 158 130 Z"
                              fill="#d90429"/>
                        <!-- Toe cap -->
                        <path d="M 30 130 Q 20 110 28 90 Q 36 72 55 75 Q 42 88 38 110 Z"
                              fill="#b8021e"/>
                        <!-- Laces area -->
                        <path d="M 70 78 Q 100 68 135 73 L 138 88 Q 108 84 75 93 Z"
                              fill="#fff" opacity="0.15"/>
                        <!-- Lace 1 -->
                        <line x1="82" y1="82" x2="82" y2="96" stroke="white" stroke-width="2" opacity="0.7"/>
                        <!-- Lace 2 -->
                        <line x1="98" y1="79" x2="98" y2="93" stroke="white" stroke-width="2" opacity="0.7"/>
                        <!-- Lace 3 -->
                        <line x1="114" y1="77" x2="114" y2="91" stroke="white" stroke-width="2" opacity="0.7"/>
                        <!-- Lace horizontal 1 -->
                        <line x1="82" y1="85" x2="98" y2="82" stroke="white" stroke-width="1.5" opacity="0.6"/>
                        <!-- Lace horizontal 2 -->
                        <line x1="98" y1="82" x2="114" y2="79" stroke="white" stroke-width="1.5" opacity="0.6"/>
                        <!-- Brand stripe -->
                        <path d="M 45 105 Q 90 92 148 98" stroke="white" stroke-width="3"
                              fill="none" opacity="0.35" stroke-linecap="round"/>
                        <!-- Heel tab -->
                        <rect x="150" y="84" width="12" height="28" rx="4" fill="#b8021e"/>
                    </g>

                    <!-- Lock floating beside shoe -->
                    <g class="lock-icon">
                        <circle cx="210" cy="55" r="28" fill="#d90429" opacity="0.1"/>
                        <rect x="196" y="48" width="28" height="20" rx="3" fill="#d90429"/>
                        <path d="M 201 48 L 201 42 A 9 9 0 0 1 219 42 L 219 48" stroke="#d90429" stroke-width="3.5" fill="none"/>
                        <circle cx="210" cy="56" r="3.5" fill="white"/>
                    </g>

                    <!-- Small stars / sparkles -->
                    <g opacity="0.5">
                        <circle cx="22"  cy="60"  r="3" fill="#d90429"/>
                        <circle cx="235" cy="130" r="2" fill="#d90429"/>
                        <circle cx="190" cy="160" r="2.5" fill="#d90429"/>
                        <circle cx="15"  cy="140" r="2" fill="#d90429"/>
                    </g>
                </svg>
            </div>

            <!-- 403 CODE -->
            <div class="error-code">403</div>

            <!-- DIVIDER -->
            <div class="error-divider"></div>

            <!-- MESSAGE -->
            <h1 class="error-title">Truy cập bị từ chối</h1>
            <p class="error-desc">
                Bạn không có quyền truy cập vào khu vực quản trị này.<br/>
                Vui lòng đăng nhập bằng tài khoản Quản trị viên<br/>
                hoặc quay lại trang chủ để tiếp tục mua sắm!
            </p>

            <!-- BUTTON -->
            <a href="${pageContext.request.contextPath}/menu" class="btn-home">
                <i class="fas fa-house"></i>
                Về Trang Chủ
            </a>

        </div>
    </div>
</main>

<jsp:include page="/Footer.jsp" />
</body>
</html>
