package dao.user;

import dao.JDBIConnector;
import model.user.User;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Objects;

public class UserDao {

    private final Jdbi jdbi;

    public UserDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    // ===== FIND BY EMAIL =====
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }

    // ===== FIND BY PHONE =====
    public User findByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone_number = :phone";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("phone", phone)
                .mapToBean(User.class)
                .findOne()
                .orElse(null));
    }

    // ===== FIND BY ID =====
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

    // ===== INSERT USER =====
    public int insertUser(User user) {
        String sql = """
                    INSERT INTO users (
                        email, password_hash, phone_number, address, full_name, role, is_active, created_at, firebase_uid
                    )
                    VALUES (
                        :email, :passwordHash, :phoneNumber, :address, :fullName, :role, :isActive, :createdAt, :firebaseUID
                    )
                """;

        try {
            int rows = jdbi.withHandle(handle -> handle.createUpdate(sql)
                    .bind("email", user.getEmail())
                    .bind("passwordHash", user.getPasswordHash())
                    .bind("phoneNumber", user.getPhoneNumber())
                    .bind("address", user.getAddress())
                    .bind("fullName", user.getFullName())
                    .bind("role", user.getRole() != null ? user.getRole().name() : null)
                    .bind("isActive", user.isActive())
                    .bind("createdAt", user.getCreatedAt())
                    .bind("firebaseUID", user.getFirebaseUID())
                    .execute());

            System.out.println("insertUser rows = " + rows);
            return rows;
        } catch (Exception e) {
            System.out.println("insertUser FAILED!");
            e.printStackTrace();
            return 0;
        }
    }

    // ===== UPDATE PASSWORD (cho quên mật khẩu) =====
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
                              firebase_uid = :firebaseUID
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
                              firebase_uid = :firebaseUID
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
                    .bind("firebaseUID", user.getFirebaseUID());

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
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user")));
    }
    public boolean updateFirebaseUID(int userId, String firebaseUID) {
        String sql = "UPDATE users SET firebase_uid = :firebaseUID WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("firebaseUID", firebaseUID)
                .bind("id", userId)
                .execute()) > 0;
    }
}
