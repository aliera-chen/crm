package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.commons.utils.DateTimeUtil;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.vo.PaginationVO;
import com.aliera.crm.workbench.domain.Tran;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.TranService;
import com.aliera.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description: 交易控制器类
 * @author: Aliera
 * @create: 2020-07-09 10:40
 */

@Controller
@RequestMapping("/workbench/transaction")
public class TranController {
    @Autowired
    private TranService tranService;
    @Autowired
    private UserService userService;


    /**
     * =========================================index页面基本功能======================================================
     */


    /**
     * 跳转到交易首页
     * @author Aliera
     * @date 2020/7/9 12:38
     * @param
     * @return java.lang.String
     */
    @RequestMapping("/toTranIndex.do")
    public String toTranIndex() {
        return "/workbench/transaction/index";
    }

    /**
     * 携带用户列表转发到交易添加页面
     * @author Aliera
     * @date 2020/7/9 12:41
     * @param
     * @return java.lang.String
     */
    @RequestMapping("/toTranSave.do")
    public String toTranSave(Model model) {
        List<User> userList = userService.findAllUsers();
        model.addAttribute("userList",userList);
        return "/workbench/transaction/save";
    }

    /**
     * 通过条件查询分页显示
     * @author Aliera
     * @date 2020/7/10 12:28
     * @param paramsMap
     *     由前端发送的参数，包含
     *              "owner"
     * 				"tranName"
     * 				"customerName"
     * 				"stage"
     * 				"type"
     * 				"source"
     * 				"contactsName"
     * 				"pageNo"
     * 				"pageSize"
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    @RequestMapping("/findTranListForPageByCondition.do")
    @ResponseBody
    public Map<String, Object> findTranListForPageByCondition(@RequestParam Map<String, Object> paramsMap) {
        //参数转换
        int pageNo = Integer.parseInt((String)(paramsMap.get("pageNo")));
        int pageSize = Integer.parseInt((String)(paramsMap.get("pageSize")));
        paramsMap.put("pageNo",pageNo);
        paramsMap.put("pageSize",pageSize);
        paramsMap.put("beginNo",(pageNo-1)*pageSize);
        PaginationVO<Tran> pageVO = tranService.findTranListForPageByCondition(paramsMap);
        return HandleFlag.successObj("pageVO",pageVO);
    }

    /**
     * 转发到交易详细页面，携带交易参数
     * @author Aliera
     * @date 2020/7/10 14:40
     * @param model
     * @Param tranId
     * @return java.lang.String
     */
    @RequestMapping("/toTranDetail.do")
    public String toTranDetail(Model model, String tranId) {
        //查询交易
        Tran tran = tranService.findTranByTranId(tranId);
        Map<String, String> sMap = (Map<String, String>) ContextLoader.getCurrentWebApplicationContext().getServletContext().getAttribute("sMap");
        tran.setPossibility(sMap.get(tran.getStage()));
        model.addAttribute("tran",tran);
        return "/workbench/transaction/detail";
    }

    /**
     * 根据名字的关键字模糊搜索符合要求的全名
     * @author Aliera
     * @date 2020/7/9 14:23
     * @param name
     * @return java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/getCustomerNameAuto.do")
    @ResponseBody
    public List<String> getCustomerNameAuto(String name) {
        return tranService.getCustomerNameAuto(name);
    }


    /**
     * =========================================添加功能======================================================
     */

    /**
     * 通过活动名模糊查询市场活动列表
     * @author Aliera
     * @date 2020/7/9 16:09
     * @param queryName
     * @return java.util.Map<java.lang.String, java.lang.Object>
     */
    @RequestMapping("/queryActivityListLikeName.do")
    @ResponseBody
    public Map<String,Object> queryActivityListLikeName(String queryName) {
        Map<String, Object> resultMap = tranService.queryActivityListLikeName(queryName);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    @RequestMapping("/queryContactsListLikeName.do")
    @ResponseBody
    public Map<String,Object> queryContactsListLikeName(String queryName) {
        Map<String, Object> resultMap = tranService.queryContactsListLikeName(queryName);
        resultMap.putAll(HandleFlag.successTrue());
        return resultMap;
    }

    /**
     * 保存交易
     * @author Aliera
     * @date 2020/7/9 17:02
     * @param paramsMap
     * @return java.lang.String
     */
    @RequestMapping("/saveTran.do")
    public String saveTran(@RequestParam Map<String,String> paramsMap, HttpSession session) {
        User user = (User)(session.getAttribute("user"));
        //放入参数
        paramsMap.put("createBy",user.getName());
        paramsMap.put("createTime", DateTimeUtil.getSysTime());
        tranService.saveTran(paramsMap);
        return "redirect:/workbench/transaction/toTranIndex.do";
    }


    /**
     * =========================================详细页面功能======================================================
     */
}
