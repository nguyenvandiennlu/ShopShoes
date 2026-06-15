package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.auth.RegisterService;
import services.common.EmailServices;
import services.user.UserServices;
import utils.EmailTemplateBuilder;
import utils.RecaptchaVerifier;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private RegisterService registerService;
    private UserServices userServices;

    // Rate limiting: track registration attempts per IP
    private static final ConcurrentHashMap<String, long[]> registerAttempts = new ConcurrentHashMap<>();
    private static final int MAX_REGISTER_ATTEMPTS = 3;
    private static final long REGISTER_WINDOW_MS = TimeUnit.MINUTES.toMillis(10);

    @Override
    public void init() {
        registerService = new RegisterService();
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("validate".equalsIgnoreCase(action)) {
            handleAjaxValidation(req, resp);
            return;
        }

        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("text/html;charset=UTF-8");

        // --- Rate limiting check ---
        String clientIp = getClientIp(req);
        if (isRateLimited(clientIp)) {
            req.setAttribute("error", "Bạn đã gửi quá nhiều yêu cầu đăng ký. Vui lòng thử lại sau 10 phút.");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // --- reCAPTCHA verification ---
        String recaptchaResponse = req.getParameter("g-recaptcha-response");
        if (!RecaptchaVerifier.verify(recaptchaResponse)) {
            req.setAttribute("error", "Xác thực reCAPTCHA thất bại. Vui lòng xác nhận bạn không phải robot.");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String address = req.getParameter("address");

        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath();

        RegisterService.RegisterResult result = registerService.register(
                fullName, email, phone, password, confirmPassword, address, baseUrl
        );

        if (!result.success) {
            req.setAttribute("error", result.message);
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // Auto-login after successful registration
        User newUser = userServices.getUserDao().findByEmail(email);
        if (newUser != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", newUser);
        }

        EmailServices emailService = new EmailServices();
        
        String otp = extractOtpFromToken(result.token);
        String emailContent = EmailTemplateBuilder.buildRegistrationOtpEmail(fullName, otp);
        try {
            boolean emailSent = emailService.send(email, "Kích hoạt tài khoản ShopShoes - Mã OTP", emailContent);
            if (emailSent) {

                req.setAttribute("email", result.email);
                req.setAttribute("token", result.token);
                req.setAttribute("otp", otp);
                req.setAttribute("success", "Đăng ký thành công! Chúng tôi đã gửi mã OTP vào email của bạn. Vui lòng nhập mã OTP để kích hoạt tài khoản.");
                req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
            } else {
                System.err.println("[ERROR] Email send failed (returned false)");
                req.setAttribute("error", "Đăng ký thành công nhưng gửi email kích hoạt thất bại. Vui lòng thử lại sau.");
                req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Exception when sending email: " + e.getMessage());
            System.err.println("[ERROR] Full trace:");
            e.printStackTrace();
            req.setAttribute("error", "Đăng ký thành công nhưng gửi email kích hoạt thất bại: " + e.getMessage());
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
        }
    }

    /**
     * Get client IP address from request, respecting proxy headers.
     */
    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        // X-Forwarded-For may contain comma-separated list; take first IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    /**
     * Check if the given IP has exceeded the rate limit for registration attempts.
     */
    private boolean isRateLimited(String ip) {
        long now = System.currentTimeMillis();
        long[] record = registerAttempts.get(ip);
        if (record == null) {
            // First attempt: [count, windowStart]
            registerAttempts.put(ip, new long[]{1, now});
            return false;
        }
        long count = record[0];
        long windowStart = record[1];
        if (now - windowStart > REGISTER_WINDOW_MS) {
            // Window expired, reset
            registerAttempts.put(ip, new long[]{1, now});
            return false;
        }
        if (count >= MAX_REGISTER_ATTEMPTS) {
            return true; // rate limited
        }
        // Increment count
        record[0] = count + 1;
        registerAttempts.put(ip, record);
        return false;
    }

    private void handleAjaxValidation(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword") == null ? "" : req.getParameter("confirmPassword");
        String address = req.getParameter("address");

        String json = registerService.buildAjaxValidationJson(
                fullName, email, phone, password, confirmPassword, address
        );

        resp.getWriter().write(json);
    }

    /**
     * Generate 6-digit numeric OTP from token
     * Example: "6ef5f7a5-4aea-4f42-b94c-1574f3278c46" -> "123456"
     */
    private String extractOtpFromToken(String token) {
        if (token == null || token.isEmpty()) {
            return "000000";
        }
        
        // Use token's hash code to generate deterministic 6-digit OTP
        int hashCode = Math.abs(token.hashCode());
        int otp = hashCode % 1000000; // Get last 6 digits (0-999999)
        
        // Format as 6-digit string with leading zeros if needed
        return String.format("%06d", otp);
    }
}
