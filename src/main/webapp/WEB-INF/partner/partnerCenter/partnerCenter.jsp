<%--
  Created by IntelliJ IDEA.
  User: xf
  Date: 2017/5/15
  Time: 10:06
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><!--强制以webkit内核来渲染-->
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
    <title>合伙人中心</title>
    <link rel="stylesheet" href="${commonResource}/css/reset.css">
    <link rel="stylesheet" href="${leplusShopResource}/partner_center/css/partnerCenter.css">
    <script src="${commonResource}/js/zepto.min.js"></script>
</head>
<body>
<div class="main">
    <!--个人信息-->
    <div class="top">
        <div class="wx-faceImg">
            <div class="img-inner">
                <img src="" alt="">
            </div>
        </div>
        <h3 class="wx-name">积分客</h3>
        <div class="personalInfo">
            <div class="item myMember">
                <div class="info clearfix">
                    <span class="left">我的会员</span>
                    <span class="right"><span class="font">120</span>/200</span>
                </div>
                <div class="progress">
                    <span style="width:30%"></span>
                </div>
            </div>
            <div class="line"></div>
            <div class="item myShop">
                <div class="info clearfix">
                    <span class="left">我的好店</span>
                    <span class="right"><span class="font">6</span>/10</span>
                </div>
                <div class="progress">
                    <span style="width:30%"></span>
                </div>
            </div>

        </div>
        <h3 class="btn-crease">名额不够？点此申请扩容</h3>
    </div>
    <!--提现-->
    <div class="tx clearfix">
        <span class="left">我的佣金：￥50.88</span>
        <span class="right btn-tx">提现</span>
    </div>
    <!--菜单-->
    <div class="menu">
        <div class="item border-bottom border-right">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/yongjinjilu@2x.png" alt=""></div>
                <h3>佣金记录</h3>
            </div>
        </div>
        <div class="item border-bottom border-right">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/tixainjilu@2x.png" alt=""></div>
                <h3>提现记录</h3>
            </div>
        </div>
        <div class="item item-final border-bottom">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/wodehuiyuan@2x.png" alt=""></div>
                <h3>我的会员</h3>
            </div>
        </div>
        <div class="item border-right">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/wodehaodian@2x.png" alt=""></div>
                <h3>我的好店</h3>
            </div>
        </div>
        <div class="item border-right">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/shourupaiming@2x.png" alt=""></div>
                <h3>收入排名</h3>
            </div>
        </div>
        <div class="item item-final">
            <div class="menu-wrapper">
                <div class="icon"><img src="images/kefuzhongxin@2x.png" alt=""></div>
                <h3>客服中心</h3>
            </div>
        </div>
    </div>
    <!--弹窗-->
    <div class="shadow">
        <div class="popup">
            <div class="people"></div>
            <h3 class="ttl">如需申请扩容，请联系乐加客服</h3>
            <div class="btn">
                <div class="btn-cancel">取消</div>
                <div class="btn-tokefu">前往客服中心</div>
            </div>
        </div>
    </div>
</div>
<script>
    $(".btn-crease").on("touchstart", function (e) {
        popupShow();
        $('.shadow').on('touchstart', function () {
            popupHide();
        });
        e.stopPropagation();//阻止事件向上冒泡
    });
    $(".shadow .popup").on("touchstart", function (e) {
        e.stopPropagation();//阻止事件向上冒泡
    });
    $(".shadow .btn-cancel").on("touchstart", function () {
        popupHide();
    });
    function popupShow() {
        $(".shadow").css("display","block");
        setTimeout(function () {
            $(".shadow").css("opacity",1);
        },0.1);
    }
    function popupHide() {
        $(".shadow").css("opacity",0);
        setTimeout(function () {
            $(".shadow").css("display","none");
        },0.1);
    }
</script>
</body>
</html>