package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.workbench.dao.CustomerDao;
import com.aliera.crm.workbench.domain.Customer;
import com.aliera.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-07 14:09
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerDao customerDao;



}
