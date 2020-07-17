package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.Customer;
import com.aliera.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerDao {

    /*
     *description: 保存客户
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [customer]
     *@return: void
     */
    void saveCustomer(Customer customer);

    /*
     *description: 通过公司名查询客户
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [company]
     *@return: com.aliera.crm.workbench.domain.Customer
     */
    Customer findCustomerByCompany(String company);

    /*
     *description: 保存客户备注列表
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [customerRemarkList]
     *@return: void
     */
    void saveCustomerRemarkList(List<CustomerRemark> customerRemarkList);

    /**
     * 根据名字的关键字模糊查询符合条件的客户名
     * @author Aliera
     * @date 2020/7/9 14:28
     * @param name
     * @return java.util.List<java.lang.String>
     */
    List<String> findCustomerByPartOfName(String name);
}
