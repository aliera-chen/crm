package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.ClueRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> findClueRemarksByClueId(String clueId);

    List<Activity> findRelationActivityByClueId(String clueId);

    List<Activity> findUnRelationActivityListByCondition(@Param("clueId") String clueId, @Param("queryName") String queryName);

    void saveRelationActivity(@Param("activityId") String activityId, @Param("clueId") String clueId,@Param("relationId") String relationId);

    void deleteClueActivityRelation(String relationId);

    void deleteClueRemark(String clueId);

    void saveClueRemark(ClueRemark clueRemark);

    void deleteClueRemarkByRemarkId(String remarkId);

    void updateClueRemark(ClueRemark clueRemark);
}
