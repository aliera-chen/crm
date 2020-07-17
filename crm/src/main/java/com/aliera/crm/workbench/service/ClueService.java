package com.aliera.crm.workbench.service;

import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    void saveClue(Clue clue);


    Long findClueCountByCondition(Map<String, Object> paramsMap);

    List<Clue> findClueByConditionForPage(Map<String, Object> paramsMap);

    /*
     *description: 通过线索id查询线索
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [id]
     *@return: com.aliera.crm.workbench.domain.Clue
     */
    Clue findClueById(String id);

    Clue findClueOwnerToNameById(String id);

    List<Activity> findRelationActivityListByCondition(String clueId, String queryName);

    void convertClue(Map<String, String> paramsMap);

    /**
     * 修改线索
     * @author Aliera
     * @date 2020/7/7 20:06
     * @param clue
     * @return
     */
    void updateClue(Clue clue);

    /**
     * 删除线索
     * @author Aliera
     * @date 2020/7/7 20:35
     * @param ids
     * @return
     */
    void deleteClueByIdArray(String[] ids);
}
