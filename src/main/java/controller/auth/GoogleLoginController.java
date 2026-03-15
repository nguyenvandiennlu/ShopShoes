package controller.auth;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import services.user.UserServices;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/google-login")
public class GoogleLoginController extends HttpServlet {

    private UserServices userService;
    private Gson gson;

    @Override
    public void init() {
        userService = new UserServices();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {

            BufferedReader reader = req.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            GoogleLoginRequest googleData = gson.fromJson(sb.toString(), GoogleLoginRequest.class);
            User user = userService.processSocialLogin(
                    googleData.email,
                    googleData.name,
                    googleData.uid,
                    "google");

            if (user != null) {
                // 4. Tạo Session
                HttpSession session = req.getSession(true);
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60);

                // 5. Trả về JSON thành công
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("success", true);

                // Điều hướng dựa trên role
                if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    jsonResponse.addProperty("redirect", req.getContextPath() + "/admin/overview");
                } else {
                    jsonResponse.addProperty("redirect", req.getContextPath() + "/menu");
                }

                resp.getWriter().write(gson.toJson(jsonResponse));
            } else {
                sendError(resp, "Không thể xử lý đăng nhập.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendError(resp, "Lỗi Server: " + e.getMessage());
        }
    }

    private void sendError(HttpServletResponse resp, String message) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("error", message);
        resp.getWriter().write(gson.toJson(jsonResponse));
    }

    private static class GoogleLoginRequest {
        String email;
        String name;
        String uid;
        String photoURL;
    }
}