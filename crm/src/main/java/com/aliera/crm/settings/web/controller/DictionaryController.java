package com.aliera.crm.settings.web.controller;

import com.aliera.crm.exception.TraditionRequestException;
import com.aliera.crm.settings.domain.DictionaryType;
import com.aliera.crm.settings.domain.DictionaryValue;
import com.aliera.crm.settings.service.DictionaryTypeService;
import com.aliera.crm.settings.service.DictionaryValueService;
import com.aliera.crm.commons.utils.HandleFlag;
import com.aliera.crm.web.listener.SysInitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @program: ProjectForCrm
 * @description: 数据字典控制器
 * @author: Aliera
 * @create: 2020-06-27 20:56
 */

@Controller
@RequestMapping("/settings/dictionary")
public class DictionaryController {

    @Autowired
    private DictionaryTypeService dictionaryTypeService;
    @Autowired
    private DictionaryValueService dictionaryValueService;
    @Autowired
    private SysInitListener sysInitListener;


    /*
     *description: 转发到/dictionary/index.jsp的控制器
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/toIndex.do")
    public String toIndex() {
        return "/settings/dictionary/index";
    }

    /*
     *description: 查询所有数据字典类型信息并转发到/type/index.jsp的控制器
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/type/toTypeIndex.do")
    public ModelAndView toTypeIndex() {

        ModelAndView mv = new ModelAndView("/settings/dictionary/type/index");
        List<DictionaryType> dicType = dictionaryTypeService.findAllDictionaryType();
        mv.addObject("dictionaryType",dicType);
        return mv;
    }



    /*
     *description: 转发到/type/edit.jsp的控制器
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/type/toTypeEdit.do")
    public String toTypeEdit() {
        return "/settings/dictionary/type/edit";
    }



    /*
     *description: 转发到/type/save.jsp的控制器
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/type/toTypeSave.do")
    public String toTypeSave() {
        return "/settings/dictionary/type/save";
    }



    /*
     *description: 查找数据字典全部类型的控制器，已被toTypeIndex替代，不使用
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: org.springframework.web.servlet.ModelAndView
     */
    @RequestMapping("/type/findAllDictionaryType.do")
    public ModelAndView findAllDictionaryType() {
        ModelAndView mv = new ModelAndView("/settings/dictionary/type/index");
        List<DictionaryType> dicType = dictionaryTypeService.findAllDictionaryType();
        mv.addObject("dictionaryType",dicType);
        return mv;
    }

    /*
     *description: 检验新增编码值是否重复
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/type/checkTypeCode.do")
    @ResponseBody
    public Map<String,Object> checkTypeCode(String code) {
        Map<String,Object> map = null;
        //编码值为空
        if(code == null || "".equals(code)) {
            map = new HashMap<>();
            map.put("success",false);
            map.put("msg","编码值不能为空！");
            return map;
        }
        //校验编码值
        boolean codeCheck = dictionaryTypeService.checkTypeCode(code);

        //编码值重复
        if(!codeCheck) {
            map = new HashMap<>();
            map.put("success",false);
            map.put("msg","编码值不能重复！");
        } else {
            //编码值检验通过
            map = HandleFlag.successTrue();
        }
        return map;
    }

    /*
     *description: 新增字典类型值
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/type/saveDictionaryType.do")
    public String saveDictionaryType(DictionaryType dictionaryType) throws TraditionRequestException {
        System.out.println(dictionaryType.getCode() + " " + dictionaryType.getName() + " " + dictionaryType.getDescription());
        //新增字典值
        dictionaryTypeService.saveDictionaryType(dictionaryType);
        ServletContext servletContext = ContextLoader.getCurrentWebApplicationContext().getServletContext();
        sysInitListener.refreshApplicationAttribute(servletContext);
        return "redirect:/settings/dictionary/type/toTypeIndex.do";
    }

    /*
     *description: 修改字典类型值
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [dictionaryType]
     *@return: java.lang.String
     */
    @RequestMapping("/type/updateDictionaryType.do")
    public String updateDictionaryType(DictionaryType dictionaryType, HttpServletRequest request) throws TraditionRequestException {
        dictionaryTypeService.updateDictionaryType(dictionaryType);
        sysInitListener.refreshApplicationAttribute(request.getServletContext());
        return "redirect:/settings/dictionary/type/toTypeIndex.do";
    }

    /*
     *description: 通过编码值搜索待修改的类型记录
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [code]
     *@return: org.springframework.web.servlet.ModelAndView
     */
    @RequestMapping("type/findDictionaryTypeByCode.do")
    public ModelAndView findDictionaryTypeByCode(String code) {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/settings/dictionary/type/edit");
        DictionaryType dictionaryType = dictionaryTypeService.findDictionaryTypeByCode(code);
        mv.addObject("dictionaryType",dictionaryType);
        return mv;
    }

    /*
     *description: 删除记录
     *@Author: Aliera
     *@date: 2020/6/29
     *@param: [request, response]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/type/deleteDictionaryType.do")
    @ResponseBody
    public Map<String, Object> deleteDictionaryType(String[] codes) throws TraditionRequestException {
        Map<String,Object> map = null;
        //String[] codes = request.getParameterValues("codes");
        System.out.println(Arrays.toString(codes));
        dictionaryTypeService.deleteDictionaryType(codes);

        return HandleFlag.successTrue();
    }

    /*
     ====================================================================================================
     type和value的功能分界线
     ====================================================================================================
     */

    /*
     *description: 转发到字典值保存页面，携带数据库中所有字典类型的编码值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: org.springframework.web.servlet.ModelAndView
     */
    @RequestMapping("/value/toValueSave.do")
    public ModelAndView toValueSave() {
        ModelAndView mv = new ModelAndView("/settings/dictionary/value/save");
        List<String> codes = dictionaryTypeService.findAllDictionaryTypeCode();
        System.out.println(codes);
        mv.addObject("typeCodes",codes);
        return mv;
    }

    /*
     *description: 检查新增字典值是否可以存入，返回值success为true时表示可以存入，返回值为false时表示已有同名数据
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [map]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/value/checkValueForSaving.do")
    @ResponseBody
    public Map<String, Object> checkValueForSaving(@RequestParam Map<String,String> paramsMap) {
        Map<String,Object> map = null;
        DictionaryValue dictionaryValue = dictionaryValueService.findDictionaryValueByValue(paramsMap);
        if(dictionaryValue == null) {
            return HandleFlag.successTrue();
        }
        map = new HashMap<>();
        map.put("success",false);
        map.put("msg","同名数据已经存在");
        return map;
    }

    /*
     *description: 检查字典值修改是否满足修改条件
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [paramsMap]
     *@return: java.util.Map<java.lang.String,java.lang.Object>
     */
    @RequestMapping("/value/checkValueForUpdate.do")
    @ResponseBody
    public Map<String,Object> checkValueForUpdate(@RequestParam Map<String,String> paramsMap) {
        DictionaryValue dictionaryValue = dictionaryValueService.findDictionaryValueByValue(paramsMap);
        //当没有查询到记录或查询到的记录id与当前待修改的id相同时，可以修改
        if(dictionaryValue == null || dictionaryValue.getId().equals(paramsMap.get("id"))) {
            return HandleFlag.successTrue();
        }
        Map<String,Object> map = new HashMap<>();
        map.put("success",false);
        map.put("msg","同名数据已经存在");
        return map;
    }


    @RequestMapping("/value/saveDictionaryValue.do")
    public String saveDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException {
        System.out.println(dictionaryValue.getTypeCode()+" "+dictionaryValue.getValue());
        dictionaryValueService.saveDictionaryValue(dictionaryValue);
        return "redirect:/settings/dictionary/value/toValueIndex.do";
    }

    /*
     *description: 转发到字典值首页的控制器，查询并携带当前数据库中所有字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: []
     *@return: org.springframework.web.servlet.ModelAndView
     */
    @RequestMapping("/value/toValueIndex.do")
    public ModelAndView toValueIndex() {
        ModelAndView mv = new ModelAndView("/settings/dictionary/value/index");

        //TODO: 查询所有字典值
        List<DictionaryValue> dicValue = dictionaryValueService.findAllDictionaryValue();
        mv.addObject("dictionaryValue",dicValue);

        return mv;
    }

    /*
     *description: 通过id查询待修改字典值信息，转发到修改页面
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [model]
     *@return: java.lang.String
     */
    @RequestMapping("/value/toDictionaryValueEdit.do")
    public String toDictionaryValueEdit(Model model, String id) {
        System.out.println(id);
        DictionaryValue dictionaryValue = dictionaryValueService.findDictionaryValueById(id);
        model.addAttribute("dictionaryValue",dictionaryValue);
        return "/settings/dictionary/value/edit";
    }

    /*
     *description: 修改字典值
     *@Author: Aliera
     *@date: 2020/6/30
     *@param: [dictionaryValue]
     *@return: java.lang.String
     */
    @RequestMapping("/value/updateDictionaryValue.do")
    public String updateDictionaryValue(DictionaryValue dictionaryValue) throws TraditionRequestException {
        System.out.println(dictionaryValue);
        dictionaryValueService.updateDictionaryValue(dictionaryValue);
        return "redirect:/settings/dictionary/value/toValueIndex.do";
    }

    /*
     *description: 删除字典值
     *@Author: Aliera
     *@date: 2020/7/1
     *@param: [ids]
     *@return: java.lang.String
     */
    @RequestMapping("/value/deleteDictionaryValue.do")
    public String deleteDictionaryValue(String[] ids) throws TraditionRequestException {
        System.out.println(Arrays.toString(ids));
        dictionaryValueService.deleteDictionaryValue(ids);
        return "redirect:/settings/dictionary/value/toValueIndex.do";
    }

}
