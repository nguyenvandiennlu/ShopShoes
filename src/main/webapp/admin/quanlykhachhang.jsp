<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.user.User" %>
<%@ page import="enums.Role" %>
<%@ page import="java.util.Map" %>
<%
    request.setAttribute("adminActive", "customers");
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
    
    boolean canAddUser = isSuperAdmin || (permissions != null && (permissions.getOrDefault("users", 0) & 2) == 2);
    boolean canEditUser = isSuperAdmin || (permissions != null && (permissions.getOrDefault("users", 0) & 4) == 4);
    boolean canDeleteUser = isSuperAdmin || (permissions != null && (permissions.getOrDefault("users", 0) & 8) == 8);
    pageContext.setAttribute("canAddUser", Boolean.valueOf(canAddUser));
    pageContext.setAttribute("canEditUser", Boolean.valueOf(canEditUser));
    pageContext.setAttribute("canDeleteUser", Boolean.valueOf(canDeleteUser));
%>
<!DOCTYPE html>

<html lang="vi"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Quản lý Khách hàng - BHD Sport Shoes</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@400;500;600;700&amp;family=Roboto:wght@400;500;700&amp;display=swap" rel="stylesheet"/>
    <!-- Material Symbols (chỉ tải weight=400, fill=0 và fill=1 để giảm kích thước) -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0&display=swap" rel="stylesheet"/>
    <!-- Page CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/quanlykhachhang.css" rel="stylesheet"/>

</head>
<body>
<jsp:include page="sidebar.jsp"/>

<jsp:include page="topbar.jsp"/>

<main class="main-content">
    <!-- Breadcrumb & Header -->
    <div>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/adminHome.jsp">Trang chủ</a></li>
                <li aria-current="page" class="breadcrumb-item active">Quản lý Khách hàng</li>
            </ol>
        </nav>
        <div class="page-header">
            <div>
                <h2 class="page-title">Quản lý Khách hàng</h2>
                <p class="page-subtitle">Theo dõi và quản lý danh sách người dùng hệ thống.</p>
            </div>
            <% if (canAddUser) { %>
            <button class="btn btn-bittersweet" id="btnAddUser">
                <span class="material-symbols-outlined fs-6">person_add</span>
                Thêm Khách Hàng
            </button>
            <% } %>
        </div>
    </div>
    <!-- Filter Bar -->
    <div class="card-custom">
        <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/admin/users">
            <div class="row g-3 align-items-end">
                <div class="col-12 col-lg-5">
                    <label class="form-label-custom">Tìm kiếm</label>
                    <div class="search-input-wrapper">
                        <span class="material-symbols-outlined">search</span>
                        <input id="searchInput" class="form-control-custom" name="search"
                               placeholder="Tên hoặc email..." type="text"
                               value="<c:out value='${search}'/>"/>
                    </div>
                </div>
                <div class="col-12 col-md-4 col-lg-3">
                    <label class="form-label-custom">Vai trò</label>
                    <select id="roleFilter" class="form-select-custom" name="role">
                        <option value="all" ${role == 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="SUPER_ADMIN" ${role == 'SUPER_ADMIN' ? 'selected' : ''}>SUPER_ADMIN</option>
                        <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        <option value="SALES_STAFF" ${role == 'SALES_STAFF' ? 'selected' : ''}>SALES_STAFF</option>
                        <option value="WAREHOUSE_STAFF" ${role == 'WAREHOUSE_STAFF' ? 'selected' : ''}>WAREHOUSE_STAFF</option>
                        <option value="USER" ${role == 'USER' ? 'selected' : ''}>USER</option>
                    </select>
                </div>
                <div class="col-12 col-md-4 col-lg-2">
                    <label class="form-label-custom">Trạng thái</label>
                    <select id="statusFilter" class="form-select-custom" name="status">
                        <option value="all" ${status == 'all' ? 'selected' : ''}>Tất cả</option>
                        <option value="active" ${status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="locked" ${status == 'locked' ? 'selected' : ''}>Bị khóa</option>
                    </select>
                </div>
                <div class="col-12 col-md-4 col-lg-2">
                    <button type="submit" class="btn-filter">
                        <span class="material-symbols-outlined fs-6">filter_list</span>
                        Lọc
                    </button>
                </div>
            </div>
        </form>
    </div>
    <!-- Data Table -->
    <div class="card-table-container">
        <div class="table-responsive">
            <table class="table table-custom table-hover">
                <thead>
                <tr>
                    <th width="4%">#</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th width="12%">Số điện thoại</th>
                    <th width="10%">Vai trò</th>
                    <th width="12%">Trạng thái</th>
                    <th width="12%">Ngày tạo</th>
                    <th class="text-end" width="10%">Thao tác</th>
                </tr>
                </thead>
                <tbody id="tableBody">
                <c:choose>
                    <c:when test="${empty usersList}">
                        <tr>
                            <td colspan="8" class="text-center text-secondary py-4">Không tìm thấy người dùng nào phù hợp.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="u" items="${usersList}" varStatus="loop">
                            <tr class="${!u.active ? 'locked' : ''}">
                                <td class="text-secondary">${(currentPage - 1) * 10 + loop.index + 1}</td>
                                <td>
                                    <div class="user-cell">
                                        <img alt="Avatar" class="avatar-sm" src="<c:choose><c:when test='${not empty u.avatarUrl}'>${u.avatarUrl}</c:when><c:otherwise>data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='50' fill='%23e8e8e8'/%3E%3Ccircle cx='50' cy='38' r='18' fill='%23bbb'/%3E%3Cellipse cx='50' cy='85' rx='28' ry='20' fill='%23bbb'/%3E%3C/svg%3E</c:otherwise></c:choose>" onerror="this.onerror=null;this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'32\' height=\'32\' viewBox=\'0 0 100 100\'%3E%3Ccircle cx=\'50\' cy=\'50\' r=\'50\' fill=\'%23e8e8e8\'/%3E%3Ccircle cx=\'50\' cy=\'38\' r=\'18\' fill=\'%23bbb\'/%3E%3Cellipse cx=\'50\' cy=\'85\' rx=\'28\' ry=\'20\' fill=\'%23bbb\'/%3E%3C/svg%3E'"/>
                                        <span class="user-name <c:if test='${!u.active}'>text-secondary text-decoration-line-through</c:if>"><c:out value="${u.fullName}"/></span>
                                    </div>
                                </td>
                                <td class="text-secondary email-cell"><c:out value="${u.email}"/></td>
                                <td><c:out value="${u.phoneNumber}" default="Chưa cập nhật"/></td>
                                <td>
                                    <span class="badge-role ${u.role == 'SUPER_ADMIN' ? 'badge-role-superadmin' : (u.role == 'ADMIN' ? 'badge-role-admin' : (u.role == 'SALES_STAFF' ? 'badge-role-sales' : (u.role == 'WAREHOUSE_STAFF' ? 'badge-role-warehouse' : '')))}">
                                        <c:out value="${u.role}"/>
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.active}">
                                            <span class="badge-status badge-active" id="status-badge-${u.id}">
                                                <span class="dot"></span> Đang hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status badge-locked" id="status-badge-${u.id}">
                                                <span class="dot"></span> Bị khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-secondary">
                                    <c:choose>
                                        <c:when test="${not empty u.createdAt}">
                                            <c:set var="d" value="${u.createdAt.dayOfMonth}"/>
                                            <c:set var="m" value="${u.createdAt.monthValue}"/>
                                            <c:set var="y" value="${u.createdAt.year}"/>
                                            ${d < 10 ? '0' : ''}${d}/${m < 10 ? '0' : ''}${m}/${y}
                                        </c:when>
                                        <c:otherwise>Chưa rõ</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn btn-view-detail" title="Xem chi tiết"
                                                data-id="${u.id}"
                                                data-fullname="<c:out value='${u.fullName}'/>"
                                                data-email="<c:out value='${u.email}'/>"
                                                data-phone="<c:out value='${u.phoneNumber}'/>"
                                                data-address="<c:out value='${u.address}'/>"
                                                data-role="${u.role}"
                                                data-active="${u.active}"
                                                data-emailverified="${u.emailVerified}"
                                                data-firebase="${not empty u.firebaseUID and u.firebaseUID != ''}"
                                                data-avatar="<c:out value='${u.avatarUrl}'/>"
                                                data-createdat="<c:choose><c:when test='${not empty u.createdAt}'><c:set var='dd' value='${u.createdAt.dayOfMonth}'/><c:set var='mm' value='${u.createdAt.monthValue}'/><c:set var='yy' value='${u.createdAt.year}'/>${dd < 10 ? '0' : ''}${dd}/${mm < 10 ? '0' : ''}${mm}/${yy}</c:when><c:otherwise>Chưa rõ</c:otherwise></c:choose>">
                                            <span class="material-symbols-outlined">visibility</span>
                                        </button>
                                        <c:if test="${canEditUser}">
                                            <button class="action-btn btn-edit-user" title="Chỉnh sửa"
                                                    data-id="${u.id}"
                                                    data-fullname="<c:out value='${u.fullName}'/>"
                                                    data-email="<c:out value='${u.email}'/>"
                                                    data-phone="<c:out value='${u.phoneNumber}'/>"
                                                    data-address="<c:out value='${u.address}'/>"
                                                    data-role="${u.role}"
                                                    data-active="${u.active}">
                                                <span class="material-symbols-outlined">edit</span>
                                            </button>
                                        </c:if>
                                        <c:if test="${canDeleteUser}">
                                            <button class="action-btn btn-toggle-status ${!u.active ? 'locked' : ''}"
                                                    title="${u.active ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}"
                                                    data-id="${u.id}"
                                                    data-name="<c:out value='${u.fullName}'/>"
                                                    data-active="${u.active}">
                                                <span class="material-symbols-outlined icon-lock">${u.active ? 'lock_open' : 'lock'}</span>
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
        <div class="pagination-container">
            <span class="pagination-info" id="paginationInfo">Hiển thị ${(currentPage - 1) * 10 + 1} - ${(currentPage * 10) > totalCount ? totalCount : (currentPage * 10)} của ${totalCount} khách hàng</span>
            <div class="pagination-custom" id="paginationBtns">
                <button class="page-btn" ${currentPage == 1 ? 'disabled' : ''} onclick="fetchUsers(${currentPage - 1})">
                    <span class="material-symbols-outlined fs-6">chevron_left</span>
                </button>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <button class="page-btn ${currentPage == i ? 'active' : ''}" onclick="fetchUsers(${i})">${i}</button>
                </c:forEach>
                <button class="page-btn" ${currentPage == totalPages ? 'disabled' : ''} onclick="fetchUsers(${currentPage + 1})">
                    <span class="material-symbols-outlined fs-6">chevron_right</span>
                </button>
            </div>
        </div>
    </div>
</main>

<!-- ===================== USER DETAIL MODAL ===================== -->
<div class="modal-overlay" id="userDetailOverlay">
    <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="modalUserName">
        <!-- Header -->
        <div class="modal-header-custom" id="modalHeader">
            <button class="modal-close-btn" id="modalCloseTop" title="Đóng">
                <span class="material-symbols-outlined" style="font-size:18px;">close</span>
            </button>
            <img id="modalAvatar" class="modal-avatar" src="" alt="Avatar" />
            <p class="modal-user-name" id="modalUserName">Đang tải...</p>
            <p class="modal-user-email" id="modalUserEmail"></p>
            <div class="modal-badges">
                <span class="modal-id-badge" id="modalIdBadge">#ID</span>
                <span class="badge-role" id="modalRoleBadge">---</span>
            </div>
        </div>
        <!-- Body -->
        <div class="modal-body-custom">
            <div class="modal-info-grid" id="modalInfoGrid">
                <!-- Nội dung được điền bởi JS từ data-* attributes -->
            </div>
        </div>
        <!-- Footer -->
        <div class="modal-footer-custom">
            <button class="btn-modal-close" id="modalCloseBottom">Đóng</button>
        </div>
    </div>
</div>

<!-- ===================== EDIT USER MODAL ===================== -->
<div class="modal-overlay" id="editUserOverlay">
    <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="editModalTitle">
        <!-- Header -->
        <div class="modal-header-custom" style="padding: 1.5rem 1.5rem 1rem; align-items: flex-start; gap: 0.25rem;">
            <button class="modal-close-btn" id="editModalCloseTop" title="Đóng">
                <span class="material-symbols-outlined" style="font-size:18px;">close</span>
            </button>
            <h3 class="modal-user-name" id="editModalTitle" style="font-size: 20px; font-weight: 600; margin: 0; color: #fff;">Chỉnh sửa thông tin</h3>
            <p class="modal-user-email" id="editModalUserEmail" style="margin: 0; font-size: 13px; color: #aaa;"></p>
        </div>
        <!-- Body -->
        <div class="modal-body-custom" style="padding: 1.5rem;">
            <form id="editUserForm">
                <input type="hidden" id="editUserId" name="userId" />
                <div class="mb-3">
                    <label for="editFullName" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Họ và tên</label>
                    <input type="text" id="editFullName" name="fullName" class="form-control-custom" style="width:100%;" required />
                </div>
                <div class="mb-3">
                    <label for="editPhone" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Số điện thoại</label>
                    <input type="text" id="editPhone" name="phone" class="form-control-custom" style="width:100%;" />
                </div>
                <div class="mb-3">
                    <label for="editAddress" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Địa chỉ</label>
                    <input type="text" id="editAddress" name="address" class="form-control-custom" style="width:100%;" />
                </div>
                <input type="hidden" id="editActive" name="isActive" />
                <div class="mb-3">
                    <label for="editRole" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Vai trò</label>
                    <select id="editRole" name="role" class="form-select-custom" style="width:100%;">
                        <option value="USER">USER</option>
                        <option value="SALES_STAFF">SALES_STAFF</option>
                        <option value="WAREHOUSE_STAFF">WAREHOUSE_STAFF</option>
                        <option value="ADMIN">ADMIN</option>
                        <option value="SUPER_ADMIN">SUPER_ADMIN</option>
                    </select>
                </div>
            </form>
        </div>
        <!-- Footer -->
        <div class="modal-footer-custom" style="display: flex; gap: 10px; justify-content: flex-end; padding: 1rem 1.5rem;">
            <button class="btn-modal-close" id="editModalCloseBottom" style="background:#6c757d; border-color:#6c757d; margin:0;">Hủy</button>
            <button class="btn btn-bittersweet" id="editModalSaveBtn" style="padding: 8px 18px; border-radius: 6px; font-weight: 500; font-size: 14px; margin: 0; background: var(--bittersweet); border-color: var(--bittersweet);">Lưu thay đổi</button>
        </div>
    </div>
</div>

<!-- ===================== ADD USER MODAL ===================== -->
<div class="modal-overlay" id="addUserOverlay">
    <div class="modal-box" role="dialog" aria-modal="true" aria-labelledby="addModalTitle">
        <!-- Header -->
        <div class="modal-header-custom" style="padding: 1.5rem 1.5rem 1rem; align-items: flex-start; gap: 0.25rem;">
            <button class="modal-close-btn" id="addModalCloseTop" title="Đóng">
                <span class="material-symbols-outlined" style="font-size:18px;">close</span>
            </button>
            <h3 class="modal-user-name" id="addModalTitle" style="font-size: 20px; font-weight: 600; margin: 0; color: #fff;">Thêm khách hàng mới</h3>
            <p class="modal-user-email" style="margin: 0; font-size: 13px; color: #aaa;">Nhập thông tin cho tài khoản mới</p>
        </div>
        <!-- Body -->
        <div class="modal-body-custom" style="padding: 1.5rem;">
            <form id="addUserForm">
                <div class="mb-3">
                    <label for="addFullName" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Họ và tên</label>
                    <input type="text" id="addFullName" name="fullName" class="form-control-custom" style="width:100%;" placeholder="Nhập họ và tên..." required />
                </div>
                <div class="mb-3">
                    <label for="addEmail" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Email</label>
                    <input type="email" id="addEmail" name="email" class="form-control-custom" style="width:100%;" placeholder="example@gmail.com" required />
                </div>
                <div class="mb-3">
                    <label for="addPhone" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Số điện thoại</label>
                    <input type="text" id="addPhone" name="phone" class="form-control-custom" style="width:100%;" placeholder="Nhập số điện thoại..." required />
                </div>
                <div class="mb-3">
                    <label for="addPassword" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Mật khẩu</label>
                    <input type="password" id="addPassword" name="password" class="form-control-custom" style="width:100%;" placeholder="Tối thiểu 6 ký tự..." required />
                </div>
                <div class="mb-3">
                    <label for="addAddress" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Địa chỉ</label>
                    <input type="text" id="addAddress" name="address" class="form-control-custom" style="width:100%;" placeholder="Nhập địa chỉ..." />
                </div>
                <div class="mb-3">
                    <label for="addRole" class="form-label-custom" style="display:block; margin-bottom: 6px; font-weight:500;">Vai trò</label>
                    <select id="addRole" name="role" class="form-select-custom" style="width:100%;">
                        <option value="USER" selected>USER</option>
                        <option value="SALES_STAFF">SALES_STAFF</option>
                        <option value="WAREHOUSE_STAFF">WAREHOUSE_STAFF</option>
                        <option value="ADMIN">ADMIN</option>
                        <option value="SUPER_ADMIN">SUPER_ADMIN</option>
                    </select>
                </div>
            </form>
        </div>
        <!-- Footer -->
        <div class="modal-footer-custom" style="display: flex; gap: 10px; justify-content: flex-end; padding: 1rem 1.5rem;">
            <button class="btn-modal-close" id="addModalCloseBottom" style="background:#6c757d; border-color:#6c757d; margin:0;">Hủy</button>
            <button class="btn btn-bittersweet" id="addModalSaveBtn" style="padding: 8px 18px; border-radius: 6px; font-weight: 500; font-size: 14px; margin: 0; background: var(--bittersweet); border-color: var(--bittersweet);">Thêm mới</button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" defer></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const canEditUser = <%= canEditUser %>;
    const canDeleteUser = <%= canDeleteUser %>;

    // ============================================================
    // AJAX FILTER / PAGINATION
    // ============================================================
    var BASE_URL = '${pageContext.request.contextPath}/admin/users';
    var DEFAULT_AVATAR = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32' viewBox='0 0 100 100'%3E%3Ccircle cx='50' cy='50' r='50' fill='%23e8e8e8'/%3E%3Ccircle cx='50' cy='38' r='18' fill='%23bbb'/%3E%3Cellipse cx='50' cy='85' rx='28' ry='20' fill='%23bbb'/%3E%3C/svg%3E";
    var currentPage = ${not empty currentPage ? currentPage : 1};
    var debounceTimer = null;

    document.getElementById('filterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        fetchUsers(1);
    });
    document.getElementById('searchInput').addEventListener('input', function() {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(function() { fetchUsers(1); }, 400);
    });
    document.getElementById('roleFilter').addEventListener('change', function() { fetchUsers(1); });
    document.getElementById('statusFilter').addEventListener('change', function() { fetchUsers(1); });

    function fetchUsers(page) {
        currentPage = page;
        var search = document.getElementById('searchInput').value;
        var role   = document.getElementById('roleFilter').value;
        var status = document.getElementById('statusFilter').value;
        var url = BASE_URL + '?page=' + page + '&search=' + encodeURIComponent(search) + '&role=' + encodeURIComponent(role) + '&status=' + encodeURIComponent(status);
        document.getElementById('tableBody').innerHTML =
            '<tr><td colspan="8" class="text-center py-4"><div style="display:inline-block;width:28px;height:28px;border:3px solid #eee;border-top-color:#ff675c;border-radius:50%;animation:spin 0.7s linear infinite;"></div></td></tr>';
        fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function(res) { if (!res.ok) throw new Error('Máy chủ gặp lỗi: ' + res.status); return res.json(); })
            .then(function(data) { renderTable(data.users, data.currentPage); renderPagination(data.currentPage, data.totalPages, data.totalCount); })
            .catch(function(err) { document.getElementById('tableBody').innerHTML = '<tr><td colspan="8" class="text-center text-danger py-4">Có lỗi xảy ra: ' + err.message + '</td></tr>'; });
    }

    function renderTable(users, page) {
        var tbody = document.getElementById('tableBody');
        if (!users || users.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" class="text-center text-secondary py-4">Không tìm thấy người dùng nào phù hợp.</td></tr>';
            return;
        }
        var html = '';
        users.forEach(function(u, idx) {
            var num       = (page - 1) * 10 + idx + 1;
            var avatar    = u.avatarUrl || DEFAULT_AVATAR;
            var locked    = !u.active;
            var nameClass = locked ? 'user-name text-secondary text-decoration-line-through' : 'user-name';
            var rowClass  = locked ? 'locked' : '';
            var roleClass = 'badge-role';
            if (u.role === 'SUPER_ADMIN') roleClass += ' badge-role-superadmin';
            else if (u.role === 'ADMIN') roleClass += ' badge-role-admin';
            else if (u.role === 'SALES_STAFF') roleClass += ' badge-role-sales';
            else if (u.role === 'WAREHOUSE_STAFF') roleClass += ' badge-role-warehouse';
            var statusBadge = u.active
                ? '<span class="badge-status badge-active" id="status-badge-' + u.id + '"><span class="dot"></span> Đang hoạt động</span>'
                : '<span class="badge-status badge-locked" id="status-badge-' + u.id + '"><span class="dot"></span> Bị khóa</span>';
            var lockIcon  = u.active ? 'lock_open' : 'lock';
            var lockClass = 'action-btn btn-toggle-status' + (locked ? ' locked' : '');
            var lockTitle = u.active ? 'Khóa tài khoản' : 'Mở khóa tài khoản';
            html += '<tr class="' + rowClass + '">';
            html += '<td class="text-secondary">' + num + '</td>';
            html += '<td><div class="user-cell">';
            html += '<img class="avatar-sm" src="' + escHtml(avatar) + '" onerror="this.src=\'' + DEFAULT_AVATAR + '\'"/>';
            html += '<span class="' + nameClass + '">' + escHtml(u.fullName || '') + '</span>';
            html += '</div></td>';
            html += '<td class="text-secondary email-cell">' + escHtml(u.email || '') + '</td>';
            html += '<td>' + escHtml(u.phoneNumber || 'Chưa cập nhật') + '</td>';
            html += '<td><span class="' + roleClass + '">' + escHtml(u.role || '') + '</span></td>';
            html += '<td>' + statusBadge + '</td>';
            html += '<td class="text-secondary">' + escHtml(u.createdAt || 'Chưa rõ') + '</td>';
            html += '<td><div class="action-btns">';
            html += '<button class="action-btn btn-view-detail" title="Xem chi tiết"'
                  + ' data-id="' + u.id + '"'
                  + ' data-fullname="' + escAttr(u.fullName) + '"'
                  + ' data-email="' + escAttr(u.email) + '"'
                  + ' data-phone="' + escAttr(u.phoneNumber) + '"'
                  + ' data-address="' + escAttr(u.address) + '"'
                  + ' data-role="' + escAttr(u.role) + '"'
                  + ' data-active="' + u.active + '"'
                  + ' data-emailverified="' + u.emailVerified + '"'
                  + ' data-firebase="' + u.hasFirebase + '"'
                  + ' data-avatar="' + escAttr(u.avatarUrl) + '"'
                  + ' data-createdat="' + escAttr(u.createdAt) + '">'
                  + '<span class="material-symbols-outlined">visibility</span></button>';
            if (canEditUser) {
                html += '<button class="action-btn btn-edit-user" title="Chỉnh sửa"'
                      + ' data-id="' + u.id + '"'
                      + ' data-fullname="' + escAttr(u.fullName) + '"'
                      + ' data-email="' + escAttr(u.email) + '"'
                      + ' data-phone="' + escAttr(u.phoneNumber) + '"'
                      + ' data-address="' + escAttr(u.address) + '"'
                      + ' data-role="' + escAttr(u.role) + '"'
                      + ' data-active="' + u.active + '">'
                      + '<span class="material-symbols-outlined">edit</span></button>';
            }
            if (canDeleteUser) {
                html += '<button class="' + lockClass + '" title="' + lockTitle + '"'
                      + ' data-id="' + u.id + '"'
                      + ' data-name="' + escAttr(u.fullName) + '"'
                      + ' data-active="' + u.active + '">'
                      + '<span class="material-symbols-outlined icon-lock">' + lockIcon + '</span></button>';
            }
            html += '</div></td></tr>';
        });
        tbody.innerHTML = html;
    }

    function renderPagination(page, totalPages, totalCount) {
        var from = (page - 1) * 10 + 1;
        var to   = Math.min(page * 10, totalCount);
        document.getElementById('paginationInfo').textContent = 'Hien thi ' + from + ' - ' + to + ' cua ' + totalCount + ' khach hang';
        var c = document.getElementById('paginationBtns');
        var h = '';
        h += '<button class="page-btn"' + (page===1?' disabled':'') + ' onclick="fetchUsers(' + (page-1) + ')"><span class="material-symbols-outlined fs-6">chevron_left</span></button>';
        for (var i = 1; i <= totalPages; i++) {
            h += '<button class="page-btn' + (page===i?' active':'') + '" onclick="fetchUsers(' + i + ')">' + i + '</button>';
        }
        h += '<button class="page-btn"' + (page===totalPages?' disabled':'') + ' onclick="fetchUsers(' + (page+1) + ')"><span class="material-symbols-outlined fs-6">chevron_right</span></button>';
        c.innerHTML = h;
    }

    function escHtml(s) { if(s==null)return''; return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
    function escAttr(s) { if(s==null)return''; return String(s).replace(/"/g,'&quot;').replace(/'/g,'&#39;'); }

    var spinStyle = document.createElement('style');
    spinStyle.textContent = '@keyframes spin{to{transform:rotate(360deg)}}';
    document.head.appendChild(spinStyle);

    // ============================================================
    // MODAL XEM CHI TIET NGUOI DUNG
    // ============================================================
    var overlay  = document.getElementById('userDetailOverlay');
    var modalBox = overlay.querySelector('.modal-box');
    var currentModalUserId   = null;
    var currentModalIsActive = null;

    function openViewModal(dataset) {
        var u = {
            id:            dataset.id,
            fullName:      dataset.fullname,
            email:         dataset.email,
            phoneNumber:   dataset.phone,
            address:       dataset.address,
            role:          dataset.role,
            active:        dataset.active === 'true',
            emailVerified: dataset.emailverified === 'true',
            firebaseUID:   dataset.firebase === 'true' ? 'linked' : '',
            avatarUrl:     dataset.avatar,
            createdAt:     dataset.createdat
        };
        currentModalUserId = u.id;
        fillModal(u);
        overlay.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function fillModal(u) {
        currentModalIsActive = u.active;
        var defaultAvatar = DEFAULT_AVATAR;
        var avatarEl = document.getElementById('modalAvatar');
        avatarEl.src = u.avatarUrl || defaultAvatar;
        avatarEl.onerror = function() { avatarEl.src = defaultAvatar; };
        document.getElementById('modalUserName').textContent  = u.fullName  || 'Chưa cập nhật';
        document.getElementById('modalUserEmail').textContent = u.email     || '';
        document.getElementById('modalIdBadge').textContent   = '#' + u.id;
        var roleBadge = document.getElementById('modalRoleBadge');
        roleBadge.textContent = u.role || '---';
        var roleSuffix = '';
        if (u.role === 'SUPER_ADMIN') roleSuffix = ' badge-role-superadmin';
        else if (u.role === 'ADMIN') roleSuffix = ' badge-role-admin';
        else if (u.role === 'SALES_STAFF') roleSuffix = ' badge-role-sales';
        else if (u.role === 'WAREHOUSE_STAFF') roleSuffix = ' badge-role-warehouse';
        roleBadge.className   = 'badge-role' + roleSuffix;
        var phoneHtml   = u.phoneNumber ? u.phoneNumber : '<span class="empty">Chưa cập nhật</span>';
        var addressHtml = u.address     ? u.address     : '<span class="empty">Chưa cập nhật</span>';
        var createdHtml = u.createdAt   ? u.createdAt   : '<span class="empty">Chưa rõ</span>';
        var emailVerifiedHtml = u.emailVerified
            ? '<span style="color:#065f46;">&#10004; Đã xác thực</span>'
            : '<span style="color:#991b1b;">&#10008; Chưa xác thực</span>';
        var firebaseHtml = (u.firebaseUID && u.firebaseUID !== '')
            ? '<span style="color:#065f46;">&#10004; Đã liên kết</span>'
            : '<span style="color:#aaa;font-style:italic;font-weight:400;">Chưa liên kết</span>';
        document.getElementById('modalInfoGrid').innerHTML =
            '<div class="modal-info-item"><span class="modal-info-label">Số điện thoại</span><span class="modal-info-value">' + phoneHtml + '</span></div>' +
            '<div class="modal-info-item"><span class="modal-info-label">Ngày đăng ký</span><span class="modal-info-value">' + createdHtml + '</span></div>' +
            '<div class="modal-info-item full-width"><span class="modal-info-label">Địa chỉ</span><span class="modal-info-value">' + addressHtml + '</span></div>' +
            '<div class="modal-info-item"><span class="modal-info-label">Xác thực email</span><span class="modal-info-value">' + emailVerifiedHtml + '</span></div>' +
            '<div class="modal-info-item"><span class="modal-info-label">Đăng nhập Google</span><span class="modal-info-value">' + firebaseHtml + '</span></div>';
    }

    function closeModal() {
        overlay.classList.remove('show');
        document.body.style.overflow = '';
        currentModalUserId   = null;
        currentModalIsActive = null;
    }

    document.getElementById('modalCloseTop').addEventListener('click', closeModal);
    document.getElementById('modalCloseBottom').addEventListener('click', closeModal);
    overlay.addEventListener('click', function(e) { if (!modalBox.contains(e.target)) closeModal(); });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
            closeEditModal();
            if (typeof closeAddModal === 'function') {
                closeAddModal();
            }
        }
    });


    function handleToggleStatus(btn) {
        var userId   = btn.getAttribute('data-id');
        var userName = btn.getAttribute('data-name');
        var isActive = btn.getAttribute('data-active') === 'true';
        var nextState   = !isActive;
        var actionText  = nextState ? 'mở khóa' : 'khóa';
        Swal.fire({
            title: 'Xác nhận ' + actionText + ' tài khoản?',
            text: 'Bạn có chắc muốn ' + actionText + ' tài khoản của "' + userName + '" không?',
            icon: 'warning', showCancelButton: true,
            confirmButtonColor: nextState ? '#198754' : '#dc3545',
            cancelButtonColor: '#6c757d', confirmButtonText: 'Đồng ý', cancelButtonText: 'Hủy bỏ'
        }).then(function(result) {
            if (!result.isConfirmed) return;
            var formData = new URLSearchParams();
            formData.append('action', 'toggle-status');
            formData.append('userId', userId);
            formData.append('isActive', nextState.toString());
            fetch('${pageContext.request.contextPath}/admin/users', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest', 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            }).then(function(r) { return r.json(); }).then(function(data) {
                if (data.success) {
                    btn.setAttribute('data-active', nextState.toString());
                    var icon = btn.querySelector('.icon-lock');
                    if (icon) icon.textContent = nextState ? 'lock_open' : 'lock';
                    btn.setAttribute('title', nextState ? 'Khóa tài khoản' : 'Mở khóa tài khoản');
                    var row = btn.closest('tr');
                    var nameSpan = row ? row.querySelector('.user-name') : null;
                    if (nextState) { if(row) row.classList.remove('locked'); if(nameSpan) nameSpan.classList.remove('text-secondary','text-decoration-line-through'); }
                    else { if(row) row.classList.add('locked'); if(nameSpan) nameSpan.classList.add('text-secondary','text-decoration-line-through'); }
                    var badge = document.getElementById('status-badge-' + userId);
                    if (badge) { badge.className = nextState ? 'badge-status badge-active' : 'badge-status badge-locked'; badge.innerHTML = nextState ? '<span class="dot"></span> Đang hoạt động' : '<span class="dot"></span> Bị khóa'; }
                    Swal.fire({ icon: 'success', title: 'Thành công!', text: data.message, timer: 1800, showConfirmButton: false });
                } else { Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message }); }
            }).catch(function(err) { Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message }); });
        });
    }

    var editOverlay = document.getElementById('editUserOverlay');

    function openEditModal(dataset) {
        var u = {
            id:          dataset.id,
            fullName:    dataset.fullname,
            email:       dataset.email,
            phoneNumber: dataset.phone,
            address:     dataset.address,
            role:        dataset.role,
            active:      dataset.active === 'true'
        };
        
        document.getElementById('editUserId').value = u.id;
        document.getElementById('editFullName').value = u.fullName || '';
        document.getElementById('editModalUserEmail').textContent = u.email || '';
        document.getElementById('editPhone').value = u.phoneNumber || '';
        document.getElementById('editAddress').value = u.address || '';
        document.getElementById('editRole').value = u.role || 'USER';
        document.getElementById('editActive').value = u.active.toString();
        
        editOverlay.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function closeEditModal() {
        editOverlay.classList.remove('show');
        document.body.style.overflow = '';
    }

    document.getElementById('editModalCloseTop').addEventListener('click', closeEditModal);
    document.getElementById('editModalCloseBottom').addEventListener('click', closeEditModal);
    editOverlay.addEventListener('click', function(e) { 
        var editModalBox = editOverlay.querySelector('.modal-box');
        if (!editModalBox.contains(e.target)) closeEditModal(); 
    });

    document.getElementById('editModalSaveBtn').addEventListener('click', function(e) {
        e.preventDefault();
        var userId = document.getElementById('editUserId').value;
        var fullName = document.getElementById('editFullName').value;
        var phone = document.getElementById('editPhone').value;
        var address = document.getElementById('editAddress').value;
        var role = document.getElementById('editRole').value;
        var isActive = document.getElementById('editActive').value;

        if (!fullName || fullName.trim() === '') {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Vui lòng nhập họ và tên.' });
            return;
        }

        var formData = new URLSearchParams();
        formData.append('action', 'update');
        formData.append('userId', userId);
        formData.append('fullName', fullName);
        formData.append('phoneNumber', phone);
        formData.append('address', address);
        formData.append('role', role);
        formData.append('isActive', isActive);

        fetch('${pageContext.request.contextPath}/admin/users', {
            method: 'POST',
            headers: { 
                'X-Requested-With': 'XMLHttpRequest', 
                'Content-Type': 'application/x-www-form-urlencoded' 
            },
            body: formData.toString()
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                closeEditModal();
                Swal.fire({ 
                    icon: 'success', 
                    title: 'Thành công!', 
                    text: data.message, 
                    timer: 1500, 
                    showConfirmButton: false 
                });
                fetchUsers(currentPage);
            } else {
                Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message });
            }
        })
        .catch(function(err) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message });
        });
    });

    // ============================================================
    // MODAL THEM KHACH HANG MOI
    // ============================================================
    var addOverlay = document.getElementById('addUserOverlay');

    function openAddModal() {
        document.getElementById('addUserForm').reset();
        addOverlay.classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function closeAddModal() {
        addOverlay.classList.remove('show');
        document.body.style.overflow = '';
    }

    var btnAddUser = document.getElementById('btnAddUser');
    if (btnAddUser) {
        btnAddUser.addEventListener('click', function(e) {
            e.preventDefault();
            openAddModal();
        });
    }

    document.getElementById('addModalCloseTop').addEventListener('click', closeAddModal);
    document.getElementById('addModalCloseBottom').addEventListener('click', closeAddModal);
    addOverlay.addEventListener('click', function(e) {
        var addModalBox = addOverlay.querySelector('.modal-box');
        if (!addModalBox.contains(e.target)) closeAddModal();
    });

    document.getElementById('addModalSaveBtn').addEventListener('click', function(e) {
        e.preventDefault();
        var fullName = document.getElementById('addFullName').value;
        var email = document.getElementById('addEmail').value;
        var phone = document.getElementById('addPhone').value;
        var password = document.getElementById('addPassword').value;
        var address = document.getElementById('addAddress').value;
        var role = document.getElementById('addRole').value;

        if (!fullName || fullName.trim() === '') {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Vui lòng nhập họ và tên.' });
            return;
        }
        if (!email || email.trim() === '') {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Vui lòng nhập email.' });
            return;
        }
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.trim())) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Email không đúng định dạng.' });
            return;
        }
        if (!phone || phone.trim() === '') {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Vui lòng nhập số điện thoại.' });
            return;
        }
        if (!password || password.length < 6) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: 'Mật khẩu phải tối thiểu 6 ký tự.' });
            return;
        }

        var formData = new URLSearchParams();
        formData.append('action', 'add');
        formData.append('fullName', fullName);
        formData.append('email', email);
        formData.append('phone', phone);
        formData.append('password', password);
        formData.append('address', address);
        formData.append('role', role);

        fetch('${pageContext.request.contextPath}/admin/users', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                closeAddModal();
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công!',
                    text: data.message,
                    timer: 1500,
                    showConfirmButton: false
                });
                fetchUsers(1);
            } else {
                Swal.fire({ icon: 'error', title: 'Thất bại!', text: data.message });
            }
        })
        .catch(function(err) {
            Swal.fire({ icon: 'error', title: 'Lỗi!', text: err.message });
        });
    });

    // Event Delegation duy nhat tren tbody cho tat ca cac nut thao tac
    document.getElementById('tableBody').addEventListener('click', function(e) {
        var btn = e.target.closest('button');
        if (!btn) return;

        if (btn.classList.contains('btn-view-detail')) {
            openViewModal(btn.dataset);
        } else if (btn.classList.contains('btn-edit-user')) {
            openEditModal(btn.dataset);
        } else if (btn.classList.contains('btn-toggle-status')) {
            handleToggleStatus(btn);
        }
    });
</script>
</body></html>
