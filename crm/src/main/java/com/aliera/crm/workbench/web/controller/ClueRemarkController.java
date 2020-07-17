package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.commons.utils.DateTimeUtil;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.Clue;
import com.aliera.crm.workbench.domain.ClueRemark;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.ActivityService;
import com.aliera.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description: 线索备注控制器类
 * @author: Aliera
 * @create: 2020-07-04 11:33
 */
@Controller
@RequestMapping("/workbench/clue/remark")
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    /*
     *description: 通过线索id查询所有备注和关联事件
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [clueId]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findClueRemarkAndRelationActivity.do")
    @ResponseBody
    public Map<String, Object> findClueRemarkAndRelationActivity(String clueId) {
        Map<String,Object> resultMap = new HashMap<>();
        List<ClueRemark> remarkList = clueRemarkService.findClueRemarksByClueId(clueId);
        List<Activity> activityList = clueRemarkService.findRelationActivityByClueId(clueId);
        resultMap.put("clueRemarkList",remarkList);
        resultMap.put("relationActivityList",activityList);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 根据线索id和活动名查询未关注市场活动表
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [clueId, queryName]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findUnRelationActivityListByCondition.do")
    @ResponseBody
    public Map<String, Object> findUnRelationActivityListByCondition(String clueId, String queryName) {
        Map<String, Object> resultMap = new HashMap<>();
        //查询未关联的市场活动表
        List<Activity> activityList = clueRemarkService.findUnRelationActivityListByCondition(clueId,queryName);
        resultMap.put("unRelationActivityList",activityList);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 添加市场活动和线索关联
     *@Author: Aliera
     *@date: 2020/7/6
     *@param: [activityIdList, clueId]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/saveRelationActivityList.do")
    @ResponseBody
    public Map<String,Object> saveRelationActivityList(String[] activityIdList, String clueId) {
        Map<String, Object> resultMap = new HashMap<>();
        clueRemarkService.saveRelationActivityList(activityIdList,clueId);

        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /*
     *description: 通过关联id删除线索-市场活动关联关系
     *@Author: Aliera
     *@date: 2020/7/7
     *@param: [relationId]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/deleteClueActivityRelation.do")
    @ResponseBody
    public Map<String,Object> deleteClueActivityRelation(String relationId) {
        Map<String, Object> resultMap = new HashMap<>();
        clueRemarkService.deleteClueActivityRelation(relationId);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;

    }


    /**
     * 跳转到线索转换页面
     * @author Aliera
     * @date 2020/7/8 10:17
     * @param model
     * @Param clue
     * @return
     */
    @RequestMapping("/toClueConvert.do")
    public String toClueConvert(Model model, Clue clue) {
        model.addAttribute("clue",clue);
        return "/workbench/clue/convert";
    }

    /**
     * 保存线索备注
     * @author Aliera
     * @date 2020/7/8 10:19
     * @param clueRemark
     * @return
     */
    @RequestMapping("/saveClueRemark.do")
    @ResponseBody
    public Map<String, Object> saveClueRemark(ClueRemark clueRemark, HttpSession session) {
        User user = (User)(session.getAttribute("user"));
        Map<String, Object> resultMap = new HashMap<>();
        //设置部分参数
        clueRemark.setCreateBy(user.getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setEditFlag("0");
        clueRemarkService.saveClueRemark(clueRemark);
        resultMap.put("clueRemark",clueRemark);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /**
     * 通过备注id删除线索备注
     * @author Aliera
     * @date 2020/7/8 11:01
     * @param remarkId
     * @return
     */
    @RequestMapping("/deleteClueRemarkByRemarkId.do")
    @ResponseBody
    public Map<String, Object> deleteClueRemarkByRemarkId(String remarkId) {
        Map<String, Object> resultMap = new HashMap<>();
        clueRemarkService.deleteClueRemarkByRemarkId(remarkId);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }
    
    /**
     * TODO
     * @author Aliera
     * @date 2020/7/8 11:41
     * @param clueRemark
     * @Param session
     * @return 
     */
    @RequestMapping("/updateClueRemark.do")
    @ResponseBody
    public Map<String, Object> updateClueRemark(ClueRemark clueRemark, HttpSession session) {
        User user = (User)(session.getAttribute("user"));
        Map<String, Object> resultMap = new HashMap<>();
        clueRemark.setEditFlag("1");
        clueRemark.setEditBy(user.getName());
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemarkService.updateClueRemark(clueRemark);
        resultMap.put("clueRemark",clueRemark);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

}
