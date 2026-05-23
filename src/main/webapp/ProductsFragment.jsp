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

<c:set var="currentPage" value="${empty page ? 1 : page}" />
<div class="pagination">
    <button type="button" class="page-btn prev-btn ${currentPage == 1 ? 'disabled' : ''}"
            data-page="${currentPage - 1}" ${currentPage == 1 ? 'disabled' : ''}>&laquo;</button>

    <button type="button" class="page-btn page-number ${currentPage == 1 ? 'active' : ''}" data-page="1">1</button>

    <c:if test="${currentPage > 4}">
        <span class="page-dots">...</span>
    </c:if>

    <c:set var="start" value="${currentPage - 2}" />
    <c:set var="end" value="${currentPage + 2}" />

    <c:if test="${start < 2}">
        <c:set var="start" value="2" />
    </c:if>
    <c:if test="${end > totalPages - 1}">
        <c:set var="end" value="${totalPages - 1}" />
    </c:if>

    <c:forEach begin="${start}" end="${end}" var="i">
        <button type="button" class="page-btn page-number ${i == currentPage ? 'active' : ''}" data-page="${i}">
                ${i}
        </button>
    </c:forEach>

    <c:if test="${currentPage < totalPages - 3}">
        <span class="page-dots">...</span>
    </c:if>

    <c:if test="${totalPages > 1}">
        <button type="button" class="page-btn page-number ${currentPage == totalPages ? 'active' : ''}"
                data-page="${totalPages}">
                ${totalPages}
        </button>
    </c:if>

    <button type="button" class="page-btn next-btn ${currentPage == totalPages ? 'disabled' : ''}"
            data-page="${currentPage + 1}" ${currentPage == totalPages ? 'disabled' : ''}>&raquo;</button>
</div>
