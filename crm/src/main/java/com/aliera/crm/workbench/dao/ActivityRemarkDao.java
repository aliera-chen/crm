package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityRemarkDao {

    List<ActivityRemark> findRemarksByActivityId(String id);

    void deleteRemark(String id);

    void saveRemark(ActivityRemark activityRemark);

    void updateRemark(Map<String, Object> paramsMap);

    ActivityRemark findActivityRemarkById(String id);

    void deleteRemarkByActivityIds(String[] ids);
}
