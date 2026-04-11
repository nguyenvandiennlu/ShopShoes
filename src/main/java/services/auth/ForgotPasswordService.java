package services.auth;

import dao.auth.ActivationTokenDao;
import dao.user.UserDao;
import enums.TokenType;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

import java.security.SecureRandom;
import java.time.LocalDateTime;

public class ForgotPasswordService {

    private final UserDao userDao;
    private final ActivationTokenDao tokenDao;
    private static final long OTP_EXPIRE = 2 * 60 * 1000;
    private static final SecureRandom RANDOM = new SecureRandom();

    public ForgotPasswordService() {
        this.userDao = new UserDao();
        this.tokenDao = new ActivationTokenDao();
    }

    public ForgotPasswordService(UserDao userDao, ActivationTokenDao tokenDao) {
        this.userDao = userDao;
        this.tokenDao = tokenDao;
    }

    public String sendOtp(String email, HttpSession session) {
        if (email == null || email.isBlank()) {
            return "Vui lòng nhập email";
        }

        email = email.trim();

        User user = userDao.findByEmail(email);
        if (user == null) {
            return "Email không tồn tại";
        }

        String otp = generateOtp();

        tokenDao.invalidateAllTokensByEmail(email, TokenType.FORGOT_PASSWORD);
        tokenDao.saveToken(
                email,
                otp,
                TokenType.FORGOT_PASSWORD,
                LocalDateTime.now().plusMinutes(2)
        );

        session.setAttribute("resetEmail", email);
        session.removeAttribute("otpVerified");

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

        tokenDao.markTokenAsUsed(email, inputOtp, TokenType.FORGOT_PASSWORD);
        session.setAttribute("otpVerified", true);
        return null;
    }

    public String resetPassword(String password, String confirmPassword, HttpSession session) {
        String email = (String) session.getAttribute("resetEmail");
        Boolean verified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || verified == null || !verified) {
            return "Bạn chưa xác thực OTP";
        }

        if (password == null || confirmPassword == null) {
            return "Vui lòng nhập đầy đủ mật khẩu";
        }

        password = password.trim();
        confirmPassword = confirmPassword.trim();

        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }

        String passwordRegex =
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])\\S{8,}$";

        if (!password.matches(passwordRegex)) {
            return "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt";
        }

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
        boolean updated = userDao.updatePassword(email, hashed);

        if (!updated) {
            return "Không thể đổi mật khẩu";
        }

        clearResetSession(session);
        return null;
    }

    private String generateOtp() {
        return String.valueOf(100000 + RANDOM.nextInt(900000));
    }

    private void clearResetSession(HttpSession session) {
        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");
    }
}