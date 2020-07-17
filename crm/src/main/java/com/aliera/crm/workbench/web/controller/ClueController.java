package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.commons.utils.DateTimeUtil;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.vo.PaginationVO;
import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.Clue;
import com.aliera.crm.workbench.domain.Customer;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.*;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description: 线索控制器类
 * @author: Aliera
 * @create: 2020-07-04 11:32
 */

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {
    @Autowired
    private ClueService clueService;
    @Autowired
    private UserService userService;

    /*
     *description: 转发到线索首页
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/toClueIndex.do")
    public String toClueIndex() {
        return "/workbench/clue/index";
    }

    /*
     *description: 查询所有用户列表
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: []
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findAllUsers.do")
    @ResponseBody
    public Map<String, Object> findAllUsers() {
        Map<String,Object> resultMap = new HashMap<>();
        List<User> userList = userService.findAllUsers();
        resultMap.put("userList",userList);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 保存线索
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: [clue, session]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/saveClue.do")
    @ResponseBody
    public Map<String, Object> saveClue(Clue clue, HttpSession session) {
        User user = (User)(session.getAttribute("user"));
        //设置参数
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(DateTimeUtil.getSysTime());
        clue.setCreateTime(user.getName());
        clueService.saveClue(clue);
        return HandleFlag.successTrue();
    }

    /*
     *description: 根据查询条件分页查询线索
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: [paramsMap]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findClueByConditionForPage.do")
    @ResponseBody
    public Map<String, Object> findClueByConditionForPage(@RequestParam Map<String, Object> paramsMap) {
        Map<String, Object> resultMap = new HashMap<>();
        int pageNo = Integer.parseInt((String)(paramsMap.get("pageNo")));
        int pageSize = Integer.parseInt((String)(paramsMap.get("pageSize")));
        int beginNo = (pageNo-1)*pageSize;
        paramsMap.put("pageNo",pageNo);
        paramsMap.put("pageSize",pageSize);
        paramsMap.put("beginNo",beginNo);

        //查询总条数
        Long total = clueService.findClueCountByCondition(paramsMap);

        //分页查询
        List<Clue> clueList = clueService.findClueByConditionForPage(paramsMap);
        //封装页面
        PaginationVO<Clue> pageVO = new PaginationVO<>(total,clueList);
        resultMap.putAll(HandleFlag.successTrue());
        resultMap.put("pageVO",pageVO);
        return resultMap;
    }

    /*
     *description: 通过id查找线索
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [id]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findClueById.do")
    @ResponseBody
    public Map<String,Object> findClueById(String id) {
        Map<String,Object> resultMap = new HashMap<>();
        Clue clue = clueService.findClueById(id);
        resultMap.put("clue",clue);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 转发到线索详情页面
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [model]
     *@return: java.lang.String
     */
    @RequestMapping("/toClueDetail.do")
    public String toClueDetail(Model model, String id) {
        Clue clue = clueService.findClueOwnerToNameById(id);
        model.addAttribute("clue",clue);
        return "/workbench/clue/detail";
    }

    /*
     *description: 根据线索id和市场活动名（模糊查询）查询当前线索关联且满足查询条件的市场活动列表
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [clueId, queryName]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findRelationActivityListByCondition.do")
    @ResponseBody
    public Map<String, Object> findRelationActivityListByCondition(String clueId, String queryName) {
        Map<String, Object> resultMap = new HashMap<>();
        //查询未关联的市场活动表
        List<Activity> activityList = clueService.findRelationActivityListByCondition(clueId,queryName);
        resultMap.put("relationActivityList",activityList);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 转换线索
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [paramsMap, session]
     *@return: java.lang.String
     */
    @RequestMapping("/convertClue.do")
    public String convertClue(@RequestParam Map<String,String> paramsMap, HttpSession session) {
        User user = (User)(session.getAttribute("user"));
        paramsMap.put("createBy",user.getName());
        paramsMap.put("createTime",DateTimeUtil.getSysTime());
        clueService.convertClue(paramsMap);

        return "redirect:/workbench/clue/toClueIndex.do";
    }

    /**
     * 修改线索
     * @author Aliera
     * @date 2020/7/7 20:34
     * @param clue
     * @Param session
     * @return
     */
    @RequestMapping("/updateClue.do")
    @ResponseBody
    public Map<String, Object> updateClue(Clue clue, HttpSession session) {
        Map<String, Object> resultMap = new HashMap<>();
        User user = (User)(session.getAttribute("user"));
        clue.setEditBy(user.getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
        clueService.updateClue(clue);

        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /**
     * 通过id队列删除线索
     * @author Aliera
     * @date 2020/7/7 23:14
     * @param ids
     * @return
     */
    @RequestMapping("/deleteClueByIdArray.do")
    @ResponseBody
    public Map<String, Object> deleteClueByIdArray(String[] ids) {
        Map<String, Object> resultMap = new HashMap<>();
        clueService.deleteClueByIdArray(ids);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

}
