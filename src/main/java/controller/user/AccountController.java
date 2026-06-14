package controller.user;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.user.User;
import services.user.AccountServices;
import utils.CloudinaryUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@WebServlet("/account")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize      = 5 * 1024 * 1024,
        maxRequestSize   = 6 * 1024 * 1024
)
public class AccountController extends HttpServlet {

    private AccountServices accountServices;

    @Override
    public void init() {
        accountServices = new AccountServices();
    }

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;


        HttpSession session = req.getSession(false);
        Object flashMsg = session.getAttribute("flashMsg");
        Object flashType = session.getAttribute("flashType");
        if (flashMsg != null) {
            req.setAttribute("msg", flashMsg);
            req.setAttribute("msgType", flashType);
            session.removeAttribute("flashMsg");
            session.removeAttribute("flashType");
        }

        // Pagination
        int page = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalOrders = accountServices.getOrderCount(currentUser.getId());
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        java.util.List<model.Order.Order> orderHistory = accountServices.getOrderHistoryPaginated(currentUser.getId(), page, PAGE_SIZE);
        req.setAttribute("orderHistory", orderHistory);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        // Determine active tab: only switch to orders tab when paginating
        String activeTab = (pageParam != null && !pageParam.isBlank()) ? "orders" : "info";
        req.setAttribute("activeTab", activeTab);

        req.getRequestDispatcher("/Account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;

        String action = safe(req.getParameter("action"));

        switch (action) {
            case "change-password" -> handlePasswordChange(req, resp, currentUser);
            case "update-profile"  -> handleProfileUpdate(req, resp, currentUser);
            case "upload-avatar"   -> handleAvatarUpload(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    private void handleAvatarUpload(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException, ServletException {

        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            Part filePart = req.getPart("avatar");
            if (filePart == null || filePart.getSize() == 0) {
                out.print("{\"success\":false,\"message\":\"Vui lòng chọn ảnh.\"}");
                return;
            }

            String contentType = filePart.getContentType();
            List<String> allowedTypes = Arrays.asList("image/jpeg", "image/png", "image/webp", "image/gif");
            if (contentType == null || !allowedTypes.contains(contentType.toLowerCase())) {
                out.print("{\"success\":false,\"message\":\"Chỉ chấp nhận ảnh JPG, PNG, WEBP hoặc GIF.\"}");
                return;
            }

            Cloudinary cloudinary = CloudinaryUtil.getInstance();
            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap(
                    "folder", "avatars",
                    "public_id", "user_" + currentUser.getId(),
                    "overwrite", true,
                    "resource_type", "image"
            ));

            String avatarUrl = (String) uploadResult.get("secure_url");
            if (avatarUrl == null || avatarUrl.isBlank()) {
                out.print("{\"success\":false,\"message\":\"Upload thất bại, vui lòng thử lại.\"}");
                return;
            }

            boolean updated = accountServices.updateAvatarUrl(currentUser.getId(), avatarUrl);
            if (!updated) {
                out.print("{\"success\":false,\"message\":\"Lưu ảnh vào cơ sở dữ liệu thất bại.\"}");
                return;
            }
            currentUser.setAvatarUrl(avatarUrl);

            out.print("{\"success\":true,\"avatarUrl\":\"" + avatarUrl + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false,\"message\":\"Lỗi hệ thống: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String fullName = safe(req.getParameter("fullName"));
        String phoneNumber = safe(req.getParameter("phoneNumber"));
        String address = safe(req.getParameter("address"));

        String requestedWith = req.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);

        if (fullName.isBlank()) {
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"message\":\"Họ tên không được để trống.\"}");
                return;
            }
            setFlash(req, "Họ tên không được để trống.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        boolean success = accountServices.updateUserProfile(
                currentUser.getId(), fullName, phoneNumber, address);

        if (success) {
            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setAddress(address);

            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":true,\"message\":\"Cập nhật thông tin thành công!\",\"fullName\":\"" + fullName + "\"}");
                return;
            } else {
                setFlash(req, "Cập nhật thông tin thành công!", "success");
            }
        } else {
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"message\":\"Cập nhật thất bại. Vui lòng thử lại.\"}");
                return;
            } else {
                setFlash(req, "Cập nhật thất bại. Vui lòng thử lại.", "danger");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private void handlePasswordChange(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String currentPassword = safe(req.getParameter("currentPassword"));
        String newPassword = safe(req.getParameter("newPassword"));
        String confirmPassword = safe(req.getParameter("confirmPassword"));

        String requestedWith = req.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(requestedWith);

        if (currentPassword.isBlank() || newPassword.isBlank() || confirmPassword.isBlank()) {
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"message\":\"Vui lòng nhập đầy đủ thông tin mật khẩu.\"}");
                return;
            }
            setFlash(req, "Vui lòng nhập đầy đủ thông tin mật khẩu.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        String result = accountServices.changePassword(
                currentUser.getEmail(), currentPassword, newPassword, confirmPassword);

        if ("SUCCESS".equals(result)) {
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":true,\"message\":\"Đổi mật khẩu thành công!\"}");
                return;
            } else {
                setFlash(req, "Đổi mật khẩu thành công!", "success");
            }
        } else {
            if (isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print("{\"success\":false,\"message\":\"" + result.replace("\"", "\\\"") + "\"}");
                return;
            } else {
                setFlash(req, result, "danger");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
            return null;
        }
        Object u = session.getAttribute("currentUser");
        if (!(u instanceof User)) {
            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
            return null;
        }
        return (User) u;
    }

    private void setFlash(HttpServletRequest req, String msg, String type) {
        HttpSession session = req.getSession();
        session.setAttribute("flashMsg", msg);
        session.setAttribute("flashType", type);
    }

    private String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
