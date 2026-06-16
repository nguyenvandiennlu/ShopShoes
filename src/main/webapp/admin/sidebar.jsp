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
<%
    String adminActive = (String) request.getAttribute("adminActive");
    if (adminActive == null) {
        adminActive = "";
    }
%>
<nav class="admin-sidebar">
    <div class="p-4">
        <h4 class="mb-0 text-white" style="font-size: 22px;">BHD Sport</h4>
        <small class="text-secondary" style="font-size: 12px;">Admin Panel</small>
    </div>
    <div class="flex-grow-1 overflow-auto">
        <ul class="nav flex-column mt-2">
            <li class="nav-item">
                <a class="admin-nav-link <%= "dashboard".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/adminHome.jsp">
                    <span class="material-symbols-outlined">dashboard</span>
                    Bảng điều khiển
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "orders".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/quanlydonhang.jsp">
                    <span class="material-symbols-outlined">shopping_cart</span>
                    Đơn hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "inventory".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/quanlykhohang.jsp">
                    <span class="material-symbols-outlined">inventory_2</span>
                    Kho hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "customers".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/users">
                    <span class="material-symbols-outlined">group</span>
                    Khách hàng
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "reports".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/thongke.jsp">
                    <span class="material-symbols-outlined">bar_chart</span>
                    Báo cáo
                </a>
            </li>
            <li class="nav-item">
                <a class="admin-nav-link <%= "settings".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/settings">
                    <span class="material-symbols-outlined">settings</span>
                    Cài đặt
                </a>
            </li>
        </ul>
    </div>
    <div class="admin-sidebar-footer">
        <a class="admin-btn-bittersweet <%= "add-product".equals(adminActive) ? "active" : "" %>" href="${pageContext.request.contextPath}/admin/addproduct.jsp">Thêm sản phẩm mới</a>
        <a class="admin-logout-link" href="${pageContext.request.contextPath}/logout">
            <span class="material-symbols-outlined">logout</span>
            <span>Đăng xuất</span>
        </a>
    </div>
</nav>
