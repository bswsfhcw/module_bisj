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
<style>
    #dialog_div{
        height: 300px !important;
    }
</style>
<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">表格</div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal">
                        <fieldset>
                            <div class="form-group" style="display:${type =='add'?'':'none'}">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>复制当前表格：</label>
                                <div class="col-sm-4">
                                    <select class="form-control input-sm" id="bgmb" name="bgmb" >
                                        <c:choose>
                                            <c:when test="${bgmblist!= null && fn:length(bgmblist) > 0}">
                                                <c:forEach items="${bgmblist}" var="item">
                                                    <option  value="${item.id}">${item.mc}</option>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="-1">-请选择-</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>名称：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_mc" name="mc" maxlength="32" type="text" value="${bgInfo.mc}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>分页：</label>
                                <div class="col-sm-4">
                                    <select id="_pagination" name="pagination" class="form-control" editable="false" style="position: relative;">
                                        <option  value="0"  <c:if test="${bgInfo.pagination eq 0}">selected="selected"</c:if> >否</option>
                                        <option  value="1"  <c:if test="${bgInfo.pagination eq 1}">selected="selected"</c:if> >是</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>显示顺序：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_sx" name="sx" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="32" type="text" value="${bgInfo.sx}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>启用状态：</label>
                                <div class="col-sm-4" style="margin-top: 5px;">
                                    <select id="_zt" name="zt" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${bgInfo.zt eq 1}">selected="selected"</c:if> >在用</option>
                                        <option  value="0"  <c:if test="${bgInfo.zt eq 0}">selected="selected"</c:if> >停用</option>
                                    </select>
                                    <%--<input id="_zt" name="zt" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${bgInfo.zt eq 1}">checked="true"</c:if>>--%>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>显示表尾：</label>
                                <div class="col-sm-4" style="margin-top: 5px;">
                                    <select id="_showFooter" name="showFooter" class="form-control" editable="false" style="position: relative;">
                                        <option  value="0"  <c:if test="${bgInfo.showFooter eq 0}">selected="selected"</c:if> >不显示</option>
                                        <option  value="1"  <c:if test="${bgInfo.showFooter eq 1}">selected="selected"</c:if> >显示</option>
                                    </select>
                                    <%--<input id="_zt" name="zt" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${bgInfo.zt eq 1}">checked="true"</c:if>>--%>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>表尾计算方式：</label>
                                <div class="col-sm-4" style="margin-top: 5px;">
                                    <select id="_dblx" name="dblx" class="form-control" editable="false" style="position: relative;">
                                        <option  value="1"  <c:if test="${bgInfo.dblx eq 1}">selected="selected"</c:if> >求和</option>
                                        <option  value="2"  <c:if test="${bgInfo.dblx eq 2}">selected="selected"</c:if> >平均</option>
                                    </select>
                                    <%--<input id="_zt" name="zt" <c:if test="${type eq 'query'}">disabled</c:if> type="checkbox" data-size="small" <c:if test="${bgInfo.zt eq 1}">checked="true"</c:if>>--%>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>表尾计算过滤列：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_dbglzd" name="dbglzd" maxlength="32" type="text" placeholder="格式:{列field}" value="${bgInfo.dbglzd}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>表尾计算过滤内容：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_dbglnr" name="dbglnr" maxlength="32" type="text" value="${bgInfo.dbglnr}"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>每页最大记录：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_pageSizeMax" name="pageSizeMax" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="32" type="text" value="${bgInfo.pageSizeMax}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>高度：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_height" name="height" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="4" type="text" value="${bgInfo.height}"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>布局比例(最大12)：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_bjkdbl" name="bjkdbl" onkeyup="value=value.replace(/\D+/g,'')" <c:if test="${type eq 'query'}">disabled</c:if> maxlength="32" type="text" value="${bgInfo.bjkdbl}"/>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="_type_bg" value="${type}">
<input type="hidden" id="_id_bg" value="${bgInfo.id}">
<input type="hidden" id="_id_ym" value="${id_ym}">

<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css"  href="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.css"/>

<script type="text/javascript">
    function editbgInfo(){
        if($.trim($("#_mc").val())==''){
            toastr.info("名称不能为空！");
            return;
        }
        if($.trim($("#_sx").val())==''){
            toastr.info("排序不能为空！");
            return;
        }
        loadMessage();
        var request = new HttpRequest("../bisj/editBgInfo", "post", {
            onRequestSuccess: function (responseText) {
            	hideMessage();
                if (responseText == "success") {
                    toastr.success("保存成功！");
                    // window.parent.initZbInfoTable();
                    // viewPwindowbg.close();
                }else{
                    toastr.error("保存失败！");
                }
            }
        });
        request.addParameter("id_bg", $("#_id_bg").val());
        request.addParameter("id_ym", $("#_id_ym").val());
        request.addParameter("id_bg_mb", $("#bgmb").val());
        request.addParameter("type", $("#_type_bg").val());
        request.addParameter("mc", $("#_mc").val());
        request.addParameter("sx", $("#_sx").val());
        request.addParameter("zt", $("#_zt").val());
        request.addParameter("pagination", $("#_pagination").val());
        request.addParameter("showFooter", $("#_showFooter").val());
        request.addParameter("pageSizeMax", $("#_pageSizeMax").val());
        request.addParameter("dbglzd", $("#_dbglzd").val());
        request.addParameter("dbglnr", $("#_dbglnr").val());
        request.addParameter("dblx", $("#_dblx").val());
        request.addParameter("height", $("#_height").val());
        request.addParameter("bjkdbl", $("#_bjkdbl").val());
        request.sendRequest();
    }

</script>

