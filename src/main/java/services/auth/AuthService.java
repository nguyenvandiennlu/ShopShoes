package services.auth;

import dao.user.RememberTokenDao;
import dao.user.UserDao;
import model.user.RememberToken;
import model.user.User;
import utils.TokenGenerator;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import java.time.LocalDateTime;
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

    public String generateAndSaveToken(int userId) {
        System.out.println("→ [AuthService] Generating token for user_id: " + userId);

        try {
            String tokenString = TokenGenerator.generateToken();

            RememberToken token = new RememberToken();
            token.setUser_id(userId);
            token.setToken(tokenString);
            token.setExpiry_date(LocalDateTime.now().plusDays(TOKEN_EXPIRY_DAYS));

            int rows = rememberTokenDao.insert(token);

            if (rows > 0) {
                System.out.println("✓ [AuthService] Token saved successfully (is_active=true by default)");
                return tokenString;
            } else {
                System.err.println("✗ [AuthService] Failed to save token");
                return null;
            }
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error generating token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean validateToken(String tokenString) {
        System.out.println("→ [AuthService] Validating token...");

        try {
            if (!TokenGenerator.isValidTokenFormat(tokenString)) {
                System.err.println("✗ [AuthService] Invalid token format");
                return false;
            }

            boolean isValid = rememberTokenDao.isTokenValid(tokenString);

            if (isValid) {
                System.out.println("✓ [AuthService] Token is valid (active + not expired)");
            } else {
                System.err.println("✗ [AuthService] Token invalid (not found, invalidated, or expired)");
            }

            return isValid;
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error validating token: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public User getUserFromToken(String tokenString) {
        System.out.println("→ [AuthService] Getting user from token...");

        try {
            RememberToken tokenObj = rememberTokenDao.findByToken(tokenString);

            if (tokenObj == null) {
                System.err.println("✗ [AuthService] Token not found or invalid");
                return null;
            }

            int userId = tokenObj.getUser_id();
            User user = userDao.findById(userId);

            if (user != null) {
                System.out.println("✓ [AuthService] User retrieved from token: " + user.getEmail());
                return user;
            } else {
                System.err.println("✗ [AuthService] User not found for token");
                return null;
            }
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error getting user from token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public boolean logoutFromDevice(int tokenId) {
        System.out.println("→ [AuthService] Logging out from device (tokenId: " + tokenId + ")");

        try {
            int rows = rememberTokenDao.markTokenAsInvalid(tokenId);

            if (rows > 0) {
                System.out.println("✓ [AuthService] Device logged out");
                return true;
            } else {
                System.err.println("✗ [AuthService] Token not found or already invalid");
                return false;
            }
        } catch (Exception e) {
            System.err.println("✗ [AuthService] Error logging out from device: " + e.getMessage());
            e.printStackTrace();
            return false;
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
