package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.common.EmailServices;
import services.user.UserServices;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private UserServices userService;

    @Override
    public void init() {
        userService = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Hiển thị trang đăng ký
        req.getRequestDispatcher("/Register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String confirmPassword = req.getParameter("confirmPassword");

        // 1. Validate dữ liệu
        if (fullName == null || email == null || phone == null ||
                password == null || confirmPassword == null ||
                fullName.isBlank() || email.isBlank() || phone.isBlank() || address.isBlank() ||
                password.isBlank() || confirmPassword.isBlank()) {

            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra mật khẩu khớp
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra độ dài mật khẩu
        password = password.trim();
        confirmPassword = confirmPassword.trim();

        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9])\\S{8,}$";

        if (!password.matches(passwordRegex)) {
            req.setAttribute("error",
                    "Mật khẩu >= 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt (không chứa khoảng trắng).");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }



        // 4. Validate email format (phải có domain đầy đủ như @gmail.com)
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            req.setAttribute("error", "Email không hợp lệ. Vui lòng nhập email có định dạng đúng (vd: example@gmail.com)");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 5. Validate phone format (10-11 số)
        if (!phone.matches("^[0-9]{10,11}$")) {
            req.setAttribute("error", "Số điện thoại phải có 10-11 chữ số");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }

        // 6. Đăng ký user
        boolean success = userService.register(fullName, phone, email, password,address);

        if (success) {
            // 1) Tạo session + lưu thông tin chờ kích hoạt
            HttpSession session = req.getSession(true);
            String token = UUID.randomUUID().toString();

            session.setAttribute("pendingActivationEmail", email);
            session.setAttribute("activationToken", token);
            session.setMaxInactiveInterval(30 * 60); // 30 phút

            // 2) Tạo link kích hoạt (mang jsessionid nếu cần)
            String base = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                    + req.getContextPath();

            String rawUrl = base + "/activate?token=" + token;
            String activateUrl = resp.encodeURL(rawUrl); // QUAN TRỌNG: giữ session

            // 3) Gửi mail
            EmailServices emailService = new EmailServices();
            emailService.send(
                    email,
                    "Kích hoạt tài khoản",
                    "Bạn vừa đăng ký tài khoản. Bấm vào link để kích hoạt: "
                            + "<a href='" + activateUrl + "'>Kích hoạt</a>"
            );

            // 4) Thông báo
            req.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.");
            req.getRequestDispatcher("/Login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Email hoặc số điện thoại đã được sử dụng");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
        }

    }}
