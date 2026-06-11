package controller.admin;

import com.google.gson.Gson;
import DTO.ChartDataDTO;
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

@WebServlet("/admin/api/chart-statistics")
public class ChartStatisticsController extends HttpServlet {
    private final StatisticsService statisticsService = new StatisticsService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String startParam = request.getParameter("startDate");
            String endParam = request.getParameter("endDate");
            String metric = request.getParameter("metric");

            if (metric == null || metric.isEmpty()) metric = "revenue";

            LocalDateTime startDateTime;
            LocalDateTime endDateTime;

            if (startParam == null || endParam == null || startParam.isEmpty() || endParam.isEmpty()) {
                LocalDate now = LocalDate.now();
                startDateTime = now.withDayOfMonth(1).atStartOfDay();
                endDateTime = now.atTime(LocalTime.MAX);
            } else {
                startDateTime = LocalDate.parse(startParam, DateTimeFormatter.ISO_LOCAL_DATE).atStartOfDay();
                endDateTime = LocalDate.parse(endParam, DateTimeFormatter.ISO_LOCAL_DATE).atTime(LocalTime.MAX);
            }

            ChartDataDTO chartData = statisticsService.getChartStatistics(startDateTime, endDateTime, metric);
            response.getWriter().write(gson.toJson(chartData));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Lỗi lấy dữ liệu biểu đồ\"}");
        }
    }
}