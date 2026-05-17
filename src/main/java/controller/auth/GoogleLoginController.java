package controller.auth;

import DTO.GoogleLoginRequest;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import enums.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.cart.CartService;
import services.user.UserServices;

import java.io.IOException;

@WebServlet("/google-login")
public class GoogleLoginController extends HttpServlet {

    private UserServices userService;
    private CartService cartService;
    private Gson gson;

    @Override
    public void init() {
        userService = new UserServices();
        cartService = new CartService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            GoogleLoginRequest googleData = gson.fromJson(req.getReader(), GoogleLoginRequest.class);
            if (googleData == null || googleData.getIdToken() == null || googleData.getIdToken().isBlank()) {
                sendError(resp, "Thiếu idToken");
                return;
            }
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(googleData.getIdToken());
            String firebaseUid = decodedToken.getUid();
            String email = decodedToken.getEmail();
            String name = (String) decodedToken.getName();
            String picture = (String) decodedToken.getPicture();

            if (email == null || email.isBlank()) {
                sendError(resp, "Token không chứa email hợp lệ");
                return;
            }
            User user = userService.processGoogleLoginVerified(email, name, firebaseUid, picture);
            if (user == null) {
                sendError(resp, "Không thể xử lý đăng nhập.");
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            cartService.mergeSessionIntoDbThenReload(session, user.getId());
            session.setMaxInactiveInterval(30 * 60);
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", true);
            if (Role.ADMIN.equals(user.getRole())) {
                jsonResponse.addProperty("redirect", req.getContextPath() + "/admin/dashboard");
            } else {
                jsonResponse.addProperty("redirect", req.getContextPath() + "/menu");
            }
            resp.getWriter().write(gson.toJson(jsonResponse));
        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, "Token không hợp lệ hoặc lỗi server: " + e.getMessage());
        }
    }
    private void sendError(HttpServletResponse resp, String message) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", message);
        resp.getWriter().write(gson.toJson(jsonResponse));
    }



}
