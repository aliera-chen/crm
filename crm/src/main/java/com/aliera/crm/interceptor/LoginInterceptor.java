package com.aliera.crm.interceptor;

import com.aliera.crm.exception.InterceptorException;
import com.aliera.crm.workbench.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @program: ProjectForCrm
 * @description: 登录拦截器
 * @author: Aliera
 * @create: 2020-06-26 15:38
 */
public class LoginInterceptor implements HandlerInterceptor {
    /*
     *description: 判断是否满足操作权限，返回true代表放行，false代表拦截
     *@Author: Aliera
     *@date: 2020/6/26
     *@param: [request, response, handler]
     *@return: boolean
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user = (User)(request.getSession().getAttribute("user"));
        if(user == null) {
            throw new InterceptorException();
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
