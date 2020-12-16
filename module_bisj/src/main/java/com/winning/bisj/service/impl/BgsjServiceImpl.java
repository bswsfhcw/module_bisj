package com.winning.bisj.service.impl;

import com.winning.bisj.service.BgsjService;
import com.winning.common.core.dao.ibatis.BaseDaoAware;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("bgsjService")
public class BgsjServiceImpl implements BgsjService {

    @Autowired
    @Qualifier("baseDao")
    private BaseDaoAware baseDao;
    @Override
    public List<Map<String,Object>> queryBgList(Map<String, Object> map) {
        List<Map<String,Object>> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Bgsj.queryBgList",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  bsjs;
    }

    @Override
    public List<Map<String,Object>> getAllBtl(Map<String,Object> map) throws Exception {
        List<Map<String,Object>> resultlist = new ArrayList<>();
        return baseDao.queryForList("Bgsj.getAllBtl",map);
    }

    @Override
    public void editBtlInit(Map<String,Object> map) throws Exception {
        String type = (String)map.get("type");
        Map btl =  new HashMap();
        btl.putAll(map);
        try {
            Map btlXz = baseDao.queryForObj("Bgsj.getBtlById",map);
            if(!"add".equalsIgnoreCase(type)){
                btl=btlXz;
            }else{
                int sx = (Integer)baseDao.queryForObj("Bgsj.btlSequence",map);
                //新增的话 上级id和级别需要操作下
                if(btlXz!=null){
                    btl.put("id_sjcl",btl.get("id_btl"));
                    btl.put("btjb",(Integer)btlXz.get("btjb")+(Integer)btlXz.get("rowspan"));
                }else{
                    btl.put("id_sjcl",0);
                    btl.put("btjb",1);
                }
                btl.put("sx",sx);
                btl.put("rowspan",1);
                btl.put("zt",1);
                btl.put("sjylx",0);
                btl.put("gshlx",0);
                btl.put("dblx",0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("btlInfo",btl);
        return  ;
    }

    @Override
    public String editBtlInfo(Map<String,Object> map) throws Exception {
        String type = (String)map.get("type");
        String result ="success";
        try {
            if(!"add".equalsIgnoreCase(type)){
                baseDao.updateObj("Bgsj.updateBtlById",map);
            }else {
                baseDao.insertObj("Bgsj.insertBtl",map);
            }
            Integer btlc=baseDao.queryForObj("Bgsj.btlSx",map);
            if(btlc>0){
                baseDao.updateObj("Bgsj.updateBtlSx",map);
            }
        } catch (Exception e) {
            result = "error";
            e.printStackTrace();
        }
        return result;
    }
    @Override
    public String actionBtl(Map<String, Object> map) {
        String result="success";
        String type=(String)map.get("type");
        try {
            if("del".equalsIgnoreCase(type)){
                baseDao.deleteObj("Bgsj.delBtl",map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }

    @Override
    public List<Map> getBsjBg(Map<String, Object> map) {
        List<Map> bsjs = null;
        try {
            bsjs = baseDao.queryForList("Bgsj.getBsjBg",map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  bsjs;
    }
    @Override
    public void editBsjInit(Map<String, Object> map) {
        String type = (String)map.get("type");
        Map bsj =  new HashMap();
        try {
            if(!"add".equalsIgnoreCase(type)){
                bsj = baseDao.queryForObj("Bgsj.getBsjByid",map);
            }else {
                int sx = (Integer)baseDao.queryForObj("Bgsj.bsjSequence",map);
                //新增的话 上级id和级别需要操作下
                bsj.put("sx",sx);
                bsj.put("zt",1);
                bsj.put("sjlx",1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        map.put("bsjInfo",bsj);
        return  ;
    }

    @Override
    public String editBsjInfo(Map<String, Object> map) {
        String type = (String)map.get("type");
        String result ="success";
        try {
            if(!"add".equalsIgnoreCase(type)){
                baseDao.updateObj("Bgsj.updateBsj",map);
            }else {
                baseDao.insertObj("Bgsj.insertBsj",map);
            }
        } catch (Exception e) {
            result = "error";
            e.printStackTrace();
        }
        return result;
    }



    @Override
    public String actionBsj(Map<String, Object> map) {
        String result="success";
        String type=(String)map.get("type");
        try {
            if("del".equalsIgnoreCase(type)){
                baseDao.deleteObj("Bgsj.delBsj",map);
            }else if("zt".equalsIgnoreCase(type)){
                baseDao.updateObj("Bgsj.updateBsjZt",map);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }
}
