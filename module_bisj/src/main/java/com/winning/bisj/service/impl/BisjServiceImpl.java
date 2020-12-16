package com.winning.bisj.service.impl;

import com.winning.bisj.service.BisjService;
import com.winning.common.core.dao.ibatis.BaseDaoAware;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/***
 * @Description:
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/9/16
 */
@Service
public class BisjServiceImpl implements BisjService {

    private static Log logger = LogFactory.getLog(BisjServiceImpl.class);
    HashMap<String, List<Map<String, Object>>> cmap = new HashMap<>();
    @Autowired
    @Qualifier("baseDao")
    private BaseDaoAware baseDao;

    @Resource
    private JdbcTemplate jdbcTemplate;
    @Override
    public List<Map> getYm(Map<String, Object> map) {
        List<Map> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Bisj.getYm",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  bsjs;
    }


    @Override
    public List<Map> getBgYm(Map<String, Object> map) {
        List<Map> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Bisj.getBgYm",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  bsjs;
    }
    @Override
    public void editYmInit(Map<String, Object> map) {
        String type = (String)map.get("type");
        List<Map> ymmblist = null;//所有模板
        try {
            map.put("lx","0");
            ymmblist = baseDao.queryForList("Bisj.getYm",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Map ym =  new HashMap();
        try {
            if(!"add".equalsIgnoreCase(type)){
                ym = baseDao.queryForObj("Bisj.getYmByid",map);
            }else{
                ym.put("mc",CollectionUtils.isNotEmpty(ymmblist)?ymmblist.get(0).get("mc")+"-新":"新页面");
                ym.put("lx","1");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("ymmblist",ymmblist);
        map.put("ymInfo",ym);
        return  ;
    }

    @Override
    public String editYmInfo(Map<String, Object> map) {
        String type = (String)map.get("type");
        String result ="success";
        try {
            if(!"add".equalsIgnoreCase(type)){
                baseDao.updateObj("Bisj.updateYm",map);
            }else {//从模板初始化
                //1、新增页面，得到新页面id:id_ym_new
                baseDao.insertObj("Bisj.insertYm",map);
                //2、复制模板的查询控件
                baseDao.insertObj("Bisj.copyCkj",map);
                //3、复制模板表格，因为表格下有 表头列和数据源配置，需要逐个复制
                List<Map> bgs = baseDao.queryForList("Bisj.getBgYmmb",map);
                for (int i = 0; i < bgs.size(); i++) {
                    Map  bg = bgs.get(i);
                    //3.1、新增表格，得到新表格id:id_bg_new
                    map.put("id_bg_mb",bg.get("id"));
                    buildInt(map);//
                    baseDao.insertObj("Bisj.copyBg",map);
                    //3.2、复制表格数据
                    baseDao.insertObj("Bisj.copyBsj",map);
                    //3.3、复制表格表头列，因为有上下级表头，递归处理
                    List<Map<String, Object>> bt_yj = cmap.get("btjb_1");//一级表头
                    map.put("btjbMax", 1);
                    if ( CollectionUtils.isNotEmpty(bt_yj)) {
                        copyBtl(map, null, bt_yj);//没有上级
                    }
                }

            }
        } catch (Exception e) {
            result = "error";
            e.printStackTrace();
        }
        return result;
    }
    private void copyBtl(Map<String, Object> map, Map<String, Object> clsj, List<Map<String, Object>> cls) throws Exception {
        int id_cl;
        for (int i = 0; i < cls.size(); i++) {
            Map<String, Object> cl = cls.get(i);
            id_cl = (Integer) cl.get("id");
            cl.put("id_bg_new",map.get("id_bg_new"));
            cl.put("id_btl_mb",id_cl);
            cl.put("id_btl_sj_new",0);
            if(clsj!=null){//主要是是处理新的btl的上级id
                cl.put("id_btl_sj_new",clsj.get("id_btl_new"));
            }
            baseDao.insertObj("Bisj.copyBtl",cl);
            List<Map<String, Object>> xjcl = cmap.get("xjcl_" + id_cl);//是否有下级扩展
            if ( CollectionUtils.isNotEmpty(xjcl)) {
                copyBtl(map,  cl, xjcl);
            }
        }
    }
    //获取当前表格的btl
    private void buildInt(Map<String, Object> map) {
        cmap.clear();
        List<LinkedHashMap<String, Object>> btl = null;
        try {
            btl = baseDao.queryForList("Bisj.hqBtlBgmb", map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int btjb;
        int id_sjcl;
        for (int i = 0; i < btl.size(); i++) {
            Map<String, Object> cl = btl.get(i);
            btjb = (Integer) cl.get("btjb");
            id_sjcl = cl.get("id_sjcl") == null ? -1 : (Integer) cl.get("id_sjcl");
            List<Map<String, Object>> bt = cmap.get("btjb_" + btjb);
            if (bt == null) {
                bt = new ArrayList<Map<String, Object>>();
                cmap.put("btjb_" + btjb, bt);
            }
            bt.add(cl);
            if (id_sjcl != -1) {
                List<Map<String, Object>> xjcl = cmap.get("xjcl_" + id_sjcl);
                if (xjcl == null) {
                    xjcl = new ArrayList<Map<String, Object>>();
                    cmap.put("xjcl_" + id_sjcl, xjcl);
                }
                xjcl.add(cl);
            }
        }
    }
    @Override
    public String actionYm(Map<String, Object> map) {
        String result="success";
        String type=(String)map.get("type");
        try {
            if("del".equalsIgnoreCase(type)){
                baseDao.deleteObj("Bisj.delYm",map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }
    @Override
    public void editBgInit(Map<String, Object> map) {
        String type = (String)map.get("type");
        List<Map> bgmblist = null;//所有表格模板
        try {
            bgmblist = baseDao.queryForList("Bisj.getBgYm",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Map bg =  new HashMap();
        try {
            if(!"add".equalsIgnoreCase(type)){
                bg = baseDao.queryForObj("Bisj.getBgByid",map);
            }else{
                bg.put("mc","新表格");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("bgmblist",bgmblist);
        map.put("bgInfo",bg);
        return  ;
    }
    @Override
    public String editBgInfo(Map<String, Object> map) {
        String type = (String)map.get("type");
        String result ="success";
        try {
            if(!"add".equalsIgnoreCase(type)){
                baseDao.updateObj("Bisj.updateBg",map);
            }else {//从模板初始化
                map.put("id_ym_new",map.get("id_ym"));//因为是复用页面初始化逻辑 这里不是新页面
                baseDao.insertObj("Bisj.copyBg",map);//得到id_ym_new
                buildInt(map);//
                //3.2、复制表格数据
                baseDao.insertObj("Bisj.copyBsj",map);
                //3.3、复制表格表头列，因为有上下级表头，递归处理
                List<Map<String, Object>> bt_yj = cmap.get("btjb_1");//一级表头
                map.put("btjbMax", 1);
                if ( CollectionUtils.isNotEmpty(bt_yj)) {
                    copyBtl(map, null, bt_yj);//没有上级
                }

            }
        } catch (Exception e) {
            result = "error";
            e.printStackTrace();
        }
        return result;
    }
    @Override
    public String actionBg(Map<String, Object> map) {
        String result="success";
        String type=(String)map.get("type");
        try {
            if("del".equalsIgnoreCase(type)){
                List<Map> bgmblist = null;//所有表格模板
                try {
                    bgmblist = baseDao.queryForList("Bisj.getBgYm",map);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if(bgmblist.size()<=1){
                    return "至少保留一个表格";
                }
                baseDao.deleteObj("Bisj.delBg",map);

            }else if("zt".equalsIgnoreCase(type)){
                baseDao.updateObj("Bisj.updateBgZt",map);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }
    @Override
    public List<Map> getCxkjYm(Map<String, Object> map) {
        List<Map> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Bisj.getCxkjYm",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  bsjs;
    }
    @Override
    public void editCxkjInit(Map<String, Object> map) {
        String type = (String)map.get("type");
        Map ckxj =  new HashMap();
        try {
            if(!"add".equalsIgnoreCase(type)){
                ckxj = baseDao.queryForObj("Bisj.getCxkjByid",map);
            }else{
                int sx = (Integer)baseDao.queryForObj("Bisj.cxkjSequence",map);
                //新增的话 上级id和级别需要操作下
                ckxj.put("sx",sx);
                ckxj.put("zt",1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("cxkjInfo",ckxj);
        return  ;
    }

    @Override
    public String editCxkjInfo(Map<String, Object> map) {
        String type = (String)map.get("type");
        String result ="success";
        try {
            if(!"add".equalsIgnoreCase(type)){
                baseDao.updateObj("Bisj.updateCxkj",map);
            }else {
                baseDao.insertObj("Bisj.insertCxkj",map);
            }
            Integer cxkjc=baseDao.queryForObj("Bisj.cxkjSx",map);
            if(cxkjc>0){
                baseDao.updateObj("Bisj.updateCxkjSx",map);
            }
        } catch (Exception e) {
            result = "error";
            e.printStackTrace();
        }
        return result;
    }



    @Override
    public String actionCxkj(Map<String, Object> map) {
        String result="success";
        String type=(String)map.get("type");
        try {
            if("del".equalsIgnoreCase(type)){
                baseDao.deleteObj("Bisj.delCxkj",map);
            }else if("zt".equalsIgnoreCase(type)){
                baseDao.updateObj("Bisj.updateCxkjZt",map);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }

    @Override
    public void sjyYlInit(Map<String, Object> map) {
        String sjy = (String)map.get("sjy");
        sjy = sjy.replaceAll("%25","%");
        sjy = sjy.replaceAll("%23","#");
        sjy = sjy.replaceAll("%26","&");
        Map sjlyInfo =  new HashMap();
        Set<String> csList1 = new HashSet<>();
        Set<String> csList2 = new HashSet<>();
        Pattern pattern1 = Pattern.compile("(\\#\\{)(.+?)(})");
        Pattern pattern2 = Pattern.compile("(\\$\\{)(.+?)(})");
        Matcher matcher1 = pattern1.matcher(sjy);
        while(matcher1.find()){
            csList1.add(matcher1.group(2).trim());
        }
        Matcher matcher2 = pattern2.matcher(sjy);
        while(matcher2.find()){
            csList2.add(matcher2.group(2).trim());
        }
        sjlyInfo.put("sjy",sjy);
        sjlyInfo.put("csList2",csList2);
        sjlyInfo.put("csList1",csList1);
        map.put("sjlyInfo",sjlyInfo);
        return  ;
    }

    @Override
    public Map<String, Object> sjyYl(Map<String, Object> map) {
        String result="success";
        String msg="success";
        String sjy = (String)map.get("sjy");
        dealSqlStr(sjy,map);
        List<LinkedHashMap<String, Object>> listResult = null;
        List<Map> listColums = new ArrayList<>();
        try {
            listResult = baseDao.queryForList("Biaction.execSql",map);
            if(CollectionUtils.isNotEmpty(listResult)){
                Map<String, Object> columns = listResult.get(0);
                for (Map.Entry<String, Object> entry : columns.entrySet()) {
                    Map<String,Object> columnMap = new HashMap<>();
                    columnMap.put("COLUMNID",entry.getKey());
                    columnMap.put("COLUMNNAME",entry.getKey());
                    listColums.add(columnMap);
                }
            }else {
                Map<String, Object> sjyYz = sjyYz(map);
                result=(String)sjyYz.get("result");
                msg=(String)sjyYz.get("msg");
                String[] lislColumnsYl=(String[])sjyYz.get("cols");
                if("success".equalsIgnoreCase(result) && lislColumnsYl !=null && lislColumnsYl.length>0){
                    for (String col: lislColumnsYl ) {
                        Map<String,Object> columnMap = new HashMap<>();
                        columnMap.put("COLUMNID",col);
                        columnMap.put("COLUMNNAME",col);
                        listColums.add(columnMap);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            result="sql";
            msg=e.getMessage();
            result=e.getMessage();
        }
        map.put("result",result);
        map.put("msg",msg);
        map.put("COLUMNS",listColums);
        map.put("rows",listResult);
        return map;
    }
    @Override
    public Map<String, Object> sjyYz(Map<String, Object> map) {
        String result="success";
        String msg="success";
        String[] lislColumns={};
        String colsStr="";
        try {
            String sjy = (String)map.get("sjy");
            Set<String> csList1 = new HashSet<>();
            Set<String> csList2 = new HashSet<>();
            Pattern pattern1 = Pattern.compile("(\\#\\{)(.+?)(})");
            Pattern pattern2 = Pattern.compile("(\\$\\{)(.+?)(})");
            Matcher matcher1 = pattern1.matcher(sjy);
            while(matcher1.find()){
                csList1.add(matcher1.group(2).trim());
            }
            Matcher matcher2 = pattern2.matcher(sjy);
            while(matcher2.find()){
                csList2.add(matcher2.group(2).trim());
            }
            for (String p:csList1){
                String pValue = ((map.get(p) == null) ? "" : map.get(p)).toString();
                sjy = sjy.replaceAll("\\#\\{"+p+"}","'" + pValue + "'");
            }
            for (String p:csList2){
                String pValue = ((map.get(p) == null) ? "" : map.get(p)).toString();
                if(pValue.indexOf("'") ==-1){
                    sjy = sjy.replaceAll("\\$\\{"+p+"}","'" + pValue + "'");
                }else{
                    sjy = sjy.replaceAll("\\$\\{"+p+"}", pValue );
                }
            }
            sjy="select sjya.* from ("+sjy+") sjya  limit 1";
            try{
                lislColumns=jdbcTemplate.queryForRowSet(sjy).getMetaData().getColumnNames();
                if( lislColumns != null && lislColumns.length>0){
                    for (int i = 0; i < lislColumns.length; i++) {
                        if(StringUtils.isNotEmpty(colsStr)){
                            colsStr+=" , ";
                        }
                        colsStr+="{"+lislColumns[i]+"}";
                    }
                }
            }catch (Exception e){
                result="sjy";
                msg=e.getMessage();
            }
        }catch (Exception e){
            result="other";
            msg=e.getMessage();
        }
        map.put("result",result);
        map.put("cols",lislColumns);
        map.put("colsStr",colsStr);
        map.put("msg",msg);
        return map;
    }
    /**
     * 主要处理 in(${khqj}) 这种
     * @param sqlStr
     * @param map
     */
//    private  static  final  Pattern pattern = Pattern.compile("(\\{)(.+?)(})");
    private void dealSqlStr(String sqlStr, Map<String, Object> map) {
        Pattern pattern = Pattern.compile("(\\$\\{)(.+?)(})");
        Set<String> ls=new HashSet<>();
        Matcher matcher = pattern.matcher(sqlStr);
        while(matcher.find()){
            ls.add(matcher.group(2).trim());
        }
        String pValue;
        for (String  str  :ls) {
            pValue = map.get(str)==null?"":(String)map.get(str);
            if(pValue.indexOf("'") ==-1){
                sqlStr = sqlStr.replaceAll("\\$\\{"+str+"}","'" + pValue + "'");
            }else{
                sqlStr = sqlStr.replaceAll("\\$\\{"+str+"}", pValue );
            }
        }
        map.put("sqlStr",sqlStr);
    }
}

