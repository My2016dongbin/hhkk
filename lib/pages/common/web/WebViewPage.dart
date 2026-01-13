import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 与h5 端的一致 不然收不到消息
const String userAgent = 'YgsApp';
class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  late final String _removeGoogleAdsJS = '''
  function removeAds() {
    const adSelectors = [
      'iframe[src*="doubleclick.net"]',
      'iframe[src*="googlesyndication.com"]',
      '.adsbygoogle',
      '[id^="google_ads"]',
      '[class*="ad-"]',
      '[class^="ad-"]',
      '[id*="ad"]',
      '[id*="banner"]',
      'ins[class="adsbygoogle"]'
    ];
    adSelectors.forEach(selector => {
      document.querySelectorAll(selector).forEach(el => el.remove());
    });
  }

  // 屏蔽 JavaScript 弹窗
  window.alert = function() {};
  window.confirm = function() { return false; };
  window.prompt = function() { return null; };
  window.open = function() { return null; }; // 屏蔽 window.open 弹窗/跳转

  removeAds();
  setInterval(removeAds, 1000);
''';




  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            controller.runJavaScript(_removeGoogleAdsJS);
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
    //..loadRequest(Uri.parse(widget.url))
      ..loadFlutterAsset(widget.url);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: HhColors.whiteColor,
        appBar: AppBar(
          leadingWidth: 100.w*3,
          leading: SizedBox(
            width: 100.w*3,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: CommonUtils.backView(white: false,padding: EdgeInsets.zero,margin: EdgeInsets.only(left: 20.w*3)),
            ),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 17.sp*3,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: HhColors.whiteColor,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            width: 1.sw,
            height: 1.sh,
            padding: EdgeInsets.all(20.w),
            child: WebViewWidget(controller: controller,)
        ),
      ),
    );
  }


  //复写返回监听
  Future<bool> onBackPressed() async {
    bool exit = false;
    if (await controller.canGoBack()) {
      controller.goBack();
      exit = false;
    } else {
      exit = true;
    }
    return Future.value(exit);
  }
}