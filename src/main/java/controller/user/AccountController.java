package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.AccountServices;

import java.io.IOException;

@WebServlet("/account")
public class AccountController extends HttpServlet {

    private AccountServices accountServices;

    @Override
    public void init() {
        accountServices = new AccountServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;


        HttpSession session = req.getSession(false);
        Object flashMsg = session.getAttribute("flashMsg");
        Object flashType = session.getAttribute("flashType");
        if (flashMsg != null) {
            req.setAttribute("msg", flashMsg);
            req.setAttribute("msgType", flashType);
            session.removeAttribute("flashMsg");
            session.removeAttribute("flashType");
        }

        java.util.List<model.Order.Order> orderHistory = accountServices.getOrderHistory(currentUser.getId());
        req.setAttribute("orderHistory", orderHistory);

        req.getRequestDispatcher("/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;

        String action = safe(req.getParameter("action"));

        switch (action) {
            case "change-password" -> handlePasswordChange(req, resp, currentUser);
            case "update-profile" -> handleProfileUpdate(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String fullName = safe(req.getParameter("fullName"));
        String phoneNumber = safe(req.getParameter("phoneNumber"));
        String address = safe(req.getParameter("address"));

        if (fullName.isBlank()) {
            setFlash(req, "Họ tên không được để trống.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        boolean success = accountServices.updateUserProfile(
                currentUser.getId(), fullName, phoneNumber, address);

        if (success) {

            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setAddress(address);

            setFlash(req, "Cập nhật thông tin thành công!", "success");
        } else {
            setFlash(req, "Cập nhật thất bại. Vui lòng thử lại.", "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private void handlePasswordChange(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String currentPassword = safe(req.getParameter("currentPassword"));
        String newPassword = safe(req.getParameter("newPassword"));
        String confirmPassword = safe(req.getParameter("confirmPassword"));

        if (currentPassword.isBlank() || newPassword.isBlank() || confirmPassword.isBlank()) {
            setFlash(req, "Vui lòng nhập đầy đủ thông tin mật khẩu.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        String result = accountServices.changePassword(
                currentUser.getEmail(), currentPassword, newPassword, confirmPassword);

        if ("SUCCESS".equals(result)) {
            setFlash(req, "Đổi mật khẩu thành công!", "success");

        } else {
            setFlash(req, result, "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        Object u = session.getAttribute("currentUser");
        if (!(u instanceof User)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        return (User) u;
    }

    private void setFlash(HttpServletRequest req, String msg, String type) {
        HttpSession session = req.getSession();
        session.setAttribute("flashMsg", msg);
        session.setAttribute("flashType", type); // success | danger | warning | info
    }

    private String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
