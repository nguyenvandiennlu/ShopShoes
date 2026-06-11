package DTO;

public class StatisticsDTO {
    private int totalOrders;
    private double ordersGrowth;

    private double totalRevenue;
    private double revenueGrowth;

    private int newUsers;
    private double usersGrowth;

    private int totalProducts;
    private int lowStockProducts;

    public StatisticsDTO() {}

    public StatisticsDTO(int totalOrders, double totalRevenue, int newUsers, int lowStockProducts) {
        this.totalOrders = totalOrders;
        this.totalRevenue = totalRevenue;
        this.newUsers = newUsers;
        this.lowStockProducts = lowStockProducts;
    }

    public int getTotalOrders() { return totalOrders; }
    public void setTotalOrders(int totalOrders) { this.totalOrders = totalOrders; }
    public double getOrdersGrowth() { return ordersGrowth; }
    public void setOrdersGrowth(double ordersGrowth) { this.ordersGrowth = ordersGrowth; }

    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    public double getRevenueGrowth() { return revenueGrowth; }
    public void setRevenueGrowth(double revenueGrowth) { this.revenueGrowth = revenueGrowth; }

    public int getNewUsers() { return newUsers; }
    public void setNewUsers(int newUsers) { this.newUsers = newUsers; }
    public double getUsersGrowth() { return usersGrowth; }
    public void setUsersGrowth(double usersGrowth) { this.usersGrowth = usersGrowth; }

    public int getLowStockProducts() { return lowStockProducts; }
    public void setLowStockProducts(int lowStockProducts) { this.lowStockProducts = lowStockProducts; }
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
}