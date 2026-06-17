<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<style>
  .admin-sidebar {
    width: 250px;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    background-color: #101720;
    z-index: 1040;
    display: flex;
    flex-direction: column;
  }
  .admin-sidebar .admin-nav-link {
    color: #a0a0a0;
    font-family: 'Josefin Sans', sans-serif;
    font-size: 16px;
    font-weight: 500;
    padding: 0.75rem 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    border-left: 4px solid transparent;
    transition: all 0.2s;
    text-decoration: none;
  }
  .admin-sidebar .admin-nav-link:hover {
    color: white;
    background-color: rgba(255, 255, 255, 0.08);
  }
  .admin-sidebar .admin-nav-link.active {
    color: white;
    background-color: rgba(255, 255, 255, 0.05);
    border-left-color: #FF675C;
    font-weight: 700;
  }
  .admin-sidebar .admin-nav-link .material-symbols-outlined {
    font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24;
  }
  .admin-sidebar .admin-nav-link.active .material-symbols-outlined {
    font-variation-settings: "FILL" 1, "wght" 700, "GRAD" 0, "opsz" 24;
  }
  .admin-sidebar-footer {
    margin-top: auto;
    padding: 1.5rem;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
  }
  .admin-btn-bittersweet {
    background-color: #FF675C;
    color: white;
    font-family: 'Josefin Sans', sans-serif;
    font-weight: 600;
    border: none;
    border-radius: 0.25rem;
    padding: 0.6rem 1rem;
    display: block;
    text-align: center;
    text-decoration: none;
    margin-bottom: 0.75rem;
  }
  .admin-btn-bittersweet.active {
    box-shadow: 0 0 0 2px rgba(255, 255, 255, 0.25) inset;
    background-color: #ff756b;
  }
  .admin-logout-link {
    color: #a0a0a0;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    text-decoration: none;
    font-family: 'Josefin Sans', sans-serif;
    font-size: 15px;
    padding: 0.5rem 0;
  }
  .admin-logout-link:hover {
    color: white;
  }
</style>
<%@ page import="model.user.User" %>
<%@ page import="enums.Role" %>
<%@ page import="java.util.Map" %>
<%
    String adminActive = (String) request.getAttribute("adminActive");
    if (adminActive == null) {
        adminActive = "";
    }

    User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
    Role role = (currentUser != null) ? currentUser.getRole() : null;
    boolean isSuperAdmin = (role == Role.SUPER_ADMIN);

    Map<String, Integer> permissions = null;
    if (!isSuperAdmin && session != null) {
        permissions = (Map<String, Integer>) session.getAttribute("userPermissions");
        if (permissions == null && role != null) {
            dao.user.RolePermissionDao rpDao = new dao.user.RolePermissionDao();
            permissions = rpDao.getPermissionsForRole(role.name());
            session.setAttribute("userPermissions", permissions);
        }
    }
%>
<nav class="admin-sidebar">
    <div class="p-4 d-flex align-items-center gap-2">
        <a href="${pageContext.request.contextPath}/admin/adminHome.jsp" class="d-inline-block flex-shrink-0">
            <img src="${pageContext.request.contextPath}/assets/images/BHD%20LOGO.png" alt="BHD Sport" style="max-height: 45px; width: auto;" />
        </a>
        <span class="text-secondary fw-semibold" style="font-size: 13px; white-space: nowrap;">Trang Admin</span>
    </div>
    <div class="flex-grow-1 overflow-auto">
        <ul class="nav flex-column mt-2">
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("dashboard", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "dashboard".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                    <span class="material-symbols-outlined">dashboard</span>
                    Bảng điều khiển
                </a>
            </li>
            <% } %>
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("orders", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "orders".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/orders">
                    <span class="material-symbols-outlined">shopping_cart</span>
                    Đơn hàng
                </a>
            </li>
            <% } %>
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("products", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "inventory".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
                    <span class="material-symbols-outlined">inventory_2</span>
                    Kho hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "promotions".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/promotions">
                    <span class="material-symbols-outlined">sell</span>
                    Khuyến mãi
                </a>
            </li>
            <% } %>
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("users", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "customers".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/users">
                    <span class="material-symbols-outlined">group</span>
                    Khách hàng
                </a>
            </li>
            <% } %>
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("statistics", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "reports".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                    <span class="material-symbols-outlined">bar_chart</span>
                    Báo cáo
                </a>
            </li>
            <% } %>
            <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("settings", 0) > 0)) { %>
            <li class="nav-item">
                <a class="admin-nav-link <%= "settings".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/settings">
                    <span class="material-symbols-outlined">settings</span>
                    Cài đặt
                </a>
            </li>
            <% } %>
        </ul>
    </div>
    <div class="admin-sidebar-footer">
        <% if (isSuperAdmin || (permissions != null && permissions.getOrDefault("products", 0) >= 2)) { %>
        <a class="admin-btn-bittersweet <%= "add-product".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/addproduct.jsp">Thêm sản phẩm mới</a>
        <% } %>
        <a class="admin-logout-link" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</nav>
