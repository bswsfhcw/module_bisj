package com.winning.bisj.service;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import com.winning.common.core.dao.ibatis.BaseDaoAware;
import com.winning.common.entitys.BaseSelectBean;
import com.winning.common.entitys.sys.Dazb;
import com.winning.common.service.CommonService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.jdbc.ScriptRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import java.sql.Connection;
import java.util.*;

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

    @PostConstruct
    public void init() throws Exception {
        log.info("=====================初始化报表数据库开始========================");
        try {
            Map<String,Object> map = new HashMap<>();
            map.put("tableName","bisj_ym");
            int c = (Integer) baseDao.queryForObj("Bisj.baseData",map);
            log.info("=====================报表数据库已经存在?"+(c==0)+"========================");
            if(c==0){
                Connection conn= jdbcTemplate.getDataSource().getConnection();
                ScriptRunner runner = new ScriptRunner(conn);
                runner.runScript(Resources.getResourceAsReader("bisj_bg.sql"));
            }
        }catch (Exception e){
            log.error("=====================初始化报表数据库异常========================"+e);
        }finally {
            log.info("=====================初始化报表数据库结束========================");
        }
    }

}
