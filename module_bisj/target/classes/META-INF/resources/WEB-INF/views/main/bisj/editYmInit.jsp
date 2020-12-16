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
        height: 240px !important;
    }
</style>
<div class="panel-body">
    <div class="row">
        <div class="col-md-12 both-pd7">
            <!--搜索查询区：常为查询-->
            <div class="box win-search-box">
                <div class="box-header">
                    <i class="fa box-search"></i>
                    <div class="box-title">页面信息</div>
                </div>
                <div class="box-body">
                    <div class="form-horizontal">
                        <fieldset>
                            <div class="form-group" style="display:${type =='add'?'':'none'}">
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>模板：</label>
                                <div class="col-sm-4">
                                    <select class="form-control input-sm" id="ymmb" name="ymmb" onchange="getNewNameYm()">
                                        <c:choose>
                                            <c:when test="${ymmblist!= null && fn:length(ymmblist) > 0}">
                                                <c:forEach items="${ymmblist}" var="item">
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
                                    <input class="form-control" id="_mc" name="mc" maxlength="32" type="text" value="${ymInfo.mc}"/>
                                </div>
                                <label class="col-sm-2 control-label"><span style="color: red;margin-top:3px;">*</span>类型：</label>
                                <div class="col-sm-4">
                                    <input class="form-control" id="_lx" name="lx" maxlength="32" type="text" value="${ymInfo.lx}"/>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="_id_ym" value="${ymInfo.id}">
<input type="hidden" id="_type_ym" value="${type}">

<script type="text/javascript" src="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.js"></script>
<link rel="stylesheet" type="text/css"  href="${basePath}asserts/js/plugins/bootstrap-treeview/bootstrap-treeview.css"/>

<script type="text/javascript">
    $(document).ready(function () {
        $("#dialog_div").eq(1).css("height","200px");
    });
    function getNewNameYm() {
       $('#_mc').val($("#ymmb option:selected").text()+"-新");
    }
    function editYmInfo(){
        if($.trim($("#_mc").val())==''){
            toastr.info("名称不能为空！");
            return;
        }
        if($.trim($("#_lx").val())==''){
            toastr.info("类型不能为空！");
            return;
        }
        loadMessage();
        var request = new HttpRequest("editYmInfo", "post", {
            onRequestSuccess: function (responseText) {
            	hideMessage();
                if (responseText == "success") {
                    toastr.success("保存成功！");
                    // window.parent.initZbInfoTable();
                    // viewPwindowym.close();
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
        request.addParameter("id_ym_mb", $("#ymmb").val());
        request.addParameter("lx", $("#_lx").val());
        request.addParameter("mc", $("#_mc").val());
        request.addParameter("type", $("#_type_ym").val());
        request.sendRequest();
    }

</script>

