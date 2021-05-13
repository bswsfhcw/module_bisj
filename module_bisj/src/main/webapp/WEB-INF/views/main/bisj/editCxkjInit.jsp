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
                                    <input class="form-control" onchange="buildHtml()"  id="_mc" name="mc" maxlength="32" type="text" value="${cxkjInfo.mc}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>编码：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" onchange="buildHtml()" id="_code"  name="code" maxlength="32" type="text" value="${cxkjInfo.code}"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>默认值：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_csz" name="csz" maxlength="32" type="text" value="${cxkjInfo.csz}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>类型：</label>
                                <div class="col-sm-4">
                                    <select id="_lx" name="lx" class="form-control" onchange="buildHtml()" editable="false" style="position: relative;">
                                        <option  value="xl"  <c:if test="${cxkjInfo.lx eq 'xl'}">selected="selected"</c:if> >下拉单选</option>
                                        <option  value="xldx"  <c:if test="${cxkjInfo.lx eq 'xldx'}">selected="selected"</c:if> >下拉多选</option>
                                        <option  value="sj"  <c:if test="${cxkjInfo.lx eq 'sj'}">selected="selected"</c:if> >时间</option>
                                        <option  value=""  <c:if test="${cxkjInfo.lx eq ''}">selected="selected"</c:if> >输入框</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>显示标签：</label>
                                <div class="col-sm-4">
                                    <select id="_iflabel" name="iflabel" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${cxkjInfo.iflabeleq eq 1}">selected="selected"</c:if> >显示</option>
                                        <option  value="0"  <c:if test="${cxkjInfo.iflabel eq 0}">selected="selected"</c:if> >不显示</option>
                                    </select>
                                    <%--<input id="_iflabel" name="iflabel" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${cxkjInfo.iflabel eq 1}">checked="true"</c:if>>--%>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>格式化：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_gs" name="gs" maxlength="32" type="text" value="${cxkjInfo.gs}"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>显示顺序：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_sx" name="sx" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="32" type="text" value="${cxkjInfo.sx}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>启用状态：</label>
                                <div class="col-sm-4" style="margin-top: 5px;">
                                    <select id="_zt" name="zt" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${cxkjInfo.zt eq 1}">selected="selected"</c:if> >在用</option>
                                        <option  value="0"  <c:if test="${cxkjInfo.zt eq 0}">selected="selected"</c:if> >停用</option>
                                    </select>
                                    <%--<input id="_zt" name="zt" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${cxkjInfo.zt eq 1}">checked="true"</c:if>>--%>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">参数说明：</label>
                                <div class="col-sm-10">
                                    控件编码、html控件id和数据源参数以及onchange的参数需要保持一致;<br>
                                    onchange->方法:change、cx;<br>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">控件源码(html)：</label>
                                <div class="col-sm-10">
                                    <textarea id="_html" class="form-control" maxlength="2048" name="html" rows="6" <c:if test="${type eq 'query'}">disabled</c:if>>${cxkjInfo.html}</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">数据源：</label>
                                <div class="col-sm-10">
                                    <textarea id="_sjy" class="form-control" maxlength="2048" name="sjy" rows="5" <c:if test="${type eq 'query'}">disabled</c:if>>${cxkjInfo.sjy}</textarea>
                                </div>
                                <label class="col-sm-2 control-label"></label>
                                <div  class="col-sm-5"><button class="col-sm-12" onclick="yzSy()">校验</button></div>
                                <div  class="col-sm-5"><button class="col-sm-12" onclick="openYl()">预览</button></div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="_id_ym" value="${id_ym}">
<input type="hidden" id="_type_cxkj" value="${type}">
<input type="hidden" id="_id_cxkj" value="${cxkjInfo.id}">

<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css"  href="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.css"/>

<script type="text/javascript">
    $(function () {
        buildHtml();
    });
    function  isNull(rowvalue) {
        if (rowvalue==null || rowvalue==undefined || rowvalue.length==0 ){
            return true
        }else {
            return false;
        }
    }
    function buildHtml() {
        debugger
        var html_ =$("#_html").val();
        var mc_ =$("#_mc").val();
        var code_ =$("#_code").val();
        var lx_=$("#_lx").val();
        if (isNull(html_)){//没有则新建
            html_=" <label class=\"col-lg-1 col-md-2 control-label\">考核对象:</label>\n" +
                "      <div class=\"col-lg-2 col-md-4\">\n" +
                "     <input type=\"text\" class=\"form-control input-sm\" id=\"khdxmc\" name=\"khdxmc\" placeholder=\"考核对象\" onchange=\"cx()\"/>\n" +
                "</div>";
            if(lx_ =="sj"){
                html_="<label class=\"col-lg-1 col-md-2 control-label\">考核年度</label>\n" +
                    "<div class=\"col-lg-2 col-md-2\">\n" +
                    "  <div class=\"input-group\">\n" +
                    "    <input type=\"text\" class=\"form-control input-sm\" name=\"khnf\" readonly=\"true\" id=\"khnf\" onchange=\"change('khpl',this)\" />\n" +
                    "    <div class=\"input-group-addon\">\n" +
                    "      <i class=\"fa fa-calendar\"></i>\n" +
                    "    </div>\n" +
                    "  </div>\n" +
                    "</div>";
            }else if(lx_ =="xl"){
                html_="<label class=\"col-lg-1 col-md-2 control-label\">考核频率：</label>\n" +
                    "<div class=\"col-lg-2 col-md-4\">\n" +
                    "    <select class=\"form-control input-sm\" id=\"khpl\" name=\"khpl\" onchange=\"change('khfa',this)\">\n" +
                    "   </select>\n" +
                    "</div>";
            }else if(lx_ =="xldx"){
                html_="<label class=\"col-lg-1 col-md-2 control-label\">考核期间：</label>\n" +
                    "<div class=\"col-lg-2 col-md-4\">\n" +
                    " <select class=\"form-control input-sm\" id=\"khqj\" name=\"khqj\" onchange=\"cx()\" multiple=\"multiple\" data-actions-box=\"true\">\n" +
                    " </select>\n" +
                    "</div>\n";
            }
        }
        if(!isNull(mc_)){
            html_=html_.replace(/(>)(.*)(<\/label>)/gm,'$1'+mc_+'$3');
        }
        if (!isNull(code_)){
            html_=html_.replace(/(id\=\")(\w+)(\")/gm,'$1'+code_+'$3');
            html_=html_.replace(/(name\=\")(\w+)(\")/gm,'$1'+code_+'$3');
        }
        $("#_html").text(html_);
        $("#_html").val(html_);
    }
    var reqPara={};
    function yzSy () {
        console.log("yzSy:");
        debugger;
        reqPara.sjy=$('#_sjy').val();
        loadMessage();
        $.ajax({
            url: '../bisj/sjyYz',
            type: 'POST',
            dataType: 'json',
            data: reqPara
        }).done(function (resultDatas) {
            hideMessage();
            if(resultDatas && resultDatas.result == 'success'){
                toastr.success(resultDatas.msg);
                toastr.success("success->"+resultDatas.colsStr);
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
    var viewPwindowYlCxkj;
    function openYl() {
        var data2=$("#_sjy").val();
        data2=data2.replace(/\%/g,"%25");
        data2=data2.replace(/\#/g,"%23");
        data2=data2.replace(/\&/g,"%26");
        viewPwindowYlCxkj = new PWindow({
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
    function editCxkjInfo(){
        if($.trim($("#_mc").val())==''){
            toastr.info("名称不能为空！");
            return;
        }
        if($.trim($("#_code").val())==''){
            toastr.info("编码不能为空！");
            return;
        }
         if($.trim($("#_sx").val())==''){
            toastr.info("排序不能为空！");
            return;
        }
        if($.trim($("#_html").val())==''){
            toastr.info("html不能为空！");
            return;
        }
        loadMessage();
        var request = new HttpRequest("editCxkjInfo", "post", {
            onRequestSuccess: function (responseText) {
            	hideMessage();
                if (responseText == "success") {
                    toastr.success("保存成功！");
                    // window.parent.initZbInfoTable();
                    // viewPwindowcxkj.close();
                }else if(responseText =='exitName'){
                    toastr.error("保存失败！名称已存在！");
                }else if(responseText =='exitCode'){
                    toastr.error("保存失败！编码已存在！");
                }else{
                    toastr.error("保存失败！");
                }
            }
        });
        request.addParameter("id_ym", $("#_id_ym").val());
        request.addParameter("type", $("#_type_cxkj").val());
        request.addParameter("id", $("#_id_cxkj").val());
        request.addParameter("id_cxkj", $("#_id_cxkj").val());
        request.addParameter("mc", $("#_mc").val());
        request.addParameter("code", $("#_code").val());
        request.addParameter("csz", $("#_csz").val());
        request.addParameter("lx", $("#_lx").val());
        // request.addParameter("iflabel", $("#_iflabel").prop("checked")?"1":"0");
        request.addParameter("iflabel", $("#_iflabel").val());
        request.addParameter("gs", $("#_gs").val());
        request.addParameter("sx", $("#_sx").val());
        // request.addParameter("zt", $("#_zt").prop("checked")?"1":"0");
        request.addParameter("zt", $("#_zt").val());
        request.addParameter("html", $("#_html").val());
        request.addParameter("sjy", $("#_sjy").val());

        request.sendRequest();
    }

</script>

