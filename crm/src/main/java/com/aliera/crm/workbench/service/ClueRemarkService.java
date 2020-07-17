package com.aliera.crm.workbench.service;

import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> findClueRemarksByClueId(String clueId);

    List<Activity> findRelationActivityByClueId(String clueId);

    /*
     *description: 通过线索id和活动名查询市场活动表
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [clueId, queryName]
     *@return: java.util.List<com.aliera.crm.workbench.domain.Activity>
     */
    List<Activity> findUnRelationActivityListByCondition(String clueId, String queryName);

    /*
     *description: 保存线索和多个市场活动的关联
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [activityIdList, clueId]
     *@return: void
     */
    void saveRelationActivityList(String[] activityIdList, String clueId);

    /*
     *description: 删除市场活动和线索的关联
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [relationId]
     *@return: void
     */
    void deleteClueActivityRelation(String relationId);

    /**
     * 保存线索备注
     * @author Aliera
     * @date 2020/7/8 10:20
     * @param clueRemark
     * @return
     */
    void saveClueRemark(ClueRemark clueRemark);

    /**
     * 通过备注id删除线索备注
     * @author Aliera
     * @date 2020/7/8 11:01
     * @param remarkId
     * @return
     */
    void deleteClueRemarkByRemarkId(String remarkId);

    /**
     * 修改线索备注
     * @author Aliera
     * @date 2020/7/8 11:35
     * @param clueRemark
     * @return
     */
    void updateClueRemark(ClueRemark clueRemark);
}
