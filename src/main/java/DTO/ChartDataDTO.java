package DTO;

import java.util.List;

public class ChartDataDTO {
    private List<String> labels;
    private List<Double> currentPeriodData;
    private List<Double> lastYearPeriodData;

    public ChartDataDTO() {}

    public ChartDataDTO(List<String> labels, List<Double> currentPeriodData, List<Double> lastYearPeriodData) {
        this.labels = labels;
        this.currentPeriodData = currentPeriodData;
        this.lastYearPeriodData = lastYearPeriodData;
    }

    public List<String> getLabels() { return labels; }
    public void setLabels(List<String> labels) { this.labels = labels; }

    public List<Double> getCurrentPeriodData() { return currentPeriodData; }
    public void setCurrentPeriodData(List<Double> currentPeriodData) { this.currentPeriodData = currentPeriodData; }

    public List<Double> getLastYearPeriodData() { return lastYearPeriodData; }
    public void setLastYearPeriodData(List<Double> lastYearPeriodData) { this.lastYearPeriodData = lastYearPeriodData; }
}