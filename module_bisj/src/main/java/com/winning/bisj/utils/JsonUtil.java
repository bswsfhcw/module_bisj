package com.winning.bisj.utils;/**
 * @Author: huchengwei * @Date: 2020/9/21 10:23 * @Description: *
 */

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

/**
 * @author     ：huchengwei
 * @date       ：Created in 2020/9/21 10:23
 * @description：
 * @modified By：
 * @version: $
 */
public class JsonUtil {
    public  static void  main(String[] args){
        JSONArray jsonArray = new JSONArray();
        JSONObject jsonObjectFSDXX = new JSONObject();
        JSONObject jsonObjectFSDXXS = new JSONObject();
        jsonObjectFSDXXS.put("SSXTDM","发送系统代码");
        jsonObjectFSDXXS.put("SSXTMC","发送系统名称");
        jsonObjectFSDXX.put("FSDXX",jsonObjectFSDXXS);

        JSONObject jsonObjectTXXX = new JSONObject();
        JSONObject jsonObjectTXXXS = new JSONObject();
        jsonObjectTXXXS.put("TXBT","消息标题");
        jsonObjectTXXXS.put("TXNR","消息内容");
        jsonObjectTXXX.put("TXXX",jsonObjectTXXXS);

        jsonArray.add(jsonObjectFSDXX);
        jsonArray.add(jsonObjectTXXX);
        System.out.println(jsonArray.toString());

    }

}
