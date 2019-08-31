<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <title>查看图片</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx!}/assets/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <style>
        .img{
            padding: 10px;
        }
    </style>
</head>

<body class="gray-bg">
<div class="row">
    <input type="hidden" id="path"  name="path" value="${path}">
    <div id="img"></div>
</div>

</div>


<!-- 全局js -->
<script src="${ctx!}/assets/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx!}/assets/js/bootstrap.min.js?v=3.3.6"></script>

<!-- jQuery Validation plugin javascript-->
<script src="${ctx!}/assets/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${ctx!}/assets/js/plugins/validate/messages_zh.min.js"></script>
<script src="${ctx!}/assets/js/plugins/layer/layer.min.js"></script>
<script src="${ctx!}/assets/js/plugins/layer/laydate/laydate.js"></script>
<script type="text/javascript">
    window.onload=function(){
      var paths =  $("#path").val().split(",");
      for(var i=0;i<paths.length-1;i++){
        $("#img").append("<img class='img'  data-url=\""+paths[i] +"\" src=\""+paths[i] +"\" width=\"100%\" />");
        }
    }
</script>

</body>

</html>
