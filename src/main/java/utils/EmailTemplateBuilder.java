package utils;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import model.Order.OrderDetailDTO;

public class EmailTemplateBuilder {

    private static final String PRIMARY_COLOR = "#ff6f61";
    private static final String PRIMARY_DARK = "#e85d2c";
    private static final String SHOP_NAME = "SPORT SHOES";
    private static final String SHOP_ADDRESS = "Khu phố 6, Phường Linh Trung, TP. Thủ Đức, TP. Hồ Chí Minh";
    private static final String SHOP_PHONE = "0332536387";
    private static final String SHOP_EMAIL = "BHDsport@gmail.com";

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

    /**
     * Builds a complete order confirmation email with all order details.
     *
     * @param fullName        Customer's full name
     * @param orderId         Order code (orders_id string)
     * @param items           List of order detail DTOs
     * @param subTotal        Sub total amount
     * @param shippingFee     Shipping fee
     * @param grandTotal      Grand total
     * @param shippingAddress Shipping address
     * @param phoneNumber     Phone number
     * @param paymentMethod   Payment method name (COD, MoMo)
     * @param orderTime       Order creation time
     * @return HTML email content
     */
    public static String buildOrderConfirmationEmail(
            String fullName,
            String orderId,
            List<OrderDetailDTO> items,
            BigDecimal subTotal,
            BigDecimal shippingFee,
            BigDecimal grandTotal,
            String shippingAddress,
            String phoneNumber,
            String paymentMethod,
            LocalDateTime orderTime
    ) {
        StringBuilder itemsHtml = new StringBuilder();
        for (OrderDetailDTO item : items) {
            String imageUrl = item.getImageUrl();
            if (imageUrl != null && !imageUrl.startsWith("http") && !imageUrl.startsWith("//")) {
                imageUrl = "https://" + imageUrl;
            }
            String imgTag;
            if (imageUrl != null && !imageUrl.isBlank()) {
                imgTag = "<img src='" + imageUrl + "' alt='" + escapeHtml(item.getProductName())
                        + "' style='width:80px;height:80px;object-fit:cover;border-radius:6px;"
                        + "border:1px solid #eee;margin-right:12px;'/>";
            } else {
                imgTag = "<div style='width:80px;height:80px;border-radius:6px;background:#f0f0f0;"
                        + "display:inline-flex;align-items:center;justify-content:center;"
                        + "margin-right:12px;font-size:11px;color:#999;vertical-align:middle;'>"
                        + "No Image</div>";
            }

            itemsHtml.append("<tr style='border-bottom:1px solid #f0f0f0;'>")
                    .append("<td style='padding:12px 8px;vertical-align:middle;'>")
                    .append("<table style='display:inline-table;vertical-align:middle;border-collapse:collapse;'><tr><td style='padding:0;vertical-align:middle;'>")
                    .append(imgTag)
                    .append("</td><td style='padding:0 0 0 12px;vertical-align:middle;'>")
                    .append("<div style='font-weight:600;color:#333;font-size:14px;white-space:nowrap;'>")
                    .append(escapeHtml(item.getProductName())).append("</div>")
                    .append("<div style='color:#777;font-size:12px;margin-top:4px;white-space:nowrap;'>")
                    .append("Màu: <b>").append(escapeHtml(item.getColorName())).append("</b> | ")
                    .append("Size: <b>").append(escapeHtml(item.getSizeName())).append("</b>")
                    .append("</div>")
                    .append("</td></tr></table>")
                    .append("</td>")
                    .append("<td style='padding:12px 8px;vertical-align:middle;text-align:center;color:#333;'>")
                    .append(item.getQuantity()).append("</td>")
                    .append("<td style='padding:12px 8px;vertical-align:middle;text-align:right;color:#333;font-weight:500;'>")
                    .append(formatCurrency(item.getUnitPrice())).append("</td>")
                    .append("<td style='padding:12px 8px;vertical-align:middle;text-align:right;color:#333;font-weight:600;'>")
                    .append(formatCurrency(item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantity()))))
                    .append("</td>")
                    .append("</tr>");
        }

        String paymentMethodDisplay = "COD".equalsIgnoreCase(paymentMethod)
                ? "Thanh toán khi nhận hàng (COD)"
                : "Thanh toán qua MoMo";

        String orderTimeStr = orderTime != null
                ? orderTime.format(DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy"))
                : "";

        return "<!DOCTYPE html>"
                + "<html><head><meta charset='UTF-8'></head>"
                + "<body style='margin:0;padding:0;background-color:#f4f6f8;font-family:Arial,Helvetica,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:30px 10px;'>"
                + "<table width='640' cellpadding='0' cellspacing='0' style='background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 12px rgba(0,0,0,0.08);'>"

                // Header
                + "<tr><td style='background:linear-gradient(135deg," + PRIMARY_COLOR + "," + PRIMARY_DARK + ");padding:30px 40px;text-align:center;'>"
                + "<h1 style='margin:0;color:#fff;font-size:24px;font-weight:800;letter-spacing:2px;text-transform:uppercase;'>" + SHOP_NAME + "</h1>"
                + "<p style='margin:6px 0 0;color:rgba(255,255,255,0.9);font-size:14px;'>Xác nhận đơn hàng</p>"
                + "</td></tr>"

                // Greeting
                + "<tr><td style='padding:30px 40px 10px;'>"
                + "<p style='margin:0;font-size:15px;color:#333;'>Xin chào <b>" + escapeHtml(fullName) + "</b>,</p>"
                + "<p style='margin:10px 0 0;font-size:14px;color:#555;line-height:1.6;'>"
                + "Cảm ơn bạn đã đặt hàng tại <b>" + SHOP_NAME + "</b>. "
                + "Đơn hàng của bạn đã được tiếp nhận và đang chờ xử lý.</p>"
                + "</td></tr>"

                // Order info
                + "<tr><td style='padding:10px 40px;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#fef6f5;border-radius:8px;padding:16px 20px;border-left:4px solid " + PRIMARY_COLOR + ";'>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Mã đơn hàng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:700;color:#333;text-align:right;'>#"
                + escapeHtml(orderId) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Thời gian đặt hàng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(orderTimeStr) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Phương thức thanh toán:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(paymentMethodDisplay) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Địa chỉ nhận hàng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(shippingAddress) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Số điện thoại:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(phoneNumber) + "</td></tr>"
                + "</table>"
                + "</td></tr>"

                // Products table header
                + "<tr><td style='padding:20px 40px 0;'>"
                + "<h3 style='margin:0 0 12px;font-size:16px;color:#333;border-bottom:2px solid " + PRIMARY_COLOR + ";padding-bottom:8px;'>"
                + "Chi tiết sản phẩm</h3>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='border-collapse:collapse;'>"
                + "<thead><tr style='background:" + PRIMARY_COLOR + ";'>"
                + "<th style='padding:10px 8px;text-align:left;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>Sản phẩm</th>"
                + "<th style='padding:10px 8px;text-align:center;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>SL</th>"
                + "<th style='padding:10px 8px;text-align:right;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>Đơn giá</th>"
                + "<th style='padding:10px 8px;text-align:right;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>Thành tiền</th>"
                + "</tr></thead><tbody>"
                + itemsHtml.toString()
                + "</tbody></table>"
                + "</td></tr>"

                // Totals
                + "<tr><td style='padding:10px 40px 30px;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='border-top:2px solid #eee;padding-top:12px;'>"
                + "<tr><td style='padding:4px 0;font-size:14px;color:#555;'>Tạm tính:</td>"
                + "<td style='padding:4px 0;font-size:14px;color:#333;text-align:right;'>"
                + formatCurrency(subTotal) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:14px;color:#555;'>Phí vận chuyển:</td>"
                + "<td style='padding:4px 0;font-size:14px;color:#333;text-align:right;'>"
                + formatCurrency(shippingFee) + "</td></tr>"
                + "<tr><td style='padding:6px 0 0;font-size:16px;font-weight:700;color:#333;border-top:1px solid #ddd;padding-top:10px;'>Tổng cộng:</td>"
                + "<td style='padding:6px 0 0;font-size:18px;font-weight:700;color:" + PRIMARY_COLOR + ";text-align:right;border-top:1px solid #ddd;padding-top:10px;'>"
                + formatCurrency(grandTotal) + "</td></tr>"
                + "</table>"
                + "</td></tr>"

                // Footer with shop contact info
                + "<tr><td style='background:#f8f9fa;padding:20px 40px;text-align:center;border-top:1px solid #eee;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0'>"
                + "<tr><td style='padding:0 0 12px;font-size:14px;font-weight:700;color:" + PRIMARY_COLOR + ";'>" + SHOP_NAME + "</td></tr>"
                + "<tr><td style='padding:2px 0;font-size:12px;color:#777;'>"
                + "Địa chỉ: " + SHOP_ADDRESS + "</td></tr>"
                + "<tr><td style='padding:2px 0;font-size:12px;color:#777;'>"
                + "Điện thoại: " + SHOP_PHONE + " | Email: " + SHOP_EMAIL + "</td></tr>"
                + "<tr><td style='padding:12px 0 0;font-size:11px;color:#999;line-height:1.6;'>"
                + "Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi qua email hoặc số điện thoại trên.<br>"
                + "&copy; 2025 " + SHOP_NAME + ". Tất cả quyền được bảo lưu.</p>"
                + "</td></tr>"
                + "</table>"
                + "</td></tr>"

                + "</table>"
                + "</td></tr></table>"
                + "</body></html>";
    }

    private static String escapeHtml(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder(input.length());
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '&':
                    sb.append("&").append("amp;");
                    break;
                case '<':
                    sb.append("&").append("lt;");
                    break;
                case '>':
                    sb.append("&").append("gt;");
                    break;
                case '"':
                    sb.append("&#").append("34;");
                    break;
                case '\'':
                    sb.append("&#").append("39;");
                    break;
                default:
                    sb.append(c);
                    break;
            }
        }
        return sb.toString();
    }

    private static String formatCurrency(BigDecimal amount) {
        if (amount == null) return "0 ₫";
        NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return fmt.format(amount);
    }
}