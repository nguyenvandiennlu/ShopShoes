<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<style>
  .admin-topbar {
    position: fixed;
    top: 0;
    right: 0;
    left: 250px;
    height: 70px;
    background: #ffffff;
    border-bottom: 1px solid #e9ecef;
    z-index: 1035;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 22px;
  }
  .admin-topbar-search {
    position: relative;
    width: 320px;
    max-width: 45vw;
  }
  .admin-topbar-search .material-symbols-outlined {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #6c757d;
    font-size: 24px;
  }
  .admin-topbar-search input {
    width: 100%;
    height: 46px;
    border: none;
    outline: none;
    border-radius: 999px;
    background: #eef0f2;
    color: #495057;
    padding: 0 16px 0 46px;
    font-size: 20px;
  }
  .admin-topbar-search input::placeholder {
    color: #7b8088;
  }
  .admin-topbar-actions {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-left: auto;
  }
  .admin-topbar-icon {
    width: 38px;
    height: 38px;
    border: 0;
    border-radius: 50%;
    background: transparent;
    color: #5f6670;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    position: relative;
    text-decoration: none;
    cursor: pointer;
    transition: background 0.2s;
  }
  .admin-topbar-icon:hover {
    background: #eef0f2;
  }
  .admin-topbar-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #d7dbe0;
    cursor: pointer;
  }
  .admin-notif-badge {
    position: absolute;
    top: 2px;
    right: 2px;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    background: #FF675C;
    color: white;
    font-size: 9px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid #fff;
  }
  .admin-notif-dropdown {
    position: absolute;
    top: 100%;
    right: 0;
    width: 320px;
    max-height: 400px;
    overflow-y: auto;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    display: none;
    z-index: 1060;
    margin-top: 8px;
  }
  .admin-notif-dropdown.show { display: block; }
  .admin-notif-dropdown-header {
    padding: 12px 16px;
    border-bottom: 1px solid #e9ecef;
    font-weight: 700;
    font-size: 14px;
    color: #101720;
  }
  .admin-notif-item {
    padding: 12px 16px;
    border-bottom: 1px solid #f0f2f3;
    display: flex;
    gap: 12px;
    cursor: pointer;
    transition: background 0.15s;
  }
  .admin-notif-item:hover { background: #f8f9fa; }
  .admin-notif-item:last-child { border-bottom: none; }
  .admin-notif-icon {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #fee2e2;
    color: #991b1b;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  .admin-notif-icon.success { background: #d1fae5; color: #065f46; }
  .admin-notif-icon.info { background: #dbeafe; color: #1e40af; }
  .admin-notif-text { font-size: 13px; line-height: 1.4; }
  .admin-notif-text strong { font-weight: 600; }
  .admin-notif-time { font-size: 11px; color: #7b8088; margin-top: 2px; }
  .admin-notif-empty { padding: 30px 16px; text-align: center; color: #7b8088; }
  .admin-notif-footer {
    padding: 10px 16px;
    border-top: 1px solid #e9ecef;
    text-align: center;
  }
  .admin-notif-footer a {
    color: #FF675C;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
  }
  .admin-topbar-profile-dropdown {
    position: absolute;
    top: 100%;
    right: 0;
    width: 200px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    display: none;
    z-index: 1060;
    margin-top: 8px;
    padding: 8px 0;
  }
  .admin-topbar-profile-dropdown.show { display: block; }
  .admin-topbar-profile-dropdown a {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 16px;
    color: #495057;
    text-decoration: none;
    font-size: 14px;
    transition: background 0.15s;
  }
  .admin-topbar-profile-dropdown a:hover { background: #f8f9fa; color: #101720; }
  .admin-topbar-profile-dropdown .dropdown-divider {
    height: 1px;
    background: #e9ecef;
    margin: 4px 0;
  }
</style>

<%
    model.user.User currentAdmin = (model.user.User) session.getAttribute("currentUser");
    String adminName = (currentAdmin != null && currentAdmin.getFullName() != null && !currentAdmin.getFullName().isEmpty())
        ? currentAdmin.getFullName() : "Admin";
    String adminAvatar = (currentAdmin != null && currentAdmin.getAvatarUrl() != null) ? currentAdmin.getAvatarUrl() : null;
    String adminEmail = (currentAdmin != null && currentAdmin.getEmail() != null) ? currentAdmin.getEmail() : "";
    String adminInitial = adminName.substring(0, 1).toUpperCase();
    boolean hasAvatar = (adminAvatar != null && !adminAvatar.isEmpty());
%>

<header class="admin-topbar">
  <div class="admin-topbar-actions">
    <!-- Notifications -->
    <div style="position:relative;">
      <button class="admin-topbar-icon" type="button" id="notifToggle" onclick="toggleNotifications()">
        <span class="material-symbols-outlined">notifications</span>
        <span class="admin-notif-badge" id="notifBadge" style="display:none;">0</span>
      </button>
      <div class="admin-notif-dropdown" id="notifDropdown">
        <div class="admin-notif-dropdown-header">Thông báo</div>
        <div id="notifList"><div class="admin-notif-empty">Đang tải...</div></div>
      </div>
    </div>

    <button class="admin-topbar-icon" type="button" onclick="window.open('https://www.facebook.com/messages', '_blank')" title="Hỗ trợ">
      <span class="material-symbols-outlined">help</span>
    </button>

    <!-- Profile -->
    <div style="position:relative;">
      <div onclick="toggleProfileDropdown()" style="display:flex;align-items:center;gap:8px;cursor:pointer;">
        <% if (hasAvatar) { %>
          <img class="admin-topbar-avatar" alt="<%= adminName %>" src="<%= adminAvatar %>"
               onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />
          <div style="display:none;width:36px;height:36px;border-radius:50%;background:#FF675C;color:#fff;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;">
            <%= adminInitial %>
          </div>
        <% } else { %>
          <div style="width:36px;height:36px;border-radius:50%;background:#FF675C;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;">
            <%= adminInitial %>
          </div>
        <% } %>
      </div>
      <div class="admin-topbar-profile-dropdown" id="profileDropdown">
        <div style="padding:12px 16px;border-bottom:1px solid #e9ecef;">
          <div style="font-weight:600;font-size:14px;"><%= adminName %></div>
          <div style="font-size:12px;color:#7b8088;"><%= adminEmail %></div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/settings"><span class="material-symbols-outlined" style="font-size:18px;">settings</span>Cài đặt</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/menu"><span class="material-symbols-outlined" style="font-size:18px;">home</span>Về trang chủ</a>
        <a href="${pageContext.request.contextPath}/logout"><span class="material-symbols-outlined" style="font-size:18px;">logout</span>Đăng xuất</a>
      </div>
    </div>
  </div>
</header>

<script>
const contextPath = '${pageContext.request.contextPath}';

// ---- Global search ----
function adminSearch() {
    const q = document.getElementById('adminSearchInput').value.trim();
    if (!q) return;
    // Redirect to orders page with search
    window.location.href = contextPath + '/admin/orders?search=' + encodeURIComponent(q);
}

// ---- Notifications ----
let notifOpen = false;
function toggleNotifications() {
    notifOpen = !notifOpen;
    document.getElementById('notifDropdown').classList.toggle('show', notifOpen);
    if (notifOpen) loadNotifications();
}
// Close notifications when clicking outside
document.addEventListener('click', function(e) {
    const notifEl = document.getElementById('notifDropdown');
    const notifBtn = document.getElementById('notifToggle');
    if (notifOpen && !notifEl.contains(e.target) && !notifBtn.contains(e.target)) {
        notifOpen = false;
        notifEl.classList.remove('show');
    }
});

function loadNotifications() {
    const list = document.getElementById('notifList');
    list.innerHTML = '<div class="admin-notif-empty">Đang tải...</div>';

    // Fetch new orders count and urgent info
    fetch(contextPath + '/admin/api/urgent-orders')
        .then(res => res.json())
        .then(data => {
            if (!data || data.length === 0) {
                // Check today's new orders count
                return fetch(contextPath + '/admin/api/statistics');
            }
            return data;
        })
        .then(data => {
            // If it's an array from urgent-orders, render those
            if (Array.isArray(data)) {
                if (data.length === 0) {
                    list.innerHTML = '<div class="admin-notif-empty">Không có thông báo mới</div>';
                    return;
                }
                let html = '';
                data.forEach(order => {
                    const orderLabel = order.ordersId || '#ORD-' + order.id;
                    const createdAt = order.createdAt ? new Date(order.createdAt) : new Date();
                    const timeStr = formatNotifTime(createdAt);
                    html += '<div class="admin-notif-item" onclick="window.location.href=\'' + contextPath + '/admin/orders?search=' + order.id + '\'">' +
                        '<div class="admin-notif-icon"><span class="material-symbols-outlined" style="font-size:18px;">shopping_cart</span></div>' +
                        '<div><div class="admin-notif-text"><strong>Đơn hàng mới</strong> ' + orderLabel + '</div>' +
                        '<div class="admin-notif-time">' + timeStr + '</div></div></div>';
                });
                list.innerHTML = html;
                document.getElementById('notifBadge').style.display = '';
                document.getElementById('notifBadge').textContent = data.length > 9 ? '9+' : data.length;
            } else {
                // From statistics - no urgent orders
                list.innerHTML = '<div class="admin-notif-empty">Không có thông báo mới</div>';
                document.getElementById('notifBadge').style.display = 'none';
            }
        })
        .catch(err => {
            console.error('Lỗi tải thông báo:', err);
            list.innerHTML = '<div class="admin-notif-empty">Không thể tải thông báo</div>';
        });
}

function formatNotifTime(date) {
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    if (diffMins < 1) return 'Vừa xong';
    if (diffMins < 60) return diffMins + ' phút trước';
    const diffHours = Math.floor(diffMins / 60);
    if (diffHours < 24) return diffHours + ' giờ trước';
    const diffDays = Math.floor(diffHours / 24);
    if (diffDays < 7) return diffDays + ' ngày trước';
    return date.toLocaleDateString('vi-VN');
}

// ---- Profile dropdown ----
let profileOpen = false;
function toggleProfileDropdown() {
    profileOpen = !profileOpen;
    document.getElementById('profileDropdown').classList.toggle('show', profileOpen);
}
document.addEventListener('click', function(e) {
    const dd = document.getElementById('profileDropdown');
    const trigger = dd.previousElementSibling;
    if (profileOpen && !dd.contains(e.target) && !trigger.contains(e.target)) {
        profileOpen = false;
        dd.classList.remove('show');
    }
});
</script>