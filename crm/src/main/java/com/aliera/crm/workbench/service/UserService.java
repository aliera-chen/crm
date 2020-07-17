package com.aliera.crm.workbench.service;


import com.aliera.crm.exception.LoginException;
import com.aliera.crm.workbench.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd);

    /*
     *description: 查询所有用户
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: []
     *@return: java.util.List<com.aliera.crm.workbench.domain.User>
     */
    List<User> findAllUsers();
}
