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

		//页面加载完成后自动获取备注
		getActivityRemarks();

		//test
		//$("#editActivityModal").modal("show");

		$("#remark").focus(function(){
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
		
/*		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/

		//鼠标移动到每条备注时，出现修改/删除按钮
		$("#remarkBody").on("mouseover",".remarkDiv", function () {
			$(this).children("div").children("div").show();
		})

		//鼠标从一条备注上移开时，按钮隐藏
		$("#remarkBody").on("mouseout",".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		})
		
/*		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/

		$("#remarkBody").on("mouseover",".myHref", function () {
			$(this).children("span").css("color","red");
		})

		//鼠标从一条备注上移开时，按钮隐藏
		$("#remarkBody").on("mouseout",".myHref", function () {
			$(this).children("span").css("color","#E6E6E6");
		})

		//保存备注
		$("#saveBtn").click(function () {
			var activityId = "${activity.id}";
			var noteContent = $.trim($("#remark").val());
			if(noteContent == "") {
				alert("备注不能为空！");
				return false;
			}
			//ajax发送数据
			$.ajax({
				type: "POST",
				dataType: "json",
				url: "workbench/activity/remark/saveRemark.do",
				data: {
					"activityId":activityId,
					"noteContent":noteContent
				},
				success: function(data) {
					if(data.success) {
						//添加备注对象
						$("#remarkDiv").before(remarkHtml(data.remark));
					} else {
						alert(data.msg);
					}
				}
			});
		})

        //修改备注（点击备注更新按钮）
        $("#updateRemarkBtn").click(function () {
            var noteContent = $.trim($("#noteContent").val());
            var id = $("#remarkId").val();
            //验证文本框
            if(noteContent == "") {
                alert("备注不能为空！");
                return false;
            }
            //传给后台修改，使用ajax
            $.ajax({
                type: "POST",
                dataType: "json",
                url: "workbench/activity/remark/updateRemark.do",
                data: {
                    "id":id,
                    "noteContent":noteContent
                },
                success: function(data) {
                    if(data.success) {
                    	//模态窗口关闭
						$("#editRemarkModal").modal("hide");
                        //更新备注信息(删除后重新生成）
						//删除页面元素
						$("#"+id).remove();
                        $("#remarkDiv").before(remarkHtml(data.remark));
                    } else {
                        alert(data.msg);
						$("#editRemarkModal").modal("show");
                    }
                }
            });

        })



	});


	/*--------------------------------------
		封装的独立方法
	 */

	//动态获取备注函数
	function getActivityRemarks() {
		//使用ajax获取所有备注
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/activity/remark/findRemarks.do",
			data: {
				"id":"${activity.id}"
			},
			success: function(data) {
				if(data.success) {
					//获得了List<Remark> remarkList
					//拼接html
					/*<div class="remarkDiv" style="height: 60px;">
						<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
							<div style="position: relative; top: -40px; left: 40px;" >
							<h5>哎呦！</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
							<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
					</div>
					</div>*/
					var html = "";
					$.each($(data.remarkList), function (i,obj) {
						html += remarkHtml(obj);
					})
					$("#remarkDiv").before(html);

				} else {
					alert(data.msg);
				}
			}
		});
	}


	//备注字符串拼接方法
	function remarkHtml(obj) {
		var html = "";
		html += "<div id='"+obj.id+"' class=\"remarkDiv\" style=\"height: 60px;\">";
		html += "<img title=\""+obj.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
		html += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
		//文本框的格式为remark_id
		html += "<h5 id=\"remark-"+obj.id+"\">"+obj.noteContent+"</h5>";
		html += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> ";
		html += "<small style=\"color: gray;\"> " +(obj.editFlag==0?(obj.createTime):(obj.editTime))+" 由"+(obj.editFlag==0?(obj.createBy+"创建"):(obj.editBy+"修改"))+"</small>";
		html += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
		//修改按钮
		html += "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"editRemark('"+obj.id+"')\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
		html += "&nbsp;&nbsp;&nbsp;&nbsp;";
		//删除按钮
		html += "<a class=\"myHref\" href=\"javascript:void(0);\" onclick=\"deleteRemark('"+obj.id+"')\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
		html += "</div></div></div>";
		return html;
	}

	//删除备注函数
	function deleteRemark(id) {
		if(!confirm("一旦删除不可恢复，请问确定要删除该备注么")) {
			return false;
		}
		//使用ajax发送id
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "workbench/activity/remark/deleteRemark.do",
			data: {
				"id":id
			},
			success: function(data) {
				if(data.success) {
					//删除页面元素
					$("#"+id).remove();
				} else {
					alert(data.msg);
				}
			}
		});
	}

	//编辑备注
	function editRemark(id) {
	    var noteContent = $.trim($("#remark-"+id).html());
		//不需要使用ajax获取数据
		//重置模态窗口中的表单

		//给模态窗口赋值
		$("#remarkId").val(id);
		$("#noteContent").val(noteContent);
		//打开模态窗口
        $("#editRemarkModal").modal("show");
	}
	
</script>

</head>
<body>
	
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
			<h3>市场活动-发传单 <small id="dateTitle">${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<!--传递的owner是实际姓名-->
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp&nbsp</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>