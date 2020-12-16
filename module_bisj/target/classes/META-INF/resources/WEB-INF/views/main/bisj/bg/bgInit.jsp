<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<script type="text/javascript" src="${basePath}asserts/js/confirm/confirm.js" ></script>
<style>
    .changeColor{
        background-color: #fdf495  !important;
        color: black;
    }
</style>
<!--panel-body开始-->
<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">查询条件</div>
                    <div class="box-tools">
                        <button  class="btn btn-default btn-sm" onclick="initTable()" style="margin-left:5px ">查询</button>
                        <button  class="btn btn-default btn-sm" onclick="editBg()" style="margin-left:5px ">修改</button>
                    </div>
                </div>
                <div class="box-body">
                    <!-- 这个部分是需要关注的：查询的表单正文区域 -->
                    <div class="form-horizontal">
                        <div class="form-group">
                            <div class="col-mr">
                                <label class="col-lg-1 col-md-2 control-label">表格:</label>
                                <div class="col-lg-2 col-md-4">
                                    <select class="form-control input-sm" id="bg" name="bg" onchange="initTable()" >
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- form结束 -->
                </div>
            </div>
            <!--搜索查询区结束-->
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 both-pd7">
            <div class="box win-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">表头列列表</div>
                    <div class="box-tools">
                        <button   class="btn btn-default btn-sm" onclick="addOreditBtl('add')" style="margin-left:5px ">新增</button>
                        <button   class="btn btn-default btn-sm" onclick="addOreditBtl('edit')" style="margin-left:5px ">修改</button>
                        <button   class="btn btn-default btn-sm" onclick="addOreditBtl('del')" style="margin-left:5px ">删除</button>
                    </div>
                </div>
                <div class="box-body" style="overflow: auto;">
                    <table  class="table-container" id="table_btl">
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12 both-pd7">
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">数据源</div>
                    <div class="box-tools">
                        <button type="button" class="btn btn-default btn-sm" onclick="bsjSelect('','add',1)">新增</button>
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
                        <div id="result_bsj" style="overflow-y: auto;overflow-x:hidden;" ></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--  临时数据域--%>
<input type="hidden"  id="curBtlid" value=0>
<input type="hidden"  id="cuBtljb" value=0>
<input type="hidden"  id="sjBtlid" value=0>

<%-- bootStrap table默认样式修改区--%>
<style>
</style>
<%--引入执行js--%>
<link rel="stylesheet" href="${basePath}asserts/css/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}asserts/css/jquery.treegrid.min.css">

<script type="text/javascript" src="${basePath}asserts/js/bootstrap-table.min.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/bootstrap-table-treegrid.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/jquery.treegrid.min.js"></script>
<input type="hidden" id="_id_bg" name="id_bg" value="${id_bg}">
<input type="hidden" id="_id_ym" name="id_ym" value="${id_ym}">
<script type="text/javascript">
    var $resultTable= $("#table_btl");
    var tableId = document.getElementById("table_btl");
    var reqParam = {};
    var id_bgSelect;
    $(function() {
        getBgs();
    });
    function getBgs() {
        $.ajax({
            url: '../bgsj/queryBgList',
            type: "post",
            data: {"id_bg": $("#_id_bg").val()},
            dataType: "json",
            success: function (responseText) {
                var jsonObject = eval(responseText);
                $("#bg").empty();
                if (jsonObject.length > 0) {
                    $.each(jsonObject, function (index, value) {
                        $('#bg').append('<option  value=' + value.id + '>' + value.mc + '</option>');
                    });
                } else {
                    $("#bg").append("<option value=''>-请选择-</option>");
                }
                $("#bg").change();
            },
            error: function (data) {
                console.log("获取表格异常！")
            }
        });
    }
    //定义全局排序变量
    var i=1;

    var viewPwindowbg;
    //编辑表格基础信息
    var editBg = function () {
        viewPwindowbg = new PWindow({
            url:"../bisj/editBgInit?id_bg="+id_bgSelect+"&type=edit"+"&id_ym="+$('#_id_ym').val(),
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
                getBgs();
            }
        });
    }
    //初始化表格
    var initTable = function(index){
        id_bgSelect=$("#bg").val();
        reqParam.id_bg = id_bgSelect;
        getBsj(id_bgSelect);
        $("#curBtlid").val(0);
        $("#sjBtlid").val(0);
        $("#cuBtljb").val(0);
        //
        $("#table_btl").bootstrapTable('destroy');  //先清空表格，然后重新加载
        $("#table_btl").bootstrapTable({
            method: "get",
            url:'../bgsj/getAllBtl?id_bg='+$("#bg").val(),
            pagination: false,                   //是否显示分页（*）
            sortable: false,                     //是否启用排序
            idField: 'id',
            dataType:'json',
            maxHeight:300,
            contentType: 'application/json',
            treeShowField:'text',               //在哪一列展开树形
            parentIdField:'parent',             //指定父id列
            onClickRow:function (row,$element) { //点击行，改变背景颜色
                debugger;
                $('.changeColor').removeClass('changeColor');
                $($element).addClass('changeColor');
                var length=$resultTable.bootstrapTable('getData').length;
                var rowindex = 0;
                for(var j=1;j<length+1;j++){
                    if(tableId.rows[j].cells[1].innerHTML == row.id){
                        rowindex = j;
                        console.log(rowindex);
                        break;
                    }
                }
                //存储选中行的数据信息
                $("#curBtlid").val(row.id);
                $("#sjBtlid").val(row.id_sjcl);
                $("#cuBtljb").val(row.btjb);
            },
            columns: [
                {   title: '序号',
                    formatter: 'operateFormatter'
                },
                {   field:'id',
                    title: 'id',
                    align: 'center'
                },
                {   field:'clfield',
                    title: '表头列编码',
                    align: 'center'
                },
                {   field:'text',
                    title: '表头列名称',
                    align: 'left',
                    formatter:function (value, row, index) {
                        return '<span id="'+row.id+'">'+row.text+'</span>';
                    }
                },
                {   field: 'btjb',
                    title: '表头级别',
                    align: 'center'
                },
                {   field: 'sjylx',
                    title: '数据源类型',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='普通';
                        if(value=='1'){
                            resRep='动态';
                        }
                        return resRep;
                    }
                },
                {   field: 'gshlx',
                    title: '格式化类型',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='常规';
                        if(value=='1'){
                            resRep='序号';
                        }else if(value=='2'){
                            resRep='超链接';
                        }
                        return resRep;
                    }
                },
                {   field: 'rowspan',
                    title: '跨行数',
                    align: 'center'
                },
                {   field: 'dbgshlx',
                    title: '底部类型',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='普通文本';
                        if(value=='1'){
                            resRep='格式化';
                        }
                        return resRep;
                    }
                },
                {   field: 'sx',
                    title: '顺序',
                    align: 'center'
                },
                {   field: 'zt',
                    title: '状态',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='停用';
                        if(row.zt=='1'){
                            resRep='正常';
                        }
                        return resRep;
                    }
                }
            ],
            onResetView: function(data) {
                var state = index=='1'?'expanded':'collapsed';        //判断机构树展开和关闭状态，如果是根据名称查询，就全展，否则关闭
                $resultTable.treegrid({
                    initialState: state,// 所有节点都折叠，'expanded' 默认展开
                    treeColumn: 2,        //选择某一行就行展开
                    expanderExpandedClass: 'glyphicon glyphicon-folder-open',  //图标样式
                    expanderCollapsedClass:'glyphicon glyphicon-folder-close',
                    onChange: function() {
                        $resultTable.bootstrapTable('resetWidth');
                    },onExpand:function () {

                    }
                });
            },
            onLoadSuccess:function () {
                i=1;
                var length=$resultTable.bootstrapTable('getData').length;
                $("#curLengthOfTree").val(length);
            }
        });
    }

    //新增表头列
    var grid;
    //修改表头列
    function addOreditBtl(type){
        if(type=="del"){
            if($("#curBtlid").val()==0){
                alertMsg("请选择需要删除的数据!");
                return;
            }
            MyConfirm.confirm({ message: "确认是否删除？"}).on(function (e) {
                if(!e){
                    return;
                }
                loadMessage();
                var request = new HttpRequest("../bgsj/actionBtl", "post", {
                    onRequestSuccess: function (responseText) {
                        hideMessage();
                        if (responseText != "success") {
                            alertMsg(responseText);
                        }else{
                            toastr.success("删除完成！");
                            initTable(1);
                        }
                    }
                });
                request.addParameter("type", type);//
                request.addParameter("id_btl", $("#curBtlid").val());//
                request.addParameter("id_bg", $("#bg").val());
                request.sendRequest();
            });
        }else {
            var tiltle ="新增";
            if(type=="edit"){
                tiltle="编辑";
                if($("#curBtlid").val()==0){
                    alertMsg("请选择需要修改的数据!");
                    return;
                }
            }
            var dialog = new PWindow({
                title:tiltle,
                url:"../bgsj/editBtlInit?id_sjcl="+$("#sjBtlid").val()+"&id_btl="+$("#curBtlid").val()+"&btjb="+$("#cuBtljb").val()+"&type="+type+"&id_bg="+$("#bg").val(),
                buttons: [
                    {
                        label: '保存',
                        action:function (dialogRef) {
                            //提交请求
                            submitFormBtl(dialogRef,grid,BootstrapDialog);
                            initTable(1);
                        }
                    },{
                        label: '关闭',
                        action:function (dialogRef) {
                            dialogRef.close();
                            initTable(1);
                        }
                    }],
                onDestroy:function (action) {
                    initTable(1);
                }
            });
        }
    }

    //序号重新排序，舍弃bs index下标排序
    function operateFormatter(value, row, index) {
        return (i++);
    }
    function getBsj(id_bg) {
        $("#result_bsj").html("");
        //只有报告类型为区县的时候才触发
        reqParam.id_bg = id_bg;
        loadMessage();
        var request = new HttpRequest("../bgsj/getBsjBg","post",{
            onRequestSuccess : function(responseText){
                hideMessage();
                $("#result_bsj").html(responseText);
            }
        });
        request.addParameter("id_bg",reqParam.id_bg);
        request.sendRequest();
    }
    /**/
    var viewPwindowbsj;
    //编辑表数据源、状态控制、删除
    function bsjSelect(id_bsj,type,zt){
        if(type == "edit" || type == "add"){
            viewPwindowbsj = new PWindow({
                url:"../bgsj/editBsjInit?id_bsj="+id_bsj+"&type="+type+"&id_bg="+reqParam.id_bg,
                title: '表数据源详情修改',
                size:"size-wide",
                buttons: [
                    {
                        label: '保存',
                        action:function (dialogRef) {
                            editBsjInfo();
                        }
                    },
                    {
                        label: '关闭',
                        action:function (dialogRef) {
                            dialogRef.close();
                        }
                    }],
                ondestroy: function (action) {
                    getBsj(id_bgSelect);
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
                var request = new HttpRequest("../bgsj/actionBsj", "post", {
                    onRequestSuccess: function (responseText) {
                        hideMessage();
                        if (responseText != "success") {
                            alertMsg(responseText);
                        }else{
                            toastr.success(czlx+"完成！");
                            getBsj(id_bgSelect);
                        }
                    }
                });
                request.addParameter("type", type);//
                request.addParameter("id_bsj", id_bsj);//
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
</script>