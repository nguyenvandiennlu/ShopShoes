package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.auth.TokenTypeService;
import services.common.EmailServices;
import services.user.UserServices;
import utils.EmailTemplateBuilder;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/verify-otp")
public class OtpVerificationController extends HttpServlet {
    private TokenTypeService tokenTypeService;
    private UserServices userServices;

    @Override
    public void init() {
        tokenTypeService = new TokenTypeService();
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Hiển thị trang xác nhận OTP
        req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");

        // Nếu người dùng yêu cầu gửi lại OTP
        if ("resend".equalsIgnoreCase(action)) {
            handleResendOtp(req, resp);
            return;
        }

        // Nếu người dùng bỏ qua xác nhận OTP
        if ("skip".equalsIgnoreCase(action)) {
            String email = req.getParameter("email");
            autoLoginUser(req, email);
            resp.sendRedirect(req.getContextPath() + "/menufilter?brandId=all");
            return;
        }

        // Nếu người dùng xác nhận OTP
        if ("verify".equalsIgnoreCase(action)) {
            String email = req.getParameter("email");
            String token = req.getParameter("token");
            String otp = req.getParameter("otp");

            // Kiểm tra và xác nhận token
            if (tokenTypeService.verifyEmailByToken(token)) {
                autoLoginUser(req, email);
                req.setAttribute("success", "Email đã được xác thực thành công!");
                resp.sendRedirect(req.getContextPath() + "/menufilter?brandId=all");
            } else {
                req.setAttribute("error", "OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                req.setAttribute("email", email);
                req.setAttribute("token", token);
                req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
            }
            return;
        }

        req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
    }

    /**
     * Auto-login user after registration or OTP verification
     */
    private void autoLoginUser(HttpServletRequest req, String email) {
        if (email == null || email.isEmpty()) return;
        User user = userServices.getUserDao().findByEmail(email);
        if (user != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
        }
    }

    private void handleResendOtp(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        String email = req.getParameter("email");
        String token = req.getParameter("token");

        if (email == null || email.isEmpty() || token == null || token.isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Thiếu thông tin email hoặc token\"}");
            return;
        }

        // Tạo token mới
        String newToken = tokenTypeService.createActivationToken(email);
        String otp = extractOtpFromToken(newToken);
        String emailContent = EmailTemplateBuilder.buildRegistrationOtpEmail(email, otp);

        try {
            EmailServices emailService = new EmailServices();
            boolean sent = emailService.send(email, "Kích hoạt tài khoản ShopShoes - Mã OTP", emailContent);
            if (sent) {
                resp.getWriter().write("{\"success\":true,\"message\":\"Đã gửi lại mã OTP\",\"token\":\"" + newToken + "\"}");
            } else {
                resp.getWriter().write("{\"success\":false,\"message\":\"Gửi email thất bại. Vui lòng thử lại.\"}");
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Resend OTP failed: " + e.getMessage());
            resp.getWriter().write("{\"success\":false,\"message\":\"Có lỗi xảy ra. Vui lòng thử lại.\"}");
        }
    }

    private String extractOtpFromToken(String token) {
        if (token == null || token.isEmpty()) {
            return "000000";
        }
        int hashCode = Math.abs(token.hashCode());
        int otp = hashCode % 1000000;
        return String.format("%06d", otp);
    }
}