<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <title>Admin</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=3.0" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        </head>

        <body>

            <div class="sidebar">
                <div class="admin-avatar">
                    <div class="admin-icon">BHD</div>
                    <span class="admin-name">Admin</span>
                </div>

                <ul class="menu">
                    <li class="${active == 'admin/dashboard' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            Dashboard
                        </a>
                    </li>

                    <li class="${active == 'admin/accounts' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/accounts">
                            Tài khoản
                        </a>
                    </li>

                    <li class="${active == 'admin/products' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/products">
                            Sản phẩm
                        </a>
                    </li>

                    <li class="${active == 'admin/variants' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/variants">
                            Biến thể
                        </a>
                    </li>

                    <li class="${active == 'admin/collections' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/collections">
                            Bộ sưu tập
                        </a>
                    </li>

                    <li class="${active == 'admin/banners' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/banners">
                            Banner
                        </a>
                    </li>

                    <li class="${active == 'admin/orders' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/orders">
                            Đơn hàng
                        </a>
                    </li>


                    <li class="${active == 'admin/statistics' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/statistics">
                            Thống kê
                        </a>
                    </li>

                    <li>
                        <a href="${pageContext.request.contextPath}/admin/logout">
                            Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>

            <div class="main">
                <jsp:include page="${contentPage}" />
            </div>

        </body>

        </html>