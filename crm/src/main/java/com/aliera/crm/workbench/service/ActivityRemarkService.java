package com.aliera.crm.workbench.service;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityRemarkService {
    
    List<ActivityRemark> findRemarksByActivityId(String id);

    void deleteRemark(String id);

    void saveRemark(ActivityRemark activityRemark);

    void updateRemark(Map<String, Object> paramsMap) throws TraditionRequestException;

    ActivityRemark findActivityRemarkById(String id);

    void deleteRemarkByActivityIds(String[] ids);
}
