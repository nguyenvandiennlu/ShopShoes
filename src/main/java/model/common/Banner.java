package model.common;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Banner implements Serializable {
    private int id;
    private String title;
    private String img_url;
    private String link_url;
    private String target_type;
    private int target_entity_id;
    private String position;
    private int sort_order;
    private String slogan;
    private boolean is_active;
    private LocalDateTime start_date;
    private LocalDateTime end_date;

    public Banner() {
    }

    public Banner(int id, String title, String img_url, String link_url, String target_type, int target_entity_id, String position, int sort_order, String slogan, boolean is_active, LocalDateTime start_date, LocalDateTime end_date) {
        this.id = id;
        this.title = title;
        this.img_url = img_url;
        this.link_url = link_url;
        this.target_type = target_type;
        this.target_entity_id = target_entity_id;
        this.position = position;
        this.sort_order = sort_order;
        this.slogan = slogan;
        this.is_active = is_active;
        this.start_date = start_date;
        this.end_date = end_date;
    }
    public int getId() {return id;}

    public void setId(int id) {this.id = id;}

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImgUrl() {
        return img_url;
    }

    public void setImgUrl(String img_url) {
        this.img_url = img_url;
    }

    public String getLinkUrl() {
        return link_url;
    }

    public void setLinkUrl(String link_url) {
        this.link_url = link_url;
    }

    public String getTargetType() {
        return target_type;
    }

    public void setTargetType(String target_type) {
        this.target_type = target_type;
    }

    public int getTargetEntityId() {
        return target_entity_id;
    }

    public void setTargetEntityId(int target_entity_id) {
        this.target_entity_id = target_entity_id;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public int getSortOrder() {
        return sort_order;
    }

    public void setSortOrder(int sort_order) {
        this.sort_order = sort_order;
    }

    public boolean isActive() {
        return is_active;
    }

    public void setActive(boolean is_active) {
        this.is_active = is_active;
    }

    public LocalDateTime getStartDate() {
        return start_date;
    }

    public void setStartDate(LocalDateTime start_date) {
        this.start_date = start_date;
    }

    public LocalDateTime getEndDate() {
        return end_date;
    }

    public void setEndDate(LocalDateTime end_date) {
        this.end_date = end_date;
    }

    public String getSlogan() {
        return slogan;
    }

    public void setSlogan(String slogan) {
        this.slogan = slogan;
    }

    public String getStartDateInput()
    {
        return start_date == null ? "" :
                start_date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
    }
    public String getEndDateInput()
    {
        return end_date == null ? "" :
                end_date.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
    }
}
