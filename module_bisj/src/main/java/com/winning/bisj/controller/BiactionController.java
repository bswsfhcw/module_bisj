package com.winning.bisj.controller;

import com.winning.bisj.service.BiactionService;
import com.winning.common.entitys.system.LoginUser;
import com.winning.common.systemlog.SystemLogAfterController;
import com.winning.common.utils.ShiroUtils;
import com.winning.common.web.annotator.RequestMap;
import com.winning.common.web.controller.AbstractController;
import com.winning.common.web.entity.MapAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/***
 * @Description: 
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/9/16
 */
@Controller
@RequestMapping("/biaction")
public class BiactionController extends AbstractController {


    @Autowired
    private BiactionService biactionService;

    @RequestMapping(value = "init",method = RequestMethod.GET)
    @SystemLogAfterController(description = "页面初始化",czmk = "报表设计")
    public ModelAndView init(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        logger.info("BisjController init");
        initMap(mapAdapter);
        return new ModelAndView("jsp/biaction/biactionInit",mapAdapter.getMap());
    }



    @ResponseBody
    @RequestMapping(value = "/queryBgList" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "查询表格",czmk = "报表设计")
    public List<Map<String,Object>> queryBgList(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return biactionService.queryBgList(mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/queryCxtjList" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "查询条件",czmk = "报表设计")
    public List<Map<String,Object>> queryCxtjList(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return biactionService.queryCxtjList(mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/change" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "联动取数",czmk = "报表设计")
    public Map<String,Object> change(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return biactionService.change(mapAdapter.getMap());
    }

    @ResponseBody
    @RequestMapping(value = "/getColums" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "查询表头",czmk = "报表设计")
    public List< List<Map<String, Object>>> getColums(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return biactionService.getColums(mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/bgData" , method = RequestMethod.GET)
    @SystemLogAfterController(description = "查询数据",czmk = "报表设计")
    public List<Map<String,Object>> bgData(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return biactionService.bgData(mapAdapter.getMap());
    }
    @RequestMapping(value = {"/addEditBiInit"})
    public String addEditZbInit(@RequestMap(requiredSelectOptions = true) MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "main/layoutit-gh-pages/index";
    }

    private void initMap(MapAdapter mapAdapter) {
        LoginUser user = ShiroUtils.getLoginUser();
        mapAdapter.getMap().put("jgbm",user.getJgbm());
        mapAdapter.getMap().put("zclsh",user.getId());
        mapAdapter.getMap().put("fzrbz",user.getFzrbz());
        mapAdapter.getMap().put("ksbm",user.getKsbm());
    }
}
