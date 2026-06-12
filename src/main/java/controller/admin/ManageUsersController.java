package controller.admin;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.UserServices;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUsersController extends HttpServlet {

    private UserServices userServices;

    @Override
    public void init() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pageParam = req.getParameter("page");
        String search = req.getParameter("search");
        String role = req.getParameter("role");
        String status = req.getParameter("status");

        int page = 1;
        int pageSize = 10;

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        List<User> usersList = userServices.getUsers(page, pageSize, search, role, status);
        int totalCount = userServices.countUsers(search, role, status);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        req.setAttribute("usersList", usersList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("search", search != null ? search : "");
        req.setAttribute("role", role != null ? role : "all");
        req.setAttribute("status", status != null ? status : "all");
        req.getRequestDispatcher("/admin/quanlykhachhang.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = req.getSession(false);
        User currentAdmin = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentAdmin == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            out.print(jsonResponse.toString());
            return;
        }

        String action = req.getParameter("action");
        if ("toggle-status".equals(action)) {
            String userIdParam = req.getParameter("userId");
            String isActiveParam = req.getParameter("isActive");

            if (userIdParam == null || isActiveParam == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu tham số yêu cầu.");
                out.print(jsonResponse.toString());
                return;
            }

            try {
                int userId = Integer.parseInt(userIdParam);
                boolean isActive = Boolean.parseBoolean(isActiveParam);
                String result = userServices.toggleUserStatus(currentAdmin.getId(), userId, isActive);

                if ("SUCCESS".equals(result)) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Cập nhật trạng thái thành công!");
                    jsonResponse.addProperty("isActive", isActive);
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", result);
                }
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Định dạng ID người dùng không hợp lệ.");
            }
            out.print(jsonResponse.toString());
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Hành động không hợp lệ.");
            out.print(jsonResponse.toString());
        }
    }
}
