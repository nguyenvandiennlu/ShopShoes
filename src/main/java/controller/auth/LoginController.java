package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.UserServices;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserServices userService;

    @Override
    public void init() {
        userService = new UserServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // 1. Validate
        if (email == null || password == null ||
                email.isBlank() || password.isBlank()) {

            req.setAttribute("error", "Vui lòng nhập email và mật khẩu");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        User u = userService.getUserDao().findByEmail(email);
        if (u != null && !u.isActive()) {
            req.setAttribute("error", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }
        // 2. Login
        User user = userService.loginByEmail(email, password);

        if (user == null) {
            req.setAttribute("error", "Sai email hoặc mật khẩu");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 3. Session
        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60);





        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/menu");

        }
    }
}
