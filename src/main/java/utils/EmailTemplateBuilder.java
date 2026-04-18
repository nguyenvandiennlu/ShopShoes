package utils;

public class EmailTemplateBuilder {

    public static String buildForgotPasswordOtpEmail(String otp) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#007bff;'>Đặt lại mật khẩu</h2>"
                + "<p>Mã OTP của bạn là:</p>"
                + "<div style='font-size:28px;font-weight:bold;letter-spacing:6px;"
                + "background:#f4f4f4;padding:12px 18px;display:inline-block;border-radius:8px;'>"
                + otp
                + "</div>"
                + "<p style='margin-top:16px;'>Mã có hiệu lực trong <b>15 phút</b>.</p>"
                + "<p>Nếu bạn không thực hiện yêu cầu này, hãy bỏ qua email.</p>"
                + "</div>";
    }

    public static String buildRegistrationOtpEmail(String fullName, String otp) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#28a745;'>Xác thực email - Kích hoạt tài khoản</h2>"
                + "<p>Xin chào <b>" + fullName + "</b>,</p>"
                + "<p>Cảm ơn bạn đã đăng ký tài khoản tại ShopShoes!</p>"
                + "<p style='margin-top:20px;'>Hãy nhập mã OTP dưới đây để kích hoạt tài khoản:</p>"
                + "<div style='font-size:32px;font-weight:bold;letter-spacing:8px;"
                + "background:#f4f4f4;padding:15px 20px;display:inline-block;border-radius:8px;"
                + "margin:20px 0;color:#28a745;font-family:monospace;'>"
                + otp
                + "</div>"
                + "<p style='margin-top:16px;'><b>Mã OTP có hiệu lực trong 2 phút.</b></p>"
                + "<p style='color:#666;'>Nếu bạn không thực hiện đăng ký, hãy bỏ qua email này.</p>"
                + "<p style='color:#999;font-size:12px;'>Lưu ý: Đừng chia sẻ mã OTP này với bất kỳ ai.</p>"
                + "</div>";
    }

    public static String buildEmailVerificationOtpEmail(String fullName, String activationLink) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#28a745;'>Kích hoạt tài khoản</h2>"
                + "<p>Xin chào <b>" + fullName + "</b>,</p>"
                + "<p>Cảm ơn bạn đã đăng ký tài khoản.</p>"
                + "<p>Vui lòng bấm vào nút bên dưới để kích hoạt tài khoản:</p>"
                + "<div style='margin:20px 0;'>"
                + "<a href='" + activationLink + "' "
                + "style='display:inline-block;padding:12px 20px;background:#28a745;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;'>"
                + "Kích hoạt tài khoản"
                + "</a>"
                + "</div>"
                + "<p style='color:#666;'>Liên kết có hiệu lực trong <b>2 phút</b>.</p>"
                + "<p>Nếu bạn không thực hiện đăng ký, hãy bỏ qua email này.</p>"
                + "</div>";
    }
}