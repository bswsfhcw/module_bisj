<%@ page language="java" import="java.util.*,java.text.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String path = request.getContextPath();
    String basepath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<style>
    .activeCxkj {
        background-color: #3f903f;
    }

    .noactiveCxkj {
        background-color: lightgrey;
    }
</style>
<div id="contentdiv" style="margin-left: 5px;margin-right: 5px" class="row">
    <div class="row" style="max-height: 120px;overflow-y: auto">
        <c:forEach items="${list}" var="ite" varStatus="status">
            <div class="col-lg-3 col-xs-3 " style="margin-top: 5px;margin-bottom: 5px;"
                 id="contentdiv_${status.index+1}">
                <div id="cxkj_${ite['id']}" class="<c:if test="${ite['zt'] eq 0}">noactiveCxkj</c:if>"
                     style="height: 50px;width:95%; border: 1px solid lightgrey;display: flex; flex-direction:column;justify-content:space-around;align-items: center;">
                    <div style="width: 60%; display: flex;justify-content:space-around;align-items: center">
                        <div>${ite['sx']}.${ite['mc']}(${ite['code']})</div>
                    </div>
                    <div style="width: 60%;display: flex;flex-direction:row;justify-content:space-around;align-items: center">
                        <div onclick="cxkjSelect('${ite['id']}','zt','${ite['zt']}')">
                            <c:if test="${ite['zt'] eq 1}">停用</c:if>
                            <c:if test="${ite['zt'] eq 0}">启用</c:if>
                        </div>
                        <div onclick="cxkjSelect('${ite['id']}','del','${ite['zt']}')">
                            删除
                        </div>
                        <div onclick="cxkjSelect('${ite['id']}','edit','${ite['zt']}')">编辑</div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    <%--var yms = '${list}';--%>
    $(document).ready(function () {

    });
</script>