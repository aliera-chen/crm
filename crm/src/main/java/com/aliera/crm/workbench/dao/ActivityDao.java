package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    /*
     *description: 保存市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [activity]
     *@return: void
     */
    void saveActivity(Activity activity);

    long findCountOfActivityByCondition(Map<String, Object> paramsMap);

    List<Activity> findActivityForPageByCondition(Map<String, Object> paramsMap);

    void deleteActivitiesByIds(String[] ids);

    Activity findActivityById(String id);

    void updateActivity(Activity activity);

    Activity findActivityWithOwnerNameById(String id);

    List<Activity> findAllActivity();

    List<Activity> findActivityByIds(String[] ids);

    void saveImportActivity(List<Activity> activityList);

    List<Activity> queryActivityListLikeName(@Param("queryName") String queryName);
}
