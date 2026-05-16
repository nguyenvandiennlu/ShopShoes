package controller.checkout;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.Config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;

@WebServlet("/api/location")
public class LocationProxyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String type = req.getParameter("type");
        String parentId = req.getParameter("parentId");

        String ghnUrl = "";

        if ("province".equals(type)) {
            ghnUrl = Config.get("api.ghn.province");
        } else if ("district".equals(type)) {
            ghnUrl = Config.get("api.ghn.district") + parentId;
        } else if ("ward".equals(type)) {
            ghnUrl = Config.get("api.ghn.ward") + parentId;
        } else {
            resp.getWriter().write("{\"code\": 400, \"message\": \"Invalid type\"}");
            return;
        }

        if (ghnUrl == null || ghnUrl.isEmpty() || ghnUrl.equals("null" + parentId)) {
            resp.getWriter().write("{\"code\": 500, \"message\": \"Missing API URL config in properties\"}");
            return;
        }

        try {
            URL url = new URI(ghnUrl).toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Token", Config.get("api.ghn"));

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }

            resp.getWriter().write(response.toString());

        } catch (Exception e) {
            resp.getWriter().write("{\"code\": 500, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}