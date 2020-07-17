package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.workbench.dao.ActivityRemarkDao;
import com.aliera.crm.workbench.domain.ActivityRemark;
import com.aliera.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-06-30 19:19
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkDao activityRemarkDao;

    /*
     *description: 通过市场活动id查询指定活动的所有备注
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: java.util.List<com.aliera.crm.workbench.domain.ActivityRemark>
     */
    @Override
    public List<ActivityRemark> findRemarksByActivityId(String id) {
        return activityRemarkDao.findRemarksByActivityId(id);
    }

    /*
     *description: 通过备注的id删除指定备注
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: void
     */
    @Override
    public void deleteRemark(String id) {
        activityRemarkDao.deleteRemark(id);
    }

    /*
     *description: 保存备注
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [activityRemark]
     *@return: void
     */
    @Override
    public void saveRemark(ActivityRemark activityRemark) {
        activityRemarkDao.saveRemark(activityRemark);
    }

    /*
     *description: 更新备注
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [paramsMap]
     *@return: void
     */
    @Override
    public void updateRemark(Map<String, Object> paramsMap) throws TraditionRequestException {
        activityRemarkDao.updateRemark(paramsMap);
    }

    /*
     *description: 通过备注id查询备注
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.ActivityRemark
     */
    @Override
    public ActivityRemark findActivityRemarkById(String id) {
        return activityRemarkDao.findActivityRemarkById(id);
    }

    @Override
    public void deleteRemarkByActivityIds(String[] ids) {
        activityRemarkDao.deleteRemarkByActivityIds(ids);
    }
}
