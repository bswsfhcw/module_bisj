<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<link rel="stylesheet" type="text/css" href="${basePath}asserts/css/bootstrap-switch.min.css"/>
<script type="text/javascript" src="${basePath}asserts/js/bootstrap-switch.min.js"></script>

<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-body">
                    <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">数据源：</label>
                            <div class="col-sm-10">
                                <textarea id="_sjy_yl" class="form-control" maxlength="2048" name="sjy" rows="6" >${sjlyInfo.sjy}</textarea>
                            </div>
                        </div>
                        <div class="form-group" id="csList">
                            <label class="col-sm-2 control-label">参数：</label>
                            <div class="col-sm-10 row">
                                <c:forEach items="${sjlyInfo.csList1}" var="ite" varStatus="status">
                                    <label class="col-sm-1 control-label">${ite}=</label>
                                    <div class="col-sm-1">
                                        <input class="form-control" id="${ite}" name="csList1" maxlength="32" type="text" />
                                    </div>
                                </c:forEach>
                                <c:forEach items="${sjlyInfo.csList2}" var="ite" varStatus="status">
                                    <label class="col-sm-1 control-label">${ite}=</label>
                                    <div class="col-sm-1">
                                        <input class="form-control" id="${ite}" name="csList2" maxlength="32" type="text" />
                                    </div>
                                </c:forEach>
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
                        <i class="fa box-search"></i>
                        <div class="box-title" style="font-size:15px;">结果</div>
                        <div class="box-tools">
                            <button   class="btn btn-default btn-sm" onclick="yzSyYl()" style="margin-left:5px ">校验</button>
                            <button   class="btn btn-default btn-sm" onclick="loadSylData(true)" style="margin-left:5px ">预览</button>
                        </div>
                    </div>
                    <div class="box-body" style="overflow: auto;">
                        <table class="table-container" id="yljgTable">
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css"  href="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.css"/>

<script type="text/javascript">
    var reqParaYl={};
    $(function () {
        loadSylData(true);
    });
    var yljgTable;
    var dabhColumns;
    function initsjyYl(resultDatas) {
        debugger;
        console.log("**initsjyYl**");
        yljgTable = $('#yljgTable').bootstrapTable('destroy').bootstrapTable({
            height: 350,
            onlyInfoPagination: false,
            pagination: false, //启动分页
            columns: dabhColumns,
            onLoadSuccess: function () {
            }
        });
        yljgTable.bootstrapTable("load", resultDatas.rows);
    };
    function loadSylData (initTableFlag) {
        console.log("loadSylData:"+initTableFlag);
        $("input[name='csList1']").each(function(){
            reqParaYl[$(this).attr("id")]=$(this).val();
        });
        $("input[name='csList2']").each(function(){
            reqParaYl[$(this).attr("id")]=$(this).val();
        });
        reqParaYl.sjy=$('#_sjy_yl').val();
        loadMessage();
        $.ajax({
            url: '../bisj/sjyYl',
            type: 'POST',
            dataType: 'json',
            data: reqParaYl
        }).done(function (resultDatas) {
            hideMessage();
            if(resultDatas && resultDatas.result != 'success'){
                toastr.error(resultDatas.result);
                return;
            }
            dabhColumns= [];//
            dabhColumns.push({
                field : "",
                title : "序号",
                formatter:function(value, row, index){
                    return index+1;
                }
            });
            //渲染数据
            $.each(resultDatas.COLUMNS,function (index,value) {
                dabhColumns.push({
                    field:value.COLUMNID,
                    title:value.COLUMNNAME
                });
            });
            if(initTableFlag){
                initsjyYl(resultDatas);
            }
            // console.log("resultDatas:"+JSON.stringify(resultDatas));
        }).fail(function () {
        }).always(function () {
        });
    };
    function yzSyYl () {
        console.log("yzSyYl:");
        $("input[name='csList1']").each(function(){
            reqParaYl[$(this).attr("id")]=$(this).val();
        });
        $("input[name='csList2']").each(function(){
            reqParaYl[$(this).attr("id")]=$(this).val();
        });
        reqParaYl.sjy=$('#_sjy_yl').val();
        loadMessage();
        $.ajax({
            url: '../bisj/sjyYz',
            type: 'POST',
            dataType: 'json',
            data: reqParaYl
        }).done(function (resultDatas) {
            hideMessage();
            if(resultDatas && resultDatas.result == 'success'){
                toastr.error(resultDatas.msg);
                toastr.success("success->"+resultDatas.colsStr);
                loadSylData(true);
                return;
            }else  if(resultDatas && resultDatas.result == 'sjy'){
                toastr.error("数据源非法->"+resultDatas.msg);
                return;
            }else {
                toastr.error("异常->"+resultDatas.msg);
                return;
            }
        }).fail(function () {
        }).always(function () {
        });
    };
</script>

