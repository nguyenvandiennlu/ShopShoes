package services.auth;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
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
    private static final int SO_LAN_SAI_TOI_DA = 5;
    private static final long THOI_GIAN_KHOA_MS = 60 * 60 * 1000;
    public ForgotPasswordService() {
        this.userDao = new UserDao();
        this.tokenDao = new TokenTypeDao();
    }
    public String sendOtp(String email, HttpSession session) {
        if (email == null || email.isBlank()) {
            return "Vui lòng nhập email";
        }
        String thongBaoKhoa = kiemTraKhoa(session);
        if (thongBaoKhoa != null) return thongBaoKhoa;
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
        if (user != null) {
            String otp = generateOtp();
            String hashOTP = hashSHA256(email + ":" + otp);
            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(15);
            tokenDao.invalidateAllTokensByEmail(email, TokenType.FORGOT_PASSWORD);
            tokenDao.saveToken(email, hashOTP, TokenType.FORGOT_PASSWORD, expiryTime);
            session.setAttribute("resetEmail", email);
            session.removeAttribute("otpVerified");
            session.removeAttribute("verifiedOtp");
            session.removeAttribute("soLanNhapSai");
        }

        return "Nếu email tồn tại, mã OTP đã được gửi";
    }
    public String verifyOtp(String inputOtp, HttpSession session) {
        String email = (String) session.getAttribute("resetEmail");
        if (email == null || email.isBlank()) {
            return "Phiên làm việc đã hết hạn";
        }

        String thongBaoKhoa = kiemTraKhoa(session);
        if (thongBaoKhoa != null) return thongBaoKhoa;

        if (inputOtp == null || inputOtp.isBlank()) {
            return "Vui lòng nhập mã OTP";
        }
        inputOtp = inputOtp.trim();
        String hashInput = hashSHA256(email + ":" + inputOtp);
        boolean valid = tokenDao.isValidToken(email, hashInput, TokenType.FORGOT_PASSWORD);
        if (!valid) {
            Integer soLanSai = (Integer) session.getAttribute("soLanNhapSai");
            soLanSai = (soLanSai == null) ? 1 : soLanSai + 1;

            if (soLanSai >= SO_LAN_SAI_TOI_DA) {
                session.setAttribute("thoiDiemKhoa", System.currentTimeMillis());
                tokenDao.invalidateAllTokensByEmail(email, TokenType.FORGOT_PASSWORD);
                clearResetSession(session);
                return "Nhập sai quá " + SO_LAN_SAI_TOI_DA + " lần. Vui lòng thử lại sau 1 giờ";
            }
            session.setAttribute("soLanNhapSai", soLanSai);
            int conLai = SO_LAN_SAI_TOI_DA - soLanSai;
            return "Mã OTP không đúng. Còn " + conLai + " lần thử";
        }
        session.removeAttribute("soLanNhapSai");
        session.setAttribute("otpVerified", true);
        session.setAttribute("verifiedOtp", hashInput);
        return null;
    }

    public String resetPassword(String password, String confirmPassword, HttpSession session) {
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
        session.removeAttribute("soLanNhapSai");
    }
    private String kiemTraKhoa(HttpSession session) {
        Long thoiDiemKhoa = (Long) session.getAttribute("thoiDiemKhoa");
        if (thoiDiemKhoa == null) return null;
        long daQuaMs = System.currentTimeMillis() - thoiDiemKhoa;
        if (daQuaMs >= THOI_GIAN_KHOA_MS) {
            session.removeAttribute("thoiDiemKhoa");
            session.removeAttribute("soLanNhapSai");
            return null;
        }
        long phutConLai = (long) Math.ceil((THOI_GIAN_KHOA_MS - daQuaMs) / 60000.0);
        return "Bạn đã nhập sai quá nhiều lần. Thử lại sau " + phutConLai + " phút";
    }
    private String hashSHA256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hashBytes) {
                hex.append(String.format("%02x", b));
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 khong kha dung", e);
        }
    }
}