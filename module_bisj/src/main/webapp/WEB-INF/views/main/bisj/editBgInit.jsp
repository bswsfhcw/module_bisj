<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!--panel-body开始-->
<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <div class="box win-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">表头列表</div>
                </div>
                <div class="box-body">
                    <table id="table_btl">
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%--  临时数据域--%>
<input type="hidden"  id="curCddm">
<input type="hidden"  id="curYzjd">
<input type="hidden"  id="curIndex">

<%-- bootStrap table默认样式修改区--%>
<style>
    <%-- 修改table标准字图标颜色 --%>
    .glyphicon-folder-open{
        color: #f5cc66;
    }
    .glyphicon-folder-close{
        color: #f5cc66;
    }
    <%--  修改选中样式颜色，自定义选中背景颜色 --%>
    .changeColor{
        background-color: #fdf495  !important;
        color: black;
    }
    <%-- 控制表头字段居中--%>
    .fixed-table-container tbody td .th-inner, .fixed-table-container thead th .th-inner{
        text-align: center;
    }

    <%-- 修改窗口内容布局--%>
    .form-horizontal .form-group {
        margin-right: 50px;
        margin-left: 0px;
        padding-top: 6px;
    }
    #dialog_div{
        height: 240px !important;
    }
</style>
<%--引入执行js--%>
<link rel="stylesheet" href="${basePath}asserts/css/bootstrap-table.min.css">
<link rel="stylesheet" href="${basePath}asserts/css/jquery.treegrid.min.css">

<script type="text/javascript" src="${basePath}asserts/js/bootstrap-table.min.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/bootstrap-table-treegrid.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/jquery.treegrid.min.js"></script>

<script type="text/javascript">
    var $resultTable= $("#table_btl");
    var tableId = document.getElementById("table_btl");
    $(function() {
        initTable(0);
    });

    //定义全局排序变量
    var i=1;

    //初始化表格
    var initTable = function(index){
        $("#table_btl").bootstrapTable('destroy');  //先清空表格，然后重新加载

        $("#table_btl").bootstrapTable({
            method: "get",
            url:'getAllMenu?jlzt='+$("#jlzt").val()+"&cdmc="+$("#cdmc").val(),
            pagination: false,                   //是否显示分页（*）
            sortable: false,                     //是否启用排序
            idField: 'id',
            dataType:'json',
            contentType: 'application/json',
            treeShowField:'text',               //在哪一列展开树形
            parentIdField:'parent',             //指定父id列
            onClickRow:function (row,$element) { //点击行，改变背景颜色
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
                $("#curIndex").val(rowindex);
                $("#curCddm").val(row.id);
                $("#curYzjd").val(row.sfyzjd);
            },
            columns: [
                {   title: '序号',
                    width: 20,
                    formatter: 'operateFormatter'
                },
                {   field:'id',
                    width:20,
                    title: '菜单编码',
                    align: 'center'
                },
                {   field:'text',
                    width:200,
                    title: '菜单名称',
                    align: 'left',
                    formatter:function (value, row, index) {
                        return '<span id="'+row.id+'">'+row.text+'</span>';
                    }
                },
                {   field: 'cdlj',
                    width:200,
                    title: '访问路径',
                    align: 'center'
                },
                {   field: 'sfyzjd',
                    width:20,
                    title: '是否叶子节点',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='否';
                        if(row.sfyzjd=='1'){
                            resRep='是';
                        }
                        return resRep;
                    }
                },
                {   field: 'ljlx',
                    width:20,
                    title: '链接类型',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='内部链接';
                        if(row.sfyzjd=='1' && row.ljlx=='1'){
                            resRep='外部链接';
                        }
                        return resRep;
                    }
                },
                {   field: 'dkfs',
                    width:20,
                    title: '打开方式',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='同窗口打开';
                        if(row.dkfs=='1'){
                            resRep='新窗口打开';
                        }
                        return resRep;
                    }
                },
                {   field: 'cdsx',
                    width:20,
                    title: '菜单顺序',
                    align: 'center'
                },
                {   field: 'jlzt',
                    width:20,
                    title: '状态',
                    align: 'center',
                    formatter:function (value, row, index) {
                        var resRep='停用';
                        if(row.jlzt=='1'){
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

    //新增菜单
    var grid;
    function addMenu(){
        var cddm=$("#curCddm").val();
        var yzjd=$("#curYzjd").val();
        if(cddm == null || cddm == ""){
            alertMsg('请选择需要添加的节点！');
            return;
        }
        if(yzjd=="1"){
            alertMsg('请选择非叶子节点！');
            return;
        }
        var dialog = new PWindow({
            title:'新增',
            url:'editMenu?sjcdId='+cddm+'&type=add',
            buttons: [
                {
                    label: '保存',
                    action:function (dialogRef) {
                        //提交请求
                        submitFormBS(dialogRef,grid,BootstrapDialog);
                        dialogRef.close();
                    }
                },
                {
                    label: '关闭',
                    action:function (dialogRef) {
                        //关闭窗口
                        dialogRef.close();
                        //刷新
                        //initTable();
                    }
                }]
        });
    }

    //修改菜单
    function editMenu(){
        if($("#curCddm").val()==''){
            alertMsg("请选择需要修改的数据!");
            return;
        }

        var dialog = new PWindow({
            title:"修改",
            url:"editMenu?cddm="+$("#curCddm").val()+"&type=update",
            buttons: [
                {
                    label: '保存',
                    action:function (dialogRef) {
                        //提交请求
                        submitFormBS(dialogRef,grid,BootstrapDialog);
                        $("#edittype").val("1");
                        updateBootstrapTableRow($("#curCddm").val());
                        dialogRef.close();
                    }
                },{
                    label: '关闭',
                    action:function (dialogRef) {
                        dialogRef.close();
                        //保存后刷新页面
                        //initTable();
                    }
                }],
            onDestroy:function (action) {

            }
        });
    }

    function updateBootstrapTableRow(rowid){
        $.ajax({     //重新构建更新方法
            type: "get",
            url:"getNodeByCddm",
            data:{'cddm':rowid},
            dataType:'text',
            async: false,
            success: function (data) {
                console.log(data);
                var row = JSON.parse(data);
                var index = $("#curIndex").val();
                var tableId = document.getElementById("table_btl");
                if(row[0].jlzt != $("#jlzt").val()){
                    index = index - 1;
                    $("#table_btl").find("tbody").find("tr:eq("+index+")").remove();

                }else{
                    $("#"+row[0].id).text(row[0].text);
                    tableId.rows[index].cells[3].innerHTML = row[0].cdlj;
                    tableId.rows[index].cells[4].innerHTML = row[0].sfyzjd=='1'?'是':'否';
                    tableId.rows[index].cells[5].innerHTML = row[0].ljlx=='1'?'外部链接':'内部链接';
                    tableId.rows[index].cells[6].innerHTML = row[0].dkfs=='1'?'新窗口打开':'同窗口打开';
                    tableId.rows[index].cells[7].innerHTML = row[0].cdsx;
                    tableId.rows[index].cells[8].innerHTML = row[0].jlzt=='1'?'正常':'停用';
                }
            }
        });
    }
    //序号重新排序，舍弃bs index下标排序
    function operateFormatter(value, row, index) {
        return (i++);
    }

</script>