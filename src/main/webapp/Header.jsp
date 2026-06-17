<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header class="header">
            <div class="container header-container">
                <div class="overlay"></div>

                <!-- LEFT SECTION: LOGO + DESKTOP NAVIGATION -->
                <div class="header-left">
                    <!-- LOGO -->
                    <a href="${pageContext.request.contextPath}/menu" class="logo">
                        <img src="${pageContext.request.contextPath}/assets/images/BHD%20LOGO.png" width="100" height="50"
                            alt="BHD logo" />
                    </a>

                    <!-- DESKTOP NAVIGATION -->
                    <nav class="navbar-desktop">
                        <ul class="navbar-list-desktop">
                            <li>
                                <a href="${pageContext.request.contextPath}/menu" class="navbar-link">
                                    Trang chủ
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/gioi-thieu" class="navbar-link">
                                    Giới thiệu
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/products" class="navbar-link">
                                    Sản phẩm
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/lien-he" class="navbar-link">
                                    Liên hệ
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>

                <!-- MIDDLE SECTION: SEARCH FORM -->
                <div class="search-wrapper header-middle">
                    <form class="search-form" id="search-form" action="${pageContext.request.contextPath}/products"
                        method="get">
                        <div class="search-input-wrapper">
                            <input type="search" name="q" id="search-input" placeholder="Tìm kiếm sản phẩm..." />
                            <button type="submit" class="search-submit-btn" id="searchSubmitBtn">
                                <ion-icon name="search-outline"></ion-icon>
                            </button>
                        </div>
                        <!-- SEARCH SUGGESTIONS DROPDOWN -->
                        <div class="search-suggestions" id="search-suggestions">
                            <ul class="suggestions-list" id="suggestions-list"></ul>
                            <div class="suggestions-footer" id="suggestions-footer">
                                <a href="#" class="view-all-link" id="view-all-link">Xem tất cả kết quả</a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- RIGHT SECTION: DESKTOP ACTION BUTTONS -->
                <div class="header-right">
                    <ul class="nav-action-list-desktop">
                        <!-- USER -->
                        <li class="nav-action-item nav-action-dropdown">
                            <c:choose>
                                <c:when test="${empty sessionScope.currentUser}">
                                    <a href="${pageContext.request.contextPath}/login" class="nav-action-btn" title="Tài khoản">
                                        <ion-icon name="person-outline"></ion-icon>
                                    </a>
                                    <div class="dropdown-content">
                                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                        <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <a href="#" class="nav-action-btn" title="Tài khoản">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                                <img
                                                    src="${sessionScope.currentUser.avatarUrl}"
                                                    alt="${sessionScope.currentUser.fullName}"
                                                    class="header-avatar"
                                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                                                <ion-icon name="person-outline" style="display:none"></ion-icon>
                                            </c:when>
                                            <c:otherwise>
                                                <ion-icon name="person-outline"></ion-icon>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                    <div class="dropdown-content">
                                        <a href="${pageContext.request.contextPath}/account">Tài khoản</a>
                                        <c:if test="${sessionScope.currentUser.role eq 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Admin</a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- WISHLIST -->
                        <li class="nav-action-item" style="position:relative">
                            <a href="${pageContext.request.contextPath}/wishlist" class="nav-action-btn wishlist-btn" title="Yêu thích">
                                <ion-icon name="heart-outline"></ion-icon>
                                <c:if test="${not empty sessionScope.wishlistCount and sessionScope.wishlistCount > 0}">
                                    <span class="cart-badge wishlist-badge">${sessionScope.wishlistCount}</span>
                                </c:if>
                            </a>
                        </li>

                        <!-- CART -->
                        <li class="nav-action-item">
                            <a href="${pageContext.request.contextPath}/cart" class="nav-action-btn cart-btn" title="Giỏ hàng">
                                <ion-icon name="bag-outline"></ion-icon>
                                <c:set var="cartCount" value="0" />
                                <c:if test="${not empty sessionScope.cart}">
                                    <c:forEach var="entry" items="${sessionScope.cart}">
                                        <c:set var="cartCount" value="${cartCount + entry.value.quantity}" />
                                    </c:forEach>
                                </c:if>
                                <c:if test="${cartCount > 0}">
                                    <span class="cart-badge">${cartCount}</span>
                                </c:if>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- MOBILE MENU BUTTON -->
                <button class="nav-open-btn">
                    <ion-icon name="menu-outline"></ion-icon>
                </button>

                <!-- MOBILE NAVIGATION -->
                <nav class="navbar">

                    <button class="nav-close-btn" data-nav-close-btn>
                        <ion-icon name="close-outline"></ion-icon>
                    </button>

                    <!-- MENU -->
                    <ul class="navbar-list">
                        <li>
                            <a href="${pageContext.request.contextPath}/menu" class="navbar-link">
                                Trang chủ
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/gioi-thieu" class="navbar-link">
                                Giới thiệu
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/products" class="navbar-link">
                                Sản phẩm
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/lien-he" class="navbar-link">
                                Liên hệ
                            </a>
                        </li>
                    </ul>

                    <!-- MOBILE ACTION -->
                    <ul class="nav-action-list">

                        <!-- SEARCH -->
                        <li>
                            <button class="nav-action-btn" id="searchToggleBtnMobile">
                                <ion-icon name="search-outline"></ion-icon>
                                <span class="nav-action-text">Tìm kiếm</span>
                            </button>
                        </li>

                        <!-- USER -->
                        <li class="nav-action-item nav-action-dropdown">
                            <c:choose>
                                <c:when test="${empty sessionScope.currentUser}">
                                    <a href="${pageContext.request.contextPath}/login" class="nav-action-btn">
                                        <ion-icon name="person-outline"></ion-icon>
                                        <span class="nav-action-text">Đăng nhập / Đăng ký</span>
                                    </a>
                                    <div class="dropdown-content">
                                        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                        <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <a href="#" class="nav-action-btn">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                                                <img
                                                    src="${sessionScope.currentUser.avatarUrl}"
                                                    alt="${sessionScope.currentUser.fullName}"
                                                    class="header-avatar header-avatar-mobile"
                                                    onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                                                <ion-icon name="person-outline" style="display:none"></ion-icon>
                                            </c:when>
                                            <c:otherwise>
                                                <ion-icon name="person-outline"></ion-icon>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="nav-action-text">
                                            ${sessionScope.currentUser.fullName}
                                        </span>
                                    </a>
                                    <div class="dropdown-content">
                                        <a href="${pageContext.request.contextPath}/account">Tài khoản</a>
                                        <c:if test="${sessionScope.currentUser.role eq 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- WISHLIST -->
                        <li class="nav-action-item">
                            <a href="${pageContext.request.contextPath}/wishlist" class="nav-action-btn wishlist-btn">
                                <ion-icon name="heart-outline"></ion-icon>
                                <span class="nav-action-text">Yêu thích</span>
                                <c:if test="${not empty sessionScope.wishlistCount and sessionScope.wishlistCount > 0}">
                                    <span class="nav-badge-count">${sessionScope.wishlistCount}</span>
                                </c:if>
                            </a>
                        </li>

                        <!-- CART -->
                        <li class="nav-action-item">
                            <a href="${pageContext.request.contextPath}/cart" class="nav-action-btn cart-btn">
                                <ion-icon name="bag-outline"></ion-icon>
                                <span class="nav-action-text">Giỏ hàng</span>
                                <c:set var="cartCountMobile" value="0" />
                                <c:if test="${not empty sessionScope.cart}">
                                    <c:forEach var="entry" items="${sessionScope.cart}">
                                        <c:set var="cartCountMobile" value="${cartCountMobile + entry.value.quantity}" />
                                    </c:forEach>
                                </c:if>
                                <c:if test="${cartCountMobile > 0}">
                                    <span class="nav-badge-count">${cartCountMobile}</span>
                                </c:if>
                            </a>
                        </li>
                    </ul>

                </nav>
            </div>
        </header>

<script>
    var CONTEXT_PATH = CONTEXT_PATH || "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/script/search-autocomplete.js"></script>
