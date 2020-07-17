package com.aliera.crm.web.listener;

import com.aliera.crm.settings.domain.DictionaryType;
import com.aliera.crm.settings.domain.DictionaryValue;
import com.aliera.crm.settings.service.DictionaryTypeService;
import com.aliera.crm.settings.service.DictionaryValueService;
import org.springframework.context.annotation.Bean;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * @program: ProjectForCrm
 * @description: 系统初始化监听器
 * @author: Aliera
 * @create: 2020-07-03 20:54
 */

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=====================监听器启动=========================");
        ServletContext application = sce.getServletContext();

        refreshApplicationAttribute(application);
        saveStagePosibility(application);

    }


    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }

    /*
     *description: 刷新缓存
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: [application]
     *@return: void
     */
    public void refreshApplicationAttribute(ServletContext application) {
        DictionaryValueService dictionaryValueService =
                WebApplicationContextUtils.getWebApplicationContext(application).getBean(DictionaryValueService.class);
        DictionaryTypeService dictionaryTypeService =
                WebApplicationContextUtils.getWebApplicationContext(application).getBean(DictionaryTypeService.class);

        //获得所有字典类型值
        List<DictionaryType> dictionaryTypeList = dictionaryTypeService.findAllDictionaryType();

        //通过字典类型获得所有字典值
        for (DictionaryType dictionaryType : dictionaryTypeList) {
            List<DictionaryValue> dictionaryValueList = dictionaryValueService.findDictionaryValueByTypeCode(dictionaryType.getCode());
            application.setAttribute(dictionaryType.getCode()+"List",dictionaryValueList);
        }
    }

    /*
     *description: 删除缓存
     *@Author: Aliera
     *@date: 2020/7/4
     *@param: [application, code]
     *@return: void
     */
    public void deleteApplicationAttribute(ServletContext application, String[] codes) {
        for (String code : codes) {
            application.removeAttribute(code+"List");
        }
    }

    /**
     * 保存阶段和可能性的映射表
     * @author Aliera
     * @date 2020/7/10 15:03
     * @param application
     * @return void
     */
    public void saveStagePosibility(ServletContext application) {
        String url = "properties/stagePosibility";
        ResourceBundle bundle = ResourceBundle.getBundle(url);
        Map<String,String> stagePosibilityMap = new HashMap<>();
        for (String key : bundle.keySet()) {
            stagePosibilityMap.put(key,(String)(bundle.getObject(key)));
           // System.out.println(key+" "+stagePosibilityMap.get(key));
        }
        //System.out.println(stagePosibilityMap);
        application.setAttribute("sMap",stagePosibilityMap);
    }
}
