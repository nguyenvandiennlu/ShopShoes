package services.admin;

import DTO.ChartDataDTO;
import dao.admin.StatisticsDao;
import DTO.StatisticsDTO;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

public class StatisticsService {
    private final StatisticsDao statisticsDao = new StatisticsDao();

    public StatisticsDTO getDashboardSummary(LocalDateTime start, LocalDateTime end) {
        StatisticsDTO dto = new StatisticsDTO();

        int currentOrders = statisticsDao.getTotalOrders(start, end);
        double currentRevenue = statisticsDao.getTotalRevenue(start, end);
        int currentUsers = statisticsDao.getNewUsers(start, end);

        long daysBetween = ChronoUnit.DAYS.between(start.toLocalDate(), end.toLocalDate()) + 1;
        LocalDateTime prevEnd = start.minusNanos(1);
        LocalDateTime prevStart = start.minusDays(daysBetween);

        int prevOrders = statisticsDao.getTotalOrders(prevStart, prevEnd);
        double prevRevenue = statisticsDao.getTotalRevenue(prevStart, prevEnd);
        int prevUsers = statisticsDao.getNewUsers(prevStart, prevEnd);

        dto.setTotalOrders(currentOrders);
        dto.setOrdersGrowth(calculateGrowth(currentOrders, prevOrders));

        dto.setTotalRevenue(currentRevenue);
        dto.setRevenueGrowth(calculateGrowth(currentRevenue, prevRevenue));

        dto.setNewUsers(currentUsers);
        dto.setUsersGrowth(calculateGrowth(currentUsers, prevUsers));

        dto.setTotalProducts(statisticsDao.getTotalProducts());
        dto.setLowStockProducts(statisticsDao.getLowStockCount());

        return dto;
    }

    public ChartDataDTO getChartStatistics(LocalDateTime start, LocalDateTime end, String metric) {
        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<Double> currentData = new java.util.ArrayList<>();
        java.util.List<Double> previousPeriodData = new java.util.ArrayList<>();

        long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(start.toLocalDate(), end.toLocalDate()) + 1;
        LocalDateTime prevEnd = start.minusNanos(1); // Kết thúc ngay trước khoảnh khắc start
        LocalDateTime prevStart = start.minusDays(daysBetween);

        if (daysBetween <= 31) {
            java.util.Map<java.time.LocalDate, Double> currentMap;
            java.util.Map<java.time.LocalDate, Double> prevMap;

            if ("orders".equals(metric)) {
                currentMap = statisticsDao.getOrdersByDay(start, end);
                prevMap = statisticsDao.getOrdersByDay(prevStart, prevEnd);
            } else if ("quantity".equals(metric)) {
                currentMap = statisticsDao.getQuantityByDay(start, end);
                prevMap = statisticsDao.getQuantityByDay(prevStart, prevEnd);
            } else {
                currentMap = statisticsDao.getRevenueByDay(start, end);
                prevMap = statisticsDao.getRevenueByDay(prevStart, prevEnd);
            }

            java.time.LocalDate curLoopDate = start.toLocalDate();
            java.time.LocalDate prevLoopDate = prevStart.toLocalDate();
            java.time.LocalDate endDateLimit = end.toLocalDate();

            java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("dd/MM");

            while (!curLoopDate.isAfter(endDateLimit)) {
                labels.add(curLoopDate.format(dtf));
                currentData.add(currentMap.getOrDefault(curLoopDate, 0.0));

                previousPeriodData.add(prevMap.getOrDefault(prevLoopDate, 0.0));

                curLoopDate = curLoopDate.plusDays(1);
                prevLoopDate = prevLoopDate.plusDays(1);
            }
        } else {
            java.util.Map<String, Double> currentMap;
            java.util.Map<String, Double> prevMap;

            if ("orders".equals(metric)) {
                currentMap = statisticsDao.getOrdersByMonth(start, end);
                prevMap = statisticsDao.getOrdersByMonth(prevStart, prevEnd);
            } else if ("quantity".equals(metric)) {
                currentMap = statisticsDao.getQuantityByMonth(start, end);
                prevMap = statisticsDao.getQuantityByMonth(prevStart, prevEnd);
            } else {
                currentMap = statisticsDao.getRevenueByMonth(start, end);
                prevMap = statisticsDao.getRevenueByMonth(prevStart, prevEnd);
            }

            java.util.List<java.time.LocalDate> currentMonths = new java.util.ArrayList<>();
            java.time.LocalDate tempCur = start.toLocalDate().withDayOfMonth(1);
            while (!tempCur.isAfter(end.toLocalDate().withDayOfMonth(1))) {
                currentMonths.add(tempCur);
                tempCur = tempCur.plusMonths(1);
            }

            java.util.List<java.time.LocalDate> prevMonths = new java.util.ArrayList<>();
            java.time.LocalDate tempPrev = prevStart.toLocalDate().withDayOfMonth(1);
            while (!tempPrev.isAfter(prevEnd.toLocalDate().withDayOfMonth(1))) {
                prevMonths.add(tempPrev);
                tempPrev = tempPrev.plusMonths(1);
            }

            int maxMonthsCount = Math.max(currentMonths.size(), prevMonths.size());
            java.time.format.DateTimeFormatter ymFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM");

            for (int i = 0; i < maxMonthsCount; i++) {
                String axisLabel = "";
                Double curVal = 0.0;
                Double prevVal = 0.0;

                if (i < currentMonths.size()) {
                    java.time.LocalDate cMonth = currentMonths.get(i);
                    axisLabel = "Tháng " + cMonth.getMonthValue();
                    curVal = currentMap.getOrDefault(cMonth.format(ymFormatter), 0.0);
                }

                if (i < prevMonths.size()) {
                    java.time.LocalDate pMonth = prevMonths.get(i);
                    if (axisLabel.isEmpty()) {
                        axisLabel = "Kỳ trước (T" + pMonth.getMonthValue() + ")";
                    } else {
                        axisLabel += " (vs T" + pMonth.getMonthValue() + ")";
                    }
                    prevVal = prevMap.getOrDefault(pMonth.format(ymFormatter), 0.0);
                }

                labels.add(axisLabel);
                currentData.add(curVal);
                previousPeriodData.add(prevVal);
            }
        }

        return new ChartDataDTO(labels, currentData, previousPeriodData);
    }

    private double calculateGrowth(double current, double previous) {
        if (previous == 0) {
            return current > 0 ? 100.0 : 0.0;
        }
        return ((current - previous) / previous) * 100.0;
    }
}