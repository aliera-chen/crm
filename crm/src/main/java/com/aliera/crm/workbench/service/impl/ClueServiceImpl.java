package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.workbench.dao.*;
import com.aliera.crm.workbench.domain.*;
import com.aliera.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-04 11:40
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueDao clueDao;
    @Autowired
    private CustomerDao customerDao;
    @Autowired
    private ContactsDao contactsDao;
    @Autowired
    private TranDao tranDao;
    @Autowired
    private ClueRemarkDao clueRemarkDao;

    @Override
    public void saveClue(Clue clue) {
        clueDao.saveClue(clue);
    }

    @Override
    public Long findClueCountByCondition(Map<String, Object> paramsMap) {
        return clueDao.findClueCountByCondition(paramsMap);
    }

    @Override
    public List<Clue> findClueByConditionForPage(Map<String, Object> paramsMap) {
        return clueDao.findClueByConditionForPage(paramsMap);
    }

    @Override
    public Clue findClueById(String id) {
        return clueDao.findClueById(id);
    }

    @Override
    public Clue findClueOwnerToNameById(String id) {
        return clueDao.findClueOwnerToNameById(id);
    }

    @Override
    public List<Activity> findRelationActivityListByCondition(String clueId, String queryName) {
        return clueDao.findRelationActivityListByCondition(clueId,queryName);
    }


    /**
     * @param paramsMap 封装了线索id，交易信息，创建人以及创建时间
     * @return void
     * @author Aliera
     * @date 2020/7/7 19:09
    */
    @Override
    public void convertClue(Map<String, String> paramsMap) {
        String createBy = paramsMap.get("createBy");
        String createTime = paramsMap.get("createTime");
        //查询线索
        Clue clue = clueDao.findClueById(paramsMap.get("clueId"));
        if(clue != null) {
            //添加客户
            //判断客户是否已经存在
            Customer customer = customerDao.findCustomerByCompany(clue.getCompany());
            if(customer == null) {
                customer = new Customer(clue);
                customer.setId(UUIDUtil.getUUID());
                customer.setCreateTime(createTime);
                customer.setCreateBy(createBy);
                //添加客户
                customerDao.saveCustomer(customer);
            }

            //添加联系人
            //判断联系人是否已经存在（使用姓名和客户id）
            Contacts contacts = contactsDao.findContactsByFullNameAndCustomerId(clue.getFullname(),customer.getId());
            if(contacts == null) {
                contacts = new Contacts(clue);
                contacts.setId(UUIDUtil.getUUID());
                contacts.setCustomerId(customer.getId());
                contacts.setCreateBy(createBy);
                contacts.setCreateTime(createTime);

                contactsDao.saveContacts(contacts);
            }

            //转换备注 通过clueId获得备注列表，更换备注id和外键id

            //查找线索备注列表
            List<ClueRemark> remarkList = clueRemarkDao.findClueRemarksByClueId(clue.getId());
            if(remarkList != null && remarkList.size() > 0) {
                List<ContactsRemark> contactsRemarkList = new ArrayList<>(remarkList.size());
                List<CustomerRemark> customerRemarkList = new ArrayList<>(remarkList.size());
                ContactsRemark contactsRemark = null;
                CustomerRemark customerRemark = null;
                for (ClueRemark clueRemark : remarkList) {
                    //创建联系人备注
                    contactsRemark = new ContactsRemark(clueRemark);
                    contactsRemark.setContactsId(contacts.getId());
                    contactsRemark.setId(UUIDUtil.getUUID());
                    contactsRemarkList.add(contactsRemark);

                    //创建客户备注
                    customerRemark = new CustomerRemark(clueRemark);
                    customerRemark.setCustomerId(customer.getId());
                    customerRemark.setId(UUIDUtil.getUUID());
                    customerRemarkList.add(customerRemark);

                }
                contactsDao.saveContactsRemarkList(contactsRemarkList);
                customerDao.saveCustomerRemarkList(customerRemarkList);
            }

            //转换市场活动关联
            //查询clueId关联的市场活动
            List<ClueActivityRelation> clueActivityRelationList = clueDao.findRelationListByClueId(clue.getId());
            if(clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
                //添加contactsId关联的市场活动
                List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>(clueActivityRelationList.size());
                ContactsActivityRelation contactsActivityRelation = null;
                for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                    contactsActivityRelation = new ContactsActivityRelation(clueActivityRelation);
                    contactsActivityRelation.setId(UUIDUtil.getUUID());
                    contactsActivityRelation.setContactsId(contacts.getId());
                    contactsActivityRelationList.add(contactsActivityRelation);
                }
                contactsDao.saveContactsActivityRelationList(contactsActivityRelationList);
            }

            //交易标记为"1"代表创建交易
            if("1".equals(paramsMap.get("tranFlag"))) {
                Tran tran = new Tran();
                tran.setId(UUIDUtil.getUUID());
                tran.setOwner(clue.getOwner());
                tran.setMoney(paramsMap.get("tranMoney"));
                tran.setName(paramsMap.get("tranName"));
                tran.setExpectedDate(paramsMap.get("expectedDate"));
                tran.setCustomerId(customer.getId());
                tran.setStage(paramsMap.get("tranStage"));
                tran.setSource(clue.getSource());
                tran.setActivityId(paramsMap.get("activityId"));
                tran.setContactsId(contacts.getId());
                tran.setCreateBy(createBy);
                tran.setCreateTime(createTime);
                tran.setDescription(clue.getDescription());
                tran.setContactSummary(clue.getContactSummary());
                tran.setNextContactTime(clue.getNextContactTime());
                tran.setType("");
                tranDao.saveTran(tran);

                //添加交易历史
                TranHistory tranHistory = new TranHistory();
                tranHistory.setId(UUIDUtil.getUUID());
                tranHistory.setTranId(tran.getId());
                tranHistory.setStage(tran.getStage());
                tranHistory.setMoney(tran.getMoney());
                tranHistory.setExpectedDate(tran.getExpectedDate());
                tranHistory.setCreateBy(tran.getCreateBy());
                tranHistory.setCreateTime(tran.getCreateTime());
                tranDao.saveTranHistory(tranHistory);
            }

            //删除线索备注
            clueRemarkDao.deleteClueRemark(clue.getId());
            //删除线索关联
            clueDao.deleteClueActivityRelationByClueId(clue.getId());
            //删除线索
            clueDao.deleteClueByClueId(clue.getId());
        }

    }

    @Override
    public void updateClue(Clue clue) {
        clueDao.updateClue(clue);
    }

    @Override
    public void deleteClueByIdArray(String[] ids) {
        clueDao.deleteClueByIdArray(ids);
    }
}
