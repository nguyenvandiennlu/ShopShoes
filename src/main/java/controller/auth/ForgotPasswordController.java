package controller.auth;

import JavaMail.IJavaMail;
import JavaMail.JavaMailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.auth.ForgotPasswordService;
import utils.RecaptchaVerifier;
import utils.EmailTemplateBuilder;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private ForgotPasswordService forgotPasswordService;
    private IJavaMail javaMail;

    @Override
    public void init() {
        forgotPasswordService = new ForgotPasswordService();
        javaMail = new JavaMailService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/ForgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        String action = req.getParameter("action");
        try {
            if (action == null || action.isBlank()) {
                sendJson(resp, false, "Yêu cầu không hợp lệ", null);
                return;
            }

            switch (action) {
                case "send-otp":
                    handleSendOtp(req, resp, session);
                    break;

                case "verify-otp":
                    handleVerifyOtp(req, resp, session);
                    break;

                case "reset-password":
                    handleResetPassword(req, resp, session);
                    break;

                default:
                    sendJson(resp, false, "Action không được hỗ trợ", null);
                    break;
            }
        } catch (Exception e) {
            System.err.println("[ForgotPasswordController] Exception: " + e.getMessage());
            e.printStackTrace();
            if (!resp.isCommitted()) {
                sendJson(resp, false, "Đã xảy ra lỗi hệ thống, vui lòng thử lại", null);
            }
        }
    }

    private void handleSendOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String recaptchaResponse = req.getParameter("g-recaptcha-response");
        if (!RecaptchaVerifier.verify(recaptchaResponse)) {
            sendJson(resp, false, "Vui lòng xác nhận bạn không phải robot", null);
            return;
        }
        String email = req.getParameter("email");
        if (email != null) {
            email = email.trim();
        }
        String result = forgotPasswordService.sendOtp(email, session);

        if (result != null && result.matches("\\d{6}")) {
            try {
                String html = EmailTemplateBuilder.buildForgotPasswordOtpEmail(result);
                boolean sent = javaMail.send(email, "Mã OTP đặt lại mật khẩu", html);
                if (!sent) {
                    System.err.println("[ForgotPasswordController] Email send returned false for: " + email);
                    sendJson(resp, false, "Không thể gửi email OTP. Vui lòng thử lại", null);
                    return;
                }
                sendJson(resp, true, "OTP đã được gửi tới email của bạn. Vui lòng kiểm tra hộp thư (xem trong thư rác nếu không thấy)", null);
                return;
            } catch (Exception e) {
                System.err.println("[ForgotPasswordController] Email send exception: " + e.getMessage());
                e.printStackTrace();
                sendJson(resp, false, "Gửi email thất bại. Vui lòng thử lại sau", null);
                return;
            }
        }
        if ("Nếu email tồn tại, mã OTP đã được gửi".equals(result)) {
            sendJson(resp, true, result, null);
            return;
        }
        sendJson(resp, false, result != null ? result : "Không thể tạo OTP", null);
    }
    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String otp = req.getParameter("otp");
        if (otp != null) {
            otp = otp.trim();
        }
        String error = forgotPasswordService.verifyOtp(otp, session);

        if (error != null) {
            sendJson(resp, false, error, null);
            return;
        }
        sendJson(resp, true, "Xác thực OTP thành công", null);
    }

    private void handleResetPassword(HttpServletRequest req, HttpServletResponse resp, HttpSession session) throws IOException {
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        String error = forgotPasswordService.resetPassword(password, confirmPassword, session);

        if (error != null) {
            sendJson(resp, false, error, null);
            return;
        }

        sendJson(resp, true, "Đổi mật khẩu thành công", req.getContextPath() + "/Login.jsp");
    }

    private void sendJson(HttpServletResponse resp, boolean success, String message, String redirect) throws IOException {
        StringBuilder json = new StringBuilder("{");
        json.append("\"success\":").append(success);

        if (message != null) {
            json.append(",\"message\":\"").append(escapeJson(message)).append("\"");
        }

        if (redirect != null) {
            json.append(",\"redirect\":\"").append(escapeJson(redirect)).append("\"");
        }

        json.append("}");
        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}