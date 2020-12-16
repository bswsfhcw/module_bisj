package com.winning.bisj.service;


import java.util.List;
import java.util.Map;

public interface BgsjService {

    List<Map<String,Object>> queryBgList(Map<String, Object> map);

    List<Map<String,Object>> getAllBtl(Map<String, Object> map) throws Exception;  //获取所有表头信息

    void editBtlInit(Map<String, Object> map) throws Exception; //根据表头编码获取当前表头信息

    String editBtlInfo(Map<String, Object> map) throws Exception;//保存表头

    String actionBtl(Map<String, Object> map) throws Exception;

    List<Map> getBsjBg(Map<String, Object> map);
    void editBsjInit(Map<String, Object> map);
    String editBsjInfo(Map<String, Object> map) throws Exception;
    String actionBsj(Map<String, Object> map) throws Exception;

}
