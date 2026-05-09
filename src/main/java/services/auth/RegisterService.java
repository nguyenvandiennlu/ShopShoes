package services.auth;

import services.user.UserServices;
import java.util.LinkedHashMap;
import java.util.Map;


public class RegisterService {

    private final UserServices userServices = new UserServices();
    private final TokenTypeService tokenTypeService = new TokenTypeService();


    public static class RegisterResult {
        public boolean success;
        public String message;
        public String activationLink;
        public String email;
        public String token;

        public RegisterResult(boolean success, String message, String activationLink) {
            this.success = success;
            this.message = message;
            this.activationLink = activationLink;
        }

        public RegisterResult(boolean success, String message, String activationLink, String email, String token) {
            this.success = success;
            this.message = message;
            this.activationLink = activationLink;
            this.email = email;
            this.token = token;
        }
    }

    public static class PasswordRules {
        public boolean minLength;
        public boolean hasUpper;
        public boolean hasLower;
        public boolean hasDigit;
        public boolean hasSpecial;
        public boolean noSpace;
        public boolean allValid;
    }

    public static class FieldValidationResult {
        public final boolean valid;
        public final String message;

        public FieldValidationResult(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }
    }

    public static class AjaxValidationResult {
        public final boolean valid;
        public final Map<String, FieldValidationResult> fields;
        public final PasswordRules passwordRules;

        public AjaxValidationResult(boolean valid, Map<String, FieldValidationResult> fields, PasswordRules passwordRules) {
            this.valid = valid;
            this.fields = fields;
            this.passwordRules = passwordRules;
        }
    }

    private String validateAllFields(String fullName, String email, String phone,
                                     String password, String confirmPassword, String address) {


        if (fullName == null || email == null || phone == null ||
                password == null || confirmPassword == null || address == null ||
                fullName.isBlank() || email.isBlank() || phone.isBlank() || address.isBlank() ||
                password.isBlank() || confirmPassword.isBlank()) {
            return "Vui lòng điền đầy đủ thông tin";
        }

        if (!isPasswordValid(password.trim())) {
            return "Mật khẩu >= 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt (không chứa khoảng trắng).";
        }

        if (!password.trim().equals(confirmPassword.trim())) {
            return "Mật khẩu xác nhận không khớp";
        }

        if (!isEmailValid(email)) {
            return "Email không hợp lệ. Ví dụ đúng: tenban@domain.com";
        }

        if (!isPhoneValid(phone)) {
            return "Số điện thoại phải đủ 10-12 số và bắt đầu từ số 0";
        }

        if (userServices.getUserDao().findByEmail(email.trim()) != null ||
                userServices.getUserDao().findByPhone(phone.trim()) != null) {
            return "Email hoặc số điện thoại đã được sử dụng";
        }

        return null;
    }

    public AjaxValidationResult validateForAjax(String fullName, String email, String phone,
                                                String password, String confirmPassword, String address) {
        String normalizedFullName = trimOrEmpty(fullName);
        String normalizedAddress = trimOrEmpty(address);
        String normalizedEmail = trimOrEmpty(email);
        String normalizedPhone = trimOrEmpty(phone);
        String normalizedPassword = password == null ? "" : password;
        String normalizedConfirmPassword = confirmPassword == null ? "" : confirmPassword;

        boolean fullNameValid = !normalizedFullName.isBlank();
        boolean addressValid = !normalizedAddress.isBlank();

        boolean emailFormatValid = isEmailValid(normalizedEmail);
        boolean emailUnique = emailFormatValid && userServices.getUserDao().findByEmail(normalizedEmail) == null;
        boolean emailValid = emailFormatValid && emailUnique;

        boolean phoneFormatValid = isPhoneValid(normalizedPhone);
        boolean phoneUnique = phoneFormatValid && userServices.getUserDao().findByPhone(normalizedPhone) == null;
        boolean phoneValid = phoneFormatValid && phoneUnique;

        PasswordRules passwordRules = evaluatePassword(normalizedPassword);
        boolean passwordValid = passwordRules.allValid;
        boolean confirmPasswordValid = !normalizedConfirmPassword.isBlank()
                && normalizedConfirmPassword.equals(normalizedPassword);

        boolean formValid = fullNameValid && addressValid && emailValid && phoneValid && passwordValid && confirmPasswordValid;

        String emailMessage = !emailFormatValid
                ? "Email phải có dạng tenban@domain.com"
                : (emailUnique ? "Email hợp lệ" : "Email này đã được sử dụng");

        String phoneMessage = !phoneFormatValid
                ? "Số điện thoại phải đủ 10-12 số và bắt đầu từ số 0"
                : (phoneUnique ? "Số điện thoại hợp lệ" : "Số điện thoại này đã được sử dụng");

        String passwordMessage = passwordValid
                ? "Mật khẩu hợp lệ"
                : "Mật khẩu chưa đạt đủ các quy tắc";

        String confirmPasswordMessage = confirmPasswordValid
                ? "Mật khẩu xác nhận khớp"
                : "Mật khẩu xác nhận chưa khớp";

        Map<String, FieldValidationResult> fields = new LinkedHashMap<>();
        fields.put("fullName", new FieldValidationResult(fullNameValid,
                fullNameValid ? "Họ và tên hợp lệ" : "Vui lòng nhập họ và tên"));
        fields.put("address", new FieldValidationResult(addressValid,
                addressValid ? "Địa chỉ hợp lệ" : "Vui lòng nhập địa chỉ"));
        fields.put("email", new FieldValidationResult(emailValid, emailMessage));
        fields.put("phone", new FieldValidationResult(phoneValid, phoneMessage));
        fields.put("password", new FieldValidationResult(passwordValid, passwordMessage));
        fields.put("confirmPassword", new FieldValidationResult(confirmPasswordValid, confirmPasswordMessage));

        return new AjaxValidationResult(formValid, fields, passwordRules);
    }

    public String buildAjaxValidationJson(String fullName, String email, String phone,
                                          String password, String confirmPassword, String address) {
        AjaxValidationResult result = validateForAjax(fullName, email, phone, password, confirmPassword, address);

        StringBuilder json = new StringBuilder();
        json.append("{")
                .append("\"valid\":").append(result.valid).append(",")
                .append("\"fields\":{")
                .append("\"fullName\":{")
                .append("\"valid\":").append(result.fields.get("fullName").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("fullName").message)).append("\"},")
                .append("\"address\":{")
                .append("\"valid\":").append(result.fields.get("address").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("address").message)).append("\"},")
                .append("\"email\":{")
                .append("\"valid\":").append(result.fields.get("email").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("email").message)).append("\"},")
                .append("\"phone\":{")
                .append("\"valid\":").append(result.fields.get("phone").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("phone").message)).append("\"},")
                .append("\"password\":{")
                .append("\"valid\":").append(result.fields.get("password").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("password").message)).append("\",")
                .append("\"rules\":{")
                .append("\"minLength\":").append(result.passwordRules.minLength).append(",")
                .append("\"hasUpper\":").append(result.passwordRules.hasUpper).append(",")
                .append("\"hasLower\":").append(result.passwordRules.hasLower).append(",")
                .append("\"hasDigit\":").append(result.passwordRules.hasDigit).append(",")
                .append("\"hasSpecial\":").append(result.passwordRules.hasSpecial).append(",")
                .append("\"noSpace\":").append(result.passwordRules.noSpace)
                .append("}},")
                .append("\"confirmPassword\":{")
                .append("\"valid\":").append(result.fields.get("confirmPassword").valid)
                .append(",\"message\":\"").append(escapeJson(result.fields.get("confirmPassword").message)).append("\"}")
                .append("}")
                .append("}");

        return json.toString();
    }

    private static boolean isEmailValid(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        return email.toLowerCase().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.com$");
    }

    private static boolean isPhoneValid(String phone) {
        if (phone == null || phone.isBlank()) {
            return false;
        }
        return phone.matches("^0\\d{9,11}$");
    }

    private static boolean isPasswordValid(String password) {
        return evaluatePassword(password).allValid;
    }

    private static PasswordRules evaluatePassword(String password) {
        String value = password == null ? "" : password;

        PasswordRules rules = new PasswordRules();
        rules.minLength = value.length() >= 8;
        rules.hasUpper = value.matches(".*[A-Z].*");
        rules.hasLower = value.matches(".*[a-z].*");
        rules.hasDigit = value.matches(".*\\d.*");
        rules.hasSpecial = value.matches(".*[^A-Za-z0-9].*");
        rules.noSpace = !value.matches(".*\\s+.*");
        rules.allValid = rules.minLength && rules.hasUpper && rules.hasLower
                && rules.hasDigit && rules.hasSpecial && rules.noSpace;
        return rules;
    }

    private static String trimOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private static String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    public RegisterResult register(String fullName, String email, String phone,
                                   String password, String confirmPassword,
                                   String address, String baseUrl) {

        String validationError = validateAllFields(fullName, email, phone, password, confirmPassword, address);
        if (validationError != null) {
            return new RegisterResult(false, validationError, null);
        }

        String normalizedEmail = email.trim().toLowerCase();
        String normalizedPhone = phone.trim();

        if (userServices.getUserDao().findByEmail(normalizedEmail) != null) {
            System.err.println("[DEBUG] Email " + normalizedEmail + " already exists in database");
            return new RegisterResult(false, "Email này đã được sử dụng trong hệ thống", null);
        }
        if (userServices.getUserDao().findByPhone(normalizedPhone) != null) {
            System.err.println("[DEBUG] Phone " + normalizedPhone + " already exists in database");
            return new RegisterResult(false, "Số điện thoại này đã được sử dụng trong hệ thống", null);
        }

        boolean userCreated = userServices.register(fullName, normalizedPhone, normalizedEmail, password.trim(), address);
        if (!userCreated) {
            System.err.println("[DEBUG] Failed to create user for email: " + normalizedEmail + ", phone: " + normalizedPhone);
            return new RegisterResult(false, "Lỗi khi tạo tài khoản. Vui lòng thử lại sau", null);
        }

        String token = tokenTypeService.createActivationToken(normalizedEmail);

        String activationLink = baseUrl + "/activate?token=" + token;

        System.out.println("[DEBUG] User registered successfully: " + normalizedEmail);
        return new RegisterResult(true, "Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt", activationLink, normalizedEmail, token);
    }
}