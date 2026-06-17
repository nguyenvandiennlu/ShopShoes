package controller.admin;

import com.google.gson.Gson;
import DTO.StatisticsDTO;
import services.admin.StatisticsService;

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

@WebServlet("/admin/api/statistics")
public class StatisticsController extends HttpServlet {
    private final StatisticsService statisticsService = new StatisticsService();
    private final Gson gson = new Gson();

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String startParam = request.getParameter("startDate");
            String endParam = request.getParameter("endDate");

            LocalDateTime startDateTime;
            LocalDateTime endDateTime;

            if (startParam == null || endParam == null || startParam.isEmpty() || endParam.isEmpty()) {
                LocalDate now = LocalDate.now();
                startDateTime = now.withDayOfMonth(1).atStartOfDay();
                endDateTime = now.atTime(LocalTime.MAX);
            } else {
                LocalDate startDate = LocalDate.parse(startParam, DateTimeFormatter.ISO_LOCAL_DATE);
                LocalDate endDate = LocalDate.parse(endParam, DateTimeFormatter.ISO_LOCAL_DATE);

                startDateTime = startDate.atStartOfDay();
                endDateTime = endDate.atTime(LocalTime.MAX);
            }

            StatisticsDTO summaryData = statisticsService.getDashboardSummary(startDateTime, endDateTime);

            // Build a clean JSON response with only the fields needed by the reports page
            com.google.gson.JsonObject json = new com.google.gson.JsonObject();
            json.addProperty("totalRevenue", summaryData.getTotalRevenue());
            json.addProperty("revenueGrowth", summaryData.getRevenueGrowth());
            json.addProperty("totalOrders", summaryData.getTotalOrders());
            json.addProperty("ordersGrowth", summaryData.getOrdersGrowth());
            json.addProperty("estimatedProfit", summaryData.getEstimatedProfit());
            json.addProperty("totalProducts", summaryData.getTotalProducts());
            json.addProperty("lowStockProducts", summaryData.getLowStockProducts());

            // Top products
            com.google.gson.JsonArray topProductsArray = new com.google.gson.JsonArray();
            if (summaryData.getTopProducts() != null) {
                for (java.util.Map<String, Object> product : summaryData.getTopProducts()) {
                    com.google.gson.JsonObject pj = new com.google.gson.JsonObject();
                    pj.addProperty("name", (String) product.getOrDefault("name", ""));
                    pj.addProperty("imageUrl", (String) product.getOrDefault("imageUrl", ""));
                    pj.addProperty("brandName", (String) product.getOrDefault("brandName", "Chưa có thương hiệu"));
                    pj.addProperty("totalQuantity", ((Number) product.getOrDefault("totalQuantity", 0)).intValue());
                    pj.addProperty("totalRevenue", ((Number) product.getOrDefault("totalRevenue", 0.0)).doubleValue());
                    topProductsArray.add(pj);
                }
            }
            json.add("topProducts", topProductsArray);

            // Brand sales (for pie chart)
            com.google.gson.JsonArray categoryArray = new com.google.gson.JsonArray();
            if (summaryData.getCategorySales() != null) {
                for (java.util.Map<String, Object> cat : summaryData.getCategorySales()) {
                    com.google.gson.JsonObject cj = new com.google.gson.JsonObject();
                    cj.addProperty("brandName", (String) cat.getOrDefault("brandName", "Chưa có thương hiệu"));
                    cj.addProperty("totalProducts", ((Number) cat.getOrDefault("totalProducts", 0)).intValue());
                    cj.addProperty("totalQuantity", ((Number) cat.getOrDefault("totalQuantity", 0)).intValue());
                    cj.addProperty("totalRevenue", ((Number) cat.getOrDefault("totalRevenue", 0.0)).doubleValue());
                    categoryArray.add(cj);
                }
            }
            json.add("categorySales", categoryArray);

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Định dạng ngày tháng không hợp lệ hoặc lỗi hệ thống.\"}");
        }
    }
}