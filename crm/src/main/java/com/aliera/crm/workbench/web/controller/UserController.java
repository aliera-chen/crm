package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.exception.LoginException;
import com.aliera.crm.commons.utils.MD5Util;
import com.aliera.crm.commons.constant.Message.ExceptionMessage;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-06-26 16:41
 */
@Controller
@RequestMapping("/workbench/users")
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private JedisPool jedisPool;

    //表单转发
    /*
     *description: 表单转发
     *@Author: Aliera
     *@date: 2020/6/27
     *@param: [loginAct, loginPwd]
     *@return: java.lang.String
     */
    @RequestMapping("/login.do")
    public String login(String loginAct, String loginPwd) throws LoginException {
        System.out.println("login-controller:"+loginAct+" "+loginPwd);
        String MD5LoginPwd = MD5Util.getMD5(loginPwd);
        System.out.println("MD5Pwd:"+MD5LoginPwd);
        User user = userService.login(loginAct, MD5LoginPwd);
        if(user == null) {
            return "redirect:/login.jsp";
        }
        System.out.println("login-controller success:"+user.getId()+" "+user.getName());
        return "/workbench/index";
    }

    /*
     *description: ajax转发，提交json格式的是否成功给ajax，返回的json中状态key值约定为"success"
     *@Author: Aliera
     *@date: 2020/6/27
     *@param: [loginAct, loginPwd, request, response, flag]
     * @param: loginAct 用户名
     * @param: loginPwd 密码
     * @param: flag 十天免登录的标记，"1"约定为选择的标记
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/ajaxToLogin.do")
    @ResponseBody
    public Map<String,Object> ajaxToLogin(String loginAct, String loginPwd, HttpServletRequest request, HttpServletResponse response, String flag) throws LoginException {
        System.out.println("ajax1 in  "+loginAct+" "+loginPwd+" "+flag);
        String md5LoginPwd = MD5Util.getMD5(loginPwd);
        User user = userService.login(loginAct,md5LoginPwd);
        Map<String, Object> map = new HashMap<>();

        //用户名和密码错误
        if(user == null) {
            throw new LoginException(ExceptionMessage.LOGIN_FAIL);
        }

        //账号锁定
        //状态码0/1, 0代表锁定，1/null代表启用
        if("0".equals(user.getLockState())) {
            throw new LoginException(ExceptionMessage.LOGIN_LOCK);
        }

        //账号过期
        String expireTime = user.getExpireTime();
        String curTime = new SimpleDateFormat("YYYY-MM-dd hh:mm:ss").format(new Date());
        System.out.println(expireTime+" "+curTime);
        if(expireTime.compareTo(curTime) < 0) {
            throw new LoginException(ExceptionMessage.LOGIN_EXPIRED);
        }

        //ip保护
        //当前ip需要在指定的ip列表中，否则受限；当允许的ip为空时，表示不受限
        String ip = request.getRemoteAddr();
        if(!user.getAllowIps().contains(ip)) {
            throw new LoginException(ExceptionMessage.LOGIN_IP_NOT_ALLOW);
        }
        request.getSession().setAttribute("user",user);

        //十天免登录功能
        //校验成功时，如果选择了十天免登录，将用户名和加密后的密码存入cookie中
        if("1".equals(flag)) {
            /*已过期*/
            /*Cookie loginActCookie = new Cookie("loginAct",loginAct);
            Cookie loginPwdCookie = new Cookie("loginPwd",md5LoginPwd);
            loginActCookie.setPath("/");
            loginPwdCookie.setPath("/");
            int maxAge = 60*60*24*10;
            loginActCookie.setMaxAge(maxAge);
            loginPwdCookie.setMaxAge(maxAge);
            response.addCookie(loginActCookie);
            response.addCookie(loginPwdCookie);*/
            String sessionId = request.getSession().getId();
            int maxAge = 60*60*24*10;
            Jedis jedis = jedisPool.getResource();
            jedis.select(1);
            Map<String, String> loginMap = new HashMap<>();
            loginMap.put("loginAct",loginAct);
            loginMap.put("loginPwd",md5LoginPwd);
            jedis.hmset(sessionId,loginMap);
            jedis.expire(sessionId,maxAge);
            Cookie cookie = new Cookie("JSESSIONID",sessionId);
            cookie.setMaxAge(maxAge);
            System.out.println(request.getContextPath());
            cookie.setPath(request.getContextPath());
            response.addCookie(cookie);
        }

        map.put("success",true);
        return map;
    }

    /*
     *description: 转发至登录成功界面，帮助ajax转发/登录后内部转发
     *@Author: Aliera
     *@date: 2020/6/26
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/toWorkbenchIndex.do")
    public String toWorkbenchIndex() {
        return "/workbench/index";
    }

    /*
     *description: 登录转发界面（初始）
     *@Author: Aliera
     *@date: 2020/6/27
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/toLogin.do")
    public String toLogin(HttpServletRequest request) {

        User user = null;
        /*已过时*/
        //十天免登录功能 使用cookie
        /*Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for (Cookie cookie : cookies) {
                if ("loginAct".equals(cookie.getName())) {
                    loginAct = cookie.getValue();
                } else if("loginPwd".equals(cookie.getName())) {
                    loginPwd = cookie.getValue();
                }
            }
        }*/
        Jedis jedis = jedisPool.getResource();
        String sessionId = request.getSession().getId();
        jedis.select(1);
        if(jedis.exists(sessionId)) {
            String loginAct = jedis.hget(sessionId,"loginAct");
            String loginPwd = jedis.hget(sessionId,"loginPwd");
            user = userService.login(loginAct,loginPwd);
        }

        if(user != null) {
            request.getSession().setAttribute("user",user);
            return "/workbench/index";
        }
        return "/login";
    }

    @RequestMapping("/logout.do")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        Jedis jedis = jedisPool.getResource();
        jedis.select(1);
        jedis.expire(session.getId(),0);
        //删除session
        session.invalidate();
        //删除cookie
        Cookie cookie = new Cookie("JSESSIONID","");
        cookie.setPath(request.getContextPath());
        cookie.setMaxAge(0);
        response.addCookie(cookie);

        /*已过期*/
        //删除cookie中的用户名和密码
/*        Cookie loginActCookie = new Cookie("loginAct","");
        Cookie loginPwdCookie = new Cookie("loginPwd","");
        loginActCookie.setPath("/");
        loginPwdCookie.setPath("/");
        int maxAge = 0;
        loginActCookie.setMaxAge(maxAge);
        loginPwdCookie.setMaxAge(maxAge);
        response.addCookie(loginActCookie);
        response.addCookie(loginPwdCookie);*/

        //使用遍历的方式删除cookie，可以使用
        /*Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if("loginAct".equals(cookie.getName()) || "loginPwd".equals(cookie.getName())) {
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }
        }*/



        //转发到login.jsp
        return "/login";
    }

}
