package controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.admin.ProductStatsDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/product-stats")
public class ProductStatsController extends HttpServlet {

    private final ProductStatsDao dao  = new ProductStatsDao();
    private final Gson            gson = new GsonBuilder().serializeNulls().create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        try {
            String tab      = req.getParameter("tab");
            String startStr = req.getParameter("startDate");
            String endStr   = req.getParameter("endDate");
            int    limit    = req.getParameter("limit") != null
                    ? Integer.parseInt(req.getParameter("limit")) : 5;

            if (tab == null) tab = "sold";

            LocalDateTime start, end;
            if (startStr != null && !startStr.isEmpty() && endStr != null && !endStr.isEmpty()) {
                start = LocalDate.parse(startStr, DateTimeFormatter.ISO_LOCAL_DATE).atStartOfDay();
                end   = LocalDate.parse(endStr,   DateTimeFormatter.ISO_LOCAL_DATE).atTime(LocalTime.MAX);
            } else {
                LocalDate now = LocalDate.now();
                start = now.withDayOfMonth(1).atStartOfDay();
                end   = now.atTime(LocalTime.MAX);
            }

            List<Map<String, Object>> result = switch (tab) {
                case "unsold"   -> dao.getUnsoldProducts(start, end, limit);
                case "lowstock" -> dao.getLowStockProducts(limit);
                default         -> dao.getTopSellingProducts(start, end, limit);
            };

            resp.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}