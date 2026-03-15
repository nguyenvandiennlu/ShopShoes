package model.Collection;

import java.io.Serializable;

public class CollectionRule implements Serializable {
        private int id;
        private int collection_id;
        private String fieldName;
        private String operator;
        private String value;

    public CollectionRule() {
    }

    public CollectionRule(int id, int collection_id, String fieldName, String operator, String value) {
        this.id = id;
        this.collection_id = collection_id;
        this.fieldName = fieldName;
        this.operator = operator;
        this.value = value;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCollectionId() {
        return collection_id;
    }

    public void setCollectionId(int collection_id) {
        this.collection_id = collection_id;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
