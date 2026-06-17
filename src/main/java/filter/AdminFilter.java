package filter;

import enums.Role;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import utils.Permission;

import java.io.IOException;
import java.util.Map;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        String path = httpRequest.getServletPath();
        if (path == null) {
            path = "";
        }
        path = path.toLowerCase().trim();

        if (path.contains("quanlykhachhang.jsp") && httpRequest.getDispatcherType() == jakarta.servlet.DispatcherType.REQUEST) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/users");
            return;
        }

        Role role = currentUser.getRole();

        if (role == Role.SUPER_ADMIN) {
            chain.doFilter(request, response);
            return;
        }

        if (role == Role.USER || role == null) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này.");
            return;
        }
        @SuppressWarnings("unchecked")
        Map<String, Integer> permissions = (session != null) ? (Map<String, Integer>) session.getAttribute("userPermissions") : null;
        if (permissions == null) {
            dao.user.RolePermissionDao rpDao = new dao.user.RolePermissionDao();
            permissions = rpDao.getPermissionsForRole(role.name());
            if (session != null) {
                session.setAttribute("userPermissions", permissions);
            }
        }

        int requiredAction = "GET".equalsIgnoreCase(httpRequest.getMethod()) ? Permission.VIEW : Permission.EDIT;
        boolean isAllowed = false;
        if (path.equals("/admin") || path.equals("/admin/") || path.contains("adminhome.jsp")) {
            if (hasPerm(permissions, "dashboard", Permission.VIEW)) {
                chain.doFilter(request, response);
            } else {
                redirectToDefaultPage(httpRequest, httpResponse, permissions);
            }
            return;
        }
        else if (path.contains("thongke.jsp")) {
            isAllowed = hasPerm(permissions, "statistics", Permission.VIEW);
        }
        else if (path.contains("chart-statistics") || path.contains("api/statistics")) {
            isAllowed = hasPerm(permissions, "statistics", Permission.VIEW) || hasPerm(permissions, "dashboard", Permission.VIEW);
        }
        else if (path.contains("quanlydonhang.jsp") || path.contains("/orders")) {
            isAllowed = hasPerm(permissions, "orders", requiredAction);
        }
        else if (path.contains("urgent-orders") || path.contains("recent-reviews")) {
            isAllowed = hasPerm(permissions, "orders", Permission.VIEW) || hasPerm(permissions, "dashboard", Permission.VIEW);
        }
        else if (path.contains("quanlykhohang.jsp") || path.contains("addproduct.jsp") || path.contains("api/inventory") || path.contains("upload-image")) {
            int action = requiredAction;
            if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
                if (path.contains("addproduct.jsp")) {
                    action = Permission.ADD;
                }
            }
            isAllowed = hasPerm(permissions, "products", action);
        }
        else if (path.contains("promotions") || path.contains("quanlykhuyenmai.jsp")) {
            int action = requiredAction;
            if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
                String actionParam = httpRequest.getParameter("action");
                if ("add".equalsIgnoreCase(actionParam)) {
                    action = Permission.ADD;
                } else if ("delete".equalsIgnoreCase(actionParam)) {
                    action = Permission.DELETE;
                } else if ("edit".equalsIgnoreCase(actionParam) || "toggle".equalsIgnoreCase(actionParam)) {
                    action = Permission.EDIT;
                }
            }
            isAllowed = hasPerm(permissions, "promotions", action);
        }
        else if (path.contains("product-stats")) {
            isAllowed = hasPerm(permissions, "products", Permission.VIEW) || hasPerm(permissions, "dashboard", Permission.VIEW);
        }
        else if (path.contains("users") || path.contains("quanlykhachhang.jsp")) {
            int action = requiredAction;
            if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
                String actionParam = httpRequest.getParameter("action");
                if ("add".equalsIgnoreCase(actionParam)) {
                    action = Permission.ADD;
                } else if ("toggle-status".equalsIgnoreCase(actionParam) || "update".equalsIgnoreCase(actionParam)) {
                    action = Permission.EDIT;
                }
            }
            isAllowed = hasPerm(permissions, "users", action);
        }
        else if (path.contains("settings") || path.contains("settingadmin.jsp")) {
            isAllowed = hasPerm(permissions, "settings", requiredAction);
        }


        if (isAllowed) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện hành động này.");
        }
    }

    private boolean hasPerm(Map<String, Integer> permissions, String module, int requiredAction) {
        if (permissions == null) return false;
        Integer userMask = permissions.get(module.toLowerCase().trim());
        if (userMask == null) return false;
        return (userMask & requiredAction) == requiredAction;
    }

    private void redirectToDefaultPage(HttpServletRequest request, HttpServletResponse response, Map<String, Integer> permissions) throws IOException {
        if (hasPerm(permissions, "orders", Permission.VIEW)) {
            response.sendRedirect(request.getContextPath() + "/admin/quanlydonhang.jsp");
        } else if (hasPerm(permissions, "products", Permission.VIEW)) {
            response.sendRedirect(request.getContextPath() + "/admin/quanlykhohang.jsp");
        } else if (hasPerm(permissions, "users", Permission.VIEW)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang quản lý.");
        }
    }

    @Override
    public void destroy() {
    }
}
