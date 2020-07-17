package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Tran;
import com.aliera.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranDao {
    /*
     *description: 创建交易
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [tran]
     *@return: void
     */
    void saveTran(Tran tran);

    /*
     *description: 保存交易历史
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [tranHistory]
     *@return: void
     */
    void saveTranHistory(TranHistory tranHistory);

    /**
     * 查询满足查询条件的总交易数
     * @author Aliera
     * @date 2020/7/10 13:24
     * @param paramsMap
     * @return java.lang.Long
     */
    Long findTranCountsByCondition(Map<String, Object> paramsMap);

    /**
     * 根据查询条件分页查询交易列表
     * @author Aliera
     * @date 2020/7/10 13:24
     * @param paramsMap
     * @return java.util.List<com.aliera.crm.workbench.domain.Tran>
     */
    List<Tran> findTranListForPageByCondition(Map<String, Object> paramsMap);

    /**
     * 通过交易id查询交易
     * @author Aliera
     * @date 2020/7/10 14:28
     * @param tranId
     * @return com.aliera.crm.workbench.domain.Tran
     */
    Tran findTranByTranId(String tranId);
}
