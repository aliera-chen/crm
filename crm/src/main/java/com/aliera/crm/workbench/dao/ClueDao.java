package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.Clue;
import com.aliera.crm.workbench.domain.ClueActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    void saveClue(Clue clue);

    Long findClueCountByCondition(Map<String, Object> paramsMap);

    List<Clue> findClueByConditionForPage(Map<String, Object> paramsMap);

    Clue findClueById(String id);

    Clue findClueOwnerToNameById(String id);

    List<Activity> findRelationActivityListByCondition(@Param("clueId") String clueId, @Param("queryName") String queryName);

    List<ClueActivityRelation> findRelationListByClueId(String clueId);

    void deleteClueByClueId(String clueId);

    void deleteClueActivityRelationByClueId(String clueId);

    void updateClue(Clue clue);

    void deleteClueByIdArray(String[] ids);
}
