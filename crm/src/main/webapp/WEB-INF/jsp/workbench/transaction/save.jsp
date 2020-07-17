<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.util.JSONWrappedObject" %>
<%@ page import="java.util.Set" %>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	$(function () {

		var json = stagePosibilityMaptoJson();

		//市场活动源查询
		$("#queryActivity-span").click(function () {
			$("#createActivity-form")[0].reset();
			queryAndShowActivityLikeName(null);

		})

		//创建市场活动源-查询框
		$("#queryCreateActivity-text").keydown(function (event) {
			if(13 == event.keyCode) {
				queryAndShowActivityLikeName($("#queryCreateActivity-text").val());
			}
		})

		//选中市场活动源
		$("#createTranActivity-btn").click(function () {
			var checkedActivity = $("#createTranActivity-tbody input[type=radio]:checked");
			$("#create-activitySrc").val($("#activity_td_"+checkedActivity.val()).html());
			$("#create-activityId").val(checkedActivity.val());
			$("#findMarketActivity").modal("hide");
		})

		//联系人查询
		$("#queryContacts-span").click(function () {
			$("#createContacts-form")[0].reset();
			queryAndShowContactsLikeName(null);
		})

		//创建-联系人-查询框
		$("#queryCreateContacts-text").keydown(function (event) {
			if(event.keyCode == 13) {
				queryAndShowContactsLikeName($("#queryCreateContacts-text").val());
			}
		})

		//确认联系人
		$("#createTranContacts-btn").click(function () {
			var checkedContacts = $("#createTranContacts-tbody input[type=radio]:checked");
			$("#create-contactsName").val(checkedContacts.val());
			$("#findContacts").modal("hide");
		})

		//点击保存
		$("#createTranSave-btn").click(function () {

			//表单校验
			var owner = $.trim($("#create-transactionOwner").val());
			var money = $.trim($("#create-amountOfMoney").val());
			var name = $.trim($("#create-transactionName").val());
			var expectedDate = $.trim($("#create-expectedClosingDate").val());
			var customerName = $.trim($("#create-accountName").val());
			var stage = $.trim($("#create-transactionStage").val());
			var activity = $.trim($("#create-activitySrc").val());
			var contacts = $.trim($("#create-contactsName").val());

			if(owner == null || owner == '') {
				alert("所有者不能为空！")
				return;
			} else if(name == null || name == '') {
				alert("交易名称不能为空！")
				return;
			} else if(expectedDate == null || expectedDate == '') {
				alert("预期时间不能为空！")
				return;
			} else if(stage == null || stage == '') {
				alert("阶段不能为空！");
				return;
			} else if(customerName == null || customerName == '') {
				alert("客户名称不能为空！")
				return;
			} else if(activity == null || activity == '') {
				alert("市场活动源不能为空！")
				return;
			} else if(contacts == null || contacts == '') {
				alert("联系人不能为空！")
				return;
			}
			if(money != null && money != '' && (isNaN(Number(money)) || Number(money) < 0)) {
				alert("金额必须为非负数字!");
				return;
			}

			$("#create-tran-form").submit();
		})

	<%--
		==============================控件注册===================================
	--%>

		//日历组件
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//自动补全插件
		$("#create-accountName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/transaction/getCustomerNameAuto.do",
						{ "name" : query },
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 500
		});
	})


	//市场列表查询及更新
	function queryAndShowActivityLikeName(queryName) {
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/transaction/queryActivityListLikeName.do",
			data: {
				"queryName":queryName
			},
			success: function(data) {
				if(data.success) {
				/*<tr>
					<td><input type="radio" name="activity"/></td>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							</tr>*/
					var html = "";
					$.each(data.activityList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type=\"radio\" value=\""+obj.id+"\" /></td>";
						html += "<td id=\"activity_td_"+obj.id+"\">"+obj.name+"</td>";
						html += "<td>"+obj.startDate+"</td>";
						html += "<td>"+obj.endDate+"</td>";
						html += "<td>"+obj.name+"</td>";
						html += "</tr>";
					})
					$("#createTranActivity-tbody").html(html);
					$("#findMarketActivity").modal("show");
				} else {
					alert(data.msg);
				}
			}
		});
	}

	function queryAndShowContactsLikeName(queryName) {
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/transaction/queryContactsListLikeName.do",
			data: {
				"queryName":queryName
			},
			success: function(data) {
				if(data.success) {
					var html = "";
					$.each(data.contactsList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type=\"radio\" value=\""+obj.fullname+"\" /></td>";
						html += "<td id=\"contacts_td_"+obj.id+"\">"+obj.fullname+"</td>";
						html += "<td>"+obj.email+"</td>";
						html += "<td>"+obj.mphone+"</td>";
						html += "</tr>";
					})
					$("#createTranContacts-tbody").html(html);
					$("#findContacts").modal("show");
				} else {
					alert(data.msg);
				}
			}
		});
	}

	//阶段和可能性数据解析，Map转换为Json
	function stagePosibilityMaptoJson() {
		var json = {
			<%
				Map<String,String> sMap = (Map<String,String>)(application.getAttribute("sMap"));
				for(String key:sMap.keySet()) {
					String value = sMap.get(key);
			%>
				"<%=key%>":"<%=value%>",
			<%
				}
			%>
		}
		return json;
	}

	function showPosibilityByStage(json) {
		$("#create-transactionStage").change(function () {
			$("#create-possibility").val(json[$("#create-transactionStage").val()]);
		})
	}

</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" onkeypress="return event.keyCode != 13;" id="createActivity-form">
						  <div class="form-group has-feedback">
						    <input type="text" id="queryCreateActivity-text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="createTranActivity-tbody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="createTranActivity-btn" type="button" class="btn btn-primary">确定</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" onkeypress="return event.keyCode != 13;" id="createContacts-form">
						  <div class="form-group has-feedback">
						    <input type="text" id="queryCreateContacts-text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="createTranContacts-tbody">


						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="createTranContacts-btn" type="button" class="btn btn-primary">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="createTranSave-btn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="create-tran-form" action="workbench/transaction/saveTran.do" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
				  <c:forEach items="${requestScope.userList}" var="u">
					  <option value="${u.id}" ${u.id eq user.id ? "selected":""}>${u.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTime" id="create-expectedClosingDate" name="expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建" autocomplete="off">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" name="stage">
			  	<option></option>
			  	<c:forEach items="${applicationScope.stageList}" var="stage">
					<option value="${stage.value}">${stage.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${applicationScope.transactionTypeList}" var="type">
						<option value="${type.value}">${type.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${applicationScope.sourceList}" var="source">
						<option value="${source.value}">${source.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" ><span id="queryActivity-span" class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
				<input type="hidden" id="create-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"><span id="queryContacts-span" class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" name="contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTime" id="create-nextContactTime" name="nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>