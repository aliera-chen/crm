package com.aliera.crm.workbench.service.impl;

import com.aliera.crm.workbench.dao.UserDao;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-06-26 17:23
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd) {

        User user = userDao.login(loginAct,loginPwd);

        return user;

    }

    @Override
    public List<User> findAllUsers() {
        return userDao.findAllUsers();
    }

}
