package com.aliera.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @program: ProjectForCrm
 * @description:
 * @author: Aliera
 * @create: 2020-06-27 20:42
 */

@Controller
@RequestMapping("/settings")
public class IndexController {

    /*
     *description:
     *@Author: Aliera
     *@date: 2020/6/27
     *@param: []
     *@return: java.lang.String
     */
    @RequestMapping("/toIndex.do")
    public String toIndex() {
        return "/settings/index";
    }
}
