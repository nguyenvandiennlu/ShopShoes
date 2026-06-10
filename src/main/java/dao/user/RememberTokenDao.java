package dao.user;

import dao.JDBIConnector;
import model.user.RememberToken;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class RememberTokenDao {

    private final Jdbi jdbi;

    // ===== CONSTRUCTOR =====
    /**
     * Constructor - Initialize JDBI connection
     */
    public RememberTokenDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public int insert(RememberToken token) {
        String sql = """
                INSERT INTO remember_token (user_id, token, expiry_date, is_active, invalidated_at)
                VALUES (:user_id, :token, :expiry_date, true, NULL)
                """;

        try {
            // Bước 1: Tạo handle (connection)
                Object expiryValue = token.getExpiryDate() == null ? null : java.sql.Timestamp.valueOf(token.getExpiryDate());

                int rows = jdbi.withHandle(handle ->
                    // Bước 2: Tạo update statement
                    handle.createUpdate(sql)
                        // Bước 3: Bind parameters
                        .bind("user_id", token.getUserId())
                        .bind("token", token.getToken())
                        .bind("expiry_date", expiryValue)
                        // Bước 4: Execute
                        .execute()
                );

            System.out.println("✓ [RememberTokenDao] Token inserted for user_id: " + token.getUserId());
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error inserting token: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }


    public RememberToken findByToken(String tokenString) {
        String sql = """
                SELECT * FROM remember_token 
                WHERE token = :token 
                  AND is_active = true
                  AND expiry_date > NOW()
                """;

        try {
            RememberToken token = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("token", tokenString)
                            .mapToBean(RememberToken.class)
                            .findOne()
                            .orElse(null)
            );

            if (token != null) {
                System.out.println("✓ [RememberTokenDao] Token found for user_id: " + token.getUserId());
            } else {
                System.out.println("✗ [RememberTokenDao] Token not found or expired");
            }
            return token;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error finding token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }


    public List<RememberToken> findByUserId(int userId) {
        String sql = """
                SELECT * FROM remember_token 
                WHERE user_id = :user_id 
                ORDER BY created_at DESC
                """;

        try {
            List<RememberToken> tokens = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("user_id", userId)
                            .mapToBean(RememberToken.class)
                            .list()  // Get all results as list
            );

            System.out.println("✓ [RememberTokenDao] Found " + tokens.size() + " tokens for user_id: " + userId);
            return tokens;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error finding tokens by user: " + e.getMessage());
            e.printStackTrace();
            return List.of();  // Return empty list on error
        }
    }


    public List<RememberToken> findValidByUserId(int userId) {
        String sql = """
                SELECT * FROM remember_token 
                WHERE user_id = :user_id 
                  AND is_active = true
                  AND expiry_date > NOW()
                ORDER BY created_at DESC
                """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("user_id", userId)
                            .mapToBean(RememberToken.class)
                            .list()
            );
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error finding valid tokens: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }
    }


    public int markTokenAsInvalid(int tokenId) {
        String sql = """
                UPDATE remember_token 
                SET is_active = false, invalidated_at = NOW()
                WHERE id = :id AND is_active = true
                """;
        try {
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", tokenId)
                            .execute()
            );
            System.out.println("✓ [RememberTokenDao] Token marked invalid, id: " + tokenId);
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error marking token as invalid: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int markUserTokensAsInvalid(int userId) {
        String sql = """
                UPDATE remember_token 
                SET is_active = false, invalidated_at = NOW()
                WHERE user_id = :user_id AND is_active = true
                """;
        try {
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("user_id", userId)
                            .execute()
            );
            System.out.println("✓ [RememberTokenDao] Marked " + rows + " tokens invalid for user_id: " + userId);
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error marking tokens as invalid: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int markExpiredTokensAsInvalid() {
        String sql = """
                UPDATE remember_token 
                SET is_active = false, invalidated_at = NOW()
                WHERE expiry_date < NOW() AND is_active = true
                """;

        try {
            int rows = jdbi.withHandle(handle ->
                    handle.createUpdate(sql).execute()
            );

            System.out.println("✓ [RememberTokenDao] Marked " + rows + " expired tokens as invalid");
            return rows;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error marking expired tokens: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public int countValidTokensByUserId(int userId) {
        String sql = """
                SELECT COUNT(*) as count FROM remember_token 
                WHERE user_id = :user_id 
                 AND is_active = true
                 AND expiry_date > NOW()
                """;

        try {
            Integer count = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("user_id", userId)
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(0)
            );

            return count;
        } catch (Exception e) {
            System.err.println("✗ [RememberTokenDao] Error counting tokens: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public boolean isTokenValid(String tokenString) {
        return findByToken(tokenString) != null;
    }
}
