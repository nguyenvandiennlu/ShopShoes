package services.user;

import dao.order.OrderDao;
import dao.order.OrderDetailDao;
import dao.user.UserDao;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

public class AccountServices {

    private final UserDao userDao;

    private final OrderDao orderDao;
    private final OrderDetailDao orderDetailDao;

    public AccountServices() {
        this.userDao = new UserDao();
        this.orderDao = new OrderDao();
        this.orderDetailDao = new OrderDetailDao();
    }

    public java.util.List<model.Order.Order> getOrderHistory(int userId) {
        // 1. Lấy danh sách đơn hàng
        java.util.List<model.Order.Order> orders = orderDao.findWithFilter(null, userId, null);

        // 2. Lấy chi tiết cho từng đơn hàng
        for (model.Order.Order order : orders) {
            java.util.List<model.Order.OrderDetailDTO> items = orderDetailDao.findByOrderId(order.getId());
            order.setItems(items);
        }

        return orders;
    }

    public java.util.List<model.Order.Order> getOrderHistoryPaginated(int userId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        java.util.List<model.Order.Order> orders = orderDao.findByUserIdWithPagination(userId, pageSize, offset);

        // Lấy chi tiết cho từng đơn hàng
        for (model.Order.Order order : orders) {
            java.util.List<model.Order.OrderDetailDTO> items = orderDetailDao.findByOrderId(order.getId());
            order.setItems(items);
        }

        return orders;
    }

    public int getOrderCount(int userId) {
        return orderDao.countByUserId(userId);
    }

    public boolean updateUserProfile(int userId, String fullName, String phone, String address) {
        return userDao.updateProfile(userId, fullName, phone, address);
    }

    public boolean updateAvatarUrl(int userId, String avatarUrl) {
        return userDao.updateAvatarUrl(userId, avatarUrl);
    }

    public String changePassword(String email, String currentPassword, String newPassword, String confirmPassword) {
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp!";
        }

        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])\\S{8,}$";
        if (!newPassword.matches(passwordRegex)) {
            return "Mật khẩu yếu: Cần 8 ký tự, hoa, thường, số và ký tự đặc biệt.";
        }

        User user = userDao.findByEmail(email);
        if (user == null) {
            return "Người dùng không tồn tại.";
        }

        // Kiểm tra mật khẩu cũ
        if (user.getPasswordHash() == null || !BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            return "Mật khẩu hiện tại không đúng!";
        }

        // Mã hóa mật khẩu mới
        if (BCrypt.checkpw(newPassword, user.getPasswordHash())) {
            return "Mật khẩu mới phải khác mật khẩu hiện tại!";
        }

        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

        // Cập nhật vào DB
        boolean success = userDao.updatePassword(email, hashedNewPassword);
        if (success) {
            return "SUCCESS";
        } else {
            return "Lỗi hệ thống, vui lòng thử lại sau.";
        }
    }
}
