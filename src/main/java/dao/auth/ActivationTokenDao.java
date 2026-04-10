package dao.auth;

import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.time.LocalDateTime;
import enums.TokenType;

public class ActivationTokenDao {
        private final Jdbi jdbi = JDBIConnector.getJdbi();

        public void saveToken(String email, String token, TokenType tokenType, LocalDateTime expiresAt) {
                String sql = "INSERT INTO activation_token (email, token, token_type, expires_at) " +
                                "VALUES (:email, :token, :tokenType, :expiresAt)";
                jdbi.useHandle(h -> h.createUpdate(sql)
                                .bind("email", email)
                                .bind("token", token)
                                .bind("tokenType", tokenType.name())
                                .bind("expiresAt", expiresAt)
                                .execute());
        }

        public String getEmailByToken(String token, TokenType tokenType) {

                String sql = "SELECT email FROM activation_token " +
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
                String sql = "UPDATE activation_token SET is_used = 1 WHERE token = :token";
                jdbi.useHandle(h -> h.createUpdate(sql)
                                .bind("token", token)
                                .execute());
        }
}
