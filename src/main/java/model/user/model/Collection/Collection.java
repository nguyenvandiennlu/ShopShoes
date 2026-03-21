package model.user.model.Collection;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

import java.io.Serializable;

public class Collection implements Serializable {
    private int id;
    private String name;
    private String slug;
    @ColumnName("rule_set_type")
    private String ruleSetType;

    @ColumnName("is_active")
    private boolean active;

    public Collection() {
    }

    public Collection(int id, String name, String slug, String ruleSetType, boolean active) {
        this.id = id;
        this.name = name;
        this.slug = slug;
        this.ruleSetType = ruleSetType;
        this.active = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getRuleSetType() {
        return ruleSetType;
    }

    public void setRuleSetType(String ruleSetType) {
        this.ruleSetType = ruleSetType;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
