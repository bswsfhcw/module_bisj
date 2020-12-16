package com.winning.bisj.dao.impl;

import com.github.pagehelper.PageInfo;
import com.winning.common.core.dao.BaseDaoMyBatisAware;
import com.winning.common.core.dao.ibatis.BaseDao;
import com.winning.bisj.dao.BisjDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/***
 * @Description:
 * @Param:
 * @return:
 * @Author: huchengwei
 * @Date: 2020/9/16
 */
@Repository("bisjDao")
public class BisjDaoImpl extends BaseDaoMyBatisAware implements BisjDao {

    @Autowired
    @Qualifier("baseDao")
    private BaseDao baseDao;

}
