package controller.admin;

import com.google.gson.JsonArray;
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
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUsersController extends HttpServlet {

    private UserServices userServices;
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    public void init() {
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String pageParam = req.getParameter("page");
        String search    = req.getParameter("search");
        String role      = req.getParameter("role");
        String status    = req.getParameter("status");

        int page     = 1;
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
        int totalCount  = userServices.countUsers(search, role, status);
        int totalPages  = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages < 1) totalPages = 1;

        String requestedWith = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            JsonObject jsonResponse = new JsonObject();
            JsonArray usersArray = new JsonArray();
            for (User u : usersList) {
                usersArray.add(serializeUser(u));
            }
            jsonResponse.add("users", usersArray);
            jsonResponse.addProperty("currentPage", page);
            jsonResponse.addProperty("totalPages", totalPages);
            jsonResponse.addProperty("totalCount", totalCount);

            resp.getWriter().write(jsonResponse.toString());
            return;
        }

        req.setAttribute("usersList",   usersList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("search", search != null ? search : "");
        req.setAttribute("role",   role   != null ? role   : "all");
        req.setAttribute("status", status != null ? status : "all");
        req.getRequestDispatcher("/admin/quanlykhachhang.jsp").forward(req, resp);
    }

    private JsonObject serializeUser(User u) {
        JsonObject jo = new JsonObject();
        jo.addProperty("id", u.getId());
        jo.addProperty("fullName", u.getFullName() != null ? u.getFullName() : "");
        jo.addProperty("email", u.getEmail() != null ? u.getEmail() : "");
        jo.addProperty("phoneNumber", u.getPhoneNumber() != null ? u.getPhoneNumber() : "");
        jo.addProperty("address", u.getAddress() != null ? u.getAddress() : "");
        jo.addProperty("role", u.getRole() != null ? u.getRole().name() : "");
        jo.addProperty("active", u.isActive());
        jo.addProperty("emailVerified", u.isEmailVerified());
        jo.addProperty("hasFirebase", u.getFirebaseUID() != null && !u.getFirebaseUID().isBlank());
        jo.addProperty("avatarUrl", u.getAvatarUrl() != null ? u.getAvatarUrl() : "");
        jo.addProperty("createdAt", u.getCreatedAt() != null ? u.getCreatedAt().format(dateFormatter) : "Chưa rõ");
        return jo;
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
        } else if ("update".equals(action)) {
            String userIdParam = req.getParameter("userId");
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phoneNumber");
            String address = req.getParameter("address");
            String role = req.getParameter("role");
            String isActiveParam = req.getParameter("isActive");

            if (userIdParam == null || fullName == null || phone == null || address == null || role == null || isActiveParam == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu tham số yêu cầu.");
                out.print(jsonResponse.toString());
                return;
            }

            try {
                int userId = Integer.parseInt(userIdParam);
                boolean isActive = Boolean.parseBoolean(isActiveParam);
                String result = userServices.updateUserAdmin(
                    currentAdmin.getId(),
                    userId,
                    fullName.trim(),
                    phone.trim(),
                    address.trim(),
                    role.toUpperCase().trim(),
                    isActive
                );

                if ("SUCCESS".equals(result)) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Cập nhật thông tin người dùng thành công!");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", result);
                }
            } catch (NumberFormatException e) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Định dạng ID người dùng không hợp lệ.");
            }
        } else if ("add".equals(action)) {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String password = req.getParameter("password");
            String address = req.getParameter("address");
            String role = req.getParameter("role");

            if (fullName == null || email == null || phone == null || password == null || role == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thiếu tham số yêu cầu.");
                out.print(jsonResponse.toString());
                return;
            }

            String result = userServices.createUserAdmin(
                fullName.trim(),
                email.trim(),
                phone.trim(),
                password,
                address,
                role.toUpperCase().trim()
            );

            if ("SUCCESS".equals(result)) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Thêm khách hàng thành công!");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", result);
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
