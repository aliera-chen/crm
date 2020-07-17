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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css" />


<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		//点击添加按钮时创建模态窗口
		$("#createBtn").click(function () {
			$("#create-form")[0].reset();
			$("#create-marketActivityOwner").val("${sessionScope.user.id}");
			$("#createActivityModal").modal("show");
		})

		//点击保存按钮时进行验证及保存
		$("#create-saveBtn").click(function () {
			//集中获取参数
			var owner = $.trim($("#create-marketActivityOwner").val());
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $("#create-startTime").val();
			var endDate = $("#create-endTime").val();
			var cost = $.trim($("#create-cost").val());
			var describe = $.trim($("#create-describe").val());
			//TODO:验证信息
			if(owner == "") {
				alert("拥有者不能为空！");
				return false;
			}
			if(name == "") {
				alert("名称不能为空！");
				return false;
			}
			if(startDate > endDate) {
				alert("开始时间不能晚于结束时间！");
				return false;
			}
			if(Number(cost) == NaN || Number(cost) < 0) {
				alert("成本必须是非负数字！")
				return false;
			}
			//TODO:使用ajax发送市场活动数据
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/activity/saveActivity.do",
				data: {
					"owner":owner,
					"name":name,
					"startDate":startDate,
					"endDate":endDate,
					"cost":cost,
					"description":describe
				},
				success: function(data) {
					if(data.success) {
						//TODO：局部刷新页面
						//findActivityForPageByCondition(1,rowsPerPage);
						//直接刷新页面
						window.location.href = "workbench/activity/toActivityIndex.do";
					} else {
						alert(msg.msg);
						$("#createActivityModal").modal("show");
					}
				}
			});
		})

		//点击查询按钮
		$("#queryBtn").click(function () {
			//判断日期是否存在问题
			var startDate = $("#query-startTime").val();
			var endDate = $("#query-endTime").val();
			var name = $.trim($("#query-name").val());
			var owner = $.trim($("#query-owner").val());
			if(startDate > endDate) {
				alert("起始日期不能晚于结束日期！");
				return false;
			}
			//备份查询条件
			$("#query-hidden-name").val(name);
			$("#query-hidden-owner").val(owner);
			$("#query-hidden-startDate").val(startDate);
			$("#query-hidden-endDate").val(endDate);

			findActivityForPageByCondition(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
		})

		//页面初始化
		findActivityForPageByCondition(1,10);


		//全选功能
		$("#allCheckbox").click(function () {
			//var c = $("#tbody input[type=checkbox]");
			$("input[name='dataCheckbox']").prop("checked",$("#allCheckbox").prop("checked"));
		})

		//反选功能，点击事件要选择固定目标
		$("#tbody").on("click","input[name='dataCheckbox']",function () {
			$("#allCheckbox").prop("checked",$("input[name='dataCheckbox']").length == $("input[name='dataCheckbox']:checked").length);
		})

		//删除按钮事件
		$("#deleteBtn").click(function () {
			//判断
			var checkedActivity = $("input[name='dataCheckbox']:checked");
			alert(checkedActivity.length);
			if(checkedActivity.length == 0) {
				alert("请至少选择一个目标");
				return false;
			}
			var activities = [];
			$.each(checkedActivity,function (i,obj) {
				activities.push($(obj).val());
			})
			alert(activities.length);
			//使用ajax发送数组
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/activity/deleteActivities.do",
				data: {
					"ids":activities,
				},
				traditional: true,
				success: function(data) {
					if(data.success) {
						//删除成功时刷新页面数据表，第一页/原条数/原条件
						findActivityForPageByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert(data.msg);
					}
				}
			});
		})

		//修改事件
		$("#editBtn").click(function () {
			var checkedActivity = $("input[name=dataCheckbox]:checked");
			if(checkedActivity.length == 0) {
				alert("请选择修改活动！");
				return false;
			}
			if(checkedActivity.length > 1) {
				alert("一次只能修改一条信息！");
				return false;
			}

			//使用ajax发送id,获取待修改元素的所有数据
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/activity/findActivityById.do",
				data: {
					"id":checkedActivity[0].value,
				},
				success: function(data) {
					if(data.success) {
						$("#edit-form")[0].reset();
						//打开模态窗口
						$("#edit-marketActivityName").val(data.updateActivity.name);
						$("#edit-marketActivityOwner").val(data.updateActivity.owner);
						$("#edit-startTime").val(data.updateActivity.startDate);
						$("#edit-endTime").val(data.updateActivity.endDate);
						$("#edit-cost").val(data.updateActivity.cost);
						$("#edit-describe").val(data.updateActivity.description);
						$("#edit-id").val(data.updateActivity.id);
						$("#editActivityModal").modal("show");
					} else {
						alert(data.msg);
					}
				}
			});

		})

		//修改完成，点击更新按钮时
		$("#edit-updateBtn").click(function () {
			var owner = $.trim($("#edit-marketActivityOwner").val());
			var name = $.trim($("#edit-marketActivityName").val());
			var startDate = $("#edit-startTime").val();
			var endDate = $("#edit-endTime").val();
			var cost = $.trim($("#edit-cost").val());
			var describe = $.trim($("#edit-describe").val());
			var id = $("#edit-id").val();
			//验证信息
			if(owner == "") {
				alert("拥有者不能为空！");
				return false;
			}
			if(name == "") {
				alert("名称不能为空！");
				return false;
			}
			if(startDate > endDate) {
				alert("开始时间不能晚于结束时间！");
				return false;
			}
			if(Number(cost) == NaN || Number(cost) < 0) {
				alert("成本必须是非负数字！")
				return false;
			}

			//使用ajax发送修改后的市场活动
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/activity/updateActivity.do",
				data: {
					"owner":owner,
					"name":name,
					"startDate":startDate,
					"endDate":endDate,
					"cost":cost,
					"description":describe,
					"id":id
				},
				success: function(data) {
					if(data.success) {
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
						//刷新数据表，原页数/原条数/原条件
						findActivityForPageByCondition($("#activityPage").bs_pagination("getOption","currentPage"),$("#activityPage").bs_pagination("getOption","rowsPerPage"));

					} else {
						alert(data.msg);
						$("#editActivityModal").modal("show");
					}
				}
			});
		})

		//导出所有市场活动
		$("#exportActivityAllBtn").click(function () {
			if(!confirm("确定要导出所有市场活动么")) {
				return false;
			}
			window.location.href = "workbench/activity/exportAllActivity.do";
		})

		//导出选中的市场活动
		$("#exportActivitySelectBtn").click(function () {
			var checkedActivity = $("#tbody input[type=checkbox]:checked");
			if(checkedActivity.length == 0) {
				alert("没有选中任何数据");
				return false;
			}
			var ids = "";
			$.each(checkedActivity,function (i,obj) {
				ids += "ids="+obj.value;
				if(i < checkedActivity.length-1) {
					ids += "&";
				}
			})
			window.location.href = "workbench/activity/exportActivitySelective.do?"+ids;
			checkedActivity.prop("checked",false);
			$("#allCheckedBox").prop("checked",false);
		})

		//导入市场活动按钮事件（打开模态窗口）
		$("#importActivityIndexBtn").click(function () {
			$("#activityFile").val("");
			$("#importActivityModal").modal("show");
		})

		//导入市场活动（导入按钮）
		$("#importActivityBtn").click(function () {
			var activityFile = $("#activityFile");
			//校验
			//校验文件类型
			if(activityFile.val().substring(activityFile.val().lastIndexOf('.')) != '.xls'
					&& activityFile.val().substring(activityFile.val().lastIndexOf('.')) != '.xlsx') {
				alert("文件类型错误！");
				return false;
			}
			//校验文件大小
			if(activityFile[0].files[0].size > 5 * 1024 * 1024) {
				alert("当前文件过大");
				return false;
			}
			var formData = new FormData();
			formData.append("importFile",activityFile[0].files[0]);
			//上传文件
			$.ajax({
				type: "POST",
				url: "workbench/activity/importActivity.do",
				data: formData,
				contentType:false,
				processData:false,
				success: function(data) {
					if(data.success) {
						alert("导入了"+data.countActivity+"条记录");
						$("#importActivityModal").modal("hide");
					} else {
						alert(data.msg);
						$("#importActivityModal").modal("show");
					}
				}
			});
		})

		//TODO: 时间控件
		//年月日时分秒
		/*$(".time").datetimepicker({
			language:  "zh-CN",
			format: "yyyy-mm-dd hh:ii:ss",//显示格式
			minView: "hour",//设置只显示到月份
			initialDate: new Date(),//初始化当前日期
			autoclose: true,//选中自动关闭
			todayBtn: true, //显示今日按钮
			clearBtn : true,
			pickerPosition: "bottom-left"
		});*/

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

	//查询数据函数
	function findActivityForPageByCondition(pageNo, pageSize) {
		//从四个隐藏域中获取信息
		var name = $.trim($("#query-hidden-name").val());
		var owner = $.trim($("#query-hidden-owner").val());
		var startDate = $("#query-hidden-startDate").val();
		var endDate = $("#query-hidden-endDate").val();

		//发送ajax请求
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/activity/findActivityForPageByCondition.do",
			data: {
				"name":name,
				"owner":owner,
				"startDate":startDate,
				"endDate":endDate,
				"pageNo":pageNo,
				"pageSize":pageSize,
			},
			success: function(data) {
				if(data.success) {
					//TODO:拼接html
					/*<tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    </tr>*/
					var htmlStr = "";
					$.each( $(data.pageVO.dataList),function (i,obj) {
						htmlStr += "<tr class='active'>";
						htmlStr += "<td><input type='checkbox' name='dataCheckbox' value='"+obj.id+"'/>";
						htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/toDetailActivity.do?id="+obj.id+"';\">"+obj.name+"</a></td>";
						htmlStr += "<td>"+obj.owner+"</td>";
						htmlStr += "<td>"+obj.startDate+"</td>";
						htmlStr += "<td>"+obj.endDate+"</td>";
						htmlStr += "</tr>";
					})
					/*$(dataList).each(function () {
                        htmlStr += "<tr class='active'>";
                        htmlStr += "<td><input type='checkbox' value='"+$(this).id+"'/>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do';\">"+$(this).name+"</a></td>";
                        htmlStr += "<td>"+obj.owner+"</td>";
                        htmlStr += "<td>"+obj.startDate+"</td>";
                        htmlStr += "<td>"+$(this).endDate+"</td>";
                        htmlStr += "</tr>";
                    })*/
					$("#tbody").html(htmlStr);

					//总页数
					var totalPages = parseInt((data.pageVO.total+pageSize-1)/pageSize);
					//分页组件
					$("#activityPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.pageVO.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							findActivityForPageByCondition(data.currentPage , data.rowsPerPage);
						}
					});

				} else {
					alert(data.msg);
				}
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="create-form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${userList}" var="uList">
										<option value="${uList.id}">${uList.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="create-saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="edit-form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
                                    <c:forEach items="${userList}" var="uList">
                                        <option id="updateSelectOption" value="${uList.id}">${uList.name}</option>
                                    </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" id="edit-startTime">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" id="edit-endTime">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						<input type="hidden" id="edit-id">
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="edit-updateBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" action=""  method="post">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
						<input type="hidden" id="query-hidden-name" name="name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
						<input type="hidden" id="query-hidden-owner" name="owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control dateTime" type="text" id="query-startTime" readonly/>
						<input type="hidden" id="query-hidden-startDate" name="startDate">
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control dateTime" type="text" id="query-endTime" readonly>
						<input type="hidden" id="query-hidden-endDate" name="endDate">
				    </div>
				  </div>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--模态窗口闪退原因：data-toggle="modal" data-target="#createActivityModal"和js事件不能共存-->
				  <button id="createBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button id="importActivityIndexBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivitySelectBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheckbox" type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tbody">

					</tbody>
				</table>
			</div>

			<!--分页组件-->
			<div id="activityPage">

			</div>

			<!--分页demo，使用页面插件替代-->
<%--			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>