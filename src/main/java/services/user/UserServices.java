package services.user;

import dao.user.UserDao;
import enums.Role;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.List;

public class UserServices {
    private final UserDao userDao;

    public UserServices(UserDao userDao) {
        this.userDao = userDao;
    }

    public UserServices() {
        this.userDao = new UserDao();
    }

    public UserDao getUserDao() {
        return userDao;
    }

    public User loginByEmail(String email, String password) {
        User user = userDao.findByEmail(email);
        if (user == null) {
            return null;
        }
        if (!user.isActive()) {
            return null;
        }
        if (user.getPasswordHash() != null
                && !user.getPasswordHash().isEmpty()
                && BCrypt.checkpw(password, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    public boolean register(String fullName, String phone, String email, String password, String address) {
        if (userDao.findByEmail(email) != null ||
                userDao.findByPhone(phone) != null) {
            return false;
        }
        User user = new User();
        user.setFullName(fullName);
        user.setPhoneNumber(phone);
        user.setEmail(email);
        user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt(12)));
        user.setAddress(address);
        user.setRole(Role.USER);
        user.setIsActive(true);
        user.setCreatedAt(LocalDateTime.now());
        user.setFirebaseUID("");
        user.setEmailVerified(false);

        return userDao.insertUser(user) > 0;
    }

    public User processGoogleLoginVerified(String email, String name, String firebaseUid, String picture) {
        User user = userDao.findByFirebaseUID(firebaseUid);
        if (user != null) {
            if (!user.isActive()) {
                throw new IllegalStateException("Tài khoản đã bị khóa");
            }
            System.out.println("User đã tồn tại theo firebase_uid: " + user.getId());
            return user;
        }
        user = userDao.findByEmail(email);
        if (user != null) {
            if (!user.isActive()) {
                throw new IllegalStateException("Tài khoản đã bị khóa");
            }
            System.out.println("User đã tồn tại theo email, cập nhật firebase_uid: " + user.getId());
            user.setFirebaseUID(firebaseUid);
            if (user.getFullName() == null || user.getFullName().isBlank()) {
                user.setFullName(name);
            }
            if ((user.getAvatarUrl() == null || user.getAvatarUrl().isBlank())
                    && picture != null && !picture.isBlank()) {
                user.setAvatarUrl(picture);
                userDao.updateAvatarUrl(user.getId(), picture);
            }
            userDao.update(user);
            return userDao.findById(user.getId());
        }
        System.out.println("Tạo user Google mới...");

        User newUser = new User();
        newUser.setEmail(email);
        newUser.setFullName(name != null ? name : "");
        newUser.setFirebaseUID(firebaseUid);
        newUser.setRole(Role.USER);
        newUser.setIsActive(true);
        newUser.setPasswordHash("");
        newUser.setAddress("");
        newUser.setAvatarUrl(picture);
        newUser.setCreatedAt(LocalDateTime.now());

        userDao.insertUser(newUser);
        User createdUser = userDao.findByEmail(email);
        if (createdUser != null && picture != null && !picture.isBlank()) {
            userDao.updateAvatarUrl(createdUser.getId(), picture);
        }
        return userDao.findByEmail(email);
    }
    public List<User> getUsers(int page, int pageSize, String search, String role, String status) {
        return userDao.findUsersWithPaginationAndFilters(page, pageSize, search, role, status);
    }
    public int countUsers(String search, String role, String status) {
        return userDao.countUsersWithFilters(search, role, status);
    }
    public String toggleUserStatus(int currentAdminId, int targetUserId, boolean isActive) {
        if (currentAdminId == targetUserId) {
            return "Không thể tự khóa hoặc mở khóa tài khoản của chính mình.";
        }
        User targetUser = userDao.findById(targetUserId);
        if (targetUser == null) {
            return "Tài khoản người dùng không tồn tại.";
        }
        if (Role.ADMIN.equals(targetUser.getRole()) && !isActive) {
            int activeAdminsCount = userDao.countUsersWithFilters(null, "ADMIN", "active");
            if (activeAdminsCount <= 1) {
                return "Không thể khóa tài khoản quản trị viên duy nhất đang hoạt động của hệ thống.";
            }
        }
        boolean success = userDao.updateUserStatus(targetUserId, isActive);
        if (success) {
            return "SUCCESS";
        } else {
            return "Cập nhật trạng thái thất bại. Vui lòng thử lại sau.";
        }
    }
}
