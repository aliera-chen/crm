<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		//为用户创建交易
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
			$("#tranFlag").val(this.checked?"1":"0");
		});


		//点击转换按钮
		$("#convertBtn").click(function () {
			$("#convert-form").submit();
		})

		//点击市场活动源
		$("#queryActivitySourceBtn").click(function () {
			getRelationActivityList(null);
		})

		//市场活动查询输入框回车提交
		$("#queryActivityNameText").keydown(function (event) {
			if(13 == event.keyCode) {
				getRelationActivityList($.trim($("#queryActivityNameText").val()));
			}
		})

		$("#createTran-btn").click(function () {
			var checkedActivity = $("#convert-activity-tbody input[type=radio]:checked");
			if(checkedActivity.length == 0) {
				alert("请选择一个用于交易的市场活动！");
				$("#searchActivityModal").modal("show");
				return;
			}
			var checkedActivityId = checkedActivity[0].value;
			var checkedActivityName = $("#activity_"+checkedActivityId).html();
			$("#activitySource-text").val(checkedActivityName);
			$("#activitySource-id").val(checkedActivityId);
		})


		//日历组件
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

	});

	//获得未关联市场活动列表（添加关联）
	function getRelationActivityList(queryName) {
		//发送ajax请求查询活动列表
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/findRelationActivityListByCondition.do",
			data: {
				"clueId":'${clue.id}',
				"queryName":queryName
			},
			success: function(data) {
				if(data.success) {
					//拼接市场活动列表
					var html = "";
					$.each(data.relationActivityList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type='radio' value='"+obj.id+"'/></td>";
						html += "<td id='activity_"+obj.id+"'>"+obj.name+"</td>";
						html += "<td>"+obj.startDate+"</td>";
						html += "<td>"+obj.endDate+"</td>";
						html += "<td>"+obj.owner+"</td>";
						html += "</tr>";
					})
					$("#convert-activity-tbody").html(html);
					//TODO：分页

					$("#queryRelationActivity-form")[0].reset();
					//打开模态窗口
					$("#searchActivityModal").modal("show");

				} else {
					alert(data.msg);
				}
			}
		});

	}

</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" onkeypress="return event.keyCode != 13;" id="queryRelationActivity-form">
						  <div class="form-group has-feedback">
						    <input id="queryActivityNameText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="convert-activity-tbody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="createTran-btn" type="button" class="btn btn-primary" data-dismiss="modal">创建</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}&nbsp;
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}&nbsp;
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="convert-form" action="workbench/clue/convertClue.do" method="post">
			<input type="hidden" name="clueId" value="${clue.id}" />
			<input type="hidden" name="tranFlag" id="tranFlag" value="0"/>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="tranMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="tranName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control dateTime" id="expectedClosingDate" name="expectedDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="tranStage">
		    	<option></option>
		    	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.value}">${stage.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="queryActivitySourceBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" id="activitySource-text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activitySource-id" name="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>