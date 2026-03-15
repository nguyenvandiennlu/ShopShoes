package services.auth;

import dao.user.UserDao;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Random;

public class ForgotPasswordService {

    private final UserDao userDao;
    private static final long OTP_EXPIRE = 5 * 60 * 1000; // 5 phút

    public ForgotPasswordService(UserDao userDao) {
        this.userDao = userDao;
    }

    /* ===== SEND OTP ===== */
    public String sendOtp(String email, HttpSession session) {

        if (email == null || email.isBlank()) {
            return "Vui lòng nhập email";
        }

        User user = userDao.findByEmail(email);
        if (user == null) {
            return "Email không tồn tại";
        }

        String otp = generateOtp();

        session.setAttribute("resetEmail", email);
        session.setAttribute("resetOtp", otp);
        session.setAttribute("otpTime", System.currentTimeMillis());
        session.removeAttribute("otpVerified");
        session.removeAttribute("otpFailedAttempts");

        return otp; // controller sẽ gửi mail
    }

    /* ===== VERIFY OTP ===== */
    public String verifyOtp(String inputOtp, HttpSession session) {

        String savedOtp = (String) session.getAttribute("resetOtp");
        Long otpTime = (Long) session.getAttribute("otpTime");

        if (inputOtp == null || inputOtp.isBlank()) {
            return "Vui lòng nhập mã OTP";
        }

        if (savedOtp == null || otpTime == null) {
            return "Phiên làm việc hết hạn";
        }

        if (System.currentTimeMillis() - otpTime > OTP_EXPIRE) {
            clearOtp(session);
            return "Mã OTP đã hết hạn";
        }

        if (savedOtp.equals(inputOtp)) {
            session.setAttribute("otpVerified", true);
            clearOtp(session);
            return null; // null = OK
        }

        Integer fails = (Integer) session.getAttribute("otpFailedAttempts");
        if (fails == null) fails = 0;
        fails++;

        session.setAttribute("otpFailedAttempts", fails);

        if (fails >= 3) {
            clearOtp(session);
            session.removeAttribute("otpFailedAttempts");
            return "Bạn đã nhập sai quá 3 lần. Vui lòng gửi lại OTP";
        }

        return "OTP không đúng. Còn " + (3 - fails) + " lần thử";
    }

    /* ===== RESET PASSWORD ===== */
    public String resetPassword(String password, String confirmPassword, HttpSession session) {

        String email = (String) session.getAttribute("resetEmail");
        Boolean verified = (Boolean) session.getAttribute("otpVerified");

        if (email == null || verified == null || !verified) {
            return "Chưa xác thực OTP";
        }

        if (password == null || confirmPassword == null) {
            return "Vui lòng nhập đầy đủ mật khẩu";
        }

        password = password.trim();
        confirmPassword = confirmPassword.trim();

        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }

        // Regex mật khẩu mạnh
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

        session.invalidate(); // xóa toàn bộ state reset
        return null; // null = thành công
    }



    private String generateOtp() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }

    private void clearOtp(HttpSession session) {
        session.removeAttribute("resetOtp");
        session.removeAttribute("otpTime");
    }
}
