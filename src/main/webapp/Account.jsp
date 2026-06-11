<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ page import="model.user.User" %>

                <% User user=(User) session.getAttribute("currentUser"); if (user==null) {
                    response.sendRedirect("Login.jsp"); return; } %>

                    <!DOCTYPE html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8" />
                        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                        <title>BHD - SPORT SHOES</title>
                        <jsp:include page="head-resources.jsp" />
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/account.css" />
                        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />
                    </head>

                    <body id="top">
                        <jsp:include page="Header.jsp" />

                        <div class="container">
                            <jsp:include page="Breadcrumb.jsp" />
                        </div>

                        <main class="TaiKhoanPage">
                            <div class="container account-dashboard">
                                <h1 class="h2 page-title">Tài Khoản Của Tôi</h1>

                                <div class="account-layout">
                                    <aside class="account-sidebar">
                                        <div class="user-info-summary">
                                            <!-- AVATAR UPLOAD -->
                                            <div class="avatar-wrapper" id="avatarWrapper" title="Nhấn để thay đổi ảnh">
                                                <img
                                                    id="avatarPreview"
                                                    src="<c:choose><c:when test='${not empty sessionScope.currentUser.avatarUrl}'>${sessionScope.currentUser.avatarUrl}</c:when><c:otherwise>data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='50' fill='%23e8e8e8'/%3E%3Ccircle cx='50' cy='38' r='18' fill='%23bbb'/%3E%3Cellipse cx='50' cy='85' rx='28' ry='20' fill='%23bbb'/%3E%3C/svg%3E</c:otherwise></c:choose>"
                                                    alt="Ảnh đại diện"
                                                    class="avatar-img"
                                                    onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'100\' height=\'100\' viewBox=\'0 0 100 100\'%3E%3Ccircle cx=\'50\' cy=\'50\' r=\'50\' fill=\'%23e8e8e8\'/%3E%3Ccircle cx=\'50\' cy=\'38\' r=\'18\' fill=\'%23bbb\'/%3E%3Cellipse cx=\'50\' cy=\'85\' rx=\'28\' ry=\'20\' fill=\'%23bbb\'/%3E%3C/svg%3E'"
                                                />
                                                <div class="avatar-overlay">
                                                    <ion-icon name="camera-outline"></ion-icon>
                                                    <span>Đổi ảnh</span>
                                                </div>
                                                <div class="avatar-loading" id="avatarLoading" style="display:none">
                                                    <div class="avatar-spinner"></div>
                                                </div>
                                            </div>
                                            <input type="file" id="avatarInput" accept="image/jpeg,image/png,image/webp,image/gif" style="display:none" />

                                            <p class="user-name-display">
                                                Xin chào, <strong>
                                                    <c:out value="${sessionScope.currentUser.fullName}"
                                                        default="${sessionScope.currentUser.email}" />
                                                </strong>
                                            </p>
                                        </div>
                                        <ul class="account-nav-list">
                                            <li class="active"><a href="#personal-info" data-tab="info"><ion-icon
                                                        name="person-circle-outline"></ion-icon> Thông tin cá nhân</a>
                                            </li>
                                            <li><a href="#change-password" data-tab="password"><ion-icon
                                                        name="lock-closed-outline"></ion-icon> Đổi mật khẩu</a></li>

                                            <li><a href="#order-history" data-tab="orders"><ion-icon
                                                        name="time-outline"></ion-icon>
                                                    Lịch sử đơn hàng</a></li>

                                            <li>
                                                <a href="#" id="btn-logout-trigger"><ion-icon
                                                        name="log-out-outline"></ion-icon>
                                                    Đăng xuất</a>
                                            </li>
                                        </ul>
                                    </aside>

                                    <div class="account-content">
                                        <% String msg=(String) request.getAttribute("msg"); String msgType=(String)
                                            request.getAttribute("msgType"); if (msg !=null) { String
                                            alertClass=(msgType !=null && msgType.equals("success")) ? "alert-success"
                                            : "alert-danger" ; %>
                                            <div class="alert <%= alertClass %>" role="alert"
                                                style="margin-bottom: 20px;">
                                                <%= msg %>
                                            </div>
                                            <% } %>

                                                <section id="personal-info" class="tab-content active"
                                                    data-content="info">
                                                    <h3 class="h3 content-title">Thông Tin Cá Nhân</h3>
                                                    <p>Quản lý tên, email và số điện thoại của bạn.</p>
                                                    <form class="account-form" method="post"
                                                        action="${pageContext.request.contextPath}/account">
                                                        <input type="hidden" name="action" value="update-profile" />
                                                        <div class="input-group">
                                                            <label for="full-name">Họ và Tên</label>
                                                            <input type="text" id="full-name" name="fullName"
                                                                value="<c:out value='${sessionScope.currentUser.fullName}'/>"
                                                                required />
                                                        </div>
                                                        <div class="input-group">
                                                            <label for="email">Địa chỉ Email</label>
                                                            <input type="email" id="email" name="email"
                                                                value="<c:out value='${sessionScope.currentUser.email}'/>"
                                                                readonly required />
                                                        </div>
                                                        <div class="input-group">
                                                            <label for="phone">Số điện thoại</label>
                                                            <input type="tel" id="phone" name="phoneNumber"
                                                                value="<c:out value='${sessionScope.currentUser.phoneNumber}'/>"
                                                                required />
                                                        </div>
                                                        <div class="input-group">
                                                            <label for="address">Địa chỉ</label>
                                                            <input type="text" id="address" name="address"
                                                                value="<c:out value='${sessionScope.currentUser.address}'/>" />
                                                        </div>
                                                        <button type="submit" class="btn btn-primary btn-save">Cập Nhật
                                                            Thông Tin</button>
                                                    </form>
                                                </section>

                                                <section id="change-password" class="tab-content"
                                                    data-content="password">
                                                    <h3 class="h3 content-title">Đổi Mật Khẩu</h3>
                                                    <p>Đặt mật khẩu mới để tăng cường bảo mật tài khoản.</p>

                                                    <form class="account-form" method="post"
                                                        action="${pageContext.request.contextPath}/account">
                                                        <input type="hidden" name="action" value="change-password" />

                                                        <div class="input-group">
                                                            <label for="current-password">Mật khẩu hiện tại</label>
                                                            <input type="password" id="current-password"
                                                                name="currentPassword" required />
                                                        </div>

                                                        <div class="input-group">
                                                            <label for="new-password">Mật khẩu mới</label>
                                                            <input type="password" id="new-password" name="newPassword"
                                                                required />
                                                        </div>

                                                        <div class="input-group">
                                                            <label for="confirm-password">Xác nhận mật khẩu mới</label>
                                                            <input type="password" id="confirm-password"
                                                                name="confirmPassword" required />
                                                        </div>

                                                        <button type="submit" class="btn btn-primary btn-save">Đổi Mật
                                                            Khẩu</button>
                                                    </form>
                                                </section>
                                                <section id="order-history" class="tab-content" data-content="orders">
                                                    <h3 class="h3 content-title">Lịch Sử Đơn Hàng</h3>
                                                    <p>Theo dõi trạng thái và lịch sử các đơn hàng của bạn.</p>

                                                    <c:choose>
                                                        <c:when test="${empty orderHistory}">
                                                            <div class="empty-orders">
                                                                <ion-icon name="cart-outline"
                                                                    style="font-size: 64px; color: #ccc;"></ion-icon>
                                                                <p style="color: #888; margin-top: 16px;">Bạn chưa có
                                                                    đơn
                                                                    hàng nào.</p>
                                                                <a href="${pageContext.request.contextPath}/products"
                                                                    class="btn btn-primary"
                                                                    style="margin-top: 16px;">Mua
                                                                    sắm ngay</a>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="order-list">
                                                                <c:forEach var="order" items="${orderHistory}">
                                                                    <div class="order-card">
                                                                        <div class="order-header">
                                                                            <div class="order-info">
                                                                                <span class="order-id">Đơn hàng
                                                                                    #${order.id}</span>
                                                                                <span class="order-date">
                                                                                    <c:if
                                                                                        test="${order.createdAt != null}">
                                                                                        ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year}
                                                                                    </c:if>
                                                                                </span>
                                                                            </div>
                                                                            <div class="order-status-wrapper">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${order.orderStatus == 'NEW'}">
                                                                                        <span
                                                                                            class="order-status status-new">Mới
                                                                                            đặt</span>
                                                                                    </c:when>
                                                                                    <c:when
                                                                                        test="${order.orderStatus == 'PROCESSING'}">
                                                                                        <span
                                                                                            class="order-status status-processing">Đang
                                                                                            xử lý</span>
                                                                                    </c:when>
                                                                                    <c:when
                                                                                        test="${order.orderStatus == 'DELIVERED'}">
                                                                                        <span
                                                                                            class="order-status status-delivered">Đã
                                                                                            giao</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="order-status">${order.orderStatus}</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Danh sách sản phẩm -->
                                                                        <div class="order-products">
                                                                            <c:forEach var="item"
                                                                                items="${order.items}">
                                                                                <div class="order-product-item">
                                                                                    <div class="product-image">
                                                                                        <img src="${item.imageUrl}"
                                                                                            alt="${item.productName}"
                                                                                            onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'" />
                                                                                    </div>
                                                                                    <div class="product-info">
                                                                                        <span
                                                                                            class="product-name">${item.productName}</span>
                                                                                        <span class="product-variant">
                                                                                            <c:if
                                                                                                test="${item.colorName != null}">
                                                                                                Màu: ${item.colorName}
                                                                                            </c:if>
                                                                                            <c:if
                                                                                                test="${item.sizeName != null}">
                                                                                                | Size: ${item.sizeName}
                                                                                            </c:if>
                                                                                        </span>
                                                                                        <span class="product-qty">x
                                                                                            ${item.quantity}</span>
                                                                                    </div>
                                                                                    <div class="product-price">
                                                                                        <fmt:formatNumber
                                                                                            value="${item.unitPrice}"
                                                                                            type="number"
                                                                                            groupingUsed="true" />đ
                                                                                    </div>
                                                                                </div>
                                                                            </c:forEach>
                                                                        </div>

                                                                        <div class="order-body">
                                                                            <div class="order-detail-row">
                                                                                <span class="label">Tạm tính:</span>
                                                                                <span class="value">
                                                                                    <fmt:formatNumber
                                                                                        value="${order.subTotal}"
                                                                                        type="number"
                                                                                        groupingUsed="true" />
                                                                                    đ
                                                                                </span>
                                                                            </div>
                                                                            <div class="order-detail-row">
                                                                                <span class="label">Phí vận
                                                                                    chuyển:</span>
                                                                                <span class="value">
                                                                                    <fmt:formatNumber
                                                                                        value="${order.shippingFee}"
                                                                                        type="number"
                                                                                        groupingUsed="true" />
                                                                                    đ
                                                                                </span>
                                                                            </div>
                                                                            <div class="order-detail-row total">
                                                                                <span class="label">Tổng cộng:</span>
                                                                                <span class="value total-price">
                                                                                    <fmt:formatNumber
                                                                                        value="${order.grandTotal}"
                                                                                        type="number"
                                                                                        groupingUsed="true" />
                                                                                    đ
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                        <div class="order-footer">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${order.paymentStatus == 'PAID'}">
                                                                                    <span
                                                                                        class="payment-status paid"><ion-icon
                                                                                            name="checkmark-circle"></ion-icon>
                                                                                        Đã thanh toán</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="payment-status unpaid"><ion-icon
                                                                                            name="time-outline"></ion-icon>
                                                                                        Chưa thanh toán</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </section>
                                    </div>
                                </div>
                            </div>

                            <div class="modal" id="addressModal"></div>

                            <div class="modal" id="logoutModal" style="display: none;">
                                <div class="modal-content">
                                    <span class="close-btn" id="closeLogout">&times;</span>
                                    <h3 class="h3 modal-title">Xác nhận đăng xuất</h3>
                                    <p>Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?</p>

                                    <div class="modal-actions">
                                        <button type="button" class="btn btn-secondary" id="cancelLogout">Không</button>

                                        <a href="${pageContext.request.contextPath}/logout"
                                            class="btn-confirm-logout">Có,
                                            đăng
                                            xuất</a>
                                    </div>
                                </div>
                            </div>

                        </main>

                        <jsp:include page="Footer.jsp" />

                        <jsp:include page="body-scripts.jsp"></jsp:include>
                        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                        <script>
                            // Inject context path từ server vào JS
                            const CONTEXT_PATH = "${pageContext.request.contextPath}";
                        </script>
                        <script src="${pageContext.request.contextPath}/assets/script/pageaccount.js"></script>
                        <script src="${pageContext.request.contextPath}/assets/script/account.js"></script>

                    </body>

                    </html>