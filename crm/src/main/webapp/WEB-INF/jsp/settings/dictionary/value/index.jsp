<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>
		$(function () {
			//点击修改按钮
			$("#updateBtn").click(function () {
				var checkedValue = $("input[name='valueFlag']:checked");
				if(checkedValue.length == 0) {
					alert("请选择待修改对象");
					return false;
				} else if(checkedValue.length > 1) {
					alert("一次只能修改一个对象");
					return false;
				}
				//将id发送到后台，由后台携带数据跳转到修改页面
				window.location.href = "settings/dictionary/value/toDictionaryValueEdit.do?id="+checkedValue.val();
			})

			//点击全选框
			$("#allCheckedBox").click(function () {
				$("input[name='valueFlag']").prop('checked',$("#allCheckedBox").prop('checked'));
			})

			//反选
			$("input[name='valueFlag']").click(function () {
				$("#allCheckedBox").prop('checked',($("input[name='valueFlag']:checked").length) == ($("input[name='valueFlag']")).length);
			})

			//TODO 点击删除按钮
			$("#deleteBtn").click(function () {
				var checkedValue = $("input[name='valueFlag']:checked");
				if(checkedValue.length == 0) {
					alert("请至少选择一组待删除数据");
					return false;
				}
				if(confirm("数据一旦删除不可恢复，请问确定要删除么？")) {
					var action = "settings/dictionary/value/deleteDictionaryValue.do?";
					checkedValue.each(function () {
						action += "ids="+$(this).val()+"&";
					})
					action = action.substring(0,action.length-1);
					window.location.href = action;
				}
			})
		})

	</script>

</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/toValueSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="updateBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input id="allCheckedBox" type="checkbox" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>

			<c:forEach items="${dictionaryValue}" var="dicValue" varStatus="vs">
				<tbody>
				<tr class="active">
					<td><input name="valueFlag" value="${dicValue.id}" type="checkbox" /></td>
					<td>${vs.count}</td>
					<td>${dicValue.value}</td>
					<td>${dicValue.text}</td>
					<td>${dicValue.orderNo}</td>
					<td>${dicValue.typeCode}</td>
				</tr>
				</tbody>
			</c:forEach>

		</table>
	</div>
	
</body>
</html>