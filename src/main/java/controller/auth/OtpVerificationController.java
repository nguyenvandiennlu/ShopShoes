package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.auth.TokenTypeService;
import services.user.UserServices;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/verify-otp")
public class OtpVerificationController extends HttpServlet {
    private TokenTypeService tokenTypeService;
    private UserServices userServices;

    @Override
    public void init() {
        tokenTypeService = new TokenTypeService();
        userServices = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");

        if ("skip".equalsIgnoreCase(action)) {
            resp.sendRedirect(req.getContextPath() + "/menufilter?brandId=all");
            return;
        }

        if ("verify".equalsIgnoreCase(action)) {
            String email = req.getParameter("email");
            String token = req.getParameter("token");
            String otp = req.getParameter("otp");

            if (tokenTypeService.verifyEmailByToken(token)) {
                req.setAttribute("success", "Email đã được xác thực thành công!");
                resp.sendRedirect(req.getContextPath() + "/menufilter?brandId=all");
            } else {
                req.setAttribute("error", "OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                req.setAttribute("email", email);
                req.setAttribute("token", token);
                req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
            }
            return;
        }

        req.getRequestDispatcher("/OtpVerification.jsp").forward(req, resp);
    }
}
