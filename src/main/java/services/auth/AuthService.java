package services.auth;

import dao.user.RememberTokenDao;
import dao.user.UserDao;
import model.user.RememberToken;
import model.user.User;
import utils.TokenGenerator;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.Base64;

public class AuthService {
    private final RememberTokenDao rememberTokenDao;
    private final UserDao userDao;
    private static final String REMEMBER_TOKEN_COOKIE = "REMEMBER_TOKEN";
    private static final int COOKIE_MAX_AGE = 30 * 24 * 60 * 60;
    private static final int TOKEN_EXPIRY_DAYS = 30;
    private static final String SESSION_USER_ID = "userId";

    public AuthService() {
        this.rememberTokenDao = new RememberTokenDao();
        this.userDao = new UserDao();
    }

    private String hashToken(String rawToken) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(rawToken.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi mã hóa token", e);
        }
    }

    public String generateAndSaveToken(int userId) {
        System.out.println("→ [AuthService] Generating secure token for user_id: " + userId);

        try {
            String rawToken = TokenGenerator.generateToken();

            String hashedToken = hashToken(rawToken);

            RememberToken token = new RememberToken();
            token.setUserId(userId);
            token.setToken(hashedToken);
            token.setExpiryDate(LocalDateTime.now().plusDays(TOKEN_EXPIRY_DAYS));
            token.setActive(true);

            int rows = rememberTokenDao.insert(token);

            if (rows > 0) {
                return rawToken;
            }
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error saving token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public User getUserFromToken(String rawTokenString) {
        try {
            String hashedToken = hashToken(rawTokenString);
            RememberToken tokenObj = rememberTokenDao.findByToken(hashedToken);

            if (tokenObj == null) {
                return null;
            }

            if (!tokenObj.isValid()) {
                return null;
            }

            User user = userDao.findById(tokenObj.getUserId());
            if (user == null) {
                System.out.println("→ [Debug] Lỗi 3: Token hợp lệ nhưng không tìm ra User có ID = " + tokenObj.getUserId());
            } else {
                System.out.println("→ [Debug] Lấy User THÀNH CÔNG: " + user.getEmail());
            }

            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void logoutFromDevice(String rawTokenString) {
        try {
            String hashedToken = hashToken(rawTokenString);
            RememberToken tokenObj = rememberTokenDao.findByToken(hashedToken);

            if (tokenObj != null) {
                rememberTokenDao.markTokenAsInvalid(tokenObj.getId());
                System.out.println("✓ [AuthService] Token invalidated successfully.");
            }
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error invalidating token: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int logoutFromAllDevices(int userId) {
        System.out.println("→ [AuthService] Logging out from all devices (userId: " + userId + ")");

        try {
            int rows = rememberTokenDao.markUserTokensAsInvalid(userId);

            System.out.println("✓ [AuthService] User logged out from " + rows + " devices (tokens marked invalid)");
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error logging out from all devices: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int getActiveDeviceCount(int userId) {
        try {
            return rememberTokenDao.countValidTokensByUserId(userId);
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error counting devices: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int cleanupExpiredTokens() {
        System.out.println("→ [AuthService] Running cleanup job for expired tokens...");

        try {
            int rows = rememberTokenDao.markExpiredTokensAsInvalid();
            System.out.println("✓ [AuthService] Cleanup complete: " + rows + " tokens marked invalid");
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error in cleanup job: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public static String getRememberTokenCookie() {
        return REMEMBER_TOKEN_COOKIE;
    }

    public static int getTokenExpiryDays() {
        return TOKEN_EXPIRY_DAYS;
    }

    public static String getSessionUserIdKey() {
        return SESSION_USER_ID;
    }
}
