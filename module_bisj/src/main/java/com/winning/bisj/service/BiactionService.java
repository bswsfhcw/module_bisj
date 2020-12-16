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
public interface BiactionService {


    List<Map<String, Object>> queryBgList(Map<String, Object> map);
    List<Map<String, Object>> queryCxtjList(Map<String, Object> map);
    Map<String, Object> change(Map<String, Object> map);
    List< List<Map<String, Object>>> getColums(Map<String, Object> map);
    List<Map<String,Object>> bgData(Map<String, Object> map)  throws Exception;

}
