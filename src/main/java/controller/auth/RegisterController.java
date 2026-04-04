package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.auth.RegisterService;
import services.common.EmailServices;

import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private RegisterService registerService;
    @Override
    public void init() {
        registerService = new RegisterService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/Register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String address = req.getParameter("address");
        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort()
                + req.getContextPath();
        RegisterService.RegisterResult result = registerService.register(
                fullName, email, phone, password, confirmPassword, address, baseUrl
        );

        if (!result.success) {
            req.setAttribute("error", result.message);
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
            return;
        }
        EmailServices emailService = new EmailServices();
        String emailContent = "<p>Xin chào " + fullName + ",</p>" +
                "<p>Cảm ơn bạn đã đăng ký. Vui lòng click link dưới để kích hoạt tài khoản:</p>" +
                "<p><a href='" + result.activationLink + "'>Kích hoạt tài khoản</a></p>" +
                "<p>Link có hiệu lực trong 2 phút.</p>";
        try {
            emailService.send(email, "Kích hoạt tài khoản ShopShoes", emailContent);
            req.setAttribute("success", result.message);
            req.getRequestDispatcher("/Login").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Đăng ký thành công nhưng gửi email kích hoạt thất bại.");
            req.getRequestDispatcher("/Register.jsp").forward(req, resp);
        }
    }
}