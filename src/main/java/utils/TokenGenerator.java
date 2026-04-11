package utils;

import java.security.SecureRandom;
import java.util.Base64;

public class TokenGenerator {
    private static final int TOKEN_LENGTH = 64;
    private static final int RANDOM_BYTES = 48;
    private static final SecureRandom secureRandom = new SecureRandom();

    public static String generateToken() {
        byte[] randomBytes = new byte[RANDOM_BYTES];

        secureRandom.nextBytes(randomBytes);

        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    public static boolean isValidTokenFormat(String token) {
        if (token == null || token.isEmpty()) {
            return false;
        }

        if (token.length() != TOKEN_LENGTH) {
            System.err.println("✗ [TokenGenerator] Invalid token length: " + token.length() +
                    " (expected " + TOKEN_LENGTH + ")");
            return false;
        }

        if (!token.matches("^[A-Za-z0-9\\-_]+$")) {
            System.err.println("✗ [TokenGenerator] Invalid token format: contains invalid characters");
            return false;
        }

        return true;
    }

    public static int getTokenLength() {
        return TOKEN_LENGTH;
    }

}

