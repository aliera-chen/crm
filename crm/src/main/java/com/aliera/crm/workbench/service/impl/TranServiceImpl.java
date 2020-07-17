package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.vo.PaginationVO;
import com.aliera.crm.workbench.dao.ActivityDao;
import com.aliera.crm.workbench.dao.ContactsDao;
import com.aliera.crm.workbench.dao.CustomerDao;
import com.aliera.crm.workbench.dao.TranDao;
import com.aliera.crm.workbench.domain.*;
import com.aliera.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-07 14:07
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranDao tranDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ActivityDao activityDao;
    @Autowired
    private ContactsDao contactsDao;

    /**
     * 根据名字的关键字搜索客户全名
     * @author Aliera
     * @date 2020/7/9 14:34
     * @param name
     * @return java.util.List<java.lang.String>
     */
    @Override
    public List<String> getCustomerNameAuto(String name) {
        return customerDao.findCustomerByPartOfName(name);
    }

    /**
     * 根据输入名字模糊查询市场活动列表
     * @author Aliera
     * @date 2020/7/9 15:47
     * @param queryName
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    @Override
    public Map<String, Object> queryActivityListLikeName(String queryName) {
        List<Activity> activityList =  activityDao.queryActivityListLikeName(queryName);
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("activityList",activityList);
        return resultMap;
    }

    /**
     * 通过人名模糊查询联系人表
     * @author Aliera
     * @date 2020/7/9 16:12
     * @param queryName
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    @Override
    public Map<String, Object> queryContactsListLikeName(String queryName) {
        List<Contacts> contactsList = contactsDao.queryContactsListLikeName(queryName);
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("contactsList",contactsList);
        return resultMap;
    }

    /**
     * 保存交易
     * @author Aliera
     * @date 2020/7/9 17:12
     * @param paramsMap
     *      参数包含
     *      owner:
     *      money:
     *      name:
     *      expectedDate:
     *      customerName:
     *      stage:
     *      source:
     *      type:
     *      activityId:
     *      contactsName:
     *      description:
     *      contactSummary:
     *      createBy:
     *      createTime:
     * @return void
     */
    @Override
    public void saveTran(Map<String, String> paramsMap) {
        String owner = paramsMap.get("owner"); 
        String money = paramsMap.get("money"); 
        String name = paramsMap.get("name");
        String expectedDate = paramsMap.get("expectedDate");
        String customerName = paramsMap.get("customerName");
        String stage = paramsMap.get("stage");
        String source = paramsMap.get("source");
        String type = paramsMap.get("type");
        String activityId = paramsMap.get("activityId");
        String contactsName = paramsMap.get("contactsName");
        String description = paramsMap.get("description");
        String contactSummary = paramsMap.get("contactSummary");
        String createBy = paramsMap.get("createBy");
        String createTime = paramsMap.get("createTime");
        String nextContactTime = paramsMap.get("nextContactTime");
        
        //按客户名搜索客户，如果没有客户创建新客户
        Customer customer = customerDao.findCustomerByCompany(customerName);
        if(customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setOwner(owner);
            customer.setCreateBy(createBy);
            customer.setCreateTime(createTime);
            customerDao.saveCustomer(customer);
        }
        //按联系人名和客户id搜索联系人，如果没有联系人创建新联系人
        Contacts contacts = contactsDao.findContactsByFullNameAndCustomerId(contactsName,customer.getId());
        if(contacts == null) {
            contacts = new Contacts();
            contacts.setId(UUIDUtil.getUUID());
            contacts.setOwner(owner);
            contacts.setCustomerId(customer.getId());
            contacts.setFullname(contactsName);
            contacts.setCreateTime(createTime);
            contacts.setCreateBy(createBy);
            contacts.setContactSummary(contactSummary);
            contacts.setNextContactTime(nextContactTime);
            contactsDao.saveContacts(contacts);
        }
        //按联系人id和市场活动id搜索关联，如果没有创建关联
        ContactsActivityRelation relation = contactsDao.findRelationByContactsAndActivity(contacts.getId(),activityId);
        if(relation == null) {
            relation = new ContactsActivityRelation();
            relation.setContactsId(contacts.getId());
            relation.setActivityId(activityId);
            relation.setId(UUIDUtil.getUUID());
            contactsDao.saveContactsActivityRelation(relation);
        }

        //创建交易
        Tran tran = new Tran();
        tran.setId(UUIDUtil.getUUID());
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setCustomerId(customer.getId());
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contacts.getId());
        tran.setCreateTime(createTime);
        tran.setCreateBy(createBy);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);
        tranDao.saveTran(tran);

        //创建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setStage(stage);
        tranHistory.setMoney(money);
        tranHistory.setCreateTime(createTime);
        tranHistory.setCreateBy(createBy);
        tranHistory.setTranId(tran.getId());
        tranHistory.setExpectedDate(expectedDate);
        tranDao.saveTranHistory(tranHistory);
    }

    /**
     * 根据条件分页查询交易列表
     * @author Aliera
     * @date 2020/7/10 13:20
     * @param paramsMap
     * @return com.aliera.crm.vo.PaginationVO<com.aliera.crm.workbench.domain.Tran>
     */
    @Override
    public PaginationVO<Tran> findTranListForPageByCondition(Map<String, Object> paramsMap) {
        //查询总条目数
        Long total = tranDao.findTranCountsByCondition(paramsMap);
        //分页查询交易列表
        List<Tran> tranList = tranDao.findTranListForPageByCondition(paramsMap);
        //封装结果集
        PaginationVO<Tran> pageVO = new PaginationVO<>(total,tranList);
        return pageVO;
    }

    /**
     * 通过交易id查询交易
     * @author Aliera
     * @date 2020/7/10 14:27
     * @param tranId
     * @return com.aliera.crm.workbench.domain.Tran
     */
    @Override
    public Tran findTranByTranId(String tranId) {
        return tranDao.findTranByTranId(tranId);
    }
}
