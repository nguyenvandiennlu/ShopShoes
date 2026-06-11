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
    private static final String SHOP_ADDRESS = "Khu ph\u1ED1 6, Ph\u01B0\u1EDDng Linh Trung, TP. Th\u1EE7 \u0110\u1EE9c, TP. H\u1ED3 Ch\u00ED Minh";
    private static final String SHOP_PHONE = "0332536387";
    private static final String SHOP_EMAIL = "BHDsport@gmail.com";

    public static String buildForgotPasswordOtpEmail(String otp) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#007bff;'>\u0110\u1EB7t l\u1EA1i m\u1EADt kh\u1EA9u</h2>"
                + "<p>M\u00E3 OTP c\u1EE7a b\u1EA1n l\u00E0:</p>"
                + "<div style='font-size:28px;font-weight:bold;letter-spacing:6px;"
                + "background:#f4f4f4;padding:12px 18px;display:inline-block;border-radius:8px;'>"
                + otp
                + "</div>"
                + "<p style='margin-top:16px;'>M\u00E3 c\u00F3 hi\u1EC7u l\u1EF1c trong <b>15 ph\u00FAt</b>.</p>"
                + "<p>N\u1EBFu b\u1EA1n kh\u00F4ng th\u1EF1c hi\u1EC7n y\u00EAu c\u1EA7u n\u00E0y, h\u00E3y b\u1ECF qua email.</p>"
                + "</div>";
    }

    public static String buildRegistrationOtpEmail(String fullName, String otp) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#28a745;'>X\u00E1c th\u1EF1c email - K\u00EDch ho\u1EA1t t\u00E0i kho\u1EA3n</h2>"
                + "<p>Xin ch\u00E0o <b>" + fullName + "</b>,</p>"
                + "<p>C\u1EA3m \u01A1n b\u1EA1n \u0111\u00E3 \u0111\u0103ng k\u00FD t\u00E0i kho\u1EA3n t\u1EA1i ShopShoes!</p>"
                + "<p style='margin-top:20px;'>H\u00E3y nh\u1EADp m\u00E3 OTP d\u01B0\u1EDBi \u0111\u00E2y \u0111\u1EC3 k\u00EDch ho\u1EA1t t\u00E0i kho\u1EA3n:</p>"
                + "<div style='font-size:32px;font-weight:bold;letter-spacing:8px;"
                + "background:#f4f4f4;padding:15px 20px;display:inline-block;border-radius:8px;"
                + "margin:20px 0;color:#28a745;font-family:monospace;'>"
                + otp
                + "</div>"
                + "<p style='margin-top:16px;'><b>M\u00E3 OTP c\u00F3 hi\u1EC7u l\u1EF1c trong 2 ph\u00FAt.</b></p>"
                + "<p style='color:#666;'>N\u1EBFu b\u1EA1n kh\u00F4ng th\u1EF1c hi\u1EC7n \u0111\u0103ng k\u00FD, h\u00E3y b\u1ECF qua email n\u00E0y.</p>"
                + "<p style='color:#999;font-size:12px;'>L\u01B0u \u00FD: \u0110\u1EEBng chia s\u1EBB m\u00E3 OTP n\u00E0y v\u1EDBi b\u1EA5t k\u1EF3 ai.</p>"
                + "</div>";
    }

    public static String buildEmailVerificationOtpEmail(String fullName, String activationLink) {
        return "<div style='font-family:Arial,sans-serif;font-size:15px;color:#333;'>"
                + "<h2 style='color:#28a745;'>K\u00EDch ho\u1EA1t t\u00E0i kho\u1EA3n</h2>"
                + "<p>Xin ch\u00E0o <b>" + fullName + "</b>,</p>"
                + "<p>C\u1EA3m \u01A1n b\u1EA1n \u0111\u00E3 \u0111\u0103ng k\u00FD t\u00E0i kho\u1EA3n.</p>"
                + "<p>Vui l\u00F2ng b\u1EA5m v\u00E0o n\u00FAt b\u00EAn d\u01B0\u1EDBi \u0111\u1EC3 k\u00EDch ho\u1EA1t t\u00E0i kho\u1EA3n:</p>"
                + "<div style='margin:20px 0;'>"
                + "<a href='" + activationLink + "' "
                + "style='display:inline-block;padding:12px 20px;background:#28a745;color:#fff;text-decoration:none;border-radius:6px;font-weight:bold;'>"
                + "K\u00EDch ho\u1EA1t t\u00E0i kho\u1EA3n"
                + "</a>"
                + "</div>"
                + "<p style='color:#666;'>Li\u00EAn k\u1EBFt c\u00F3 hi\u1EC7u l\u1EF1c trong <b>2 ph\u00FAt</b>.</p>"
                + "<p>N\u1EBFu b\u1EA1n kh\u00F4ng th\u1EF1c hi\u1EC7n \u0111\u0103ng k\u00FD, h\u00E3y b\u1ECF qua email n\u00E0y.</p>"
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
                    .append(imgTag)
                    .append("<div style='display:inline-block;vertical-align:middle;'>")
                    .append("<div style='font-weight:600;color:#333;font-size:14px;'>")
                    .append(escapeHtml(item.getProductName())).append("</div>")
                    .append("<div style='color:#777;font-size:12px;margin-top:4px;'>")
                    .append("M\u00E0u: <b>").append(escapeHtml(item.getColorName())).append("</b> | ")
                    .append("Size: <b>").append(escapeHtml(item.getSizeName())).append("</b>")
                    .append("</div>")
                    .append("</div>")
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
                ? "Thanh to\u00E1n khi nh\u1EADn h\u00E0ng (COD)"
                : "Thanh to\u00E1n qua MoMo";

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
                + "<p style='margin:6px 0 0;color:rgba(255,255,255,0.9);font-size:14px;'>X\u00E1c nh\u1EADn \u0111\u01A1n h\u00E0ng</p>"
                + "</td></tr>"

                // Greeting
                + "<tr><td style='padding:30px 40px 10px;'>"
                + "<p style='margin:0;font-size:15px;color:#333;'>Xin ch\u00E0o <b>" + escapeHtml(fullName) + "</b>,</p>"
                + "<p style='margin:10px 0 0;font-size:14px;color:#555;line-height:1.6;'>"
                + "C\u1EA3m \u01A1n b\u1EA1n \u0111\u00E3 \u0111\u1EB7t h\u00E0ng t\u1EA1i <b>" + SHOP_NAME + "</b>. "
                + "\u0110\u01A1n h\u00E0ng c\u1EE7a b\u1EA1n \u0111\u00E3 \u0111\u01B0\u1EE3c ti\u1EBFp nh\u1EADn v\u00E0 \u0111ang ch\u1EDD x\u1EED l\u00FD.</p>"
                + "</td></tr>"

                // Order info
                + "<tr><td style='padding:10px 40px;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='background:#fef6f5;border-radius:8px;padding:16px 20px;border-left:4px solid " + PRIMARY_COLOR + ";'>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>M\u00E3 \u0111\u01A1n h\u00E0ng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:700;color:#333;text-align:right;'>#"
                + escapeHtml(orderId) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Th\u1EDDi gian \u0111\u1EB7t h\u00E0ng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(orderTimeStr) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>Ph\u01B0\u01A1ng th\u1EE9c thanh to\u00E1n:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(paymentMethodDisplay) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>\u0110\u1ECBa ch\u1EC9 nh\u1EADn h\u00E0ng:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(shippingAddress) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:13px;color:#555;'>S\u1ED1 \u0111i\u1EC7n tho\u1EA1i:</td>"
                + "<td style='padding:4px 0;font-size:13px;font-weight:600;color:#333;text-align:right;'>"
                + escapeHtml(phoneNumber) + "</td></tr>"
                + "</table>"
                + "</td></tr>"

                // Products table header
                + "<tr><td style='padding:20px 40px 0;'>"
                + "<h3 style='margin:0 0 12px;font-size:16px;color:#333;border-bottom:2px solid " + PRIMARY_COLOR + ";padding-bottom:8px;'>"
                + "Chi ti\u1EBFt s\u1EA3n ph\u1EA9m</h3>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='border-collapse:collapse;'>"
                + "<thead><tr style='background:" + PRIMARY_COLOR + ";'>"
                + "<th style='padding:10px 8px;text-align:left;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>S\u1EA3n ph\u1EA9m</th>"
                + "<th style='padding:10px 8px;text-align:center;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>SL</th>"
                + "<th style='padding:10px 8px;text-align:right;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>\u0110\u01A1n gi\u00E1</th>"
                + "<th style='padding:10px 8px;text-align:right;font-size:12px;text-transform:uppercase;color:#fff;font-weight:600;'>Th\u00E0nh ti\u1EC1n</th>"
                + "</tr></thead><tbody>"
                + itemsHtml.toString()
                + "</tbody></table>"
                + "</td></tr>"

                // Totals
                + "<tr><td style='padding:10px 40px 30px;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0' style='border-top:2px solid #eee;padding-top:12px;'>"
                + "<tr><td style='padding:4px 0;font-size:14px;color:#555;'>T\u1EA1m t\u00EDnh:</td>"
                + "<td style='padding:4px 0;font-size:14px;color:#333;text-align:right;'>"
                + formatCurrency(subTotal) + "</td></tr>"
                + "<tr><td style='padding:4px 0;font-size:14px;color:#555;'>Ph\u00ED v\u1EADn chuy\u1EC3n:</td>"
                + "<td style='padding:4px 0;font-size:14px;color:#333;text-align:right;'>"
                + formatCurrency(shippingFee) + "</td></tr>"
                + "<tr><td style='padding:6px 0 0;font-size:16px;font-weight:700;color:#333;border-top:1px solid #ddd;padding-top:10px;'>T\u1ED5ng c\u1ED9ng:</td>"
                + "<td style='padding:6px 0 0;font-size:18px;font-weight:700;color:" + PRIMARY_COLOR + ";text-align:right;border-top:1px solid #ddd;padding-top:10px;'>"
                + formatCurrency(grandTotal) + "</td></tr>"
                + "</table>"
                + "</td></tr>"

                // Footer with shop contact info
                + "<tr><td style='background:#f8f9fa;padding:20px 40px;text-align:center;border-top:1px solid #eee;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0'>"
                + "<tr><td style='padding:0 0 12px;font-size:14px;font-weight:700;color:" + PRIMARY_COLOR + ";'>" + SHOP_NAME + "</td></tr>"
                + "<tr><td style='padding:2px 0;font-size:12px;color:#777;'>"
                + "\u0110\u1ECBa ch\u1EC9: " + SHOP_ADDRESS + "</td></tr>"
                + "<tr><td style='padding:2px 0;font-size:12px;color:#777;'>"
                + "\u0110i\u1EC7n tho\u1EA1i: " + SHOP_PHONE + " | Email: " + SHOP_EMAIL + "</td></tr>"
                + "<tr><td style='padding:12px 0 0;font-size:11px;color:#999;line-height:1.6;'>"
                + "N\u1EBFu b\u1EA1n c\u00F3 b\u1EA5t k\u1EF3 th\u1EAFc m\u1EAFc n\u00E0o, vui l\u00F2ng li\u00EAn h\u1EC7 v\u1EDBi ch\u00FAng t\u00F4i qua email ho\u1EB7c s\u1ED1 \u0111i\u1EC7n tho\u1EA1i tr\u00EAn.<br>"
                + "\u00A9 2025 " + SHOP_NAME + ". T\u1EA5t c\u1EA3 quy\u1EC1n \u0111\u01B0\u1EE3c b\u1EA3o l\u01B0u.</p>"
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
        if (amount == null) return "0 \u20AB";
        NumberFormat fmt = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return fmt.format(amount);
    }
}