package com.aliera.crm.workbench.service;

import com.aliera.crm.vo.PaginationVO;
import com.aliera.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    /**
     * 根据名字的关键字模糊搜索符合要求的全名
     * @author Aliera
     * @date 2020/7/9 14:34
     * @param name
     * @return java.util.List<java.lang.String>
     */
    List<String> getCustomerNameAuto(String name);

    /**
     * 通过活动名模糊查询市场活动列表
     * @author Aliera
     * @date 2020/7/9 16:10
     * @param queryName
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    Map<String, Object> queryActivityListLikeName(String queryName);

    /**
     * 通过联系人名模糊查询联系人列表
     * @author Aliera
     * @date 2020/7/9 16:10
     * @param queryName
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    Map<String, Object> queryContactsListLikeName(String queryName);

    /**
     * 保存交易
     * @author Aliera
     * @date 2020/7/9 17:06
     * @param paramsMap
     * @return void
     */
    void saveTran(Map<String, String> paramsMap);

    /**
     * 根据条件分页查询交易列表
     * @author Aliera
     * @date 2020/7/10 13:20
     * @param paramsMap
     * @return com.aliera.crm.vo.PaginationVO<com.aliera.crm.workbench.domain.Tran>
     */
    PaginationVO<Tran> findTranListForPageByCondition(Map<String, Object> paramsMap);

    /**
     * 根据交易id查询交易
     * @author Aliera
     * @date 2020/7/10 14:27
     * @param tranId
     * @return com.aliera.crm.workbench.domain.Tran
     */
    Tran findTranByTranId(String tranId);
}
