<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <ul class="product-list grid-list">
            <c:forEach items="${productList}" var="p">
                <li class="product-item">
                    <div class="product-card" tabindex="0">
                        <figure class="card-banner">

                            <c:choose>
                                <c:when test="${p.mainImageUrl != null && p.mainImageUrl.startsWith('http')}">
                                    <img src="${p.mainImageUrl}" loading="lazy" alt="${p.name}" class="image-contain" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${p.mainImageUrl}" loading="lazy"
                                        alt="${p.name}" class="image-contain" />
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${p.isNew}">
                                <div class="card-badge">New</div>
                            </c:if>
                        </figure>

                        <div class="card-content">
                            <h3 class="h3 card-title">
                                <a href="${pageContext.request.contextPath}/product?id=${p.id}">
                                    ${p.name}
                                </a>
                            </h3>

                            <div class="product-card-price">
                                <c:choose>
                                    <c:when test="${p.price eq p.finalPrice}">
                                        <span class="discounted-price">${p.price}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="price-row">
                                            <span class="discounted-price">${p.finalPrice}</span>
                                            <span class="original-price">${p.price}</span>
                                        </div>

                                        <c:if test="${not empty p.discountValue}">
                                            <div class="discount-badge-wrapper">
                                                <span class="discount-value">Giảm: ${p.discountValue}</span>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </li>
            </c:forEach>
        </ul>

        <div class="pagination">

            <!-- Prev -->
            <button class="page-btn prev-btn ${page==1 ? 'disabled' : ''}" data-page="${page-1}" ${page==1 ? 'disabled'
                : '' }>&laquo;</button>

            <!-- Trang 1 -->
            <button class="page-btn page-number ${page==1 ? 'active' : ''}" data-page="1">1</button>

            <!-- Dấu ... đầu -->
            <c:if test="${page > 4}">
                <span class="page-dots">...</span>
            </c:if>

            <!-- Nhóm giữa: từ (page-2) đến (page+2) nhưng chặn trong [2..totalPages-1] -->
            <c:set var="start" value="${page-2}" />
            <c:set var="end" value="${page+2}" />

            <c:if test="${start < 2}">
                <c:set var="start" value="2" />
            </c:if>
            <c:if test="${end > totalPages-1}">
                <c:set var="end" value="${totalPages-1}" />
            </c:if>

            <c:forEach begin="${start}" end="${end}" var="i">
                <button class="page-btn page-number ${i==page ? 'active' : ''}" data-page="${i}">
                    ${i}
                </button>
            </c:forEach>

            <!-- Dấu ... cuối -->
            <c:if test="${page < totalPages - 3}">
                <span class="page-dots">...</span>
            </c:if>

            <!-- Trang cuối (nếu > 1) -->
            <c:if test="${totalPages > 1}">
                <button class="page-btn page-number ${page==totalPages ? 'active' : ''}" data-page="${totalPages}">
                    ${totalPages}
                </button>
            </c:if>

            <!-- Next -->
            <button class="page-btn next-btn ${page==totalPages ? 'disabled' : ''}" data-page="${page+1}"
                ${page==totalPages ? 'disabled' : '' }>&raquo;</button>
        </div>