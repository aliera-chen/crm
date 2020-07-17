package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.workbench.dao.ContactsDao;
import com.aliera.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-07-07 14:10
 */
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsDao contactsDao;
}
