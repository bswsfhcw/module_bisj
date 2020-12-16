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
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">控件信息</div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal">
                        <fieldset>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>名称：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_mc" name="mc" maxlength="32" type="text" value="${bsjInfo.mc}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>类型：</label>
                                <div class="col-sm-4">
                                    <select id="_sjlx" name="sjlx" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${bsjInfo.sjlx eq 1}">selected="selected"</c:if> >辅助</option>
                                        <option  value="0"  <c:if test="${bsjInfo.sjlx eq 0}">selected="selected"</c:if> >基准</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>显示顺序：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_sx" name="sx" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="32" type="text" value="${bsjInfo.sx}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>启用状态：</label>
                                <div class="col-sm-4" style="margin-top: 5px;">
                                    <select id="_zt" name="zt" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${bsjInfo.zt eq 1}">selected="selected"</c:if> >在用</option>
                                        <option  value="0"  <c:if test="${bsjInfo.zt eq 0}">selected="selected"</c:if> >停用</option>
                                    </select>
                                    <%--<input id="_zt" name="zt" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${bsjInfo.zt eq 1}">checked="true"</c:if>>--%>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">参数说明：</label>
                                <div class="col-sm-10">
                                    数据源需要唯一列 key_id，标识记录的唯一性;行转列数据源规定按顺序key_value_从1开始<br>
                                    行转列规定格式{}_;数据源参数需要和查询控件编码保持一致;
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">数据源：</label>
                                <div class="col-sm-10">
                                    <textarea id="_sjy"  class="form-control" maxlength="2048" name="sjy" rows="10" <c:if test="${type eq 'query'}">disabled</c:if>>${bsjInfo.sjy}</textarea>
                                </div>
                                <label class="col-sm-2 control-label"></label>
                                <div  class="col-sm-5"><button class="col-sm-12" onclick="yzSy()">校验</button></div>
                                <div  class="col-sm-5"><button class="col-sm-12" onclick="openYl()">预览</button></div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">行转列可选项：</label>
                                <div class="col-sm-10">
                                    <textarea id="_kxx" class="form-control" maxlength="2048" name="kxx" rows="1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">clfield(行转列)：</label>
                                <div class="col-sm-8">
                                    <textarea id="_clfield" class="form-control" maxlength="2048" name="clfield" rows="1" <c:if test="${type eq 'query'}">disabled</c:if>>${bsjInfo.clfield}</textarea>
                                </div>
                                <div class="col-sm-2">
                                    <button type="button" class="btn btn-default btn-sm" style="background-color:#eb6841;border-color:#eb6841;color:#fff;" id="addCategory">新增项目</button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"></label>
                                <div class="col-sm-10">
                                    <div class="box-body" style="overflow: auto;">
                                        <table class="table table-hover" id="optionListTable" style="table-layout:fixed">
                                            <thead>
                                            <tr style="background-color:#3587d3;color: #fff;">
                                                <th>列cfield</th>
                                                <th>列取值</th>
                                                <th width="200">操作</th>
                                            </tr>
                                            </thead>
                                            <tbody id="optionTableTbody">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="_id_bg" value="${id_bg}">
<input type="hidden" id="_type_bsj" value="${type}">
<input type="hidden" id="_id_bsj" value="${bsjInfo.id}">

<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css"  href="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.css"/>

<script type="text/javascript">
    function delCategory(obj){
        $(obj).parent().parent().remove();
    }
    var reqPara={};
    var viewPwindowYl;
    function yzSy () {
        console.log("yzSy:");
        reqPara.sjy=$('#_sjy').val();
        $('#_kxx').text("");
        if(reqPara.sjy == null || reqPara.sjy.length==0){
            return;
        }
        loadMessage();
        debugger;
        $.ajax({
            url: '../bisj/sjyYz',
            type: 'POST',
            dataType: 'json',
            data: reqPara
        }).done(function (resultDatas) {
            hideMessage();
            if(resultDatas && resultDatas.result == 'success'){
                toastr.success(resultDatas.msg);
                $('#_kxx').text(resultDatas.colsStr);
            }else  if(resultDatas && resultDatas.result == 'sjy'){
                toastr.error("数据源非法->"+resultDatas.msg);
                return;
            }else {
                toastr.error("异常->"+resultDatas.msg);
            }
        }).fail(function () {
        }).always(function () {
        });
    };
    function openYl() {
        var data2=$("#_sjy").val();
        data2=data2.replace(/\%/g,"%25");
        data2=data2.replace(/\#/g,"%23");
        data2=data2.replace(/\&/g,"%26");
        viewPwindowYl = new PWindow({
            url:encodeURI( "../bisj/sjyYlInit?sjy="+data2),
            title: '数据源预览',
            size:"size-wide",
            buttons: [
                {
                    label: '关闭',
                    action:function (dialogRef) {
                        dialogRef.close();
                    }
                }],
            ondestroy: function (action) {
            }
        });
    }
    function kxx(){
        debugger;
        var _sjy = $('#_sjy').val();
        _sjy=_sjy.replace(/[\n\r]/g,' ');
        var _sjys = _sjy.match(/select(.+?)from/ig);
        var xxs="";
        for (let j = 0; j <_sjys.length ; j++) {
            var sjy =_sjys[j];
            sjy=sjy.substring(6,sjy.toUpperCase().indexOf('FROM'));
            var sjys=sjy.trim().split(",");
            for (let i = 0; i <sjys.length ; i++) {
                var sjyx = sjys[i].trim();
                var sjyxss = sjyx.split(" ");
                var sjyxs="";
                if(sjyxss.length==1){
                    sjyxs=sjyxss[0].substring(sjyxss[0].indexOf(".")+1,sjyxss[0].length);
                }else if(sjyxss.length==2){
                    sjyxs=sjyxss[1];
                }
                if(xxs.indexOf("{"+sjyxs+"}")==-1){
                    if(xxs.length>0){
                        xxs = xxs+" , ";
                    }
                    xxs = xxs+"{"+sjyxs+"}";
                }
            }
        }
        $('#_kxx').text(xxs);
    }
    $(function () {
        try {
            yzSy();
        }catch (e) {
            alert("kxx error");
        }
        $("#addCategory").click(function(){
            addCategory();
        });
        cshCategorys();
    });
    function cshCategorys() {
        var clfield= $('#_clfield').val();
        if(isNull(clfield)){
            return;
        }
        var clfields=clfield.trim().split(";");
        for (let i = 0; i < clfields.length; i++) {
            var xx=clfields[i];
            var category={};
            category.clfield=xx.split(":")[0];
            category.clvalue=xx.split(":")[1];
            addCategoryHasV(category);
        }

    }
    function addCategory() {
        var index = parseInt($("#optionTableTbody").children("tr:last-child").attr("id"))+1;
        var html = "<tr id='"+index+"'>";
        html+="<td><input type='text'  class='form-control input-sm text-center'/></td>";
        html+="<td><input type='text'  class='form-control input-sm text-center' maxlength='50'/></td>";
        html+="<td><a  class='blue' onclick='delCategory(this)' title='删除' style='cursor:pointer;'>删除</a></td>";
        html+="</tr>";
        $("#optionTableTbody").append(html);
    }
    function addCategoryHasV(category) {
        var index = parseInt($("#optionTableTbody").children("tr:last-child").attr("id"))+1;
        var html = "<tr id='"+index+"'>";
        html+="<td><input type='text' name='clfield' maxlength='16' class='form-control input-sm text-center' value=\""+category.clfield+"\"></td>";
        html+="<td><input type='text' name='clvalue' class='form-control input-sm text-center' maxlength='50' value=\""+category.clvalue+"\"></td>";
        html+="<td><a  class='blue' onclick='delCategory(this)' title='删除' style='cursor:pointer;'>删除</a></td>";
        html+="</tr>";
        $("#optionTableTbody").append(html);
    }
    function editBsjInfo(){
        if($.trim($("#_mc").val())==''){
            toastr.info("名称不能为空！");
            return;
        }
        if($.trim($("#_sx").val())==''){
            toastr.info("排序不能为空！");
            return;
        }
        if($.trim($("#_sjy").val())==''){
            toastr.info("数据源不能为空！");
            return;
        }
        var trList = $("#optionTableTbody").children("tr");
        var _clfields ="";
        var checkValueFlag = false;
        for (var i=0;i<trList.length;i++) {
            var _clfield="";
            var tdArr = trList.eq(i).find("td");
            var clfield = tdArr.eq(0).find("input").val();
            var clvalue = tdArr.eq(1).find("input").val();
            if(clfield==''||clvalue==''){
                checkValueFlag = true;
                break;
            }
            _clfield=clfield+":"+clvalue;
            if(_clfields.length>0){
                _clfields+=";";
            }
            _clfields+=_clfield
        }
        $("#_clfield").val(_clfields);
        if(checkValueFlag){
            toastr.error("新增clfield，clvalue不能为空！");
            return false;
        }
        loadMessage();
        var request = new HttpRequest("../bgsj/editBsjInfo", "post", {
            onRequestSuccess: function (responseText) {
            	hideMessage();
                if (responseText == "success") {
                    toastr.success("保存成功！");
                    // window.parent.initZbInfoTable();
                    // viewPwindowbsj.close();
                }else if(responseText =='exitName'){
                    toastr.error("保存失败！名称已存在！");
                }else if(responseText =='exitCode'){
                    toastr.error("保存失败！编码已存在！");
                }else{
                    toastr.error("保存失败！");
                }
            }
        });
        request.addParameter("id_bg", $("#_id_bg").val());
        request.addParameter("type", $("#_type_bsj").val());
        request.addParameter("id", $("#_id_bsj").val());
        request.addParameter("id_bsj", $("#_id_bsj").val());
        request.addParameter("mc", $("#_mc").val());
        request.addParameter("sjlx", $("#_sjlx").val());
        request.addParameter("sx", $("#_sx").val());
        request.addParameter("zt", $("#_zt").val());
        request.addParameter("sjy", $("#_sjy").val());
        request.addParameter("clfield", _clfields);

        request.sendRequest();
    }
    function  isNull(rowvalue) {
        if (rowvalue==null || rowvalue==undefined || rowvalue.length==0 ){
            return true
        }else {
            return false;
        }
    }
</script>

