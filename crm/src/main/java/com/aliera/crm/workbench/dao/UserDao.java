package com.aliera.crm.workbench.dao;

import com.aliera.crm.workbench.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {
    User login(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);
    User loginByUser(User user);

    List<User> findAllUsers();
}
