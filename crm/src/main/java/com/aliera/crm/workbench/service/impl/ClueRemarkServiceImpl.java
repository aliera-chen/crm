package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.workbench.dao.ClueRemarkDao;
import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.ClueRemark;
import com.aliera.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-04 11:41
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkDao clueRemarkDao;

    @Override
    public List<ClueRemark> findClueRemarksByClueId(String clueId) {
        return clueRemarkDao.findClueRemarksByClueId(clueId);
    }

    @Override
    public List<Activity> findRelationActivityByClueId(String clueId) {
        return clueRemarkDao.findRelationActivityByClueId(clueId);
    }

    @Override
    public List<Activity> findUnRelationActivityListByCondition(String clueId, String queryName) {
        return clueRemarkDao.findUnRelationActivityListByCondition(clueId,queryName);
    }

    @Override
    public void saveRelationActivityList(String[] activityIdList, String clueId) {
        for (String activityId : activityIdList) {
            clueRemarkDao.saveRelationActivity(activityId,clueId,UUIDUtil.getUUID());
        }
    }

    @Override
    public void deleteClueActivityRelation(String relationId) {
        clueRemarkDao.deleteClueActivityRelation(relationId);
    }

    /**
     * 保存线索备注
     * @author Aliera
     * @date 2020/7/8 10:21
     * @param clueRemark
     * @return
     */
    @Override
    public void saveClueRemark(ClueRemark clueRemark) {
        clueRemarkDao.saveClueRemark(clueRemark);
    }

    /**
     * 通过备注id删除线索备注
     * @author Aliera
     * @date 2020/7/8 11:02
     * @param remarkId
     * @return
     */
    @Override
    public void deleteClueRemarkByRemarkId(String remarkId) {
        clueRemarkDao.deleteClueRemarkByRemarkId(remarkId);
    }

    /**
     * 修改线索备注
     * @author Aliera
     * @date 2020/7/8 11:35
     * @param clueRemark
     * @return
     */
    @Override
    public void updateClueRemark(ClueRemark clueRemark) {
        clueRemarkDao.updateClueRemark(clueRemark);
    }
}
