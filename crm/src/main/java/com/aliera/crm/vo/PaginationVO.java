package com.aliera.crm.vo;

import java.io.Serializable;
import java.util.List;

/**
 * @program: ProjectForCrm
 * @description: 分页查询封装工具类
 * @author: Aliera
 * @create: 2020-07-01 15:31
 */
public class PaginationVO<T> implements Serializable {
    public PaginationVO() {
    }

    public PaginationVO(long total, List<T> dataList) {
        this.total = total;
        this.dataList = dataList;
    }

    private long total;

    private List<T> dataList;

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
