<%--
  Created by IntelliJ IDEA.
  User: Aliera.chen
  Date: 2020/6/26
  Time: 16:17
  To change this template use File | Settings | File Templates.
--%>
<!--分页-->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>

    <script>
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "workbench/users/ajaxToLogin.do",
            data: {
                "loginAct":$("#loginAct").val(),
                "loginPwd":$("#loginPwd").val(),
                "flag":flag
            },
            traditional: true,  //发送数组
            async: false,       //ajax同步
            success: function(data) {
                if(data.success) {
                    window.location.href = "workbench/users/toWorkbenchIndex.do";
                } else {
                    alert(data.msg);
                }
            }
        });

        //页面刷新
        findActivityForPageByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));

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

        //自动补全插件
        $("#create-customerName").typeahead({
            source: function (query, process) {
                $.post(
                    "workbench/transaction/getCustomerName.do",
                    { "name" : query },
                    function (data) {
                        //alert(data);
                        process(data);
                    },
                    "json"
                );
            },
            delay: 1500
        });


        //数据查询和分页
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
<tr class='active'>
    <td><input type='checkbox' value='xxx'/>
    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detailActivity.do';">undefined</a></td>
    <td>张三</td>
    <td>2020-07-02</td>
    <td>2020-07-07</td>
</tr>

<!--分页容器-->
<div id="activityPage"></div>

<!--关闭表单回车默认提交-->
<form class="form-inline" role="form" onkeypress="return event.keyCode != 13;" id="queryUnRelationActivity-form">

</body>
</html>
