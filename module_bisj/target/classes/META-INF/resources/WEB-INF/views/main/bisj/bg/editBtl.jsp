<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String headPath = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
%>
<style>
    <%-- 控制新增/修改弹出窗口的大小,并居中--%>
    /*.modal-content{
        width:70%;
        margin:0 auto;
        !*  vertical-align: middle;*!
    }*/

    <%--  修改字符样式--%>
    .spanSytle{
        color: red;
        position: absolute;
        top:3px;
        right:0px
    }

    <%--  主要修改弹窗的内容超框，出现下拉框 --%>
    /*#dialog_div{
        height: 450px !important;
    }*/
</style>
<form class="form-horizontal" role="form" action="#" method="post" id="formBtl">
    <input type="hidden" id="_type" name="type" value="${type}">
    <input type="hidden" id="_id_btl" name="id_btl" value="${btlInfo.id}">
    <input type="hidden" id="_id_bg" name="id_bg" value="${id_bg}">
    <div class="form-group">
            <label class="col-sm-2 control-label">列field</label>
            <div class="col-sm-4">
                <input class="form-control" style="position: relative;" id="_clfield" name="clfield" maxlength="32" type="text"  value="${btlInfo.clfield}"/>
                <span class="spanSytle">*</span>
            </div>
            <label class="col-sm-2 control-label">列title</label>
            <div class="col-sm-4">
                <input class="form-control" style="position: relative;" id="_cltitle" name="cltitle" maxlength="32" type="text"  value="${btlInfo.cltitle}"/>
                <span class="spanSytle">*</span>
            </div>

    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">表头级别</label>
        <div class="col-sm-4">
            <input  class="form-control" style="position: relative;" id="_btjb" name="btjb" maxlength="64"  type="text" placeholder="" value="${btlInfo.btjb}"/>
            <span class="spanSytle">*</span>
        </div>
        <label class="col-sm-2 control-label">上级列id</label>
        <div class="col-sm-4">
            <input readonly class="form-control" style="position: relative;" id="_id_sjcl" name="id_sjcl" maxlength="64"  type="text" placeholder="" value="${btlInfo.id_sjcl}"/>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">显示顺序</label>
        <div class="col-sm-4">
            <input class="form-control" style="position: relative;" id="_sx" name="sx" type="text" onkeyup="value=value.replace(/\D+/g,'')"  maxlength="8" value="${btlInfo.sx}"/>
            <span class="spanSytle">*</span>
        </div>
        <label class="col-sm-2 control-label">数据源类型</label>
        <div class="col-sm-4">
            <select id="_sjylx" name="sjylx" class="form-control" editable="false" style="position: relative;">
                <option  value="1"  <c:if test="${btlInfo.sjylx eq '1'}">selected="selected"</c:if> >动态</option>
                <option  value="0"  <c:if test="${btlInfo.sjylx eq '0'}">selected="selected"</c:if> >普通</option>
            </select>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">记录状态</label>
        <div class="col-sm-4">
            <select id="_zt" name="zt" class="form-control" editable="false" style="position: relative;">
                <option  value="1" <c:if test="${btlInfo.zt eq '1'}">selected="selected"</c:if> >正常</option>
                <option  value="0" <c:if test="${btlInfo.zt eq '0'}">selected="selected"</c:if> >停用</option>
            </select>
            <span class="spanSytle">*</span>
        </div>
        <label class="col-sm-2 control-label">跨行数</label>
        <div class="col-sm-4">
            <input class="form-control" style="position: relative;" id="_rowspan" name="rowspan" type="text" onkeyup="value=value.replace(/\D+/g,'')"   maxlength="8" value="${btlInfo.rowspan}"/>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">底部格式类型</label>
        <div class="col-sm-4">
            <select id="_dbgshlx" name="dbgshlx" class="form-control" editable="false" style="position: relative;">
                <option  value="0" <c:if test="${btlInfo.dbgshlx eq '0'}">selected="selected"</c:if> >普通文本</option>
                <option  value="1" <c:if test="${btlInfo.dbgshlx eq '1'}">selected="selected"</c:if> >格式化</option>
            </select>
            <span class="spanSytle">*</span>
        </div>
        <label class="col-sm-2 control-label">底部格式(可配分隔符)</label>
        <div class="col-sm-4">
            <input class="form-control" style="position: relative;" id="_dbgs" name="dbgs" name="rowspan" type="text"   maxlength="32" value="${btlInfo.dbgs}"/>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">格式化类型</label>
        <div class="col-sm-4">
            <select id="_gshlx" name="gshlx" class="form-control" editable="false" style="position: relative;">
                <option  value="0" <c:if test="${btlInfo.gshlx eq '0'}">selected="selected"</c:if> >常规</option>
                <option  value="1" <c:if test="${btlInfo.gshlx eq '1'}">selected="selected"</c:if> >序号</option>
                <option  value="2" <c:if test="${btlInfo.gshlx eq '2'}">selected="selected"</c:if> >超链接</option>
            </select>
            <span class="spanSytle">*</span>
        </div>
        <label class="col-sm-2 control-label">合并</label>
        <div class="col-sm-4">
            <select id="_hb" name="hb" class="form-control" editable="false" style="position: relative;">
                <option  value="0" <c:if test="${btlInfo.hb eq '0'}">selected="selected"</c:if> >不合并</option>
                <option  value="1" <c:if test="${btlInfo.hb eq '1'}">selected="selected"</c:if> >相同值合并</option>
            </select>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">默认值</label>
        <div class="col-sm-4">
            <input class="form-control" style="position: relative;" id="_mrz" name="mrz" maxlength="32" type="text"  value="${btlInfo.mrz}"/>
            <span class="spanSytle">*</span>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">格式：</label>
        <div class="col-sm-10">
            <textarea id="_gs" class="form-control" maxlength="2048" name="gs" rows="2" >${btlInfo.gs}</textarea>
        </div>
    </div>
    <div class="form-group">
        <label class="col-sm-2 control-label">数据源：</label>
        <div class="col-sm-10">
            <textarea id="_sjy_btl" class="form-control" maxlength="2048" name="sjy" rows="6" >${btlInfo.sjy}</textarea>
        </div>
        <label class="col-sm-2 control-label"></label>
        <div  class="col-sm-5"><button class="col-sm-12" onclick="return yzSy()">校验</button></div>
        <div  class="col-sm-5"><button class="col-sm-12" onclick="return openYlBtl()">预览</button></div>
    </div>
</form>
<script type="text/javascript">
    var reqPara={};
    function yzSy () {
        setTimeout(function () {
            console.log("yzSy:");
            reqPara.sjy=$('#_sjy_btl').val();
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
                }else  if(resultDatas && resultDatas.result == 'sjy'){
                    toastr.error("数据源非法->"+resultDatas.msg);
                }else {
                    toastr.error("异常->"+resultDatas.msg);
                }
            }).fail(function () {
            }).always(function () {
            });
        },500)
        return false;
    };
    var viewPwindowYlBtl;
    function openYlBtl() {
      debugger;
       var data2=$("#_sjy_btl").val();
       data2=data2.replace(/\%/g,"%25");
       data2=data2.replace(/\#/g,"%23");
       data2=data2.replace(/\&/g,"%26");
       viewPwindowYlBtl = new PWindow({
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
       return false;
    }
    var submitFormBtl = function(d, g, p) {
        if($("#_clfield").val()==''){
            toastr.info("未填列field！");
            $("#_clfield").focus();
            return;
        }
        if($("#_cltitle").val()==''){
            toastr.info("未填列title！");
            $("#_cltitle").focus();
            return;
        }
        if($("#_sx").val()==''){
            toastr.info("未填显示顺序！");
            $("#_sx").focus();
            return;
        }
        $.ajax({     //重新构建更新方法
            type: "post",
            url:"../bgsj/editBtlInfo",
            data:$('#formBtl').serialize(),
            dataType:'text',
            async: false,
            success: function (data) {
                if (data=='success') {
                    toastr.success("操作成功");
                }else{
                    toastr.error("操作失败");
                }
            }
        });
    };
    $(document).ready(function () {

    });
</script>