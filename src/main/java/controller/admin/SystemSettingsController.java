package controller.admin;

import com.google.gson.JsonObject;
import dao.user.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;
import services.common.EmailServices;
import utils.EmailConfigLoader;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/admin/settings")
public class SystemSettingsController extends HttpServlet {

    private UserDao userDao;
    private EmailServices emailServices;

    @Override
    public void init() {
        userDao = new UserDao();
        emailServices = new EmailServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !enums.Role.ADMIN.equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/admin/settingadmin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = req.getSession(false);
        User currentAdmin = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentAdmin == null || !enums.Role.ADMIN.equals(currentAdmin.getRole())) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
            out.print(jsonResponse.toString());
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Thiếu hành động.");
            out.print(jsonResponse.toString());
            return;
        }

        switch (action) {
            case "save-general":
                String shopName = req.getParameter("shopName");
                String shopHotline = req.getParameter("shopHotline");
                String shopAddress = req.getParameter("shopAddress");
                String shopEmail = req.getParameter("shopEmail");

                if (shopName == null || shopName.isBlank() || shopHotline == null || shopHotline.isBlank()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Vui lòng nhập đầy đủ các trường bắt buộc.");
                } else {
                    String host = EmailConfigLoader.get("mail.host");
                    String port = EmailConfigLoader.get("mail.port");
                    String username = EmailConfigLoader.get("mail.username");
                    String password = EmailConfigLoader.get("mail.password");
                    String auth = EmailConfigLoader.get("mail.auth");
                    String starttls = EmailConfigLoader.get("mail.starttls.enable");

                    boolean saved = EmailConfigLoader.save(
                            host, port, username, password, auth, starttls,
                            shopName.trim(), shopHotline.trim(), shopAddress != null ? shopAddress.trim() : "", shopEmail != null ? shopEmail.trim() : ""
                    );

                    if (saved) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Lưu thông tin cửa hàng thành công!");
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Có lỗi xảy ra khi ghi file cấu hình.");
                    }
                }
                break;

            case "save-smtp":
                String mailHost = req.getParameter("mailHost");
                String mailPort = req.getParameter("mailPort");
                String mailUsername = req.getParameter("mailUsername");
                String mailPassword = req.getParameter("mailPassword");
                String mailAuth = req.getParameter("mailAuth");
                String mailStarttls = req.getParameter("mailStarttls");

                if (mailHost == null || mailHost.isBlank() || mailPort == null || mailPort.isBlank() ||
                    mailUsername == null || mailUsername.isBlank() || mailPassword == null || mailPassword.isBlank()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Vui lòng nhập đầy đủ thông tin cấu hình SMTP.");
                } else {
                    String shopNameOld = EmailConfigLoader.get("shop.name");
                    String shopHotlineOld = EmailConfigLoader.get("shop.hotline");
                    String shopAddressOld = EmailConfigLoader.get("shop.address");
                    String shopEmailOld = EmailConfigLoader.get("shop.email");

                    boolean saved = EmailConfigLoader.save(
                            mailHost.trim(), mailPort.trim(), mailUsername.trim(), mailPassword,
                            mailAuth != null ? mailAuth.trim() : "true", mailStarttls != null ? mailStarttls.trim() : "true",
                            shopNameOld, shopHotlineOld, shopAddressOld, shopEmailOld
                    );

                    if (saved) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Cập nhật cấu hình SMTP thành công!");
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Có lỗi xảy ra khi ghi file cấu hình.");
                    }
                }
                break;

            case "change-password":
                if (currentAdmin != null && currentAdmin.getFirebaseUID() != null && !currentAdmin.getFirebaseUID().isBlank()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Tài khoản liên kết Google không được phép thực hiện đổi mật khẩu.");
                    out.print(jsonResponse.toString());
                    return;
                }

                String oldPassword = req.getParameter("oldPassword");
                String newPassword = req.getParameter("newPassword");
                String confirmPassword = req.getParameter("confirmPassword");

                if (oldPassword == null || oldPassword.isBlank() ||
                    newPassword == null || newPassword.isBlank() ||
                    confirmPassword == null || confirmPassword.isBlank()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Vui lòng nhập đầy đủ các trường mật khẩu.");
                } else if (newPassword.length() < 6) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Mật khẩu mới phải có độ dài tối thiểu 6 ký tự.");
                } else if (!newPassword.equals(confirmPassword)) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Xác nhận mật khẩu mới không khớp.");
                } else {
                    User latestAdmin = userDao.findById(currentAdmin.getId());
                    if (latestAdmin == null) {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Không tìm thấy tài khoản admin.");
                    } else if (latestAdmin.getPasswordHash() == null || latestAdmin.getPasswordHash().isBlank() ||
                               !BCrypt.checkpw(oldPassword, latestAdmin.getPasswordHash())) {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Mật khẩu hiện tại không chính xác.");
                    } else {
                        String newPasswordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
                        boolean updated = userDao.updatePassword(latestAdmin.getId(), newPasswordHash);

                        if (updated) {
                            latestAdmin.setPasswordHash(newPasswordHash);
                            session.setAttribute("currentUser", latestAdmin);
                            jsonResponse.addProperty("success", true);
                            jsonResponse.addProperty("message", "Thay đổi mật khẩu thành công!");
                        } else {
                            jsonResponse.addProperty("success", false);
                            jsonResponse.addProperty("message", "Không thể cập nhật mật khẩu vào cơ sở dữ liệu.");
                        }
                    }
                }
                break;

            case "test-email":
                String testEmail = req.getParameter("testEmail");
                if (testEmail == null || testEmail.isBlank()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ email nhận thử nghiệm.");
                } else {
                    boolean sent = emailServices.send(
                            testEmail.trim(),
                            "Email kiểm tra SMTP - BHD Sport Shoes",
                            "<h3>Xin chào!</h3><p>Đây là email tự động gửi từ trang quản trị <b>BHD Sport Shoes</b> nhằm kiểm tra cấu hình SMTP. Nếu bạn nhận được email này, cấu hình của bạn đã hoạt động chính xác!</p>"
                    );

                    if (sent) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Gửi email thử nghiệm thành công! Vui lòng kiểm tra hộp thư của bạn.");
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Gửi email thất bại. Vui lòng kiểm tra lại log hoặc cấu hình SMTP.");
                    }
                }
                break;

            default:
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hành động không hợp lệ.");
                break;
        }

        out.print(jsonResponse.toString());
    }
}
