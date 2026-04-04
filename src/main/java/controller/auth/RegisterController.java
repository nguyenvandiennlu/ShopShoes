package controller.auth;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.auth.RegisterService;
import services.common.EmailServices;
import services.user.UserServices;

import java.nio.charset.StandardCharsets;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserServices userService;
    private RegisterService registerService;
    @Override
    public void init() {
        userService = new UserServices();
        registerService = new RegisterService();
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

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

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

        // 1. Validate dữ liệu
        if (fullName == null || email == null || phone == null ||
                password == null || confirmPassword == null ||
                fullName.isBlank() || email.isBlank() || phone.isBlank() || address.isBlank() ||
                password.isBlank() || confirmPassword.isBlank()) {

            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra mật khẩu khớp
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra độ dài mật khẩu
        password = password.trim();
        confirmPassword = confirmPassword.trim();

        if (!isPasswordValid(password)) {
            req.setAttribute("error",
                    "Mật khẩu >= 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt (không chứa khoảng trắng).");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 4. Validate email format (phải có domain đầy đủ như @gmail.com)
        if (!isEmailValid(email)) {
            req.setAttribute("error", "Email không hợp lệ. Ví dụ đúng: tenban@domain.com");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 5. Validate phone format (10-12 số, bắt đầu bằng 0)
        if (!isPhoneValid(phone)) {
            req.setAttribute("error", "Số điện thoại phải đủ 10-12 số và bắt đầu từ số 0");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        if (!result.success) {
            req.setAttribute("error", result.message);
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }
        EmailServices emailService = new EmailServices();
        String emailContent = "<p>Xin chào " + fullName + ",</p>" +
                "<p>Cảm ơn bạn đã đăng ký. Vui lòng click link dưới để kích hoạt tài khoản:</p>" +
                "<p><a href='" + result.activationLink + "'>Kích hoạt tài khoản</a></p>" +
                "<p>Link có hiệu lực trong 2 phút.</p>";
        try {
            emailService.send(email, "Kích hoạt tài khoản ShopShoes", emailContent);
            req.setAttribute("success", result.message);
            req.getRequestDispatcher("/Login").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Đăng ký thành công nhưng gửi email kích hoạt thất bại.");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
        }
    }

    private void handleAjaxValidation(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json;charset=UTF-8");

        String fullName = trimOrEmpty(req.getParameter("fullName"));
        String email = trimOrEmpty(req.getParameter("email"));
        String phone = trimOrEmpty(req.getParameter("phone"));
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword") == null ? "" : req.getParameter("confirmPassword");
        String address = trimOrEmpty(req.getParameter("address"));

        boolean fullNameValid = !fullName.isBlank();
        boolean addressValid = !address.isBlank();

        boolean emailFormatValid = isEmailValid(email);
        boolean emailUnique = emailFormatValid && userService.getUserDao().findByEmail(email) == null;
        boolean emailValid = emailFormatValid && emailUnique;

        boolean phoneFormatValid = isPhoneValid(phone);
        boolean phoneUnique = phoneFormatValid && userService.getUserDao().findByPhone(phone) == null;
        boolean phoneValid = phoneFormatValid && phoneUnique;

        PasswordRules passwordRules = evaluatePassword(password);
        boolean passwordValid = passwordRules.allValid;
        boolean confirmPasswordValid = !confirmPassword.isBlank() && confirmPassword.equals(password);

        boolean formValid = fullNameValid && addressValid && emailValid && phoneValid && passwordValid && confirmPasswordValid;

        String emailMessage = !emailFormatValid
                ? "Email phải có dạng tenban@domain.com"
                : (emailUnique ? "Email hợp lệ" : "Email này đã được sử dụng");

        String phoneMessage = !phoneFormatValid
                ? "Số điện thoại phải đủ 10-12 số và bắt đầu từ số 0"
                : (phoneUnique ? "Số điện thoại hợp lệ" : "Số điện thoại này đã được sử dụng");

        String passwordMessage = passwordValid
                ? "Mật khẩu hợp lệ"
                : "Mật khẩu chưa đạt đủ các quy tắc";

        String confirmPasswordMessage = confirmPasswordValid
                ? "Mật khẩu xác nhận khớp"
                : "Mật khẩu xác nhận chưa khớp";

        StringBuilder json = new StringBuilder();
        json.append("{")
                .append("\"valid\":").append(formValid).append(",")
                .append("\"fields\":{")
                .append("\"fullName\":{\"valid\":").append(fullNameValid)
                .append(",\"message\":\"").append(escapeJson(fullNameValid ? "Họ và tên hợp lệ" : "Vui lòng nhập họ và tên")).append("\"},")
                .append("\"address\":{\"valid\":").append(addressValid)
                .append(",\"message\":\"").append(escapeJson(addressValid ? "Địa chỉ hợp lệ" : "Vui lòng nhập địa chỉ")).append("\"},")
                .append("\"email\":{\"valid\":").append(emailValid)
                .append(",\"message\":\"").append(escapeJson(emailMessage)).append("\"},")
                .append("\"phone\":{\"valid\":").append(phoneValid)
                .append(",\"message\":\"").append(escapeJson(phoneMessage)).append("\"},")
                .append("\"password\":{\"valid\":").append(passwordValid)
                .append(",\"message\":\"").append(escapeJson(passwordMessage)).append("\",")
                .append("\"rules\":{")
                .append("\"minLength\":").append(passwordRules.minLength).append(",")
                .append("\"hasUpper\":").append(passwordRules.hasUpper).append(",")
                .append("\"hasLower\":").append(passwordRules.hasLower).append(",")
                .append("\"hasDigit\":").append(passwordRules.hasDigit).append(",")
                .append("\"hasSpecial\":").append(passwordRules.hasSpecial).append(",")
                .append("\"noSpace\":").append(passwordRules.noSpace)
                .append("}},")
                .append("\"confirmPassword\":{\"valid\":").append(confirmPasswordValid)
                .append(",\"message\":\"").append(escapeJson(confirmPasswordMessage)).append("\"}")
                .append("}")
                .append("}");

        resp.getWriter().write(json.toString());
    }

    private static boolean isEmailValid(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        return email.toLowerCase().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.com$");
    }

    private static boolean isPhoneValid(String phone) {
        if (phone == null || phone.isBlank()) {
            return false;
        }
        return phone.matches("^0\\d{9,11}$");
    }

    private static boolean isPasswordValid(String password) {
        return evaluatePassword(password).allValid;
    }

    private static PasswordRules evaluatePassword(String password) {
        String value = password == null ? "" : password;

        PasswordRules rules = new PasswordRules();
        rules.minLength = value.length() >= 8;
        rules.hasUpper = value.matches(".*[A-Z].*");
        rules.hasLower = value.matches(".*[a-z].*");
        rules.hasDigit = value.matches(".*\\d.*");
        rules.hasSpecial = value.matches(".*[^A-Za-z0-9].*");
        rules.noSpace = !value.matches(".*\\s+.*");
        rules.allValid = rules.minLength && rules.hasUpper && rules.hasLower
                && rules.hasDigit && rules.hasSpecial && rules.noSpace;
        return rules;
    }

    private static String trimOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private static String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    private static class PasswordRules {
        boolean minLength;
        boolean hasUpper;
        boolean hasLower;
        boolean hasDigit;
        boolean hasSpecial;
        boolean noSpace;
        boolean allValid;
    }
}
