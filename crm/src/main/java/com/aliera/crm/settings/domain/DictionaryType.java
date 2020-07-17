package com.aliera.crm.settings.domain;

/**
 * @program: ProjectForCrm
 * @description: 数据字典类型实体类
 * @author: Aliera
 * @create: 2020-06-29 10:48
 */
public class DictionaryType {
    private String code;
    private String name;
    private String description;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "DictionaryType{" +
                "code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
