package model.user.model.Order;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order implements Serializable {

    private int id;
    private int user_id;
    private LocalDateTime created_at;

    private BigDecimal shipping_fee;
    private BigDecimal sub_total;
    private BigDecimal grand_total;

    private String shipping_address;
    private String phone_number;

    private String order_status;
    private String payment_method;
    private String payment_status;

    private String order_note;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }

    public LocalDateTime getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    // Helper for JSP fmt:formatDate
    public java.util.Date getCreatedAtTimestamp() {
        return created_at == null ? null : java.sql.Timestamp.valueOf(created_at);
    }

    public BigDecimal getShippingFee() {
        return shipping_fee;
    }

    public void setShippingFee(BigDecimal shipping_fee) {
        this.shipping_fee = shipping_fee;
    }

    public BigDecimal getSubTotal() {
        return sub_total;
    }

    public void setSubTotal(BigDecimal sub_total) {
        this.sub_total = sub_total;
    }

    public BigDecimal getGrandTotal() {
        return grand_total;
    }

    public void setGrandTotal(BigDecimal grand_total) {
        this.grand_total = grand_total;
    }

    public String getShippingAddress() {
        return shipping_address;
    }

    public void setShippingAddress(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public String getPhoneNumber() {
        return phone_number;
    }

    public void setPhoneNumber(String phone_number) {
        this.phone_number = phone_number;
    }

    public String getOrderStatus() {
        return order_status;
    }

    public void setOrderStatus(String order_status) {
        this.order_status = order_status;
    }

    public String getPaymentMethod() {
        return payment_method;
    }

    public void setPaymentMethod(String payment_method) {
        this.payment_method = payment_method;
    }

    public String getPaymentStatus() {
        return payment_status;
    }

    public void setPaymentStatus(String payment_status) {
        this.payment_status = payment_status;
    }

    public String getOrderNote() {
        return order_note;
    }

    public void setOrderNote(String order_note) {
        this.order_note = order_note;
    }

    // List items for display
    private java.util.List<OrderDetailDTO> items;

    public java.util.List<OrderDetailDTO> getItems() {
        return items;
    }

    public void setItems(java.util.List<OrderDetailDTO> items) {
        this.items = items;
    }
}