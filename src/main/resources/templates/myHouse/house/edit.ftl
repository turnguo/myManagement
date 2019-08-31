<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <title>增加房源</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <link rel="shortcut icon" href="favicon.ico">
    <link href="${ctx!}/assets/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${ctx!}/assets/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${ctx!}/assets/css/animate.css" rel="stylesheet">
    <link href="${ctx!}/assets/css/style.css?v=4.1.0" rel="stylesheet">
    <link href="${ctx!}/assets/css/upload-md.css" rel="stylesheet">
</head>

<body class="gray-bg">
<div class="row">
    <div class="col-sm-12">
        <div class="ibox-content">
            <form class="form-horizontal m-t" id="house_add" method="post" action="${ctx!}/myHouse/house/edit">
                <input type="hidden" id="id" name="id" value="${house.id}">
                <div class="form-group">
                    <label class="col-sm-3 control-label">小区名：</label>
                    <div class="col-sm-8">
                        <input id="community" name="community" class="form-control" type="text" value="${house.community}" >
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">租房或卖房：</label>
                    <div class="col-sm-8">
                        <select name="flag" class="form-control">
                            <option value="0" <#if house.flag == 0>selected="selected"</#if>>出租</option>
                            <option value="1" <#if house.flag == 1>selected="selected"</#if>>卖房</option>
                            <option value="2" <#if house.flag == 2>selected="selected"</#if>>租售</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">电话：</label>
                    <div class="col-sm-8">
                        <input id="telephone" name="telephone" class="form-control" value="${house.telephone}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">价格：</label>
                    <div class="col-sm-8">
                        <input id="price" name="price" class="form-control" value="${house.price}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">详细描述：</label>
                    <div class="col-sm-8">
                        <input type="text" id="description" name="description" class="form-control" value="${house.description}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">上传图片：</label>
                    <div class="col-sm-8">
                        <div id="imgUpload"></div>

                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3">
                        <button id = "btnSub" class="btn btn-primary" type="submit">提交</button>
                    </div>
                </div>
            </form>
            <input type="hidden" id="paths"  name="paths" value="${house.path}">
        </div>

    </div>
</div>

</div>


<!-- 全局js -->
<script src="${ctx!}/assets/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx!}/assets/js/bootstrap.min.js?v=3.3.6"></script>

<!-- 自定义js -->
<script src="${ctx!}/assets/js/content.js?v=1.0.0"></script>

<!-- jQuery Validation plugin javascript-->
<script src="${ctx!}/assets/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${ctx!}/assets/js/plugins/validate/messages_zh.min.js"></script>
<script src="${ctx!}/assets/js/plugins/layer/layer.min.js"></script>
<script src="${ctx!}/assets/js/plugins/layer/laydate/laydate.js"></script>
<script src="${ctx!}/assets/js/upload-md.js"></script>
<script src="${ctx!}/assets/js/imageService.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        if($("#paths").val()){
            var paths =   $("#paths").val().substring(0,$("#paths").val().length-1).split(",");
        }else {
            var paths=new Array();
        }
      console.log(paths)
        var uploadImg=uploadMd.defineImgUpload({
            container:'#imgUpload', //插件所需容器
            max:6, //允许选择的最大上传图片数
            previewImg:paths, //传入预览的图片，适用编辑时展示曾经上传的图片
        });
        $("#house_add").validate({
            messages: {},
            submitHandler:function(form){
                var pss =$("#imgUpload .img-view");
               debugger;
                var pat="";
                var patname="";
                for (var i = 0;i< pss.length; i++) {
                    var ppp = pss.eq(i).attr("data-src");
                    if(ppp.length<=100){
                        pat+= ppp +","
                        patname =  ppp.substr(ppp.lastIndexOf("/")+1)
                    }
                }

                $("#btnSub").attr({"disabled":"disabled"});
                var $files=$("#house_add").find('input[type=file]');
                var arr = new Array();
                for(var i=0;i<$files.length-1;i++){
                    arr.push($files[i].files[0]);
                }
                convertAndResizeImageFiles(arr, function (transformedImageFiles) {
                    var fd = new FormData();
                    for(var j=0;j<transformedImageFiles.length;j++){
                        fd.append("files",transformedImageFiles[j]);
                    }
                    $.ajax({
                        url: "${ctx!}/myHouse/house/edit?"+$(form).serialize()+"&path="+ pat+"&fileName="+patname,
                        type:'POST',
                        processData: false,  // 告诉jQuery不要去处理发送的数据
                        contentType: false,   // 告诉jQuery不要去设置Content-Type请求头
                        cache:false,
                        data:fd,
                        xhr:function(){
                            return $.ajaxSettings.xhr();
                        },
                        success: function(msg){
                            layer.msg($.parseJSON(msg).message, {time: 1000},function(){
                                var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
                                parent.layer.close(index);
                            });
                        } , error: function (data) {
                            $("#btnSub").removeAttr("disabled");
                        }
                    });
                });

            }
        });
    });
    function  convertAndResizeImageFiles(imageFiles, callback) {
        if (imageFiles.length === 0) {
            return callback(imageFiles);
        }

        var processedFiles = [];

        /**
         * @param {File} imageFile
         * @param {number} imageFileIndex
         */
        function processImageFile(imageFile, imageFileIndex) {
            imageService.convertToJpeg(imageFile, function (jpegImageBlob) {
                imageService.scaleUpImageWithTooSmallResolution(jpegImageBlob, function (largeEnoughImageBlob) {
                    imageService.scaleDownImageWithTooBigResolution(largeEnoughImageBlob, function (smallEnoughResolutionImageBlob) {
                        imageService.scaleDownImageWithTooBigSize(smallEnoughResolutionImageBlob, function (smallEnoughImageBlob) {
                            var processedFile = new File([smallEnoughImageBlob], imageFile.name);
                            processedFiles.push(processedFile);

                            // Continue with the next file or exit if applicable
                            var newIndex = imageFileIndex + 1;
                            if (newIndex < imageFiles.length) {
                                processImageFile(imageFiles[newIndex], newIndex);
                            } else {
                                callback(processedFiles);
                            }
                        });
                    });
                });
            });
        }

        processImageFile(imageFiles[0], 0);
    }

</script>

</body>

</html>
