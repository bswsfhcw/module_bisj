package com.winning.bisj.service;

import com.winning.common.core.dao.ibatis.BaseDaoAware;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.jdbc.ScriptRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.sql.Connection;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/***
 * @Description:
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/12/15
 */
@Component
public class DataService {

    private static final Log log = LogFactory.getLog(DataService.class);

    @Autowired
    @Qualifier("baseDao")
    private BaseDaoAware baseDao;

    @Resource
    private JdbcTemplate jdbcTemplate;

    @Value("${db.url}")
    private String dbUrl;

    @Value("#{upload_pros[bisjCshMs]}")
    private String bisjCshMs;

    @PostConstruct
    public void init() {
        log.info("=====================DataService开始========================");
        try {
            log.info("=====================bisjCshMs:"+bisjCshMs+"========================");
            //根据库中该表bisj_ym是否有数据,没有则自动初始化相关表和数据
            if("1".equalsIgnoreCase(bisjCshMs)){
                Map<String,Object> map = new HashMap<>();
                map.put("tableName","bisj_ym");
                String regex = "\\{(.*?)}";
                regex = "jdbc:mysql:\\/\\/(.*?)\\/(.*?)\\?";
                Pattern pattern = Pattern.compile(regex);
                Matcher matcher = pattern.matcher(dbUrl);
                while (matcher.find()) {
                    map.put("tableSchema",matcher.group(2));
                    break;
                }
                int c = (Integer) baseDao.queryForObj("Bisj.baseData",map);
                log.info("=====================报表数据库已经存在?"+(c>0)+"========================");
                if(c==0){
                    bisjCsh();
                }
            //强制初始化
            }else if("2".equalsIgnoreCase(bisjCshMs)) {
                bisjCsh();
            }
            //默认不初始化
        }catch (Exception e){
            log.error("=====================DataService异常========================"+e);
        }finally {
            log.info("=====================DataService结束========================");
        }
    }
    void bisjCsh() throws Exception{
        log.info("=====================初始化报表数据库开始========================");
        Connection conn= jdbcTemplate.getDataSource().getConnection();
        ScriptRunner runner = new ScriptRunner(conn);
        runner.runScript(Resources.getResourceAsReader("bisj_bg.sql"));
        log.info("=====================初始化报表数据库结束========================");
        return;
    }
    public  static  void main(String[] args){
        String dbUrl="jdbc:mysql://172.16.0.101:3306/tljx_ys?useUnicode=true&characterEncod";
        Set<String> set=new HashSet<>();
        String regex = "\\{(.*?)}";
        regex = "jdbc:mysql:\\/\\/(.*?)\\/(.*?)\\?";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(dbUrl);
        while (matcher.find()) {
            set.add(matcher.group(2));
        }
    }
}
