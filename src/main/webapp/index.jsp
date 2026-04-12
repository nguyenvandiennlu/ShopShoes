<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String uri = request.getRequestURI();
    String context = request.getContextPath();
    String path = uri.substring(context.length());

    if (path.equals("") || path.equals("/")) {
        response.sendRedirect(context + "/menu");
        return;
    }
%>