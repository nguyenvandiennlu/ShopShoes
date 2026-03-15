package model.product;

import java.io.Serializable;

public class Color implements Serializable {
    private int id;
    private String name;
    private String hexcode;

    public Color() {
    }

    public Color(int id, String name, String hexcode) {
        this.id = id;
        this.name = name;
        this.hexcode = hexcode;
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

    public String getHexCode() {
        return hexcode;
    }

    public void setHexCode(String hexcode) {
        this.hexcode = hexcode;
    }
}
