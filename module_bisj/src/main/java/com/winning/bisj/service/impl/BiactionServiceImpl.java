package com.winning.bisj.service.impl;

import com.shael.commons.CollectionUtils;
import com.winning.bisj.dao.BisjDao;
import com.winning.common.core.dao.ibatis.BaseDaoAware;
import com.winning.bisj.service.BiactionService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.jdbc.ScriptRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.sql.Connection;
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
public class BiactionServiceImpl implements BiactionService {

    private static Log logger = LogFactory.getLog(BiactionServiceImpl.class);
    private static HashMap<String,Map<String, Object>> kjmap = new HashMap<>();
    private static HashMap<String,List<Map<String, Object>>> cmap = new HashMap<>();
    @Autowired
    @Qualifier("bisjDao")
    private BisjDao bisjDao;

    @Autowired
    @Qualifier("baseDao")
    private BaseDaoAware baseDao;
    @Override
    public List<Map<String, Object>> queryBgList(Map<String, Object> map) {
        List<Map<String, Object>> list  = new ArrayList<>();
        try {
            list=baseDao.queryForList("Biaction.hqbg",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    @Override
    public List<Map<String, Object>> queryCxtjList(Map<String, Object> map) {
        List<Map<String, Object>> list  = new ArrayList<>();
        try {
            list=baseDao.queryForList("Biaction.hqcxkj",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        kjmap.clear();
        for (int i = 0; i <list.size() ; i++) {
            kjmap.put((String)list.get(i).get("code"),list.get(i));
        }
        return list;
    }
    @Override
    public Map<String, Object> change(Map<String, Object> map) {
        Map<String, Object> mapKj = new HashMap<>();
        String kjcode = (String)map.get("kjid");
        Map<String, Object> kj = kjmap.get(kjcode);
        String kjsjy = (String)kj.get("sjy");
        dealSqlStr(kjsjy,map);
        List<Map<String, Object>> list = null;
        try {
            list = baseDao.queryForList("Biaction.execSql",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        mapKj.put("kj",kj);
        mapKj.put("kjValueList",list);
        return mapKj;
    }

    /**
     * 主要处理 in(${khqj}) 这种
     * @param sqlStr
     * @param map
     */
//    private  static  final  Pattern pattern = Pattern.compile("(\\{)(.+?)(})");
    private void dealSqlStr(String sqlStr, Map<String, Object> map) {
        Pattern pattern = Pattern.compile("(\\$\\{)(.+?)(})");
        List<String> ls=new ArrayList<String>();
        Matcher matcher = pattern.matcher(sqlStr);
        while(matcher.find()){
            ls.add(matcher.group(2));
        }
        for (String  str  :ls) {
            sqlStr=sqlStr.replaceAll("\\$\\{"+str+"}",(String)map.get(str));
        }
        map.put("sqlStr",sqlStr);
    }

    @Override
    public List< List<Map<String, Object>>> getColums(Map<String, Object> map) {
        List< List<Map<String, Object>>> result  = new ArrayList<>();
        //
        LinkedHashMap<String,List<Map<String, Object>>> rmap = new LinkedHashMap<>();
        //最大标题级别
        map.put("btjbMax",1);
        try {
            buildInt(map);//初始化
            List<Map<String, Object>> bt_yj = cmap.get("btjb_1");//一级表头
            dealCls(map,rmap,null,bt_yj);//没有上级
        } catch (Exception e) {
            e.printStackTrace();
        }
        int btjbMax = (Integer)map.get("btjbMax");
        HashMap<String,Integer> mapColspan = new HashMap<>();//记录每个级别_单元格的跨列
        //要确定跨列,从倒数第二行表头开始统计下级列个数即可
        for (int i = btjbMax; i >0 ; i--) {
            List<Map<String, Object>> bt = rmap.get("btjb_"+i);
            for (int j = 0; j < bt.size(); j++) {
                Map<String, Object> cl = bt.get(j);
                if(cl.get("clsxj")!=null ){
                    LinkedList<Map<String, Object>> clsxj = (LinkedList<Map<String, Object>>)cl.get("clsxj");
                    int colspan=0;
                    for (int k = 0; k <clsxj.size() ; k++) {//取每个下级的下级个数相加即可
                        Map<String, Object> clxj = clsxj.get(k);
                        colspan+=mapColspan.get(clxj.get("btjb")+"_"+clxj.get("clfield"))==null?1:mapColspan.get(clxj.get("btjb")+"_"+clxj.get("clfield"));
                    }
                    cl.put("colspan",colspan);
                    mapColspan.put(cl.get("btjb")+"_"+cl.get("clfield"),colspan);//记录当前的clsspan，供上级使用
                }
            }
        }
        for (Map.Entry<String,List<Map<String, Object>>> entry : rmap.entrySet()) {
            result.add(entry.getValue());
        }
        return result;
    }

    private void buildInt(Map<String, Object> map) {
        cmap.clear();
            List<LinkedHashMap<String, Object>> btl = null;
            try {
                btl = baseDao.queryForList("Biaction.hqbgl",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int btjb;
        int id_sjcl;
        for (int i = 0; i < btl.size(); i++) {
            Map<String, Object> cl = btl.get(i);
            btjb = (Integer)cl.get("btjb");
            id_sjcl =cl.get("id_sjcl")==null?-1:(Integer)cl.get("id_sjcl");
            List<Map<String, Object>> bt = cmap.get("btjb_"+btjb);
            if(bt == null){
                bt = new ArrayList<Map<String, Object>>();
                cmap.put("btjb_"+btjb,bt);
            }
            bt.add(cl);
            if(id_sjcl != -1){
                List<Map<String, Object>> xjcl = cmap.get("xjcl_"+id_sjcl);
                if(xjcl == null){
                    xjcl = new ArrayList<Map<String, Object>>();
                    cmap.put("xjcl_"+id_sjcl,xjcl);
                }
                xjcl.add(cl);
            }
        }
    }

    private void  dealCls(Map<String, Object> map, HashMap<String, List<Map<String, Object>>> rmap,  Map<String, Object> clSj, List<Map<String, Object>> clsCu) {
        int btjbMax=(Integer)map.get("btjbMax");
        int id_cl;
        int btjb;
        int sjylx;
        String sjy;
        int xjclCount;
        LinkedList<Map<String, Object>> clsCuReal = new LinkedList<>();//真实得列数
        for (int i = 0; i < clsCu.size(); i++) {
            Map<String, Object> clCu = clsCu.get(i);
            btjb = (Integer)clCu.get("btjb");
            if(btjb>btjbMax){
                btjbMax=btjb;
                map.put("btjbMax",btjbMax);
            }
            id_cl = (Integer)clCu.get("id");
            sjylx = (Integer)clCu.get("sjylx");
            sjy = (String)clCu.get("sjy");
            if(clSj!=null){
                for (Map.Entry<String, Object> entry : clSj.entrySet()) {
                    map.put(entry.getKey()+"Sj",entry.getValue());//很重要 把上级列所有键值对拿过来
                }
            }
            List<Map<String, Object>> clsSameBtjb = rmap.get("btjb_"+btjb);//按照表头级别分组
            if(clsSameBtjb == null ){
                clsSameBtjb=new ArrayList<>();
                rmap.put("btjb_"+btjb,clsSameBtjb);
            }
            List<Map<String, Object>> xjcl = cmap.get("xjcl_"+id_cl);//是否有下级扩展
            xjclCount =CollectionUtils.isEmpty(xjcl)?0:xjcl.size();
            if(sjylx == 0){//表头直接添加
                clsCuReal.add(clCu);
                //处理下级
                clsSameBtjb.add(clCu);
                if(xjclCount>0){
                    dealCls(map, rmap,clCu, xjcl);
                }
            }else if(sjylx == 1){
                dealSqlStr(sjy,map);
                List<Map<String, Object>> list  = null;
                try {
                    list = baseDao.queryForList("Biaction.execSql",map);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                for (int j = 0; j < list.size(); j++) {///表头添加
                    Map<String, Object> clCu_sql = new HashMap<>();
                    Map<String, Object> clCu_sql_ = list.get(j);
                    clCu_sql.putAll(clCu);//相关属性取数据库,动态取得再覆盖
                    for (Map.Entry<String, Object> entry : clCu_sql_.entrySet()) {
                        clCu_sql.put(entry.getKey(),entry.getValue());
                    }
                    clsCuReal.add(clCu_sql);
                    clsSameBtjb.add(clCu_sql);
                    //处理下级
                    if(xjclCount>0){
                        dealCls(map, rmap,clCu_sql, xjcl);
                    }
                }
            }
            //记录每列下级扩展的列的个数;
            if(clSj !=null){
                clSj.put("clsxj",clsCuReal);
            }
        }
    }

    @Override
    public List<Map<String,Object>>  bgData(Map<String, Object> map) {
        Map<String,Map<String, Object>> fzMap = new HashMap<>();
        List<Map<String,Object>> list = new ArrayList<>();
        List<LinkedHashMap<String, Object>> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Biaction.hqbsj",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        String sjy;
        String jzKeyBz="key_id";
        String[] clfieldStrs;
        String clfield_="";
        List<String> clfields;
        List<Map<String, Object>> listsjJz = null;
        List<Map<String, Object>> listsj = null;
        for (int i = 0; i <bsjs.size() ; i++) {//
            LinkedHashMap<String, Object> bsj = bsjs.get(i);
            if((Integer)bsj.get("sjlx")==2){
                sjy=(String)bsj.get("sjy");
                dealSqlStr(sjy,map);
                try {
                    listsjJz = baseDao.queryForList("Biaction.execSql",map);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        for (int i = 0; i <bsjs.size() ; i++) {//暂定一个基准
            LinkedHashMap<String, Object> bsj = bsjs.get(i);
            if((Integer)bsj.get("sjlx")==0){
                sjy=(String)bsj.get("sjy");
                dealSqlStr(sjy,map);
                try {
                    listsjJz = baseDao.queryForList("Biaction.execSql",map);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            }
        }
        for (int i = 0; i <bsjs.size() ; i++) {
            LinkedHashMap<String, Object> bsj = bsjs.get(i);
            if((Integer)bsj.get("sjlx")==1){//按照指标封装数据
                sjy=(String)bsj.get("sjy");
                dealSqlStr(sjy,map);
                try {
                    listsj = baseDao.queryForList("Biaction.execSql",map);
                    clfieldStrs=((String)bsj.get("clfield")).split(";");
                    int fieldValueIndex=1;
                    for (String xx:clfieldStrs){
                        String clfield = xx.split(":")[0];
                        String clvalue = xx.split(":")[1].replaceAll("\\{","").replaceAll("\\}","");
                        clfields = extractMessageByRegular(clfield);
                        for (int j = 0; j <listsj.size() ; j++) {//每条记录
                            Map<String, Object> sj=listsj.get(j);
                            String zjkey=(String)sj.get(jzKeyBz);
                            Map<String, Object> fz= fzMap.get(zjkey);
                            if(fz == null){
                                fz = new HashMap<>();
                                fzMap.put(zjkey,fz);
                            }
                            for (int k = 0; k < clfields.size(); k++) {
                                clfield_ =clfield.replaceAll("\\{"+clfields.get(k)+"\\}",(String)sj.get(clfields.get(k)));
                            }
                            fz.put(clfield_,sj.get(clvalue));
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        for (int i = 0; i <listsjJz.size() ; i++) {
            Map<String, Object> jz = listsjJz.get(i);
            String zjkey=(String)jz.get(jzKeyBz);
            Map<String, Object> fz = fzMap.get(zjkey);
            if(fz == null){
                continue;
            }
            for (Map.Entry<String,Object> entry : fz.entrySet()) {//横向扩展表头
                jz.put(entry.getKey(),entry.getValue());
            }
        }
        return listsjJz;
    }
    public  static  void  main( String[] args){
        String input = "{111}_{222}_ggzl";
        System.out.println(input.replaceAll("\\{"+"111"+"\\}",""));

    }
    public static List<String> extractMessageByRegular(String input){
        List<String> list = new ArrayList<>();
        Set<String> set=new HashSet<>();
        String regex = "\\{(.*?)}";
       Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);
        while (matcher.find()) {
            set.add(matcher.group(1));
        }
        list.addAll(set);
        Connection con = null;
        ScriptRunner runner = new ScriptRunner(con);
        return list;
    }
}

