package services.user;

import dao.user.UserDao;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;

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
        if(!user.isActive()){
            return null;
        }
        if ( user.getPasswordHash() != null
            && !user.getPasswordHash().isEmpty() 
            && BCrypt.checkpw(password, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    public boolean register(String fullName, String phone, String email, String password,String address) {

        // check trùng email / phone
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
        user.setRole("user");
        user.setIsActive(false);
        user.setCreatedAt(LocalDateTime.now());
        user.setFirebaseUID(null);

        return userDao.insertUser(user) > 0;
    }
    
    public User processSocialLogin(String email, String name, String firebase_uid, String provider) {

        // TÌM USER TRONG DB THEO EMAIL
        User user = userDao.findByEmail(email);
        //                  ↑
        //          Query: SELECT * FROM users WHERE email = 'nguyenvana@gmail.com'

        if (user != null) {
            // USER ĐÃ TỒN TẠI → Trả về luôn
            System.out.println("User đã tồn tại: " + user.getId());
            return user;
        } else {
            // USER CHƯA TỒN TẠI → Tạo mới
            System.out.println("Tạo user mới...");

            // TẠO OBJECT USER MỚI
            User newUser = new User();
            newUser.setEmail(email);                    // "nguyenvana@gmail.com"
            newUser.setFullName(name);                  // "Nguyễn Văn A"
            newUser.setFirebaseUID(firebase_uid);       // "AbC123XyZ"
            newUser.setRole("user");                    // Role mặc định
            newUser.setIsActive(true);                    // Kích hoạt ngay
            newUser.setPasswordHash("");
            newUser.setAddress("");
            // Google login không cần password
            newUser.setCreatedAt(LocalDateTime.now());  // Thời gian hiện tại

            //LƯU VÀO DATABASE
            userDao.insertUser(newUser);

            //LẤY LẠI USER VỪA TẠO (để có ID)
            return userDao.findByEmail(email);
        }
    }
}

