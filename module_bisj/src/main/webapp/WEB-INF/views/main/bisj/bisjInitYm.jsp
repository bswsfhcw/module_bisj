<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script language="javascript" src="${basePath}/asserts/js/plugins/bootstrap-datepicker/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/confirm/confirm.js" ></script>
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
    <div class="row" id="row_zcm" style="display: none;">
        <div class="col-md-12 both-pd7">
            <input type="text" class="form-control input-sm"  style="height: 200px;text-align: center;font-size: 20px" name="zcm" id="zcm" value="${zcm}" placeholder="注册码"/>
            <span id="zcxx">${zcxx}</span><button style="margin-left: 20px" onclick="zc()">注册</button>
        </div>
    </div>
    <div id="row_zym">
        <div class="row">
            <div class="col-md-12 both-pd7">
                <!--搜索查询区：常为查询-->
                <div class="box win-search-box">
                    <div class="box-header">
                        <i class="fa box-search"></i>
                        <div class="box-title"></div>
                        <div class="box-tools" style="position: absolute;left: 10px">
                            <input type="text" class="form-control input-sm"  style="width: 200px" name="mc" id="mc" value="${mc}" placeholder="页面名称搜索" onchange="getYm()"/>
                        </div>
                        <div class="box-tools">
                            <button   class="btn btn-default btn-sm" onclick="ymSelect('','','add','')" style="margin-left:5px ">初始化新页面</button>
                            <button type="button" class="btn btn-default btn-sm" id="getList" onclick="getYm()">查询</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 both-pd7">
                <div class="tab-pane fade in active">
                    <div class="box win-box">
                        <div class="box-body" style="overflow: auto;">
                            <div id="result_ym" style="overflow-y: auto;overflow-x:hidden;" ></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 both-pd7">
                <div class="box win-search-box">
                    <div class="box-header">
                        <i class="fa box-search"></i>
                        <div class="box-title">控件</div>
                        <div class="box-tools">
                            <button type="button" class="btn btn-default btn-sm" onclick="cxkjSelect('','add',1)">新增</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 both-pd7">
                <div class="tab-pane fade in active">
                    <div class="box win-box">
                        <div class="box-body" style="overflow: auto;">
                            <div id="result_cxkj" style="overflow-y: auto;overflow-x:hidden;" ></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 both-pd7">
                <div class="box win-search-box">
                    <div class="box-header">
                        <i class="fa box-search"></i>
                        <div class="box-title">表格</div>
                        <div class="box-tools">
                            <button   class="btn btn-default btn-sm" onclick="addBg()" style="margin-left:5px ">初始化新表格</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 both-pd7">
                <div class="tab-pane fade in active">
                    <div class="box win-box">
                        <div class="box-body" style="overflow: auto;">
                            <div id="result_bg" style="overflow-y: auto;overflow-x:hidden;" ></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var reqParam = {};
    var id_ymSelect;
    var sjylContent;
    //页面初始化
    $(document).ready(function(){
        getYm();
    });
    function zc() {
        loadMessage();
        var request = new HttpRequest("zc", "post", {
            onRequestSuccess: function (responseText) {
                hideMessage();
                if (responseText != "success") {
                    toastr.warning(responseText);
                }else{
                    toastr.success("注册成功！");
                    $("#row_zcm").css("display","none");
                    $("#row_zym").css("display","");
                }
            }
        });
        request.addParameter("zcm",  $("#zcm").val());//
        request.sendRequest();
    }
    //获取表格数据配置
    function getYm() {
        $("#result_ym").html("");
        //只有报告类型为区县的时候才触发
        reqParam.mc = $('#mc').val();
        loadMessage();
        var request = new HttpRequest("./getYm","post",{
            onRequestSuccess : function(responseText){
                hideMessage();
                $("#result_ym").html(responseText);
            }
        });
        request.addParameter("mc",reqParam.mc);
        request.sendRequest();
    }
    function getCxkj(id_ym) {
        $("#result_cxkj").html("");
        //只有报告类型为区县的时候才触发
        reqParam.id_ym = id_ym;
        loadMessage();
        var request = new HttpRequest("./getCxkjYm","post",{
            onRequestSuccess : function(responseText){
                hideMessage();
                $("#result_cxkj").html(responseText);
            }
        });
        request.addParameter("id_ym",reqParam.id_ym);
        request.sendRequest();
    }
    function getBg(id_ym) {
        $("#result_bg").html("");
        //只有报告类型为区县的时候才触发
        reqParam.id_ym = id_ym;
        loadMessage();
        var request = new HttpRequest("./getBgYm","post",{
            onRequestSuccess : function(responseText){
                hideMessage();
                $("#result_bg").html(responseText);
            }
        });
        request.addParameter("id_ym",reqParam.id_ym);
        request.sendRequest();
    }
    function getTableHeight() {
        return  200;
    }
    var ymFwContent;
    function ymSelect(id_ym,mc_ym,type,lx,e){
        var e = window.event || e;
        if (e.stopPropagation) e.stopPropagation();
        else e.cancelBubble = true;
        // toastr.success(type);
        id_ymSelect =id_ym;
        debugger;
        if(type =="query"){
            $("[name='ym']").removeClass("activeYm");
            $("#ym_"+id_ymSelect).addClass("activeYm");
            getCxkj(id_ymSelect);
            getBg(id_ymSelect);
        }else if(type == "edit" || type == "add"){
            viewPwindowcxkj = new PWindow({
                url:"./editYmInit?id_ym="+id_ym+"&type="+type,
                title: '页面名称修改',
                size:"size-wide",
                buttons: [
                    {
                        label: '保存',
                        action:function (dialogRef) {
                            editYmInfo();
                        }
                    },
                    {
                        label: '关闭',
                        action:function (dialogRef) {
                            dialogRef.close();
                        }
                    }],
                ondestroy: function (action) {
                    getYm();
                }
            });
        }else if(type == "del"){
            if(lx =='0'){
                toastr.warning('模板不能删除');
                return;
            }
            MyConfirm.confirm({ message: "确认是否删除？"}).on(function (e) {
                if(!e){
                    return;
                }
                loadMessage();
                var request = new HttpRequest("actionYm", "post", {
                    onRequestSuccess: function (responseText) {
                        hideMessage();
                        if (responseText != "success") {
                            alertMsg(responseText);
                        }else{
                            toastr.success("删除完成！");
                            getYm();
                        }
                    }
                });
                request.addParameter("type", type);//
                request.addParameter("id_ym", id_ym);//
                request.sendRequest();
            });
        }else if(type == "fw"){
            ymFwContent = layer.open({
                type: 2,
                title: mc_ym,
                shadeClose: true,
                shade: false,
                maxmin: true, //开启最大化最小化按钮
                area: ['893px', '600px'],
                content: '../biaction/init?noFrame=1&id_ym='+id_ym
            });
            layer.full(ymFwContent);
        }
    }
    /**/
    var viewPwindowcxkj
    //编辑控件、状态控制、删除
    function cxkjSelect(id_cxkj,type,zt){

        if(type == "edit" || type == "add"){
            viewPwindowcxkj = new PWindow({
                url:"./editCxkjInit?id_cxkj="+id_cxkj+"&type="+type+"&id_ym="+reqParam.id_ym,
                title: '控件详情修改',
                size:"size-wide",
                buttons: [
                    {
                        label: '保存',
                        action:function (dialogRef) {
                            editCxkjInfo();
                        }
                    },
                    {
                        label: '关闭',
                        action:function (dialogRef) {
                            dialogRef.close();
                        }
                    }],
                ondestroy: function (action) {
                    getCxkj(id_ymSelect);
                }
            });
        }else if(type == "zt" || type == "del"){
            var  czlx="删除";
            if(type == "zt"){
                if(zt == 1){
                    czlx="停用";
                }else{
                    czlx="启用";
                }
            }
            MyConfirm.confirm({ message: "确认是否"+czlx+"？"}).on(function (e) {
                if(!e){
                    return;
                }
                loadMessage();
                var request = new HttpRequest("actionCxkj", "post", {
                    onRequestSuccess: function (responseText) {
                        hideMessage();
                        if (responseText != "success") {
                            alertMsg(responseText);
                        }else{
                            toastr.success(czlx+"完成！");
                            getCxkj(id_ymSelect);
                        }
                    }
                });
                request.addParameter("type", type);//
                request.addParameter("id_cxkj", id_cxkj);//
                if(zt == 1){
                    zt=0;
                }else{
                    zt=1;
                }
                request.addParameter("zt", zt);//
                request.sendRequest();
            });
        }
    }
    var bgAddContent;
    function  addBg() {
        bgAddContent = new PWindow({
            url:"editBgInit?type=add"+"&id_ym="+id_ymSelect,
            title: '表格详情修改',
            size:"size-wide",
            buttons: [
                {
                    label: '保存',
                    action:function (dialogRef) {
                        editbgInfo();
                    }
                },
                {
                    label: '关闭',
                    action:function (dialogRef) {
                        dialogRef.close();
                    }
                }],
            ondestroy: function (action) {
                getBg(id_ymSelect);
            }
        });
    }
    var bgContent;
    function bgSelect(id_bg,type,zt){
        if(type == "edit" ){
            bgContent = layer.open({
                type: 2,
                title: '表格配置',
                shadeClose: true,
                shade: false,
                maxmin: true, //开启最大化最小化按钮
                area: ['893px', '600px'],
                content: '../bgsj/initBg?noFrame=1&id_bg='+id_bg+'&type='+type+'&id_ym='+id_ymSelect,
                end:function () {
                    // getBg(id_ymSelect);
                }
            });
            layer.full(bgContent);
            /*bgContent = new PWindow({
                url:'../bgsj/initBg?noFrame=1&id_bg='+id_bg+'&type='+type+'&id_ym='+id_ymSelect,
                title: '表格配置',
                size:"size-wide",
                buttons: [
                    {
                        label: '关闭',
                        action:function (dialogRef) {
                            dialogRef.close();
                            getBg(id_ymSelect);
                        }
                    }],
                ondestroy: function (action) {
                    getBg(id_ymSelect);
                }
            });*/
        }else if(type == "zt" || type == "del"){
            var  czlx="删除";
            if(type == "zt"){
                if(zt == 1){
                    czlx="停用";
                }else{
                    czlx="启用";
                }
            }
            MyConfirm.confirm({ message: "确认是否"+czlx+"？"}).on(function (e) {
                if(!e){
                    return;
                }
                loadMessage();
                var request = new HttpRequest("actionBg", "post", {
                    onRequestSuccess: function (responseText) {
                        hideMessage();
                        if (responseText != "success") {
                            toastr.warning(responseText);
                        }else{
                            toastr.success(czlx+"完成！");
                            getBg(id_ymSelect);
                        }
                    }
                });
                request.addParameter("type", type);//
                request.addParameter("id_bg", id_bg);//
                request.addParameter("id_ym", id_ymSelect);//
                if(zt == 1){
                    zt=0;
                }else{
                    zt=1;
                }
                request.addParameter("zt", zt);//
                request.sendRequest();
            });
        }

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