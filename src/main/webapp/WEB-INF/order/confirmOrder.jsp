<%--
  Created by IntelliJ IDEA.
  User: zhangwen
  Date: 2016/9/22
  Time: 17:24
  Content:订单确认页
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>订单确认</title>
    <meta name="viewport"
          content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <c:set var="resourceUrl" value="http://www.lepluslife.com/resource"></c:set>
    <c:set var="wxRootUrl" value="http://www.lepluslife.com"></c:set>
    <c:set var="leplusShopResource" value="http://image.tiegancrm.com/leplus_shop/"></c:set>
    <!--App自定义的css-->
    <link rel="stylesheet" href="${resourceUrl}/frontRes/css/reset.css">
    <link rel="stylesheet" href="${leplusShopResource}/order/common_confirm/css/pay.css">
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <%--以下代替jquery--%>
    <script src="${resourceUrl}/js/zepto.min.js"></script>
</head>
<style>
    input:not([type=checkbox]) {
        -webkit-appearance: none;
    }

    .joinLe {
        background-color: #ffffff;
        margin-bottom: 10px;
        padding: 10px;
    }

    .joinLe > p {
        width: 94%;
        line-height: 20px;
        margin-left: 6%;
        /*text-align: center;*/
    }

    .joinLe > div > div {
        float: left;
    }

    .joinLe > div > div:first-child {
        width: 4%;
        margin-right: 2%;
        margin-top: 0.5%;
    }

    .joinLe img {
        width: 100%;
        display: block;
    }

    .clearfix:after {
        content: '\20';
        display: block;
        clear: both;
    }
</style>
<body>
<section class="address" onclick="goAddressEdit()">
    <div>
        <div>
            <img src="${resourceUrl}/frontRes/order/confirmOrder/img/address.png" alt="">
        </div>
    </div>
    <div>
        <c:if test="${order.address == null}">
            <p class="useAddress" style="padding: 13px 0 10px 0;font-size: 15px;">请添加收货地址</p>
        </c:if>
        <c:if test="${order.address != null}">
            <p class="useAddress">${order.address.name}<span
                    style="font-size: 15px">${order.address.phoneNumber}</span>
            </p>

            <p class="useAddress">${order.address.province}${order.address.city}${order.address.county}${order.address.location}</p>
        </c:if>
        <p class="notUseAddress" style="padding: 12px 0 10px 0;font-size: 15px;display: none;">
            已选择线下自提</p>
    </div>

    <div id="editAddr">
        <div>
            <img src="${resourceUrl}/frontRes/order/confirmOrder/img/to.png" alt="">
        </div>
    </div>
</section>
<c:if test="${order.address != null && userState == 0}">
    <section class="joinLe">
        <div class="clearfix">
            <div><img id="w-check" src="${leplusShopResource}/order/common_confirm/img/1.png"
                      alt=""></div>
            <div>使用<span id="phone">${order.address.phoneNumber}</span>注册成为乐+会员</div>
        </div>
        <p>成为乐+会员，消费后能得鼓励金呦！</p>
    </section>
</c:if>

<section class="goodsList">
    <c:forEach items="${order.orderDetails}" var="orderDetail">
        <div>
            <div>
                <img src="${orderDetail.product.type == 1 ? orderDetail.productSpec.picture : orderDetail.product.picture}"
                     alt="">
            </div>
            <div>
                <div>
                    <div>${orderDetail.product.name}</div>
                    <div><span
                            style="font-size: 16px;color: #666;">×</span>${orderDetail.productNumber}
                    </div>
                </div>
                <p>${orderDetail.productSpec.specDetail}</p>

                <p>￥<fmt:formatNumber type="number"
                                      value="${orderDetail.productSpec.minPrice/100}"
                                      pattern="0.00"
                                      maxFractionDigits="2"/>+<span><c:if
                        test="${orderDetail.product.type == 1}">
                    <fmt:formatNumber type="number"
                                      value="${orderDetail.productSpec.minScore/100}"
                                      pattern="0.00"
                                      maxFractionDigits="2"/>金币

                </c:if>
                     <c:if test="${orderDetail.product.type == 2}">
                         ${orderDetail.productSpec.minScore}金币
                     </c:if></span>
                </p>
            </div>
        </div>
    </c:forEach>
</section>
<section class="w-text" id="scoreBwarning" style="display: none">
    <div>
        <div>*</div>
        <div id="BWarningText">金币不足，将按1元=1金币补交</div>
    </div>
</section>
<section class="cost">
    <div style="padding: 20px 0;">
        <div>使用金币</div>
        <div class="useJf">
            <input type="number" id="trueScore"/>
            <span>最多可使用<span id="maxScore"></span>金币</span>
        </div>
        <div class="jfButton">
            <input type="checkbox" checked="checked" class="check-switch check-switch-anim"/>
        </div>
    </div>
    <div>
        <div>运费</div>
        <div id="postage">
            <c:if test="${order.freightPrice == 0}">
                包邮
            </c:if>
            <c:if test="${order.freightPrice != 0}">
                ￥<fmt:formatNumber type="number" value="${order.freightPrice/100}" pattern="0.00"
                                   maxFractionDigits="2"/>
            </c:if>
        </div>
    </div>
    <div>
        <div>总价</div>
        <div>￥<fmt:formatNumber type="number" value="${order.truePrice/100}" pattern="0.00"
                                maxFractionDigits="2"/>+<span><fmt:formatNumber type="number"
                                                                                value="${order.totalScore/100}"
                                                                                pattern="0.00"
                                                                                maxFractionDigits="2"/>金币</span>
        </div>
    </div>
</section>
<section class="integral">
    <div class="offline">
        <div>
            <img class="off-img" src="${resourceUrl}/frontRes/order/confirmOrder/img/off.png"
                 alt="">
        </div>
        <div>线下自提</div>
    </div>
    <div>
        <p>金币余额：<span><fmt:formatNumber type="number"
                                        value="${canUseScore/100}"
                                        pattern="0.00"
                                        maxFractionDigits="2"/>金币</span></p>
    </div>
</section>
<section class="footer">
    <div>还需付款：￥<span id="truePrice"></span></div>
    <div id="btn-wxPay">立即购买</div>
</section>
<div class="waiting">
    <div class="img">
        <img src="${resourceUrl}/frontRes/img/waiting.gif" alt="">
    </div>
</div>
</body>
<script>
    var checked = true;
    $(".w-check").click(function () {
        if (checked) {
            $("#w-check").attr("src", "${leplusShopResource}/order/common_confirm/img/0.png");
            checked = false;
        } else {
            $("#w-check").attr("src", "${leplusShopResource}/order/common_confirm/img/1.png");
            checked = true;
        }
    });
    $(".joinLe").on("click", function () {
        if (checked) {
            $("#w-check").attr("src", "${leplusShopResource}/order/common_confirm/img/0.png");
            checked = false;
        } else {
            $("#w-check").attr("src", "${leplusShopResource}/order/common_confirm/img/1.png");
            checked = true;
        }
    });
</script>
<script>
    var canUseScore = eval('${canUseScore}'), orderTotalScore = eval('${order.totalScore}'); //用户可用金币和订单可用金币
    var maxScore = 0, minPrice = eval('${order.totalPrice}'),
        freightPrice = eval('${order.freightPrice}'); //最多可用金币和最少需付金额
    var trueScoreInput = $("#trueScore"), postageInput = $("#postage"), postageText = '';
    function scoreAndPriceReset() {
        if (canUseScore >= orderTotalScore) {
            $('#maxScore').html(toDecimal(orderTotalScore / 100));
            $('#trueScore').val(toDecimal(orderTotalScore / 100));
            $('#truePrice').html(toDecimal(minPrice / 100));
            maxScore = orderTotalScore;
        } else { //用户金币少于订单可用金币
            $('#maxScore').html(toDecimal(canUseScore / 100));
            $('#trueScore').val(toDecimal(canUseScore / 100));
            $('#truePrice').html(toDecimal((minPrice + orderTotalScore - canUseScore) / 100));
            maxScore = canUseScore;
            $('#scoreBwarning').show();
            $('#BWarningText').html('您的金币不足，将按1元=1金币补交');
        }
    }
    scoreAndPriceReset();
    /*使用金币开关*/
    var on = true;//true = on ; false = off
    $(".jfButton").click(function (e) {
        if (on) {//不使用金币
            $(".useJf").hide();
            trueScoreInput.val(0);
            on = false;
            $('#truePrice').html(toDecimal((minPrice + orderTotalScore) / 100));
            $('#scoreBwarning').show();
            $('#BWarningText').html('不使用金币，将按1元=1金币补交');
        } else {//使用金币
            $(".useJf").show();
            on = true;
            scoreAndPriceReset();
        }
    });
    /*线下自提开关*/
    var offline = false; //true = on ; false = off
    $(".offline").click(function (e) {
        if (offline) { //邮寄
            $(".off-img").attr("src", "${resourceUrl}/frontRes/order/confirmOrder/img/off.png");
            $(".useAddress").css('display', 'block');
            $(".notUseAddress").css('display', 'none');
            $(".address").attr('onclick', 'goAddressEdit()');
            postageInput.html(postageText);
            //添加运费
            minPrice += freightPrice;
            allClick();
            offline = false;
            $('#editAddr').css('display', 'block');
        } else { //线下自提
            $(".off-img").attr("src", "${resourceUrl}/frontRes/order/confirmOrder/img/on.png");
            $(".notUseAddress").css('display', 'block');
            $(".useAddress").css('display', 'none');
            $(".address").attr('onclick', '');
            postageText = postageInput.html();
            postageInput.html('线下自提');
            //减掉运费
            minPrice -= freightPrice;
            allClick();
            offline = true;
            $('#editAddr').css('display', 'none');
        }
    });

    //数量切换
    //可买数量的最大值和最小值判断
    function judgeFun1() {
        if (eval(trueScoreInput.val()) * 100 > maxScore) {
            if (maxScore == orderTotalScore) {
                $('#scoreBwarning').hide();
            } else if (maxScore == canUseScore) {
                $('#scoreBwarning').show();
                $('#BWarningText').html('您的金币不足，将按1元=1金币补交');
            } else {
                $('#scoreBwarning').show();
                $('#BWarningText').html('使用金币不足，将按1元=1金币补交');
            }
            trueScoreInput.val(toDecimal(maxScore / 100));
        } else if (eval(trueScoreInput.val()) * 100 <= 0) {
            trueScoreInput.val(0);
            $('#scoreBwarning').show();
            $('#BWarningText').html('使用金币不足，将按1元=1金币补交');
        }
    }
    //点击事件
    function allClick() {
        $('#truePrice').html(toDecimal((minPrice + (orderTotalScore - (eval(trueScoreInput.val())
                                                                       == null ? 0
                                           : eval(trueScoreInput.val() * 100))))
                                       / 100));
    }
    //输入框改变
    trueScoreInput.bind('keyup', function () {
        judgeFun1();
        allClick();
    });

    //强制保留两位小数
    function toDecimal(x) {
        var f = parseFloat(x);
        if (isNaN(f)) {
            return false;
        }
        var f = Math.round(x * 100) / 100;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
            rs = s.length;
            s += '.';
        }
        while (s.length <= rs + 2) {
            s += '0';
        }
        return s;
    }
</script>
<script type="text/javascript">
    function goAddressEdit() {
        location.href = "/weixin/order/addressEdit/${order.id}";
    }

</script>
<script>
    wx.config({
                  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
                  appId: '${wxConfig['appId']}', // 必填，公众号的唯一标识
                  timestamp: ${wxConfig['timestamp']}, // 必填，生成签名的时间戳
                  nonceStr: '${wxConfig['noncestr']}', // 必填，生成签名的随机串
                  signature: '${wxConfig['signature']}',// 必填，签名，见附录1
                  jsApiList: [
                      'chooseWXPay'
                  ] // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
              });
    wx.ready(function () {
        // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
//       隐藏菜单
        wx.hideOptionMenu();

    });
    wx.error(function (res) {
        // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。

    });

</script>
<script type="text/javascript">
    function payByWx() {
        $('.waiting').css('display', 'block');
        $('#btn-wxPay').attr('onclick', '');
        //是否线下自提
        var transmitWay = 0;    //取货方式  1=线下自提|2=快递
        if (offline) {
            transmitWay = 1;
        }
        if (transmitWay == 1 || ${order.address!=null}) {
            var truePrice = $("#truePrice").html();
            if (truePrice < 0) {
                $('.waiting').css('display', 'none');
                alert("选择商品后才能付款~");
                location.href = "/front/product/weixin/productIndex";
                return;
            }
            var trueScore = $('#trueScore').val() * 100;
            if ((!(typeof trueScore === 'number')) || (!(trueScore % 1 === 0))) {
                $('.waiting').css('display', 'none');
                alert("请正确输入使用金币");
                return false;
            }
            //判断是否注册（异步）
            if ($('.joinLe').length > 0) {
                $.post('/front/weixin/weixin/register', {phoneNumber: $('#phone').html()});
            }
            var price = eval(truePrice * 100);
//            首先提交请求，生成预支付订单
            $.post('/weixin/pay/weixinpay', {
                orderId: '${order.id}',
                truePrice: truePrice,
                trueScore: $('#trueScore').val(),
                transmitWay: transmitWay
            }, function (res) {
                if (price == 0) {
                    if (res.status == 200) {
                        location.href = "/front/order/weixin/orderList";
                    } else {
                        $('.waiting').css('display', 'none');
                        alert("订单处理异常(" + res.status + ")");
                        $('#btn-wxPay').attr('onclick', 'payByWx()');
                    }
                } else {
                    if (res.status == 200) {//调用微信支付js-api接口
                        weixinPay(res);
                        return;
                    } else {
                        $('.waiting').css('display', 'none');
                        alert(res['msg']);
                        $('#btn-wxPay').attr('onclick', 'payByWx()');
                        return;
                    }
                }
            });
        } else {
            location.href = "/weixin/order/addressEdit/${order.id}";
        }
    }
    setTimeout(function () {
        $('#btn-wxPay').attr('onclick', 'payByWx()');
    }, 200);

    function weixinPay(res) {
        $('.waiting').css('display', 'none');
        wx.chooseWXPay({
                           timestamp: res['timeStamp'], // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
                           nonceStr: res['nonceStr'], // 支付签名随机串，不长于 32 位
                           package: res['package'], // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
                           signType: res['signType'], // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
                           paySign: res['sign'], // 支付签名
                           success: function (res) {
                               // 支付成功后的回调函数
//                               var total = eval($("#truePrice").html()) * 100;
                               window.location.href = '/weixin/pay/paySuccess/${order.id}';
                           },
                           cancel: function (res) {
                               $('#btn-wxPay').attr('onclick', 'payByWx()');
                               <%--window.location.href = '/weixin/pay/payFail/${order.id}';--%>
                           },
                           fail: function (res) {
                               $('#btn-wxPay').attr('onclick', 'payByWx()');
                               <%--window.location.href = '/weixin/pay/payFail/${order.id}';--%>
                           }
                       });
    }
</script>
</html>