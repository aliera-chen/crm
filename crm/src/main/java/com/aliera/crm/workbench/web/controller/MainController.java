package com.aliera.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @program: ProjectForCrm
 * @description: 用于处理并转发main/index.jsp的控制器
 * @author: Aliera
 * @create: 2020-06-27 19:28
 */
@Controller
@RequestMapping("/workbench/main")
public class MainController {
    @RequestMapping("/toMainIndex.do")
    public String toMainIndex() {
        return "/workbench/main/index";
    }
}
