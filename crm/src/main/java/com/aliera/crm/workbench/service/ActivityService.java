package com.aliera.crm.workbench.service;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    /*
     *description: 保存市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [activity]
     *@return: void
     */
    void saveActivity(Activity activity) throws TraditionRequestException;

    /*
     *description: 返回满足查询条件的总字段数
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: long
     */
    long findCountOfActivityByCondition(Map<String, Object> paramsMap);

    /*
     *description: 返回按查询条件（条件包含分页情况）的查询活动表
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    List<Activity> findActivityForPageByCondition(Map<String, Object> paramsMap);

    /*
     *description: 根据id删除市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [ids]
     *@return: void
     */
    void deleteActivitiesByIds(String[] ids) throws TraditionRequestException;

    /*
     *description: 根据id查找市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.Activity
     */
    Activity findActivityById(String id) throws TraditionRequestException;

    /*
     *description: 修改市场活动
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [activity]
     *@return: void
     */
    void updateActivity(Activity activity) throws TraditionRequestException;

    /*
     *description: 根据id查找市场活动（owner为实际名字）
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.Activity
     */
    Activity findActivityWithOwnerNameById(String id);

    /*
     *description: 查询所有市场活动
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: []
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    List<Activity> findAllActivity();

    /*
     *description: 通过id数组（多个）查询市场活动
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [ids]
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    List<Activity> findActivityByIds(String[] ids);

    /*
     *description: 保存导入市场活动
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [activityList]
     *@return: void
     */
    void saveImportActivity(List<Activity> activityList);
}
