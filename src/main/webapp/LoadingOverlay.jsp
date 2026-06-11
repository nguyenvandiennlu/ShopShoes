<%--
  Shared Loading Overlay Component
  Include this in any page that needs a loading spinner popup.
  Usage:
    1. <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/loading-overlay.css" /> (in head)
    2. <jsp:include page="LoadingOverlay.jsp" /> (before </body>)
    3. <script src="${pageContext.request.contextPath}/assets/script/loading-overlay.js"></script> (after include)
    4. Call showLoadingOverlay('loadingOverlay') to show, hideLoadingOverlay('loadingOverlay') to hide
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="loadingOverlay" class="loading-overlay">
    <div class="loading-container">
        <div class="spinner"></div>
        <div class="loading-text" id="loadingText">Đang xử lý...</div>
    </div>
</div>