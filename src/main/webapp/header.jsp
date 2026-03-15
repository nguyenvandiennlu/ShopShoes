<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <header class="header">
            <div class="container">
                <div class="overlay"></div>

                <!-- LOGO -->
                <a href="${pageContext.request.contextPath}/menu" class="logo">
                    <img src="${pageContext.request.contextPath}/assets/images/BHD%20LOGO.png" width="100" height="50"
                        alt="BHD logo" />
                </a>

                <button class="nav-open-btn">
                    <ion-icon name="menu-outline"></ion-icon>
                </button>

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


                    <!-- ACTION -->
                    <ul class="nav-action-list">

                        <!-- SEARCH -->
                        <li>
                            <button class="nav-action-btn" id="searchToggleBtn">
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
                                        <ion-icon name="person-outline"></ion-icon>
                                        <span class="nav-action-text">
                                            ${sessionScope.currentUser.fullName}
                                        </span>
                                    </a>
                                    <div class="dropdown-content">
                                        <a href="${pageContext.request.contextPath}/account">Tài khoản</a>
                                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- WISHLIST -->
                        <li class="nav-action-item">
                            <a href="${pageContext.request.contextPath}/wishlist" class="nav-action-btn">
                                <ion-icon name="heart-outline"></ion-icon>
                            </a>
                        </li>

                        <!-- CART -->
                        <li class="nav-action-item">
                            <a href="${pageContext.request.contextPath}/cart" class="nav-action-btn cart-btn">
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

                    <!-- SEARCH FORM -->
                    <form class="search-form" id="search-form" action="${pageContext.request.contextPath}/products"
                        method="get">
                        <input type="search" name="q" placeholder="Tìm kiếm sản phẩm..." required />
                        <button type="button" class="search-close-btn" id="searchCloseBtn">
                            <ion-icon name="close-outline"></ion-icon>
                        </button>
                    </form>

                </nav>
            </div>
        </header>