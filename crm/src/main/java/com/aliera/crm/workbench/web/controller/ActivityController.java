package com.aliera.crm.workbench.web.controller;

import com.aliera.crm.commons.constant.ActivityConstant;
import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.commons.utils.DateTimeUtil;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.vo.PaginationVO;
import com.aliera.crm.commons.utils.UUIDUtil;
import com.aliera.crm.workbench.domain.Activity;
import com.aliera.crm.workbench.domain.User;
import com.aliera.crm.workbench.service.ActivityRemarkService;
import com.aliera.crm.workbench.service.ActivityService;
import com.aliera.crm.workbench.service.UserService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

/**
 * @program: ProjectForCrm
 * @description: 市场活动控制器
 * @author: Aliera
 * @create: 2020-06-30 12:03
 */

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {
    @Autowired
    private ActivityService activityService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /*
     *description: 携带所有用户id和姓名转发到市场活动首页
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [model]
     *@return: java.lang.String
     */
    @RequestMapping("/toActivityIndex.do")
    public String toActivityIndex(Model model) {
        List<User> userList = userService.findAllUsers();
        model.addAttribute("userList",userList);
        return "/workbench/activity/index";
    }

    /*
     *description: 保存市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: []
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/saveActivity.do")
    @ResponseBody
    public Map<String, Object> saveActivity(Activity activity, HttpSession session) throws TraditionRequestException {
        User user = (User)session.getAttribute("user");
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(user.getName());
        activity.setCreateTime(DateTimeUtil.getSysTime());
        activityService.saveActivity(activity);

        return HandleFlag.successTrue();
    }

    @RequestMapping("/findActivityForPageByCondition.do")
    @ResponseBody
    public Map<String, Object> findActivityForPageByCondition(@RequestParam Map<String, Object> paramsMap) {
        Map<String, Object> resultMap = new HashMap<>();
        //转换数据类型
        int pageNo = Integer.parseInt(paramsMap.get("pageNo").toString());
        int pageSize = Integer.parseInt(paramsMap.get("pageSize").toString());
        int beginNo = (pageNo-1)*pageSize;
        paramsMap.put("beginNo",beginNo);
        paramsMap.put("pageSize",pageSize);
        paramsMap.put("pageNo",pageNo);
        //获取总字段数
        long totalRows = activityService.findCountOfActivityByCondition(paramsMap);
        //获取分页的信息
        List<Activity> activityList = activityService.findActivityForPageByCondition(paramsMap);
        //封装分页信息
        PaginationVO<Activity> paginationVO = new PaginationVO<>(totalRows,activityList);
        resultMap.put("success",true);
        resultMap.put("msg","成功");
        resultMap.put("pageVO",paginationVO);
        return resultMap;
    }

    /*
     *description: 删除市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [ids]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/deleteActivities.do")
    @ResponseBody
    public Map<String,Object> deleteActivities(String[] ids) throws TraditionRequestException {
        activityService.deleteActivitiesByIds(ids);
        activityRemarkService.deleteRemarkByActivityIds(ids);
        return HandleFlag.successTrue();
    }

    /*
     *description: 按id查找市场活动
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [id]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/findActivityById.do")
    @ResponseBody
    public Map<String,Object> findActivityById(String id) throws TraditionRequestException {
        Activity activity = activityService.findActivityById(id);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success",true);
        resultMap.put("updateActivity",activity);
        return resultMap;
    }

    /*
     *description: 修改市场活动
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [activity]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/updateActivity.do")
    @ResponseBody
    public Map<String,Object> updateActivity(Activity activity, HttpSession session) throws TraditionRequestException {
        User user = (User)(session.getAttribute("user"));
        //设置修改信息
        activity.setEditBy(user.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        activityService.updateActivity(activity);
        return HandleFlag.successTrue();
    }

    /*
     *description: 携带市场活动信息转发到详细信息页面
     *@Author: Aliera
     *@date: 2020/7/2
     *@param: [model, id]
     *@return: java.lang.String
     */
    @RequestMapping("/toDetailActivity.do")
    public String toDetailActivity(Model model, String id) throws TraditionRequestException {
        Activity activity = activityService.findActivityWithOwnerNameById(id);


        model.addAttribute("activity",activity);

        return "/workbench/activity/detail";
    }

    /*
     =========================市场活动导入导出功能（owner以id形式存取）===================================
     */

   /*
    *description: 把市场活动写入文件中并输出，封装功能，不提供外部调用接口
    *@Author: Aliera
    *@date: 2020/7/3
    *@param: [activityList, response, ownerAsId]
    *@return: void
    */
    private void activityOutput(List<Activity> activityList, HttpServletResponse response, boolean ownerAsId) throws IOException {

        //写入excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("ActivityList");
        HSSFRow row = sheet.createRow(0);

        //表头
        HSSFCell cell = row.createCell(ActivityConstant.ExportActivity.ID_NO);
        cell.setCellValue("编号");
        cell = row.createCell(ActivityConstant.ExportActivity.OWNER_NO);
        cell.setCellValue(ownerAsId?"所有者编号":"所有者");
        cell = row.createCell(ActivityConstant.ExportActivity.NAME_NO);
        cell.setCellValue("活动名");
        cell = row.createCell(ActivityConstant.ExportActivity.STARTDATE_NO);
        cell.setCellValue("开始日期");
        cell = row.createCell(ActivityConstant.ExportActivity.ENDDATE_NO);
        cell.setCellValue("结束日期");
        cell = row.createCell(ActivityConstant.ExportActivity.COST_NO);
        cell.setCellValue("成本");
        cell = row.createCell(ActivityConstant.ExportActivity.DESCRIPTION_NO);
        cell.setCellValue("描述");
        cell = row.createCell(ActivityConstant.ExportActivity.CREATETIME_NO);
        cell.setCellValue("创建时间");
        cell = row.createCell(ActivityConstant.ExportActivity.CREATEBY_NO);
        cell.setCellValue("创建者");
        cell = row.createCell(ActivityConstant.ExportActivity.EDITTIME_NO);
        cell.setCellValue("修改时间");
        cell = row.createCell(ActivityConstant.ExportActivity.EDITBY_NO);
        cell.setCellValue("修改者");
        
        //写入数据
        for(int i = 0; i < activityList.size(); i++) {
            row = sheet.createRow(i+1);
            Activity activity = activityList.get(i);
            for(int j = 0; j < ActivityConstant.ExportActivity.VAL_COUNT; j++) {
                if(j == ActivityConstant.ExportActivity.ID_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getId());
                } else if(j == ActivityConstant.ExportActivity.OWNER_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getOwner());
                } else if(j == ActivityConstant.ExportActivity.NAME_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getName());
                } else if(j == ActivityConstant.ExportActivity.STARTDATE_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getStartDate());
                } else if(j == ActivityConstant.ExportActivity.ENDDATE_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getEndDate());
                } else if(j == ActivityConstant.ExportActivity.COST_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getCost());
                } else if(j == ActivityConstant.ExportActivity.DESCRIPTION_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getDescription());
                } else if(j == ActivityConstant.ExportActivity.CREATETIME_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getCreateTime());
                } else if(j == ActivityConstant.ExportActivity.CREATEBY_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getCreateBy());
                } else if(j == ActivityConstant.ExportActivity.EDITTIME_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getEditTime());
                } else if(j == ActivityConstant.ExportActivity.EDITBY_NO) {
                    cell = row.createCell(j);
                    cell.setCellValue(activity.getEditBy());
                }
            }
        }
        String filename = "activity-"+DateTimeUtil.getSysTimeForUpload()+".xls";
        //设置响应
        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition","attachment;filename="+filename);
        //获得输出流
        OutputStream os = response.getOutputStream();
        //输出
        wb.write(os);
        //刷新流通道
        os.flush();
        //关闭文件
        wb.close();
    }

    /*
     *description: 以.xls的形式导出所有市场活动数据，所有者以id的形式保存
     *@Author: Aliera
     *@date: 2020/7/3
     *@param: [response]
     *@return: void
     */
    @RequestMapping("/ExportActivityAllActivity.do")
    public void ExportActivityAllActivity(HttpServletResponse response) throws IOException {
        //查询所有市场活动
        List<Activity> activityList = activityService.findAllActivity();


        //将市场活动录入工作簿
        activityOutput(activityList,response,true);

    }

    @RequestMapping("/ExportActivityActivitySelective.do")
    public void ExportActivityActivitySelective(String[] ids, HttpServletResponse response) throws IOException {
        System.out.println(Arrays.toString(ids));
        //查询选中的市场活动
        List<Activity> activityList = activityService.findActivityByIds(ids);
        System.out.println(activityList.size());
        for (Activity activity : activityList) {
            System.out.println(activity);
        }
        HSSFWorkbook wb = new HSSFWorkbook();
        activityOutput(activityList,response,true);
    }

    @RequestMapping("/importActivity.do")
    @ResponseBody
    public Map<String, Object> importActivity(@RequestParam("importFile") MultipartFile multipartFile, HttpSession session/*HttpServletRequest request*/) throws IOException {
        User user = (User)(session.getAttribute("user"));
        Map<String, Object> map = new HashMap<>();

        //方法1：将文件临时保存
/*        String path = request.getServletContext().getRealPath("/upload");
        String fileName = DateTimeUtil.getSysTimeForUpload()+".xls";
        File file = new File(path);
        file.mkdirs();
        multipartFile.transferTo(new File(path+"/"+fileName));
        */
        //InputStream is = new FileInputStream(path+"/"+fileName);

        //方法2：直接获取inputStream对象
        InputStream is = multipartFile.getInputStream();
        //读取导入数据
        List<Activity> activityList = new ArrayList<>();
        HSSFWorkbook wb = new HSSFWorkbook(is);
        HSSFSheet sheet = wb.getSheetAt(0);
        HSSFRow row = null;
        HSSFCell cell = null;
        int countActivity = sheet.getLastRowNum();
        for(int i = 1; i <= countActivity; i++) {
            //创建市场活动并添加参数
            Activity activity = new Activity();
            activity.setId(UUIDUtil.getUUID());
            activity.setOwner(user.getId());
            activity.setCreateTime(DateTimeUtil.getSysTime());
            activity.setCreateBy(user.getName());

            row = sheet.getRow(i);

            for(int j = 0; j < row.getLastCellNum(); j++) {
                cell = row.getCell(j);
                if(j == ActivityConstant.ImportActivity.NAME_NO) {
                    activity.setName(cell.getStringCellValue());
                } else if(j == ActivityConstant.ImportActivity.STARTDATE_NO) {
                    activity.setStartDate(cell.getStringCellValue());
                } else if(j == ActivityConstant.ImportActivity.ENDDATE_NO) {
                    activity.setEndDate(cell.getStringCellValue());
                } else if(j == ActivityConstant.ImportActivity.COST_NO) {
                    activity.setCost(cell.getStringCellValue());
                } else if(j == ActivityConstant.ImportActivity.DESCRIPTION_NO) {
                    activity.setDescription(cell.getStringCellValue());
                }
            }
            activityList.add(activity);
        }

        activityService.saveImportActivity(activityList);

        map.put("countActivity",countActivity);
        map.putAll(HandleFlag.successTrue());
        return map;
    }

}
