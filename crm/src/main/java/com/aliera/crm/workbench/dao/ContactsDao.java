package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Contacts;
import com.aliera.crm.workbench.domain.ContactsActivityRelation;
import com.aliera.crm.workbench.domain.ContactsRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {

    /*
     *description: 通过姓名和客户id查询联系人
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [fullname, id]
     *@return: com.aliera.crm.workbench.domain.Contacts
     */
    Contacts findContactsByFullNameAndCustomerId(@Param("fullname") String fullname, @Param("customerId") String customerId);

    /*
     *description: 新增联系人
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [contacts]
     *@return: void
     */
    void saveContacts(Contacts contacts);

    /*
     *description: 保存联系人备注列表
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [contactsRemarkList]
     *@return: void
     */
    void saveContactsRemarkList(List<ContactsRemark> contactsRemarkList);

    /*
     *description: 保存联系人-市场活动关联信息列表
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [contactsActivityRelationList]
     *@return: void
     */
    void saveContactsActivityRelationList(List<ContactsActivityRelation> contactsActivityRelationList);

    /**
     * 通过联系人名模糊从查询联系人表
     * @author Aliera
     * @date 2020/7/9 16:12
     * @param queryName
     * @return java.util.List<com.aliera.crm.workbench.domain.Contacts>
     */
    List<Contacts> queryContactsListLikeName(@Param("queryName") String queryName);

    /**
     * 通过联系人id和市场活动id查询关联记录
     * @author Aliera
     * @date 2020/7/9 17:47
     * @param contactsId
     * @Param activityId
     * @return com.aliera.crm.workbench.domain.ContactsActivityRelation
     */
    ContactsActivityRelation findRelationByContactsAndActivity(@Param("contactsId") String contactsId, @Param("activityId") String activityId);

    /**
     * 保存联系人-市场活动关系
     * @author Aliera
     * @date 2020/7/9 17:52
     * @param relation
     * @return void
     */
    void saveContactsActivityRelation(ContactsActivityRelation relation);
}
