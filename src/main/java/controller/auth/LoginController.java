package controller.auth;
import enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.user.WishlistDao;
import model.user.User;
import services.cart.CartService;
import services.user.UserServices;
import utils.LoginAttemptTracker;
import utils.RecaptchaVerifier;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private UserServices userService;
    private CartService cartService = new CartService();
    @Override
    public void init() {
        userService = new UserServices();
        cartService = new CartService();
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
            if (email != null) {
                email = email.trim().toLowerCase();
            }
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
            User checkLocked = userService.getUserDao().findByEmail(email);
            if (checkLocked != null && !checkLocked.isActive()) {
                String errorMsg = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ Admin để mở khóa.";
                if (isAjax) {
                    sendJson(resp, false, errorMsg, null, false);
                } else {
                    req.setAttribute("error", errorMsg);
                    req.setAttribute("showRecaptcha", false);
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
            cartService.mergeSessionIntoDbThenReload(session, user.getId());
            session.setAttribute("wishlistCount", new WishlistDao().countByUser(user.getId()));
            session.setMaxInactiveInterval(30 * 60);

            String rememberMe = req.getParameter("rememberMe");

            if ("on".equals(rememberMe)) {
                services.auth.AuthService authService = new services.auth.AuthService();
                String rawToken = authService.generateAndSaveToken(user.getId());

                if (rawToken != null) {
                    jakarta.servlet.http.Cookie rememberCookie = new jakarta.servlet.http.Cookie("REMEMBER_TOKEN", rawToken);
                    rememberCookie.setMaxAge(30 * 24 * 60 * 60);
                    rememberCookie.setPath("/");
                    rememberCookie.setHttpOnly(true);

                    resp.addCookie(rememberCookie);
                    System.out.println("✓ [LoginController] Remember Me cookie issued for user: " + user.getEmail());
                }
            }

            Role role = user.getRole();
            String redirectUrl;

            if (role == null) {
                redirectUrl = req.getContextPath() + "/menu";
            } else {
                switch (role) {
                    case ADMIN:
                        redirectUrl = req.getContextPath() + "/admin/dashboard";
                        break;
                    default:
                        redirectUrl = req.getContextPath() + "/menu";
                        break;
                }
            }
            if (isAjax) {
                sendJson(resp, true, null, redirectUrl, false);
            } else {
                resp.sendRedirect(redirectUrl);
            }
        } catch (Exception e) {
            System.err.println("[LoginController] Exception: " + e.getMessage());
            e.printStackTrace();

            if (!resp.isCommitted()) {
                if (isAjax) {
                    sendJson(resp, false, "Đã xảy ra lỗi hệ thống, vui lòng thử lại", null, false);
                } else {
                    req.setAttribute("error", "Đã xảy ra lỗi, vui lòng thử lại");
                    req.getRequestDispatcher("/Login.jsp").forward(req, resp);
                }
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
