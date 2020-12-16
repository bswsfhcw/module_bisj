package com.winning.bisj.controller;

import com.winning.bisj.service.BisjService;
import com.winning.common.constant.Constants;
import com.winning.common.entitys.project.LoginInfo;
import com.winning.common.entitys.system.LoginUser;
import com.winning.common.page.PageVariable;
import com.winning.common.service.CommonService;
import com.winning.common.systemlog.SystemLogAfterController;
import com.winning.common.utils.MessageStreamResult;
import com.winning.common.utils.ShiroUtils;
import com.winning.common.web.annotator.RequestMap;
import com.winning.common.web.controller.AbstractController;
import com.winning.common.web.entity.MapAdapter;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
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
@RequestMapping("/bisj")
public class BisjController extends AbstractController {


    @Autowired
    private BisjService bisjService;

    @Autowired
    private CommonService commonService;

    @RequestMapping(value = "initYm",method = RequestMethod.GET)
    @SystemLogAfterController(description = "页面初始化",czmk = "报表设计")
    public ModelAndView initYm(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        logger.info("BisjController init");
        initMap(mapAdapter);
        return new ModelAndView("jsp/bisj/bisjInitYm",mapAdapter.getMap());
    }
    @RequestMapping(value = "getYm")
    public ModelAndView getYm(@RequestMap(requiredSelectOptions = true) MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)  throws Exception{
        initMap(mapAdapter);
        List<Map> list = bisjService.getYm(mapAdapter.getMap());
        mapAdapter.getMap().put("list", list);
        return new ModelAndView("main/bisj/ymList", mapAdapter.getMap());
    }
    @RequestMapping(value = "editYmInit")
    @SystemLogAfterController(description = "初始化修改页面",czmk = "报表设计")
    public ModelAndView editYmInit(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        bisjService.editYmInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/editYmInit",mapAdapter.getMap());
    }
    @RequestMapping(value = "editYmInfo" ,method = RequestMethod.POST)
    @SystemLogAfterController(description = "修改页面信息",czmk = "报表设计")
    public void editYmInfo(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        try {
            msgStreamResult(response,bisjService.editYmInfo(mapAdapter.getMap()));
        }catch (Exception e){
            msgStreamResult(response,"error");
        }
    }
    @RequestMapping(value = "/actionYm",method = RequestMethod.POST)
    @SystemLogAfterController(description = "操作页面",czmk = "报表设计")
    public void actionYm(@RequestMap MapAdapter mapAdapter,  HttpServletRequest request, HttpServletResponse response) throws Exception{
        MessageStreamResult.msgStreamResult(response, bisjService.actionYm(mapAdapter.getMap()));
    }
    @RequestMapping(value = "getCxkjYm")
    public ModelAndView getCxkjYm(@RequestMap(requiredSelectOptions = true) MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)  throws Exception{
        initMap(mapAdapter);
        List<Map> list = bisjService.getCxkjYm(mapAdapter.getMap());
        mapAdapter.getMap().put("list", list);
        return new ModelAndView("main/bisj/cxkjList", mapAdapter.getMap());
    }
    @RequestMapping(value = "editCxkjInit")
    @SystemLogAfterController(description = "初始化修改查询控件页面",czmk = "报表设计")
    public ModelAndView editCxkjInit(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        bisjService.editCxkjInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/editCxkjInit",mapAdapter.getMap());
    }
    @RequestMapping(value = "sjyYlInit")
    @SystemLogAfterController(description = "初始数据源预览页面",czmk = "报表设计")
    public ModelAndView sjyYlInit(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        bisjService.sjyYlInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/sjyYlInit",mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/sjyYl" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "数据源预览",czmk = "报表设计")
    public Map<String,Object> sjyYl(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return bisjService.sjyYl(mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/sjyYz" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "数据源验证",czmk = "报表设计")
    public Map<String,Object> sjyYz(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return bisjService.sjyYz(mapAdapter.getMap());
    }
    @RequestMapping(value = "editCxkjInfo" ,method = RequestMethod.POST)
    @SystemLogAfterController(description = "修改查询控件信息",czmk = "报表设计")
    public void editCxkjInfo(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        try {
            msgStreamResult(response,bisjService.editCxkjInfo(mapAdapter.getMap()));
        }catch (Exception e){
            msgStreamResult(response,"error");
        }
    }
    @RequestMapping(value = "/actionCxkj",method = RequestMethod.POST)
    @SystemLogAfterController(description = "操作控件",czmk = "报表设计")
    public void actionCxkj(@RequestMap MapAdapter mapAdapter,  HttpServletRequest request, HttpServletResponse response) throws Exception{
        MessageStreamResult.msgStreamResult(response, bisjService.actionCxkj(mapAdapter.getMap()));
    }
    @RequestMapping(value = "getBgYm")
    public ModelAndView getBgYm(@RequestMap(requiredSelectOptions = true) MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)  throws Exception{
        initMap(mapAdapter);
        List<Map> list = bisjService.getBgYm(mapAdapter.getMap());
        mapAdapter.getMap().put("list", list);
        return new ModelAndView("main/bisj/bgList", mapAdapter.getMap());
    }
    @RequestMapping(value = "editBgInit")
    @SystemLogAfterController(description = "初始化修改表格页面",czmk = "报表设计")
    public ModelAndView editBgInit(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        bisjService.editBgInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/bg/editBgInit",mapAdapter.getMap());
    }
    @RequestMapping(value = "editBgInfo" ,method = RequestMethod.POST)
    @SystemLogAfterController(description = "修改表格信息",czmk = "报表设计")
    public void editBgInfo(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        try {
            msgStreamResult(response,bisjService.editBgInfo(mapAdapter.getMap()));
        }catch (Exception e){
            msgStreamResult(response,"error");
        }
    }
    @RequestMapping(value = "/actionBg",method = RequestMethod.POST)
    @SystemLogAfterController(description = "操作表格",czmk = "报表设计")
    public void actionBg(@RequestMap MapAdapter mapAdapter,  HttpServletRequest request, HttpServletResponse response) throws Exception{
        MessageStreamResult.msgStreamResult(response, bisjService.actionBg(mapAdapter.getMap()));
    }
    @RequestMapping(value = "ymsj",method = RequestMethod.GET)
    @SystemLogAfterController(description = "页面设计",czmk = "报表设计")
    public ModelAndView ymsj(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        logger.info("BisjController init");
        initMap(mapAdapter);
        return new ModelAndView("jsp/bisj/ymsj",mapAdapter.getMap());
    }
    private void initMap(MapAdapter mapAdapter) {
        LoginUser user = ShiroUtils.getLoginUser();
        mapAdapter.getMap().put("jgbm",user.getJgbm());
        mapAdapter.getMap().put("zclsh",user.getId());
        mapAdapter.getMap().put("fzrbz",user.getFzrbz());
        mapAdapter.getMap().put("ksbm",user.getKsbm());
    }
}
