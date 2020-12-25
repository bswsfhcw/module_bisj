<%@ page language="java" import="java.util.*,java.text.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .activeYm {
        background-color: #3f903f;
    }
</style>
<textarea hidden   id="url_ym"></textarea>
<div id="contentdiv" style="margin-left: 5px;margin-right: 5px" class="row">
    <div class="row" style="max-height: 120px;overflow-y: auto" >
        <c:forEach items="${list}" var="ite" varStatus="status">
            <c:if test="${status.first}"><%--取第一个控件--%>
                <input readonly hidden id="id_ym" value="${ite['id']}">
                <input readonly hidden id="mc_ym" value="${ite['mc']}">
            </c:if>
            <div class="col-lg-2 col-xs-2" style="margin-top: 5px;margin-bottom: 5px;"

                 id="contentdiv_${status.index+1}">
                <div  name="ym"  id="ym_${ite['id']}" style="height: 50px;width:95%; border: 1px solid lightgrey;
                     display: flex; flex-direction:column;justify-content:space-around;align-items: center;"
                      onclick="ymSelect('${ite['id']}','${ite['mc']}','query')">
                    <div class=""  style="display: flex;justify-content:space-around;align-items: center" >
                        ${ite['mc']}
                            <c:if test="${ite['lx'] eq 0}">（模板）</c:if>
                    </div>
                    <div style="width: 80%;display: flex;flex-direction:row;justify-content:space-around;align-items: center">
                        <div onclick="ymSelect('${ite['id']}','${ite['mc']}','del','${ite['lx']}')">
                            删除
                        </div>
                        <div onclick="ymSelect('${ite['id']}','${ite['mc']}','edit','${ite['lx']}')">编辑</div>
                        <div onclick="ymSelect('${ite['id']}','${ite['mc']}','fw','${ite['lx']}')">访问</div>
                        <div onclick="copyUrl('${ite['id']}')">复制URL</div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script type="text/javascript">
    var basePath = "${basePath}";
</script>
<script>
    $(document).ready(function(){
        ymSelect( $("#id_ym").val(),$("#mc_ym").val(),'query');
    });
    function copyUrl(id_ym,e){
        var e = window.event || e;
        if (e.stopPropagation) e.stopPropagation();
        else e.cancelBubble = true;
        $('#url_ym').show();
        $('#url_ym').text(basePath+"biaction/init?id_ym="+id_ym);
        $('#url_ym').select();
        document.execCommand('Copy');
        $('#url_ym').hide();
        toastr.success("复制URL成功,可以粘贴到你需要的地方了");
    }

</script>