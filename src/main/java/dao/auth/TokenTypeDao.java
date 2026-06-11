package dao.auth;

import java.time.LocalDateTime;
import java.sql.Timestamp;

import org.jdbi.v3.core.Jdbi;

import dao.JDBIConnector;
import enums.TokenType;

public class TokenTypeDao {
        private final Jdbi jdbi = JDBIConnector.getJdbi();

        public void saveToken(String email, String token, TokenType tokenType, LocalDateTime expiresAt) {
                String sql = "INSERT INTO tokentype (email, token, token_type, created_at, expires_at) " +
                                "VALUES (:email, :token, :tokenType, NOW(), :expiresAt)";
                Object expiresAtValue = expiresAt == null ? null : Timestamp.valueOf(expiresAt);

                jdbi.useHandle(h -> h.createUpdate(sql)
                                .bind("email", email)
                                .bind("token", token)
                                .bind("tokenType", tokenType.name())
                                .bind("expiresAt", expiresAtValue)
                                .execute());
        }

        public String getEmailByToken(String token, TokenType tokenType) {

                String sql = "SELECT email FROM tokentype " +
                                "WHERE token = :token " +
                                "AND token_type = :tokenType " +
                                "AND is_used = 0 " +
                                "AND expires_at > NOW()";

                return jdbi.withHandle(h -> h.createQuery(sql)
                                .bind("token", token)
                                .bind("tokenType", tokenType.name()).mapTo(String.class).findOne()
                                .orElse(null));
        }

        public void markTokenAsUsed(String token) {
                String sql = "UPDATE tokentype SET is_used = 1 WHERE token = :token";
                jdbi.useHandle(h -> h.createUpdate(sql)
                                .bind("token", token)
                                .execute());
        }
        public boolean isValidToken(String email, String token, TokenType tokenType) {
                String sql = "SELECT COUNT(*) FROM tokentype " +
                        "WHERE email = :email " +
                        "AND token = :token " +
                        "AND token_type = :tokenType " +
                        "AND is_used = 0 " +
                        "AND expires_at > NOW()";

                Integer count = jdbi.withHandle(h -> h.createQuery(sql)
                        .bind("email", email)
                        .bind("token", token)
                        .bind("tokenType", tokenType.name())
                        .mapTo(Integer.class)
                        .one());

                return count != null && count > 0;
        }

        public void markTokenAsUsed(String email, String token, TokenType tokenType) {
                String sql = "UPDATE tokentype " +
                        "SET is_used = 1 " +
                        "WHERE email = :email " +
                        "AND token = :token " +
                        "AND token_type = :tokenType";

                jdbi.useHandle(h -> h.createUpdate(sql)
                        .bind("email", email)
                        .bind("token", token)
                        .bind("tokenType", tokenType.name())
                        .execute());
        }

        public void invalidateAllTokensByEmail(String email, TokenType tokenType) {
                String sql = "UPDATE tokentype " +
                        "SET is_used = 1 " +
                        "WHERE email = :email " +
                        "AND token_type = :tokenType " +
                        "AND is_used = 0";

                jdbi.useHandle(h -> h.createUpdate(sql)
                        .bind("email", email)
                        .bind("tokenType", tokenType.name())
                        .execute());
        }
        public boolean existsRecentToken(String email, TokenType type, LocalDateTime after) {
                String sql = "SELECT COUNT(*) FROM tokentype " +
                        "WHERE email = :email " +
                        "AND token_type = :type " +
                        "AND created_at > :after " +
                        "AND is_used = 0 " +
                        "AND expires_at > NOW()";
                Object afterValue = after == null ? null : Timestamp.valueOf(after);

                Integer count = jdbi.withHandle(handle -> handle.createQuery(sql)
                        .bind("email", email)
                        .bind("type", type.name())
                        .bind("after", afterValue)
                        .mapTo(Integer.class)
                        .one());
                return count != null && count > 0;
        }
        public int countTokensAfter(String email, TokenType type, LocalDateTime after) {
                String sql = "SELECT COUNT(*) FROM tokentype " +
                        "WHERE email = :email " +
                        "AND token_type = :type " +
                        "AND created_at > :after";
                Object afterValue = after == null ? null : Timestamp.valueOf(after);

                Integer count = jdbi.withHandle(handle -> handle.createQuery(sql)
                        .bind("email", email)
                        .bind("type", type.name())
                        .bind("after", afterValue)
                        .mapTo(Integer.class)
                        .one());
                return count != null ? count : 0;
        }
}
