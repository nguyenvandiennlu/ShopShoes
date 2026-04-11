package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.UserServices;
import utils.LoginAttemptTracker;
import utils.RecaptchaVerifier;

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
        HttpSession session = req.getSession();
        req.setAttribute("showRecaptcha", LoginAttemptTracker.isRecaptchaRequired(session));
        req.setAttribute("failCount", LoginAttemptTracker.getFailCount(session));
        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
        HttpSession session = req.getSession();
        try {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            if (LoginAttemptTracker.isRecaptchaRequired(session)) {
                String recaptchaResponse = req.getParameter("g-recaptcha-response");
                if (!RecaptchaVerifier.verify(recaptchaResponse)) {
                    if (isAjax) {
                        sendJson(resp, false, "Vui lòng xác nhận bạn không phải robot", null, true);
                    } else {
                        req.setAttribute("error", "Vui lòng xác nhận bạn không phải robot");
                        req.setAttribute("showRecaptcha", true);
                        req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                    }
                    return;
                }
            }
            if (email == null || password == null || email.isBlank() || password.isBlank()) {
                if (isAjax) {
                    sendJson(resp, false, "Vui lòng nhập email và mật khẩu", null,
                            LoginAttemptTracker.isRecaptchaRequired(session));
                } else {
                    req.setAttribute("error", "Vui lòng nhập email và mật khẩu");
                    req.setAttribute("showRecaptcha", LoginAttemptTracker.isRecaptchaRequired(session));
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
                return;
            }
            User u = userService.getUserDao().findByEmail(email);
            if (u != null && !u.isActive()) {
                if (isAjax) {
                    sendJson(resp, false, "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.", null,
                            LoginAttemptTracker.isRecaptchaRequired(session));
                } else {
                    req.setAttribute("error", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.");
                    req.setAttribute("showRecaptcha", LoginAttemptTracker.isRecaptchaRequired(session));
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
                return;
            }
            User user = userService.loginByEmail(email, password);

            if (user == null) {
                LoginAttemptTracker.recordFailedAttempt(session);
                boolean needRecaptcha = LoginAttemptTracker.isRecaptchaRequired(session);
                
                String errorMsg = "Sai email hoặc mật khẩu";
                if (needRecaptcha) {
                    errorMsg += ". Vui lòng xác nhận bạn không phải robot để tiếp tục.";
                }
                if (isAjax) {
                    sendJson(resp, false, errorMsg, null, needRecaptcha);
                } else {
                    req.setAttribute("error", errorMsg);
                    req.setAttribute("showRecaptcha", needRecaptcha);
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
                return;
            }
            LoginAttemptTracker.resetAttempts(session);
            session.setAttribute("currentUser", user);
            session.setMaxInactiveInterval(30 * 60);

            String redirectUrl = switch (user.getRole().toUpperCase()) {
                case "ADMIN" -> req.getContextPath() + "/admin/dashboard";
                default -> req.getContextPath() + "/menu";
            };
            if (isAjax) {
                sendJson(resp, true, null, redirectUrl, false);
            } else {
                resp.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            System.err.println("[LoginController] Exception: " + e.getMessage());
            e.printStackTrace();
            if (isAjax) {
                sendJson(resp, false, "Lỗi server: " + e.getMessage(), null, false);
            } else {
                req.setAttribute("error", "Đã xảy ra lỗi, vui lòng thử lại");
                req.getRequestDispatcher("/Login.jsp").forward(req, resp);
            }
        }
    }
    private void sendJson(HttpServletResponse resp, boolean success, String message, 
                          String redirect, boolean showRecaptcha) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder("{");
        json.append("\"success\":").append(success);
        if (message != null) {
            json.append(",\"message\":\"").append(escapeJson(message)).append("\"");
        }
        if (redirect != null) {
            json.append(",\"redirect\":\"").append(redirect).append("\"");
        }
        json.append(",\"showRecaptcha\":").append(showRecaptcha);
        json.append("}");

        resp.getWriter().write(json.toString());
    }
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}