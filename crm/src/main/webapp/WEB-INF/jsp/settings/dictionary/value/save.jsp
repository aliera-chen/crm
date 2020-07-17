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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>

		$(function() {
			//点击保存按钮时
			$("#saveBtn").click(function() {
				var typeCode = $("#create-dicTypeCode").val();
				var dicValue = $.trim($("#create-dicValue").val());
				if(typeCode == "" || dicValue == "") {
					alert("字典类型编码/字典值不能为空！")
					return false;
				}
				//ajax发送编码和字典值到后台进行校验
				$.ajax({
					type: "POST",
					dataType: "json",
					url: "settings/dictionary/value/checkValueForSaving.do",
					data: {
						"code":typeCode,
						"value":dicValue,
					},
					traditional: true,
					success: function(msg) {
						if(msg.success) {
							//表单提交
							$("#saveForm").submit();
						} else {
							alert(msg.msg);
						}
					}
				});
			})
		})

	</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="saveForm" action="settings/dictionary/value/saveDictionaryValue.do" method="post" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="typeCode" class="form-control" id="create-dicTypeCode" style="width: 200%;">
				  <option></option>
					<c:forEach items="${typeCodes}" var="typeCode">
						<option>${typeCode}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-dicValue" name="value" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" name="text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" name="orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>