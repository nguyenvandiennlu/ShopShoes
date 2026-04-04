package controller.auth;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.UserServices;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // 1. Validate
        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            if (isAjax) {
                sendJson(resp, false, "Vui lòng nhập email và mật khẩu", null);
            } else {
                req.setAttribute("error", "Vui lòng nhập email và mật khẩu");
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            }
            return;
        }
        User u = userService.getUserDao().findByEmail(email);
        if (u != null && !u.isActive()) {
            if (isAjax) {
                sendJson(resp, false, "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.", null);
            } else {
                req.setAttribute("error", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.");
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            }
            return;
        }
        // 2. Login
        User user = userService.loginByEmail(email, password);

        if (user == null) {
            if (isAjax) {
                sendJson(resp, false, "Sai email hoặc mật khẩu", null);
            } else {
                req.setAttribute("error", "Sai email hoặc mật khẩu");
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            }
            return;
        }

        // 3. Session
        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60);

        String redirectUrl = switch (user.getRole().toUpperCase()) {
            case "ADMIN" -> req.getContextPath() + "/admin/dashboard";
            default -> req.getContextPath() + "/menu";
        };

        if (isAjax) {
            sendJson(resp, true, null, redirectUrl);
        } else {
            resp.sendRedirect(redirectUrl);
    }
}
    private void sendJson(HttpServletResponse resp, boolean success, String message, String redirect) throws IOException {
        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("success", success);
        if (message != null) {
            jsonMap.put("message", message);
        }
        if (redirect != null) {
            jsonMap.put("redirect", redirect);
        }
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        String json = "{"
                + "\"success\":" + success
                + (message != null ? ",\"message\":\"" + message + "\"" : "")
                + (redirect != null ? ",\"redirect\":\"" + redirect + "\"" : "")
                + "}";

        resp.getWriter().write(json);
    }
}


