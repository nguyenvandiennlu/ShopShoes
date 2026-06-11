package dao.user;

import dao.JDBIConnector;
import model.user.User;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Objects;
import java.sql.Timestamp;

public class UserDao {

    private final Jdbi jdbi;

    public UserDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public User findByEmail(String email) {
        if (email == null || email.isEmpty()) {
            return null;
        }

        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(:email)";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email.trim())
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }

    public User findByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone_number = :phone";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("phone", phone)
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }

    public User findById(Integer id) {
        String sql = "SELECT * FROM users WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(User.class)
                .list());
    }

    public int insertUser(User user) {
        String sql = """
                    INSERT INTO users (
                        email, password_hash, phone_number, address, full_name, role, is_active, created_at, firebase_uid, email_verified
                    )
                    VALUES (
                        :email, :passwordHash, :phoneNumber, :address, :fullName, :role, :isActive, :createdAt, :firebaseUID, :emailVerified
                    )
                """;

        try {
                // Convert LocalDateTime to SQL Timestamp for reliable JDBC binding
                Object createdAtValue = user.getCreatedAt() == null ? null : Timestamp.valueOf(user.getCreatedAt());

                int rows = jdbi.withHandle(handle -> handle.createUpdate(sql)
                    .bind("email", user.getEmail())
                    .bind("passwordHash", user.getPasswordHash())
                    .bind("phoneNumber", user.getPhoneNumber())
                    .bind("address", user.getAddress())
                    .bind("fullName", user.getFullName())
                    .bind("role", user.getRole() != null ? user.getRole().name() : null)
                    .bind("isActive", user.isActive())
                    .bind("createdAt", createdAtValue)
                    .bind("firebaseUID", user.getFirebaseUID())
                    .bind("emailVerified", user.isEmailVerified())
                    .execute());

            System.out.println("insertUser rows = " + rows);
            return rows;
        } catch (Exception e) {
            System.err.println("[ERROR] insertUser FAILED: " + e.getMessage());
            System.err.println("[ERROR] Full trace:");
            e.printStackTrace();
            return 0;
        }
    }

    public boolean updatePassword(String email, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = :password WHERE email = :email";

        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("email", email)
                .bind("password", newPasswordHash)
                .execute()) > 0;
    }

    public boolean activateByEmail(String email) {
        String sql = "UPDATE users SET is_active = 1 WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("email", email)
                .execute()) > 0;
    }

    public boolean verifyEmailByEmail(String email) {
        String sql = "UPDATE users SET email_verified = 1 WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("email", email)
                .execute()) > 0;
    }

    public int update(User user) {
        boolean hasPassword = user.getPasswordHash() != null;

        String sql = hasPassword
                ? """
                          UPDATE users SET
                              email = :email,
                              password_hash = :passwordHash,
                              phone_number = :phoneNumber,
                              address = :address,
                              full_name = :fullName,
                              role = :role,
                              is_active = :isActive,
                              firebase_uid = :firebaseUID,
                              email_verified = :emailVerified
                          WHERE id = :id
                        """
                : """
                          UPDATE users SET
                              email = :email,
                              phone_number = :phoneNumber,
                              address = :address,
                              full_name = :fullName,
                              role = :role,
                              is_active = :isActive,
                              firebase_uid = :firebaseUID,
                              email_verified = :emailVerified
                          WHERE id = :id
                        """; 

        return jdbi.withHandle(h -> {
            var q = h.createUpdate(sql)
                    .bind("id", user.getId())
                    .bind("email", user.getEmail())
                    .bind("phoneNumber", user.getPhoneNumber())
                    .bind("address", user.getAddress())
                    .bind("fullName", user.getFullName())
                    .bind("role", user.getRole() != null ? user.getRole().name() : null)
                    .bind("isActive", user.isActive())
                    .bind("firebaseUID", user.getFirebaseUID())
                    .bind("emailVerified", user.isEmailVerified());

            if (hasPassword) {
                q.bind("passwordHash", user.getPasswordHash());
            }

            return q.execute();
        });
    }

    public void delete(Integer id) {
        String sql = """
                UPDATE users
                SET is_active = 0
                WHERE id = :id
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    public boolean deleteById(Integer id) {
        String sql = "DELETE FROM users WHERE id = :id";
        return jdbi.withHandle(h -> h.createUpdate(sql)
                .bind("id", id)
                .execute()) > 0;
    }

    public Integer todayCustomers() {
        String sql = """
                SELECT COUNT(*) AS total
                FROM users u
                WHERE u.created_at >= CURDATE()
                AND u.created_at < CURDATE() + INTERVAL 1 DAY;
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public boolean updateProfile(int userId, String fullName, String phone, String address) {
        String sql = "UPDATE users SET full_name = :fullName, phone_number = :phone, address = :address WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("fullName", fullName)
                .bind("phone", phone)
                .bind("address", address)
                .bind("id", userId)
                .execute()) > 0;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = :password WHERE id = :id";
        return jdbi.withHandle(h -> h.createUpdate(sql)
                .bind("id", userId)
                .bind("password", newPasswordHash)
                .execute()) > 0;
    }
    public User findByFirebaseUID(String firebaseUID) {
        String sql = "SELECT * FROM users WHERE firebase_uid = :firebaseUID";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("firebaseUID", firebaseUID)
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }
    public boolean updateFirebaseUID(int userId, String firebaseUID) {
        String sql = "UPDATE users SET firebase_uid = :firebaseUID WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("firebaseUID", firebaseUID)
                .bind("id", userId)
                .execute()) > 0;
    }

    public boolean updateAvatarUrl(int userId, String avatarUrl) {
        String sql = "UPDATE users SET avatar_url = :avatarUrl WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("avatarUrl", avatarUrl)
                .bind("id", userId)
                .execute()) > 0;
    }
}
