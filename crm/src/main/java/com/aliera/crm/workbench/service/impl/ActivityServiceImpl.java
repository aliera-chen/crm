package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.workbench.dao.ActivityDao;
import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:市场模块
 * @author: Aliera
 * @create: 2020-06-30 12:04
 */

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityDao activityDao;

    /*
     *description: 保存市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [activity]
     *@return: void
     */
    @Override
    public void saveActivity(Activity activity) throws TraditionRequestException {
        activityDao.saveActivity(activity);
    }

    /*
     *description: 返回满足查询条件的总字段数
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: long
     */
    @Override
    public long findCountOfActivityByCondition(Map<String, Object> paramsMap) {
        return activityDao.findCountOfActivityByCondition(paramsMap);
    }

    /*
     *description: 返回按查询条件（条件包含分页情况）的查询活动表
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    @Override
    public List<Activity> findActivityForPageByCondition(Map<String, Object> paramsMap) {
        return activityDao.findActivityForPageByCondition(paramsMap);
    }

    /*
     *description: 按id删除市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [ids]
     *@return: void
     */
    @Override
    public void deleteActivitiesByIds(String[] ids) throws TraditionRequestException {
        activityDao.deleteActivitiesByIds(ids);
    }

    /*
     *description: 根据id查找市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.Activity
     */
    @Override
    public Activity findActivityById(String id) throws TraditionRequestException {
        return activityDao.findActivityById(id);
    }

    /*
     *description: 修改市场活动
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [activity]
     *@return: void
     */
    @Override
    public void updateActivity(Activity activity) throws TraditionRequestException {
        activityDao.updateActivity(activity);
    }

    /*
     *description: 通过id查找市场活动（owner获取实际姓名）
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.Activity
     */
    @Override
    public Activity findActivityWithOwnerNameById(String id) {
        return activityDao.findActivityWithOwnerNameById(id);
    }

    /*
     *description: 查找所有市场活动
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: []
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    @Override
    public List<Activity> findAllActivity() {
        return activityDao.findAllActivity();
    }

    /*
     *description: 通过id数组查询市场活动（多个）
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [ids]
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    @Override
    public List<Activity> findActivityByIds(String[] ids) {
        return activityDao.findActivityByIds(ids);
    }

    /*
     *description: 保存导入活动
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [activityList]
     *@return: void
     */
    @Override
    public void saveImportActivity(List<Activity> activityList) {
        activityDao.saveImportActivity(activityList);
    }


}
