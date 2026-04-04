package services.auth;

import services.user.UserServices;


public class RegisterService {

    private final UserServices userServices = new UserServices();
    private final ActivationService activationService = new ActivationService();


    public static class RegisterResult {
        public boolean success;
        public String message;
        public String activationLink;

        public RegisterResult(boolean success, String message, String activationLink) {
            this.success = success;
            this.message = message;
            this.activationLink = activationLink;
        }
    }

    private String validateAllFields(String fullName, String email, String phone,
                                     String password, String confirmPassword, String address) {


        if (fullName == null || fullName.isBlank()) {
            return "Vui lòng nhập họ tên";
        }
        if (fullName.length() < 2 || fullName.length() > 100) {
            return "Họ tên phải từ 2 đến 100 ký tự";
        }
        if (email == null || email.isBlank()) {
            return "Vui lòng nhập email";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            return "Email không hợp lệ (vd: example@gmail.com)";
        }

        if (phone == null || phone.isBlank()) {
            return "Vui lòng nhập số điện thoại";
        }
        if (!phone.matches("^[0-9]{10,11}$")) {
            return "Số điện thoại phải có 10-11 chữ số";
        }

        if (address == null || address.isBlank()) {
            return "Vui lòng nhập địa chỉ";
        }
        if (address.length() < 5 || address.length() > 200) {
            return "Địa chỉ phải từ 5 đến 200 ký tự";
        }

        if (password == null || password.isBlank()) {
            return "Vui lòng nhập mật khẩu";
        }
        password = password.trim();
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])\\S{8,}$";
        if (!password.matches(passwordRegex)) {
            return "Mật khẩu >= 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt (không chứa khoảng trắng)";
        }

        if (confirmPassword == null || confirmPassword.isBlank()) {
            return "Vui lòng xác nhận mật khẩu";
        }
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp";
        }
        return null;
    }

    public RegisterResult register(String fullName, String email, String phone,
                                   String password, String confirmPassword,
                                   String address, String baseUrl) {

        String validationError = validateAllFields(fullName, email, phone, password, confirmPassword, address);
        if (validationError != null) {
            return new RegisterResult(false, validationError, null);
        }

        boolean userCreated = userServices.register(fullName, phone, email, password.trim(), address);
        if (!userCreated) {
            return new RegisterResult(false, "Email hoặc số điện thoại đã được sử dụng", null);
        }

        String token = activationService.createActivationToken(email);

        String activationLink = baseUrl + "/activate?token=" + token;

        return new RegisterResult(true, "Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt", activationLink);
    }
}