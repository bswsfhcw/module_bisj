package com.winning.bisj.service;

import java.util.List;
import java.util.Map;

/***
 * @Description: 
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/9/16
 */
public interface BisjService {
    String zc(Map<String, Object> map) throws Exception;
    List<Map> getYm(Map<String, Object> map);
    List<Map> getBgYm(Map<String, Object> map);
    void editYmInit(Map<String, Object> map);
    String editYmInfo(Map<String, Object> map) throws Exception;
    String actionYm(Map<String, Object> map) throws Exception;
    void editBgInit(Map<String, Object> map);
    String editBgInfo(Map<String, Object> map) throws Exception;
    String actionBg(Map<String, Object> map) throws Exception;
    List<Map> getCxkjYm(Map<String, Object> map);
    void editCxkjInit(Map<String, Object> map);
    String editCxkjInfo(Map<String, Object> map) throws Exception;
    String actionCxkj(Map<String, Object> map) throws Exception;
    void sjyYlInit(Map<String, Object> map);
    Map<String, Object> sjyYl(Map<String, Object> map);
    Map<String, Object> sjyYz(Map<String, Object> map);
}
