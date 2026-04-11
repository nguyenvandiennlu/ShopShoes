package controller.auth;

import java.io.IOException;

import dao.user.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.auth.ForgotPasswordService;
import services.common.EmailServices;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private ForgotPasswordService service;
    private EmailServices emailService;

    @Override
    public void init() {
        service = new ForgotPasswordService(new UserDao());
        emailService = new EmailServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String action = req.getParameter("action");

        if ("send-otp".equals(action)) {
            String result = service.sendOtp(req.getParameter("email"), session);

            if (result != null && !result.matches("\\d{6}")) {
                req.setAttribute("msg", result);
                req.getRequestDispatcher("/ForgotPassword.jsp").forward(req, resp);
                return;
            }
            String html = "<!DOCTYPE html>" +
                    "<html lang='vi'>" +
                    "<head>" +
                    "  <meta charset='UTF-8'>" +
                    "  <title>Xác nhận OTP</title>" +
                    "</head>" +
                    "<body style='font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;'>" +

                    "  <div style='max-width: 500px; margin: 0 auto; background: #ffffff; padding: 24px; border-radius: 6px;'>"
                    +

                    "    <h2 style='color: #333; margin-top: 0;'>Đặt lại mật khẩu</h2>" +

                    "    <p style='color: #555;'>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                    +

                    "    <p style='color: #555;'>Mã xác thực của bạn là:</p>" +

                    "    <div style='text-align: center; margin: 20px 0;'>" +
                    "      <span style='font-size: 28px; font-weight: bold; letter-spacing: 4px; color: #000;'>" +
                    result +
                    "      </span>" +
                    "    </div>" +

                    "    <p style='color: #555;'>Mã OTP có hiệu lực trong <strong>5 phút</strong>.</p>" +

                    "    <p style='color: #888; font-size: 13px;'>" +
                    "      Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này." +
                    "    </p>" +

                    "    <hr style='border: none; border-top: 1px solid #eee; margin: 24px 0;'/>" +

                    "    <p style='font-size: 13px; color: #888;'>" +
                    "      BHD Sport Shoes" +
                    "    </p>" +

                    "  </div>" +
                    "</body>" +
                    "</html>";

            emailService.send(
                    req.getParameter("email"),
                    "Mã OTP đặt lại mật khẩu",
                    html);

            resp.sendRedirect(req.getContextPath() + "/VerifyOtp.jsp");
            return;
        }

        if ("verify-otp".equals(action)) {
            String err = service.verifyOtp(req.getParameter("otp"), session);
            if (err != null) {
                req.setAttribute("msg", err);
                req.getRequestDispatcher("/VerifyOtp.jsp").forward(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/ResetPassword.jsp");
            return;
        }

        if ("reset-password".equals(action)) {
            String err = service.resetPassword(
                    req.getParameter("password"),
                    req.getParameter("confirmPassword"),
                    session);

            if (err != null) {
                req.setAttribute("msg", err);
                req.getRequestDispatcher("/ResetPassword.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/Login.jsp");
        }

    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/ForgotPassword.jsp").forward(req, resp);
    }

}
