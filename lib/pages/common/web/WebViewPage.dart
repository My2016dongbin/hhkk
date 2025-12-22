import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.whiteColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
              color: HhColors.trans,
              child: Image.asset(
                "assets/images/common/back.png",
                height: 17.w*3,
                width: 10.w*3,
                fit: BoxFit.fill,
              ),
            ),
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
    );
  }
}