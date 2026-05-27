<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="utils.BreadcrumbGenerator" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Lấy path từ request
    String requestPath = request.getRequestURI();
    if (requestPath.contains("/ShopShoes_war_exploded")) {
        requestPath = requestPath.substring("/ShopShoes_war_exploded".length());
    } else if (requestPath.contains("/ShopShoes")) {
        requestPath = requestPath.substring("/ShopShoes".length());
    }
    
    // Tạo breadcrumb
    List<BreadcrumbGenerator.BreadcrumbItem> breadcrumbItems = BreadcrumbGenerator.generateBreadcrumb(requestPath);
    request.setAttribute("breadcrumbItems", breadcrumbItems);
%>

<div class="breadcrumb-container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <c:forEach var="item" items="${breadcrumbItems}" varStatus="status">
                <li class="breadcrumb-item <c:if test='${status.last}'>active</c:if>">
                    <c:choose>
                        <c:when test="${status.last}">
                            <span aria-current="page">${item.label}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}${item.url}">${item.label}</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>
        </ol>
    </nav>
</div>
