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
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function() {

		<%--
		=========================================事件触发============================================
		--%>

		//刷新线索列表
		refreshClueList(1,10);

		//创建线索
		$("#createClueBtn").click(function () {
			//模态窗口重置
			$("#createClueForm")[0].reset();
			//ajax动态获取用户列表
			getUserList($("#create-clueOwner"));

			//弹出模态窗口
			$("#createClueModal").modal("show");

		})

		//保存新增线索
		$("#saveBtn").click(function () {
			//alert($("#create-clueOwner").val());
			var owner = $.trim($("#create-clueOwner").val());
			var company = $.trim($("#create-company").val());
			var fullname = $.trim($("#create-fullname").val());
			var appellation = $.trim($("#create-call").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var clueState = $.trim($("#create-status").val());
			var source = $.trim($("#create-source").val());

			var description = $.trim($("#create-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());
			//数据合法性校验
			if(owner == "" || fullname == "" || company == "") {
				alert("请填写必填项！");
				return false;
			}

			//把数据使用ajax发送到后端
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/saveClue.do",
				data: {
					"owner":owner,
					"company":company,
					"fullname":fullname,
					"appellation":appellation,
					"job":job,
					"email":email,
					"phone":phone,
					"website":website,
					"mphone":mphone,
					"state":clueState,
					"source":source,
					"description":description,
					"contactSummary":contactSummary,
					"nextContactTime":nextContactTime,
					"address":address
				},
				success: function(data) {
					if(data.success) {
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//刷新线索列表
						//TODO: 页面参数暂时写死
						refreshClueList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));

					} else {
						alert(data.msg);
					}
				}
			});
		})

		//全选
		$("#allCheckBox").click(function () {
			$("#clueTBody input[type=checkbox]").prop("checked",$("#allCheckBox").prop("checked"));
		})

		//反选
		$("#clueTBody").on("click","input[type=checkbox]",function () {
			$("#allCheckBox").prop("checked",$("#clueTBody input[type=checkbox]").length == $("#clueTBody input[type=checkbox]:checked").length);
		})

		//修改线索
		$("#editClueBtn").click(function () {
			var checkedClue = $("#clueTBody input[type=checkbox]:checked");
			if(checkedClue.length == 0) {
				alert("请选择待修改的线索");
				return false;
			} else if(checkedClue > 1) {
				alert("一次只能修改一条线索");
				return false;
			}
			//重置模态窗口表单
			$("#edit-clue-form")[0].reset();
			//获取选定的线索对象
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/findClueById.do",
				data: {
					"id":checkedClue.val()
				},
				success: function(data) {
					if(data.success) {
						//获取用户名
						getUserList($("#edit-clueOwner"));
						//设置默认值
						$("#edit-id").val(data.clue.id);
						$("#edit-fullname").val(data.clue.fullname);
						$("#edit-appellation").val(data.clue.appellation);
						$("#edit-owner").val(data.clue.owner);
						$("#edit-company").val(data.clue.company);
						$("#edit-job").val(data.clue.job);
						$("#edit-email").val(data.clue.email);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-website").val(data.clue.website);
						$("#edit-mphone").val(data.clue.mphone);
						$("#edit-clueState").val(data.clue.state);
						$("#edit-source").val(data.clue.source);
						$("#edit-description").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactSummary);
						$("#edit-nextContactTime").val(data.clue.nextContactTime);
						$("#edit-address").val(data.clue.address);

						//显示模态窗口
						$("#editClueModal").modal("show");
					} else {
						alert(data.msg);
					}
				}
			});
		})

		//更新线索
		$("#updateClue-btn").click(function () {
			var id = $("#edit-id").val();
			var owner = $.trim($("#edit-clueOwner").val());
			var company = $.trim($("#edit-company").val());
			var fullname = $.trim($("#edit-fullname").val());
			var appellation = $.trim($("#edit-call").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var mphone = $.trim($("#edit-mphone").val());
			var clueState = $.trim($("#edit-clueState").val());
			var source = $.trim($("#edit-source").val());

			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var address = $.trim($("#edit-address").val());
			//数据合法性校验
			if(owner == "" || fullname == "" || company == "") {
				alert("请填写必填项！");
				return false;
			}

			//把数据使用ajax发送到后端
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/updateClue.do",
				data: {
					"id": id,
					"owner": owner,
					"company": company,
					"fullname": fullname,
					"appellation": appellation,
					"job": job,
					"email": email,
					"phone": phone,
					"website": website,
					"mphone": mphone,
					"state": clueState,
					"source": source,
					"description": description,
					"contactSummary": contactSummary,
					"nextContactTime": nextContactTime,
					"address": address
				},
				success: function (data) {
					if (data.success) {
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//刷新线索列表
						//TODO: 页面参数暂时写死
						refreshClueList($("#activityPage").bs_pagination("getOption", "currentPage"), $("#activityPage").bs_pagination("getOption", "rowsPerPage"));

					} else {
						alert(data.msg);
					}
				}
			});
		})

		//删除线索
		$("#deleteClueBtn").click(function () {
			var checkedClue = $("#clueTBody input[type=checkbox]:checked");
			if(checkedClue.length == 0) {
				alert("请选中待删除线索");
				return;
			}
			var ids = new Array();
			$.each(checkedClue,function (i,obj) {
				ids.push(obj.value);
			})
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/deleteClueByIdArray.do",
				data: {
					"ids":ids
				},
				traditional: true,  //发送数组
				success: function(data) {
					if(data.success) {
						refreshClueList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));
					} else {
						alert(data.msg);
					}
				}
			});
		})

		//查询线索
		$("#queryClueBtn").click(function () {
			//更新隐藏域
			$("#query-name-hidden").val($("#query-name").val());
			$("#query-company-hidden").val($("#query-company").val());
			$("#query-source-hidden").val($("#query-source").val());
			$("#query-state-hidden").val($("#query-state").val());
			$("#query-phone-hidden").val($("#query-phone").val());
			$("#query-mphone-hidden").val($("#query-mphone").val());
			refreshClueList(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"))
		})


		<%--
		==========================================组件=============================================
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

	});



	<%--
		=========================================封装方法============================================
	--%>

	//获取用户列表
	function getUserList(jqueryObj) {
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/findAllUsers.do",
			success: function(data) {
				if(data.success) {
					//拼接下拉框,下拉框每个元素value为用户id
					var optionHtml = "<option></option>";
					$.each(data.userList,function (i,obj) {
						var opt = $("<option value='"+obj.id+"'>"+obj.name+"</option>");
						optionHtml += "<option value='"+obj.id+"'>"+obj.name+"</option>";
					})
					jqueryObj.html(optionHtml);
					jqueryObj.val('${sessionScope.user.id}');

				} else {
					alert(data.msg);
				}
			}
		});
	}

	//刷新线索列表
	function refreshClueList(pageNo, pageSize) {
		//获得隐藏域数据
		var fullname = $.trim($("#query-name-hidden").val());
		var company = $.trim($("#query-company-hidden").val());
		var phone = $.trim($("#query-phone-hidden").val());
		var source = $.trim($("#query-source-hidden").val());
		var owner = $.trim($("#query-owner-hidden").val());
		var mphone = $.trim($("#query-mphone-hidden").val());
		var state = $.trim($("#query-state-hidden").val());
		//发送ajax请求
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/findClueByConditionForPage.do",
			data: {
				"fullname":fullname,
				"company":company,
				"phone":phone,
				"source":source,
				"owner":owner,
				"mphone":mphone,
				"state":state,
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			success: function(data) {
				if(data.success) {
					//拼接线索列表
					var html = "";
					$.each(data.pageVO.dataList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type=\"checkbox\" value='"+obj.id+"'/></td>";
						html += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/toClueDetail.do?id="+obj.id+"';\">"+obj.fullname+obj.appellation+"</a></td>";
						html += "<td>"+obj.company+"</td>";
						html += "<td>"+obj.phone+"</td>";
						html += "<td>"+obj.mphone+"</td>";
						html += "<td>"+obj.source+"</td>";
						html += "<td>"+obj.owner+"</td>";
						html += "<td>"+obj.state+"</td>";
						html += "</tr>";
					})
					$("#clueTBody").html(html);
					//分页插件
					var totalPages = parseInt((data.pageVO.total+pageSize-1)/pageSize);

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
							refreshClueList(data.currentPage , data.rowsPerPage);
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

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<option></option>
									<c:forEach items="${applicationScope.appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control dateTime" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="edit-clue-form">
						<input id="edit-id" type="hidden"/>
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-clueState" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueState">
								  <option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control dateTime" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateClue-btn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
						<input id="query-name-hidden" type="hidden">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
						<input id="query-company-hidden" type="hidden">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="query-phone">
						<input id="query-phone-hidden" type="hidden">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:forEach items="${applicationScope.sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
					  </select>
						<input id="query-source-hidden" type="hidden">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" value="${sessionScope.user.name}" readonly>
						<input id="query-owner-hidden" type="hidden" value="${sessionScope.user.id}">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="query-mphone">
						<input id="query-mphone-hidden" type="hidden">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
					  	<c:forEach items="${applicationScope.clueStateList}" var="state">
							<option value="${state.value}">${state.text}</option>
						</c:forEach>
					  </select>
						<input id="query-state-hidden" type="hidden">
				    </div>
				  </div>

				  <button id="queryClueBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createClueBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editClueBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead id="clueThead">
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="allCheckBox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueTBody">

					</tbody>

				</table>
			</div>

			<div style="height: 50px; position: relative;top: 60px;">
				<!--分页容器-->
				<div id="activityPage"></div>
			</div>

			
		</div>
		
	</div>
</body>
</html>