package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.user.UserServices;

import java.io.IOException;

@WebServlet("/activate")
public class ActivateController extends HttpServlet {

    private UserServices userService;

        @Override
        public void init() {
            userService = new UserServices();
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {

            String token = req.getParameter("token");
            HttpSession session = req.getSession(false);

            if (session == null || token == null || token.isBlank()) {
                resp.getWriter().println("Link kích hoạt không hợp lệ hoặc đã mất session.");
                return;
            }

            String pendingEmail = (String) session.getAttribute("pendingActivationEmail");
            String sessionToken = (String) session.getAttribute("activationToken");

            if (pendingEmail == null || sessionToken == null || !token.equals(sessionToken)) {
                resp.getWriter().println("Token không đúng hoặc đã hết hạn.");
                return;
            }

            // Bật active trong DB
            boolean ok = userService.getUserDao().activateByEmail(pendingEmail);

            // Xóa khỏi session (dùng 1 lần)
            session.removeAttribute("pendingActivationEmail");
            session.removeAttribute("activationToken");

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/login?activated=1");
            } else {
                resp.getWriter().println("Kích hoạt thất bại.");
            }
        }
    }


