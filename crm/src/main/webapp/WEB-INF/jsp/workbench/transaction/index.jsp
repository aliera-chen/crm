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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" /><!--分页-->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">


<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		loadTransactionListForPageByCondition(1,10);
		
	});

	<%--
	--------------------------------------------封装方法-------------------------------------------------
	--%>

	//根据查询条件搜索交易信息，参数为页数和每页数据条数
	function loadTransactionListForPageByCondition(pageNo, pageSize) {
		//将隐藏域信息使用ajax发送到后台
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/transaction/findTranListForPageByCondition.do",
			data: {
				"owner":$.trim($("#queryOwner-hidden").val()),
				"tranName":$.trim($("#queryTranName-hidden").val()),
				"customerName":$.trim($("#queryCustomerName-hidden").val()),
				"stage":$.trim($("#queryStage-hidden").val()),
				"type":$.trim($("#queryType-hidden").val()),
				"source":$.trim($("#querySource-hidden").val()),
				"contactsName":$.trim($("#queryContactsName-hidden").val()),
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			success: function(data) {
				if(data.success) {
					//data包含success:true  pageVO:[tranList,total]
				/*<tr>
					<td><input type="checkbox" /></td>
							<td>
							<a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/toTranDetail.do?tranId=100';">
							动力节点-交易01
							</a>
							</td>
					<td>动力节点</td>
					<td>谈判/复审</td>
					<td>新业务</td>
					<td>zhangsan</td>
					<td>广告</td>
					<td>李四</td>
					</tr>*/
					var html = "";
					$.each(data.pageVO.dataList,function (i,obj) {
						html += "<tr>";
						html += "<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
						html += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/toTranDetail.do?tranId="+obj.id+"';\">"
						html += obj.name + "</a></td>";
						html += "<td>"+obj.customerName+"</td>";
						html += "<td>"+obj.stage+"</td>";
						html += "<td>"+obj.type+"</td>";
						html += "<td>"+obj.owner+"</td>";
						html += "<td>"+obj.source+"</td>";
						html += "<td>"+obj.contactsName+"</td>";
					})
					$("#tbody_tranList").html(html);
					//分页
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
							loadTransactionListForPageByCondition(data.currentPage , data.rowsPerPage);
						}
					})
				} else {
					alert(data.msg);
				}
			}
		});
	}


</script>
</head>
<body>

	<!--查询信息隐藏域，用于查询-->
	<input type="hidden" id="queryOwner-hidden" value="${user.id}">
	<input type="hidden" id="queryTranName-hidden">
	<input type="hidden" id="queryCustomerName-hidden">
	<input type="hidden" id="queryStage-hidden">
	<input type="hidden" id="queryType-hidden">
	<input type="hidden" id="querySource-hidden">
	<input type="hidden" id="queryContactsName-hidden">
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control">
					  	<option></option>
					  	<option>资质审查</option>
					  	<option>需求分析</option>
					  	<option>价值建议</option>
					  	<option>确定决策者</option>
					  	<option>提案/报价</option>
					  	<option>谈判/复审</option>
					  	<option>成交</option>
					  	<option>丢失的线索</option>
					  	<option>因竞争丢失关闭</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control">
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="create-clueSource">
						  <option></option>
						  <option>广告</option>
						  <option>推销电话</option>
						  <option>员工介绍</option>
						  <option>外部介绍</option>
						  <option>在线商场</option>
						  <option>合作伙伴</option>
						  <option>公开媒介</option>
						  <option>销售邮件</option>
						  <option>合作伙伴研讨会</option>
						  <option>内部研讨会</option>
						  <option>交易会</option>
						  <option>web下载</option>
						  <option>web调研</option>
						  <option>聊天</option>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/toTranSave.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tbody_tranList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="activityPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>