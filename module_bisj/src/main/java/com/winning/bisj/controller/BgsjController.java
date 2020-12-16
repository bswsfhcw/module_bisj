package com.winning.bisj.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.winning.bisj.service.BgsjService;
import com.winning.common.entitys.system.LoginUser;
import com.winning.common.exception.BaseException;
import com.winning.common.systemlog.SystemLogAfterController;
import com.winning.common.utils.DateUtil;
import com.winning.common.utils.MessageStreamResult;
import com.winning.common.utils.ShiroUtils;
import com.winning.common.web.annotator.RequestMap;
import com.winning.common.web.controller.AbstractController;
import com.winning.common.web.entity.MapAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/***
 * @Description: 
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/11/16
 */
@Controller
@RequestMapping("/bgsj")
public class BgsjController extends AbstractController {

    @Autowired
    @Qualifier("bgsjService")
    private BgsjService bgsjService;

    @RequestMapping(value = "initBg")
    @SystemLogAfterController(description = "表格设计主页面",czmk = "报表设计")
    public ModelAndView init(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        initMap(mapAdapter);
        return new ModelAndView("jsp/bisj/bg/bgInit",mapAdapter.getMap());
    }
    @ResponseBody
    @RequestMapping(value = "/queryBgList" , method = RequestMethod.POST)
    @SystemLogAfterController(description = "查询考核汇总表的方案",czmk = "绩效报表")
    public List<Map<String,Object>> queryBgList(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception {
        initMap(mapAdapter);
        return bgsjService.queryBgList(mapAdapter.getMap());
    }
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "getAllBtl")
    @SystemLogAfterController(description = "表头列表查询",czmk = "报表设计")
    public void getAllBtl(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        initMap(mapAdapter);
        response.setContentType("text/html;charset=UTF-8");
        List<Map<String,Object>> getAllNodes=bgsjService.getAllBtl(mapAdapter.getMap());
        JSONArray jsonArray=JSONArray.parseArray(JSON.toJSONString(getAllNodes));
        PrintWriter out=response.getWriter();
        out.print(jsonArray);
        out.close();
    }

    @RequestMapping(value = "editBtlInit")
    @SystemLogAfterController(description = "表头修改页面",czmk = "报表设计")
    public ModelAndView editBtl(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)throws Exception {
        initMap(mapAdapter);
        bgsjService.editBtlInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/bg/editBtl", mapAdapter.getMap());
    }

    @RequestMapping(value = "editBtlInfo")
    @SystemLogAfterController(description = "表头保存",czmk = "报表设计")
    public void saveBtl(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)throws Exception {
        try {
            MessageStreamResult.msgStreamResult(response,bgsjService.editBtlInfo(mapAdapter.getMap()));
        } catch (BaseException e) {
            MessageStreamResult.msgStreamResult(response, e.getExcpMsgStr());
        } catch (Exception e) {
            MessageStreamResult.msgStreamResult(response, "3");
        }
    }
    @RequestMapping(value = "getBtlById")
    public void getNodeByCddm(@RequestMap MapAdapter map, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        response.setContentType("text/html;charset=UTF-8");
        bgsjService.editBtlInit(map.getMap());
        JSONArray jsonArray=JSONArray.parseArray(JSON.toJSONString(map.getMap().get("btlInfo")));
        PrintWriter out=response.getWriter();
        out.print(jsonArray);
        out.close();
    }
    @RequestMapping(value = "/actionBtl",method = RequestMethod.POST)
    @SystemLogAfterController(description = "操作表头列",czmk = "报表设计")
    public void actionBtl(@RequestMap MapAdapter mapAdapter,  HttpServletRequest request, HttpServletResponse response) throws Exception{
        MessageStreamResult.msgStreamResult(response, bgsjService.actionBtl(mapAdapter.getMap()));
    }

    @RequestMapping(value = "getBsjBg")
    public ModelAndView getBsjBg(@RequestMap(requiredSelectOptions = true) MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response)  throws Exception{
        initMap(mapAdapter);
        List<Map> list = bgsjService.getBsjBg(mapAdapter.getMap());
        mapAdapter.getMap().put("list", list);
        return new ModelAndView("main/bisj/bg/bsjList", mapAdapter.getMap());
    }
    @RequestMapping(value = "editBsjInit")
    @SystemLogAfterController(description = "初始化修改查询控件页面",czmk = "报表设计")
    public ModelAndView editBsjInit(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        bgsjService.editBsjInit(mapAdapter.getMap());
        return new ModelAndView("main/bisj/bg/editBsjInit",mapAdapter.getMap());
    }
    @RequestMapping(value = "editBsjInfo" ,method = RequestMethod.POST)
    @SystemLogAfterController(description = "修改查询控件信息",czmk = "报表设计")
    public void editBsjInfo(@RequestMap MapAdapter mapAdapter, HttpServletRequest request, HttpServletResponse response) throws Exception{
        try {
            msgStreamResult(response,bgsjService.editBsjInfo(mapAdapter.getMap()));
        }catch (Exception e){
            msgStreamResult(response,"error");
        }
    }
    @RequestMapping(value = "/actionBsj",method = RequestMethod.POST)
    @SystemLogAfterController(description = "操作控件",czmk = "报表设计")
    public void actionBsj(@RequestMap MapAdapter mapAdapter,  HttpServletRequest request, HttpServletResponse response) throws Exception{
        MessageStreamResult.msgStreamResult(response, bgsjService.actionBsj(mapAdapter.getMap()));
    }
    private void initMap(MapAdapter mapAdapter) {
        LoginUser user = ShiroUtils.getLoginUser();
        mapAdapter.getMap().put("jgbm",user.getJgbm());
        mapAdapter.getMap().put("zclsh",user.getId());
        mapAdapter.getMap().put("fzrbz",user.getFzrbz());
        mapAdapter.getMap().put("ksbm",user.getKsbm());
    }
}
