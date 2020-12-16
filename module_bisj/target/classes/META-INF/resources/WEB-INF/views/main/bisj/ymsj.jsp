<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script language="javascript" src="${basePath}/asserts/js/plugins/bootstrap-datepicker/bootstrap-datepicker.js"></script>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<style>
    .fixed-table-toolbar{
        display: none !important;
    }
    .progress {
        margin-bottom: 0px;
        height: auto;
        position: relative;
    }
    .progress-bar {
        position: absolute;
        z-index: 10;
    }
    .progress-placeholder {
        float: left;
        width: 100%;
        text-align: center;
        visibility: hidden;
    }
    .progress-text {
        position: absolute;
        z-index: 20;
        width: 100%;
        text-align: center;
    }
    .submitBtn{
        background-color:#eb6841;font-family:Microsoft YaHei;color: rgb(255, 255, 255);font-size:14px;
    }
</style>
<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">查询条件</div>
                    <div class="box-tools">
                        <button type="button" class="btn btn-default btn-sm" id="getList" onclick="getYm()">查询</button>
                    </div>
                </div>
                <div class="box-body">

                    <div class="form-horizontal">
                        <div class="form-group">

                            <div class="col-mr">
                                <label class="col-lg-1 col-md-2 control-label">页面名称：</label>
                                <div class="col-lg-2 col-md-2">
                                    <div class="input-group">
                                        <input type="text" class="form-control input-sm" name="mc" id="mc" value="${mc}" onchange="getYm()"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 both-pd7">
            <div class="tab-pane fade in active">
                <div class="box win-box">
                    <div class="box-header">
                        <%-- <i class="fa box-search"></i>--%>
                        <div class="box-title">页面列表</div>
                    </div>
                    <div class="box-body" style="overflow: auto;">
                        <table class="table-container" id="table_bisjym">

                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var reqParam = {};
    var  resultTable;
    var sjylContent;
    //页面初始化
    $(document).ready(function(){
        getYm();
    });
    //获取表格数据配置
    var getYm = function () {
        reqParam.mc = $('#mc').val();
        resultTable = $('#table_bisjym').bootstrapTable('destroy').bootstrapTable({
            method : 'GET',
            url:"./getYm",
            contentType: "application/x-www-form-urlencoded",
            height:getTableHeight(),
            showFooter:false,
            showHeader: true,
            striped: true, //表格显示条纹
            pagination: false, //启动分页
            search: false, //是否启用查询
            onlyInfoPagination: false,
            columns: [
                {
                    field: 'id',
                    title: 'id'
                },{
                    field: 'mc',
                    title: '名称'
                }
            ],
            //得到查询的参数
            queryParams : function (params) {
                return reqParam;
            },
            onLoadSuccess: function (data) {
                console.log("onLoadSuccess");
            },
            onAll:function (name, args) {
                // console.log("onAll:"+name);
            },
            formatNoMatches: function(){
                return "没有相关的匹配结果";
            }
        });
    };

    function getTableHeight() {
        return  200;
    }

    function sjyl(id_ym) {
        sjylContent = layer.open({
            type: 2,
            title: '页面配置',
            shadeClose: true,
            shade: false,
            maxmin: true, //开启最大化最小化按钮
            area: ['893px', '600px'],
            // content: basePath + 'slhs/gInit?nd='+$('#nf').val()+'&pd=1&qj='+params.name.replaceAll("月","")+'&ztbm='+$('#gp').val()+'&noFrame=1'
            content: basePath + 'bisj/ymsj?id_ym='+id_ym
        });
        layer.full(sjylContent);
    }
</script>