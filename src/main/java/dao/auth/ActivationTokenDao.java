package dao.auth;

import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;


import java.time.LocalDateTime;

public class ActivationTokenDao {
    private final Jdbi jdbi = JDBIConnector.getJdbi();
    public void saveToken(String email, String token, LocalDateTime expiresAt) {
        String sql = "INSERT INTO activation_token (email, token, expires_at) " +
                "VALUES (:email, :token, :expiresAt)";
        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bind("email", email)           
                        .bind("token", token)
                        .bind("expiresAt", expiresAt)
                        .execute()
        );
    }
    public String getEmailByToken(String token) {

        String sql = "SELECT email FROM activation_token " +
                "WHERE token = :token " +
                "AND is_used = 0 " +
                "AND expires_at > NOW()";

        return jdbi.withHandle(h -> h.createQuery(sql).bind("token", token).mapTo(String.class).findOne().orElse(null));
    }
    public void markTokenAsUsed(String token) {
        String sql = "UPDATE activation_token SET is_used = 1 WHERE token = :token";
        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bind("token", token)
                        .execute()
        );
    }
}
