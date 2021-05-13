<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script language="javascript" src="${basePath}/asserts/js/plugins/bootstrap-datepicker/bootstrap-datepicker.js"></script>
<script language="javascript" src="${basePath}/asserts/js/plugins/bootstrap-multiselect/bootstrap-multiselect.js"></script>
<link rel="stylesheet" type="text/css" href="${basePath}asserts/js/plugins/bootstrap-multiselect/bootstrap-multiselect.css"/>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<style>
    /*表格内容滚动，不换行显示*/
    td{
        white-space:nowrap;
        overflow:hidden;
        word-break:keep-all;
    }
</style>
<div class="panel-body" id="body_bi">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">查询条件</div>
                    <div class="box-tools">
                        <button type="button" class="btn btn-default btn-sm"  onclick="cx()">查询</button>
                        <button type="button" class="btn btn-default btn-sm " onclick="dc()">导出</button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal">
                        <div class="form-group" >
                            <div class="col-mr" id="col_cxtj">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row" id="tables_bi">

    </div>
</div>
<script type="text/javascript">
    var UrlParams={};//因为升级页面跳转，这里获取所有参数
    var reqParam={};
    var baseURL = '${basePath}';
    var tables=[] ;
    var cxkj=[];
    var cxkjMap = new HashMap();
    var tableColumsMap = new HashMap();
    var tableHblsMap = new HashMap();
    var viewPwindow;
    //页面初始化
    $(document).ready(function(){
        initUrlParams();
        // reqParam.id_ym=$('#id_ym').val();
        cshBg();//先初始表格，保证控件change事件能找到表格id
        cshCxtjkj();
    });
    function  cshBg() {//初始化表格
        var tableNew = $(".tableNew");
        if(tableNew){
            $(".tableNew").remove();
        }
        $.ajax({
            url:'./queryBgList',
            async: false,//改为同步方式
            type:"post",
            data:reqParam,
            dataType:"json",
            success:function(responseText){
                var jsonObject  = eval(responseText);
                if(jsonObject.length > 0){
                    tables=jsonObject;
                    $.each(jsonObject,function(index,value){
                        var html_table="<div class=\"col-md-"+value.bjkdbl+" both-pd7 tableNew\">\n" +
                            "            <div class=\"tab-pane fade in active\">\n" +
                            "                <div class=\"box win-box\">\n" +
                            "                    <div class=\"box-header\">\n" +
                            "                        <div class=\"box-title\">"+value.mc+"</div>\n" +
                            "                    </div>\n" +
                            "                    <div class=\"box-body\" style=\"overflow: auto;\" id=\"out_table_"+value.id+"\">\n" +
                            "                        <table class=\"table-container\" id=\"table_"+value.id+"\">\n" +
                            "                        </table>\n" +
                            "                    </div>\n" +
                            "                </div>\n" +
                            "            </div>\n" +
                            "    </div>";
                        $("#tables_bi").append(html_table);
                    });
                }
            },
            error:function(data){
                console.log("获取查询条件异常！")
            }
        });
    }
    function  cshCxtjkj() {//初始化控件
        $.ajax({
            url:'./queryCxtjList',
            async: false,//改为同步方式
            type:"post",
            data:reqParam,
            dataType:"json",
            success:function(responseText){
                var jsonObject  = eval(responseText);
                $("#col_cxtj").empty();
                if(jsonObject.length > 0){
                    cxkj=jsonObject;
                    $.each(jsonObject,function(index,value){
                        $("#col_cxtj").append(value.html);
                        cxkjMap.put(value.code,value);
                    });
                    $.each(jsonObject,function(index,value){
                        debugger;
                        if(value.lx=="xldx"){
                            $("#"+value.code).multiselect({
                                // 自定义参数，按自己需求定义
                                nonSelectedText : '-请选择-',
                                selectAllText:'全选',
                                allSelectedText:'全选',
                                nSelectedText: '个被选中',
                                maxHeight : 350,
                                includeSelectAllOption : true,
                                numberDisplayed : 3
                            });
                        }
                    });
                    //初始化控件值，初始化第一个，其他的默认需要onchange事件
                    var valueF = jsonObject[0];
                    if( !isNull(valueF.csz)){
                        $("#"+valueF.code).val(valueF.csz);
                    }else{
                        changeFist(valueF.code);
                    }
                    if(valueF.lx=="sj"){
                        $("#"+valueF.code).datepicker({
                            format: valueF.gs,
                            minViewMode: 2,
                            autoclose : true
                        });
                    }
                }else{//适配无查询条件的情况
                    cx();
                }
            },
            error:function(data){
                console.log("获取查询条件异常！")
            }
        });
    }
    /**/
    function change(kjid,obj) {
        var cxkjIdCu=obj.id;
        var cxkjValueCu=obj.value;
        var cxkjCu=cxkjMap.get(cxkjIdCu);//获取触发的控件
        if(!isNull(cxkjCu.lx) && isNull(cxkjValueCu)){//非普通文本
            toastr.warning(cxkjCu.mc+"不能为空");
            return;
        }
        reqParam.kjid=kjid;//后端更加这个kjid动态取数
        //控件change的时候把自己的值赋给reqParam
        if(cxkjCu.lx =="xldx"){
            var  multiValue = [];
            $("#"+cxkjIdCu+" option:selected").each(function () {
                multiValue.push($(this).val());
            });
            reqParam[cxkjIdCu]= multiValue.join(",");
        }else{
            reqParam[cxkjIdCu]=$('#'+cxkjIdCu).val();
        }
        initKj(kjid);
    }
    function changeFist(kjid) {
        reqParam.kjid=kjid;//后端更加这个kjid动态取数
        initKj(kjid);
    }
    function initKj(kjid) {
        $.ajax({
            url:'./change',
            async: false,//改为同步方式
            type:"post",
            data:reqParam,
            dataType:"json",
            success:function(responseText){
                var jsonObject  = eval(responseText);
                var kj  =jsonObject.kj;
                var kjValueList  = jsonObject.kjValueList;
                $("#"+kjid).empty();
                if(kj.lx=="sj"){
                    if(kjValueList.length > 0){
                        $("#"+kjid).val(kjValueList[0].value);
                    }
                }else if(kj.lx=="xldx"){
                    if(kjValueList.length > 0){
                        $.each(kjValueList,function(index,value){
                            if(index == 0){
                                $("#"+kjid).append('<option selected="selected" value='+value.value+'>'+value.name+'</option>');
                            }else{
                                $("#"+kjid).append('<option  value='+value.value+'>'+value.name+'</option>');
                            }
                        });
                    }else{
                        $("#"+kjid).append("<option value=''>-请选择-</option>");
                    }
                    $("#"+kjid).multiselect("destroy").multiselect({
                        // 自定义参数，按自己需求定义
                        nonSelectedText : '-请选择-',
                        selectAllText:'全选',
                        allSelectedText:'全选',
                        nSelectedText: '个被选中',
                        maxHeight : 350,
                        includeSelectAllOption : true,
                        numberDisplayed : 3
                    });
                }else{
                    if(kjValueList.length > 0){
                        $.each(kjValueList,function(index,value){
                            $("#"+kjid).append('<option  value='+value.value+'>'+value.name+'</option>');
                        });
                    }else{
                        $("#"+kjid).append("<option value=''>-请选择-</option>");
                    }
                }
                $("#"+kjid).change();
            },
            error:function(data){
                console.log("获取查询条件异常！")
            }
        });
    }
    function cx() {
        debugger;
        for (let i = 0; i < cxkj.length; i++) {
            var cxkjid = cxkj[i].code;
            if(!isNull(cxkj[i].lx) &&isNull($('#'+cxkjid).val())){
                toastr.warning( cxkj[i].mc+"不能为空");
                return;
            }
            if(cxkj[i].lx =="xldx"){
                var  multiValue = [];
                $("#"+cxkjid+" option:selected").each(function () {
                    // multiValue.push("'"+$(this).val()+"'");
                    multiValue.push($(this).val());
                });
                reqParam[cxkjid]= multiValue.join(",");
            }else{
                reqParam[cxkjid]=$('#'+cxkjid).val();
            }
        }
        cshBg();
        for (let i = 0; i < tables.length; i++) {
            var tableId = tables[i].id;
            queryTable(tables[i]);
        }
    }
    function dc(){
        var filename;
        for (let i = 0; i < tables.length; i++) {
            filename = tables[i].mc;
            var tableId = tables[i].id;
            var showFooter =  tables[i].showFooter==1?true:false;
            if(showFooter){
                $('#out_table_'+tableId).find('table:eq(1),table:eq(2)').tableExport({type:'excel',escape: 'false',fileName:filename});
            }else {
                $('#out_table_'+tableId).find('table:eq(1)').tableExport({type:'excel',escape: 'false',fileName:filename});
            }
        }
    }
    var tableData;
    function queryTable(table) {
        debugger;
        var tableid = table.id;
        reqParam.id_bg=tableid;
        initTableColums(table);//
        initTable(table);
    }
    function initTableColums(table){
        var tableid = table.id;
        var dbglzd = table.dbglzd;
        if(!isNull(dbglzd)){
            dbglzd=dbglzd.replaceAll("{","").replaceAll("}","");
        }
        var dbglnr = table.dbglnr;
        var dblx = table.dblx;
        var  hbls= [];
        var dabhColumns = [];
        $.ajax({
            url: 'getColums',
            async: false,//改为同步方式
            type: 'post',
            dataType: 'json',
            data:reqParam
        }).done(function (resultDatas) {
            //渲染数据
            $.each(resultDatas,function (index,bt) {
                var  dabhColumnsTemp = [];
                $.each(bt,function (index,column) {
                    if(column.hb == 1){//哪些需要合并
                        hbls.push(column.clfield)
                    }
                    dabhColumnsTemp.push({
                        field: column.clfield,
                        title: column.cltitle,
                        colspan: column.colspan,
                        rowspan: column.rowspan,
                        align: 'center',
                        valign: 'middle',
                        formatter : function (value, row, index){
                            var mrz =column.mrz;
                            if(isNull(mrz)){//默认值
                                mrz=0;
                            }
                            if(isNull(value)){//默认值
                                value=mrz;
                            }
                            if(column.gshlx==0){//普通默认
                                return value;
                            }else if(column.gshlx==1){//序号
                                return index + 1;
                            }else if(column.gshlx==2){//超链接
                                var field = this.field;
                                var title = this.title;
                                return "<a href=\"javascript:;\"" +
                                    " onclick=\"showDetail('"+column.gs+"','"+(JSON.stringify(column).replace(/\"/g, "&quot;").replace(/\'/g, "\\\'"))+"','"+row.key_id+"','"+field+"','"+title+"','"+row[field]+"\')\">"
                                    +value +"&nbsp;&nbsp;<i class=\"fa fa-hand-o-down\"></i></a>";
                            }else {
                                return value;//普通默认
                                // return "<div style='width:150px'>"+value+"</div> " ;
                            }
                        },
                        footerFormatter:function (data) {
                            var result;
                            var field = this.field;
                            var rowvalue;
                            var dbgs=column.dbgs;
                            if(column.dbgshlx ==0){
                                return column.dbgs;
                            }else if(column.dbgshlx ==1){//分隔计算
                                if (isNull(dbgs)){
                                    result = data.reduce(function(sum, row) {
                                        rowvalue = row[field];
                                        if (isNull(rowvalue)){
                                            rowvalue=0;
                                        }else if(!isNull(dbglzd) && !isNull(dbglnr) && (row[dbglzd]+"").indexOf(dbglnr)>-1 ){
                                            rowvalue=0
                                        }
                                        return sum +parseInt(rowvalue) ;
                                    }, 0);
                                    if(dblx==2) {//平均
                                        result= result/data.length;
                                    }
                                    result= result.toFixed(2);
                                }else{
                                    var resultLeft = data.reduce(function(sum, row) {
                                        rowvalue = row[field];
                                        if (isNull(rowvalue)){
                                            rowvalue=0;
                                        }else if(!isNull(dbglzd) && !isNull(dbglnr) && (row[dbglzd]+"").indexOf(dbglnr)>-1){
                                            rowvalue=0
                                        }else{
                                            rowvalue=rowvalue.toString().split(dbgs)[0];
                                        }
                                        if (isNull(rowvalue)){
                                            rowvalue=0;
                                        }
                                        return sum + rowvalue*1;
                                    }, 0);
                                    var resultRight = data.reduce(function(sum, row) {
                                        rowvalue = row[field];
                                        if (isNull(rowvalue)){
                                            rowvalue=0;
                                        }else if(!isNull(dbglzd) && !isNull(dbglnr) && (row[dbglzd]+"").indexOf(dbglnr)>-1){
                                            rowvalue=0
                                        }else if(rowvalue.toString().split(dbgs).length==2){
                                            rowvalue=rowvalue.toString().split(dbgs)[1];
                                        }else {
                                            rowvalue=0;
                                        }
                                        if (isNull(rowvalue)){
                                            rowvalue=0;
                                        }
                                        return sum + rowvalue*1;
                                    }, 0);
                                    if(dblx==2){//平均
                                        resultLeft = resultLeft/data.length;
                                        resultRight = resultRight/data.length;
                                    }
                                    result=resultLeft.toFixed(2)+""+dbgs+resultRight.toFixed(2);
                                }
                                return result;
                            }
                        }
                    });
                })
                dabhColumns.push(dabhColumnsTemp);
            })
            console.log("dabhColumns:"+dabhColumns);
        }).fail(function () {
        }).always(function () {
        })
        tableColumsMap.remove(tableid);
        tableHblsMap.remove(tableid);
        tableColumsMap.put(tableid,dabhColumns);
        tableHblsMap.put(tableid,hbls);
    }
    function initTable(table) {
        var tableid = table.id;
        var height = table.height;
        if(isNull(height) || height==0){
            height=450;
        }
        var showFooter = table.showFooter==1?true:false;
        var pagination = table.pagination==1?true:false;
        var pageSizeMax = table.pageSizeMax;
        //动态设置每页最大记录数，方便导出
        var pageList =[10,20,50,100];
        if(pageSizeMax && pageList.includes(pageSizeMax) >-1){
            pageList.push(pageSizeMax);
        }
        //
        var dabhColumns = tableColumsMap.get(tableid);
        var hbls = tableHblsMap.get(tableid);
        var resultTable = $('#table_'+tableid).bootstrapTable('destroy').bootstrapTable({
            method : 'GET',
            url:"./bgData",
            contentType: "application/x-www-form-urlencoded",
            columns: dabhColumns,
            showFooter:showFooter,
            search:true,
            height: height,
            showHeader: true,
            striped: true, //表格显示条纹
            pagination: pagination, //启动分页
            sortable: false,                     //是否启用排序
            pageNumber: 1, //当前第几页
            pageSize: 20, //每页显示的记录数
            smartDisplay:false,  // 分页样式统一
            pageList: pageList, //记录数可选列表
            search: false, //是否启用查询
            showColumns: false, //显示下拉框勾选要显示的列
            showRefresh: false, //显示刷新按钮
            onlyInfoPagination: false,
            //得到查询的参数
            queryParams : function (params) {
                //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                return reqParam;
            },
            onLoadSuccess: function (data) {
                console.log("onLoadSuccess");
                tableData=data;
                if (data.length > 0 && hbls.length>0) {
                    for (let i = 0; i <hbls.length ; i++) {
                        mergeCells(data, hbls[i], 1, $('#table_'+tableid));
                    }
                }

            },
            onPageChange:function(number, size){
                console.log("onPageChangeSuccess");
                if (tableData.length > 0 && hbls.length>0) {
                    for (let i = 0; i <hbls.length ; i++) {
                        mergeCells(tableData, hbls[i], 1, $('#table_'+tableid));
                    }
                }
            },
            onSort:function(name,order){
            },
            onAll:function (name, args) {
                console.log("onAll:"+name);
            },
            formatNoMatches: function(){
                return "没有相关的匹配结果";
            },
            onPostBody: function (data) {
                //合并页脚 暂时没处理
                // merge_footer('out_table_'+tableid);
            }
        });
    }
    function showDetail(url,column,key_id,field,title,fieldVule) {
        if(url.indexOf("?")==-1){
            url = url+"?1=1";
        }
        if(url.indexOf("=")==-1){
            url = url+"1=1";
        }
        url =url+"&noFrame=1";
        for (var r in reqParam) {
            url=changeUrlArg(url,r,reqParam[r]);
        }
        url=changeUrlArg(url,"key_id",key_id);
        url=changeUrlArg(url,"field",field);
        url=changeUrlArg(url,"fieldVule",fieldVule);
        var column_=JSON.parse(column);
        for (var c in column_){
            url=changeUrlArg(url,c,column_[c]);
        }
        var content = layer.open({
            type: 2,
            title: title,
            shadeClose: true,
            shade: false,
            resizable:true,
            maxmin: true, //开启最大化最小化按钮
            area: ['893px', '600px'],
            content: encodeURI( url)
        });
    }

    //获取登录页面传递的URL并提取出其中的参数
    function initUrlParams() {
        var tmpArr, QueryString,pair;
        var testpaperName;
        var URL = document.location.toString(); //获取带参数的URL
        if(URL.lastIndexOf("?") != -1) {
            QueryString = URL.substring(URL.lastIndexOf("?") + 1, URL.length);
            tmpArr = QueryString.split("&"); //分离参数
            console.log(tmpArr.length);
            for(i = 0; i < tmpArr.length; i++) {
                pair = tmpArr[i].split("=");
                if(pair.length=2){
                    UrlParams[pair[0]]=pair[1];
                    reqParam[pair[0]]=pair[1];
                }
            }
        }
    }
    //替换参数值 取最新的
    function changeUrlArg(url, arg, val){
        var pattern = arg+'=([^&]*)';
        var replaceText = arg+'='+val;
        return url.match(pattern) ? url.replace(eval('/('+ arg+'=)([^&]*)/gi'), replaceText) : (url.match('[\?]') ? url+'&'+replaceText : url+'?'+replaceText);
    }
    function  isNull(rowvalue) {
        if (rowvalue==null || rowvalue==undefined || rowvalue.length==0 ){
            return true
        }else {
            return false;
        }
    }
    //合并列
    function mergeCells(data,fieldName,colspan,target){
        //声明一个map计算相同属性值在data对象出现的次数和
        var sortMap = {};
        for(var i = 0 ; i < data.length ; i++){
            for(var prop in data[i]){
                if(prop == fieldName){
                    var key = data[i][prop]
                    if(sortMap.hasOwnProperty(key)){
                        sortMap[key] = sortMap[key] * 1 + 1;
                    } else {
                        sortMap[key] = 1;
                    }
                    break;
                }
            }
        }
        /*for(var prop in sortMap){
            console.log(prop,sortMap[prop])
        }*/
        var index = 0;
        for(var prop in sortMap){
            var count = sortMap[prop] * 1;
            $(target).bootstrapTable('mergeCells',{index:index, field:fieldName, colspan: colspan, rowspan: count});
            index += count;
        }
    }
    //合并页脚
    function merge_footer(id_out_table_div) {
        //获取table表中footer 并获取到这一行的所有列
        var footer_tbody = $('#'+id_out_table_div+' .fixed-table-footer table tbody');
        var footer_tr = footer_tbody.find('>tr');
        var footer_td = footer_tr.find('>td');
        var footer_td_1 = footer_td.eq(0);
        var footer_td_2 = footer_td.eq(1);//隐藏第二列
        footer_td_2.hide();
        footer_td_1.attr('colspan', 2).show();
        //这里可以根据自己的表格来设置列的宽度 使对齐
        footer_td_1.attr('width', "910px").show();
    }
</script>