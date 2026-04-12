package services.auth;

import java.security.SecureRandom;
import java.time.LocalDateTime;

import org.mindrot.jbcrypt.BCrypt;

import dao.auth.TokenTypeDao;
import dao.user.UserDao;
import enums.TokenType;
import jakarta.servlet.http.HttpSession;
import model.user.User;

public class ForgotPasswordService {
    private final UserDao userDao;
    private final TokenTypeDao tokenDao;
    private static final SecureRandom RANDOM = new SecureRandom();

    public ForgotPasswordService() {
        this.userDao = new UserDao();
        this.tokenDao = new TokenTypeDao();
    }

    public String sendOtp(String email, HttpSession session) {
        if (email == null || email.isBlank()) {
            return "Vui lòng nhập email";
        }
        email = email.trim();
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Email không hợp lệ. Ví dụ: example@gmail.com";
        }
        LocalDateTime oneMinuteAgo = LocalDateTime.now().minusSeconds(60);
        boolean recentlyRequested = tokenDao.existsRecentToken(email, TokenType.FORGOT_PASSWORD, oneMinuteAgo);

        if (recentlyRequested) {
            return "Vui lòng chờ 60 giây trước khi yêu cầu OTP mới";
        }
        LocalDateTime oneHourAgo = LocalDateTime.now().minusHours(1);
        int countLastHour = tokenDao.countTokensAfter(email, TokenType.FORGOT_PASSWORD, oneHourAgo);
        if (countLastHour >= 5) {
            return "Bạn đã yêu cầu OTP quá nhiều lần. Vui lòng thử lại sau 1 giờ";
        }
        User user = userDao.findByEmail(email);
        if (user == null) {
            return "Email không tồn tại";
        }
        String otp = generateOtp();
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(15);
        tokenDao.invalidateAllTokensByEmail(email, TokenType.FORGOT_PASSWORD);
        tokenDao.saveToken(email, otp, TokenType.FORGOT_PASSWORD, expiryTime);
        session.setAttribute("resetEmail", email);
        session.removeAttribute("otpVerified");
        session.removeAttribute("verifiedOtp");
        return otp;
    }

    public String verifyOtp(String inputOtp, HttpSession session) {
        String email = (String) session.getAttribute("resetEmail");

        if (email == null || email.isBlank()) {
            return "Phiên làm việc đã hết hạn";
        }
        if (inputOtp == null || inputOtp.isBlank()) {
            return "Vui lòng nhập mã OTP";
        }
        inputOtp = inputOtp.trim();
        boolean valid = tokenDao.isValidToken(email, inputOtp, TokenType.FORGOT_PASSWORD);
        if (!valid) {
            return "Mã OTP không đúng hoặc đã hết hạn";
        }
        session.setAttribute("otpVerified", true);
        session.setAttribute("verifiedOtp", inputOtp);
        return null;
    }

    public String resetPassword(String password, String confirmPassword, HttpSession session) {
        // ===== VALIDATE SESSION & OTP VERIFICATION =====
        String email = (String) session.getAttribute("resetEmail");
        Boolean verified = (Boolean) session.getAttribute("otpVerified");
        String verifiedOtp = (String) session.getAttribute("verifiedOtp");
        if (email == null || verified == null || !verified) {
            return "Bạn chưa xác thực OTP";
        }
        if (verifiedOtp == null) {
            return "OTP không hợp lệ";
        }
        boolean valid = tokenDao.isValidToken(email, verifiedOtp, TokenType.FORGOT_PASSWORD);
        if (!valid) {
            return "OTP đã hết hạn, vui lòng yêu cầu mã mới";
        }
        if (password == null || confirmPassword == null) {
            return "Vui lòng nhập đầy đủ mật khẩu";
        }
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])\\S{8,}$";
        if (!password.matches(passwordRegex)) {
            return "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt";
        }
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
        boolean updated = userDao.updatePassword(email, hashed);

        if (!updated) {
            return "Không thể đổi mật khẩu";
        }
        tokenDao.markTokenAsUsed(email, verifiedOtp, TokenType.FORGOT_PASSWORD);
        clearResetSession(session);
        return null;
    }

    private String generateOtp() {
        return String.format("%06d", RANDOM.nextInt(1000000));
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");
        session.removeAttribute("verifiedOtp");
    }
}