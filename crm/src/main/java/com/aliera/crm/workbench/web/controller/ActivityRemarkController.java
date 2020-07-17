package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.commons.utils.DateTimeUtil;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.workbench.domain.ActivityRemark;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-06-30 19:20
 */
@Controller
@RequestMapping("/workbench/activity/remark")
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /*
     *description: 查找并返回指定市场活动id的备注
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findRemarks.do")
    @ResponseBody
    public Map<String,Object> findRemarks(String id) {
        Map<String,Object> map = new HashMap<>();
        List<ActivityRemark> remarkList = activityRemarkService.findRemarksByActivityId(id);
        map.put("remarkList",remarkList);
        map.putAll(HandleFlag.successTrue());
        return map;
    }

    /*
     *description: 删除备注
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [id]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/deleteRemark.do")
    @ResponseBody
    public Map<String,Object> deleteRemark(String id) {
        activityRemarkService.deleteRemark(id);

        return HandleFlag.successTrue();
    }

    /*
     *description: 保存备注
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [activityRemark, session]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Map<String,Object> saveRemark(ActivityRemark activityRemark, HttpSession session) throws TraditionRequestException {
        Map<String, Object> map = new HashMap<>();
        User user = (User)(session.getAttribute("user"));

        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateBy(user.getName());
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());
        activityRemark.setEditFlag("0");

        activityRemarkService.saveRemark(activityRemark);
        map.put("remark",activityRemark);
        map.putAll(HandleFlag.successTrue());
        return map;
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public Map<String,Object> updateRemark(@RequestParam Map<String, Object> paramsMap, HttpSession session) throws TraditionRequestException {
        Map<String,Object> map = new HashMap<>();
        User user = (User)(session.getAttribute("user"));
        //设置修改参数
        paramsMap.put("editFlag","1");
        paramsMap.put("editBy",user.getName());
        paramsMap.put("editTime",DateTimeUtil.getSysTime());
        //修改备注
        activityRemarkService.updateRemark(paramsMap);
        //通过id查询备注
        ActivityRemark remark = activityRemarkService.findActivityRemarkById((String)(paramsMap.get("id")));
        //设置回传信息
        map.put("remark",remark);
        map.putAll(HandleFlag.successTrue());
        return map;
    }
}
