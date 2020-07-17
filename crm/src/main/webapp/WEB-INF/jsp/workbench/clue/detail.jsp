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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		<%--
		==============================================页面显示相关设置=================================================
		--%>

		$("#clueRemark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		/*$("#remarkBody").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$("#remarkBody").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/

		$("#remarkBody").on("mouseover",".remarkDiv", function () {
			$(this).children("div").children("div").show();
		})

		$("#remarkBody").on("mouseout",".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		})
		
		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		$("#remarkBody").on("mouseover",".myHref", function () {
			$(this).children("span").css("color","red");
		})

		$("#remarkBody").on("mouseout",".myHref", function () {
			$(this).children("span").css("color","#E6E6E6");
		})

		<%--
		==============================================线索备注相关功能=================================================
		--%>

		//获取线索备注和关联市场活动
		getClueRemarkAndRalationActivity();

		//保存备注
		$("#saveClueRemark-btn").click(function () {
			var remarkText = $("#clueRemark").val();
			if(remarkText == null || "" == remarkText) {
				alert("备注不能为空！");
				return;
			}
			//发送ajax，参数包含线索id和正文
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/remark/saveClueRemark.do",
				data: {
					"clueId":'${clue.id}',
					"noteContent":remarkText
				},
				success: function(data) {
					if(data.success) {
						showClueRemark(data.clueRemark);
					} else {
						alert(data.msg);
					}
				}
			});
		})

		//修改备注
		$("#updateRemarkBtn").click(function () {
			var noteContent = $("#noteContent").val();
			var remarkId = $("#remarkId").val();
			if(noteContent == null || "" == noteContent) {
				alert("备注内容不能为空！");
				return;
			}
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/remark/updateClueRemark.do",
				data: {
					"id":remarkId,
					"noteContent":noteContent
				},
				success: function(data) {
					//回传success,clueRemark
					if(data.success) {
						$("#editRemarkModal").modal("hide");
						//删除页面备注
						$("#clueRemark-div-"+remarkId).remove();
						showClueRemark(data.clueRemark);
					} else {
						alert(data.msg);
					}
				}
			});
		})

		<%--
		==============================================线索关联相关功能=================================================
		--%>

		//全选功能
		$("#relation-allCheckbox").click(function () {
			$("#create-relation-tbody input[type=checkbox]").prop("checked",$("#relation-allCheckbox").prop("checked"));
		})

		//反选功能
		$("#create-relation-tbody").on("click","input[type=checkbox]",function () {
			$("#relation-allCheckbox").prop("checked",$("#create-relation-tbody input[type=checkbox]").length == $("#create-relation-tbody input[type=checkbox]:checked").length);
		})

		//提交搜索框
		$("#queryByActivityNameText").keydown(function (event) {
			if(event.keyCode != 13) {
				return;
			}
			getUnRelationActivityList($("#queryByActivityNameText").val());
		})

		//确认关联
		$("#relationBtn").click(function () {
			var checkedRelationActivity = $("#create-relation-tbody input[type=checkbox]:checked");
			if(checkedRelationActivity.length == 0) {
				alert("请至少选择一个关联活动！");
				return;
			}
			var activityIdList = new Array();
			$.each(checkedRelationActivity,function (i,obj) {
				activityIdList.push(obj.value);
			})
			//发送ajax请求
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/clue/remark/saveRelationActivityList.do",
				data: {
					"clueId":'${clue.id}',
					"activityIdList":activityIdList
				},
				traditional: true,  //发送数组
				success: function(data) {
					if(data.success) {
						//关闭模态窗口
						$("#bundModal").modal("hide");
						getClueRemarkAndRalationActivity();
					} else {
						alert(data.msg);
					}
				}
			});
		})

		//点击转换按钮
		$("#clueConvertBtn").click(function () {
			var html = "workbench/clue/remark/toClueConvert.do?";
			html += "id=${clue.id}&appellation=${clue.appellation}&company=${clue.company}&fullname=${clue.fullname}&owner=${clue.owner}";
			window.location.href = html;
		})
	});

	<%--
	==============================================封装方法=================================================
	--%>

	//获取线索备注和关联市场活动方法
	function getClueRemarkAndRalationActivity() {
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/remark/findClueRemarkAndRelationActivity.do",
			data: {
				"clueId":'${clue.id}'
			},
			success: function(data) {
				if(data.success) {
					$.each(data.clueRemarkList,function (i,obj) {
						showClueRemark(obj);
					})
					//showClueRemarks(data.clueRemarkList);
					showRelationActivities(data.relationActivityList);
				} else {
					alert(data.msg);
				}
			}
		});
	}

	//添加备注
	function showClueRemarks(list) {

		$.each(list,function (i,obj) {
			showClueRemark(obj);
		})

	}

	function showClueRemark(obj) {
		var html = "<div id=\"clueRemark-div-"+obj.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
		html += "<img title=\"${user.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
		//alert("<img title=\""+obj.name+" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">");
		html += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
		html += "<h5 id=\"remarkContent-"+obj.id+"\">"+obj.noteContent+"</h5>";
		html += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "
				+(obj.editFlag=='0'?obj.createTime:obj.editTime)+" 由"+(obj.editFlag=='0'?obj.createBy:obj.editBy)+"</small>";
		html += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
		html += "<a class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" onclick=\"updateClueRemark('"+obj.id+"')\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
		html += "&nbsp;&nbsp;&nbsp;&nbsp;";
		html += "<a class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" onclick=\"deleteClueRemark('"+obj.id+"')\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
		html += "</div></div></div>";
		$("#remarkHeader").after(html);
	}

	function deleteClueRemark(remarkId) {
		if(!confirm("一旦删除不可恢复，请问确定要删除该备注么")) {
			return;
		}
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/remark/deleteClueRemarkByRemarkId.do",
			data: {
				"remarkId":remarkId
			},
			success: function(data) {
				if(data.success) {
					//删除页面备注
					$("#clueRemark-div-"+remarkId).remove();
				} else {
					alert(data.msg);
				}
			}
		});
	}

	function updateClueRemark(remarkId) {
		$("#remarkId").val(remarkId);
		$("#noteContent").val($("#remarkContent-"+remarkId).html());
		$("#editRemarkModal").modal("show");
	}

	//添加关联市场活动
	function showRelationActivities(list) {
		var html = "";
		$.each(list,function (i,obj) {
			html += "<tr id='activity-tr-"+obj.relationId+"'>";
			html += "<td>"+obj.name+"</td>";
			html += "<td>"+obj.startDate+"</td>";
			html += "<td>"+obj.endDate+"</td>";
			html += "<td>"+obj.owner+"</td>";
			html += "<td><a href=\"javascript:void(0);\" onclick=\"removeRelation('"+obj.relationId+"')\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
			html += "</tr>";
		})
		$("#relationActivity-tbody").html(html);
	}

	//获得未关联市场活动列表（添加关联）
	function getUnRelationActivityList(queryName) {
		//发送ajax请求查询活动列表
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/remark/findUnRelationActivityListByCondition.do",
			data: {
				"clueId":'${clue.id}',
				"queryName":queryName
			},
			success: function(data) {
				if(data.success) {
					//拼接市场活动列表
					var html = "";
					$.each(data.unRelationActivityList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type='checkbox' value='"+obj.id+"'/></td>";
						html += "<td>"+obj.name+"</td>";
						html += "<td>"+obj.startDate+"</td>";
						html += "<td>"+obj.endDate+"</td>";
						html += "<td>"+obj.owner+"</td>";
						html += "</tr>";
					})
					$("#create-relation-tbody").html(html);
					//TODO：分页

					$("#relation-allCheckbox").prop("checked",false);
					$("#queryUnRelationActivity-form")[0].reset();
					//打开模态窗口
					$("#bundModal").modal("show");

				} else {
					alert(data.msg);
				}
			}
		});

	}

	//解除关联
	function removeRelation(relationId) {
		alert(relationId);
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/clue/remark/deleteClueActivityRelation.do",
			data: {
				"relationId":relationId
			},
			success: function(data) {
				if(data.success) {
					$("#activity-tr-"+relationId).remove();
				} else {
					alert(data.msg);
				}
			}
		});
	}
	
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" onkeypress="return event.keyCode != 13;" id="queryUnRelationActivity-form">
						  <div class="form-group has-feedback">
						    <input id="queryByActivityNameText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="relation-allCheckbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="create-relation-tbody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="relationBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="clue-detail-header">${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button id="clueConvertBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createTime}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createBy}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editTime}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editBy}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.website}&nbsp;
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
		<div class="page-header" id="remarkHeader">
			<h4>备注</h4>
		</div>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="clueRemark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveClueRemark-btn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relationActivity-tbody">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" onclick="getUnRelationActivityList(null)" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>