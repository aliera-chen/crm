package com.aliera.crm.vo;

import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.ActivityRemark;

import java.io.Serializable;
import java.util.List;

/**
 * @program: ProjectForCrm
 * @description: 市场活动详情封装类
 * @author: Aliera
 * @create: 2020-07-02 15:03
 */
public class ActivityDetailVO implements Serializable {
    private List<ActivityRemark> remarkList;
    private Activity activity;
    private String userName;


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "ActivityDetailVO{" +
                "remarkList=" + remarkList +
                ", activity=" + activity +
                ", userName='" + userName + '\'' +
                '}';
    }

    public List<ActivityRemark> getRemarkList() {
        return remarkList;
    }

    public void setRemarkList(List<ActivityRemark> remarkList) {
        this.remarkList = remarkList;
    }

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }
}
