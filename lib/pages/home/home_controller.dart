import 'dart:io';
import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/amap_location/location_service.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../utils/EventBusUtils.dart';

class HomeController extends GetxController {
  final index = 0.obs;
  late BuildContext context;
  final unreadMsgCount = 0.obs;
  final Rx<int> versionStatus = 0.obs;
  final Rx<int> downloadStep = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;

  Function()? onScrollToUnreadMessage;
  late StreamSubscription showToastSubscription;
  StreamSubscription? versionSubscription;
  StreamSubscription? progressSubscription;
  StreamSubscription? downloadProgressSubscription;
  late StreamSubscription showLoadingSubscription;
  late StreamSubscription showShareReceiveSubscription;
  final Rx<String> version = ''.obs;
  final Rx<String> buildNumber = ''.obs;

  final Rx<int> totalSize = (65*1000*1000).obs;
  final Rx<int> currentSize = 0.obs;
  late Dio dio = Dio();
  late String downloadUrl =
      'http://192.168.1.88:9000/resource/fireRebuild-2.1.1.apk';
  late String savePath = '';

  switchTab(index) {
    this.index.value = index;
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }

  scrollToUnreadMessage(index) {
    onScrollToUnreadMessage?.call();
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied) {
      status = await Permission.notification.request();
    }

    if (status.isGranted) {
      return;
    }

    // 是否首次提示标记
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasPrompted = prefs.getBool("hasPromptedNotificationPermission") ?? false;

    if (!hasPrompted) {
      prefs.setBool("hasPromptedNotificationPermission", true);
      EventBusUtil.getInstance().fire(HhToast(title: '请开启通知权限', type: 0));
      Future.delayed(const Duration(milliseconds: 2000), () {
        //openAppSettings();
      });
    }
  }


  @override
  void onClose() {
    try {
      versionSubscription!.cancel();
      showToastSubscription.cancel();
      progressSubscription!.cancel();
      downloadProgressSubscription!.cancel();
      showLoadingSubscription.cancel();
      showShareReceiveSubscription.cancel();
    } catch (e) {
      //
    }
  }

  @override
  void onInit() {
    localVersion();
    Future.delayed(const Duration(seconds: 1), () {
      showToastSubscription =
          EventBusUtil.getInstance().on<HhToast>().listen((event) {
        if (event.title.isEmpty || event.title == "null") {
          return;
        }

        showToastWidget(
          Container(
            margin: EdgeInsets.fromLTRB(20.w * 3, 15.w * 3, 20.w * 3, 25.w * 3),
            padding: EdgeInsets.fromLTRB(30.w * 3,
                event.type == 0 ? 18.h * 3 : 25.h * 3, 30.w * 3, 18.h * 3),
            decoration: BoxDecoration(
                color: HhColors.blackColor.withAlpha(200),
                borderRadius: BorderRadius.all(Radius.circular(8.w * 3))),
            constraints: BoxConstraints(minWidth: 117.w * 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // event.type==0?const SizedBox():SizedBox(height: 16.w*3,),
                event.type == 0
                    ? const SizedBox()
                    : Image.asset(
                        event.type == 1
                            ? 'assets/images/common/icon_success.png'
                            : event.type == 2
                                ? 'assets/images/common/icon_error.png'
                                : event.type == 3
                                    ? 'assets/images/common/icon_lock.png'
                                    : 'assets/images/common/icon_warn.png',
                        height: 20.w * 3,
                        width: 20.w * 3,
                        fit: BoxFit.fill,
                      ),
                event.type == 0
                    ? const SizedBox()
                    : SizedBox(
                        height: 16.h * 3,
                      ),
                // SizedBox(height: 16.h*3,),
                Text(
                  event.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HhColors.whiteColor, fontSize: 16.sp * 3),
                ),
                // SizedBox(height: 10.h*3,)
                // event.type==0?SizedBox(height: 10.h*3,):SizedBox(height: 10.h*3,),
              ],
            ),
          ),
          context: context,
          animation: StyledToastAnimation.slideFromBottomFade,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 2),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
        );
      });
    });
    versionSubscription =
        EventBusUtil.getInstance().on<Version>().listen((event) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - CommonData.time > 1000) {
        CommonData.time = now;
        getVersion();
      }
    });
    progressSubscription =
        EventBusUtil.getInstance().on<DownProgress>().listen((event) {
      downloadStep.value = event.progress;
    });
    showLoadingSubscription =
        EventBusUtil.getInstance().on<HhLoading>().listen((event) {
      if (event.show) {
        if(event.title!=null && event.title!=""){
          CommonData.loadingInfo = event.title??"";
        }else{
          CommonData.loadingInfo = CommonData.loadingInfoFinal;
        }
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
    showShareReceiveSubscription =
        EventBusUtil.getInstance().on<Share>().listen((event) {
      dynamic model = event.model;

      showCupertinoDialog(
          context: context,
          builder: (context) => Center(
                child: Container(
                  width: 1.sw,
                  height: 300.w * 3,
                  margin: EdgeInsets.fromLTRB(30.w * 3, 0, 30.w * 3, 0),
                  padding: EdgeInsets.fromLTRB(
                      20.w * 3, 17.w * 3, 20.w * 3, 12.w * 3),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w * 3))),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/images/common/ic_x.png",
                            width: 12.w * 3,
                            height: 12.w * 3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 9.w * 3),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CommonUtils().parseNull(
                                    "${model['shareUrerName'] ?? ''}", ""),
                                style: TextStyle(
                                    color: HhColors.blackTextColor,
                                    fontSize: 18.sp * 3,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4.w * 3,
                              ),
                              Text(
                                "共享给您",
                                style: TextStyle(
                                    color: HhColors.blackTextColor,
                                    fontSize: 18.sp * 3,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w200),
                              ),
                              SizedBox(
                                height: 12.w * 3,
                              ),
                              Image.asset(
                                "assets/images/common/icon_share_camera.png",
                                width: 110.w * 3,
                                height: 110.w * 3,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                height: 10.w * 3,
                              ),
                              Text(
                                CommonUtils().parseNull(
                                    "${model['deviceName'] ?? ''}", ""),
                                style: TextStyle(
                                    color: HhColors.gray6TextColor,
                                    fontSize: 16.sp * 3,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w200),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 1.2,
                                      onPressed: () {
                                        handleShare("${model['id'] ?? ''}", 2,
                                            "${model['deviceName'] ?? ''}");
                                      },
                                      child: Container(
                                        height: 44.w * 3,
                                        margin: EdgeInsets.fromLTRB(
                                            0, 30.w, 20.w, 0),
                                        decoration: BoxDecoration(
                                            color: HhColors.whiteColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.w * 3)),
                                            border: Border.all(
                                                color: HhColors.grayE6BackColor,
                                                width: 2.w)),
                                        child: Center(
                                          child: Text(
                                            "拒绝",
                                            style: TextStyle(
                                              color: HhColors.blackTextColor,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.sp * 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: BouncingWidget(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      scaleFactor: 1.2,
                                      onPressed: () {
                                        handleShare("${model['id'] ?? ''}", 1,
                                            "${model['deviceName'] ?? ''}");
                                      },
                                      child: Container(
                                        height: 44.w * 3,
                                        margin: EdgeInsets.fromLTRB(
                                            13.w * 3, 30.w, 0, 0),
                                        decoration: BoxDecoration(
                                            color: HhColors.mainBlueColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.w * 3))),
                                        child: Center(
                                          child: Text(
                                            "同意共享",
                                            style: TextStyle(
                                              color: HhColors.whiteColor,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.sp * 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
    });
    //获取通知权限
    Future.delayed(const Duration(milliseconds: 2000), () {
      requestNotificationPermission();
    });
    super.onInit();

    ///定位服务
    checkLocation();
  }

  void checkLocation(){
    ///处理原生定位初始化延时问题
    AmapLocationService().dispose();
    AmapLocationService().init();
    AmapLocationService().startLocation();
    if(!AmapLocationService().hasResult){
      Future.delayed(const Duration(milliseconds: 10000),(){
        checkLocation();
      });
    }
  }

  Future<void> handleShare(String id, int status, String name) async {
    EventBusUtil.getInstance().fire(HhLoading(show: true));
    dynamic data = {
      "id": id,
      "status": status,
    };
    var result = await HhHttp()
        .request(RequestUtils.shareHandle, method: DioMethod.post, data: data);
    EventBusUtil.getInstance().fire(HhLoading(show: false));
    HhLog.d("handleShare -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      EventBusUtil.getInstance().fire(HhToast(
          title: status == 2 ? '操作成功' : '“$name”\n已共享至“默认分组”',
          type: 0,
          color: 0));
      Get.back();
      EventBusUtil.getInstance().fire(SpaceList());
      EventBusUtil.getInstance().fire(DeviceList());
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  Future<void> getVersion() async {
    Map<String, dynamic> map = {};
    map['operatingSystem'] = Platform.isAndroid?"Android":"IOS";
    map['version'] = buildNumber.value;
    map['type'] = CommonData.test ? (CommonData.personal ? 'testPersonal' : 'testCompany') : (CommonData.personal ? 'personal' : 'company');
    var result = await HhHttp()
        .request(RequestUtils.versionNew, method: DioMethod.get, params: map);
    HhLog.d("getVersion -- request ${RequestUtils.versionNew}");
    HhLog.d("getVersion -- map $map");
    HhLog.d("getVersion -- $result");
    if (result["code"] == 0 && result["data"] != null) {
      dynamic update = result["data"];
      showVersionDialog(update);
    } else {
      // EventBusUtil.getInstance().fire(HhToast(title: CommonUtils().msgString(result["msg"])));
    }
  }

  void showVersionDialog(dynamic update) {
    versionStatus.value = 0;
    bool force = false;
    try {
      int minSupportedVersion =  int.parse(update["minSupportedVersion"]);
      if(minSupportedVersion > (int.parse(buildNumber.value)) || minSupportedVersion == -1){
        force = true;
      }
      showCupertinoDialog(
          context: CommonData.context!,
          builder: (context) => WillPopScope(
                onWillPop: () async {
                  // 阻止返回键关闭对话框
                  return false;
                },
                child: Center(
                  child: Obx(
                    () => Container(
                      width: 281.w * 3,
                      height: 320.w * 3,
                      decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.w * 3))),
                      child: Stack(
                        children: [
                          Image.asset('assets/images/common/icon_up_top.png'),
                          /*"${update["isForce"]}"=="true"?const SizedBox():*/
                          Align(
                            alignment: Alignment.topRight,
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: () {
                                if (force) {
                                  EventBusUtil.getInstance()
                                      .fire(HhToast(title: '请更新版本后使用'));
                                  Future.delayed(
                                      const Duration(milliseconds: 1600), () {
                                    SystemNavigator.pop();
                                  });
                                } else {
                                  Get.back();
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    0, 16.w * 3, 16.w * 3, 0),
                                padding: EdgeInsets.all(20.w),
                                child: Image.asset(
                                  "assets/images/common/icon_up_x.png",
                                  width: 40.w,
                                  height: 40.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 113.w * 3, 0, 0),
                              child: Text(
                                "发现新版本",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: HhColors.blackColor,
                                    fontSize: 16.sp * 3,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 138.w * 3, 0, 0),
                              child: Text(
                                "V${update["versionName"]}",
                                style: TextStyle(
                                    letterSpacing: -3.w,
                                    decoration: TextDecoration.none,
                                    color: HhColors.gray9TextColor,
                                    fontSize: 14.sp * 3,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          versionStatus.value == 0
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin:
                                        EdgeInsets.fromLTRB(0, 162.w * 3, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "更新内容:",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: HhColors.blackColor,
                                              fontSize: 14.sp * 3,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 5.w * 3,
                                        ),
                                        SizedBox(
                                          width: 243.w * 3,
                                          height: 63.w * 3,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${update["versionDescription"]}"
                                                      .replaceAll("\\n", "\n"),
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      color:
                                                          HhColors.blackColor,
                                                      fontSize: 13.sp * 3,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        15.w * 3, 182.w * 3, 15.w * 3, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "更新中...",
                                          style: TextStyle(
                                              decoration: TextDecoration.none,
                                              color: HhColors.blackColor,
                                              fontSize: 14.sp * 3,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 5.w * 3,
                                        ),
                                        StepProgressIndicator(
                                          totalSteps: 100,
                                          currentStep: downloadStep.value,
                                          size: 12,
                                          padding: 0,
                                          selectedColor: HhColors.mainBlueColor,
                                          unselectedColor:
                                              HhColors.mainBlueColorUn,
                                          roundedEdges:
                                              Radius.circular(10.w * 3),
                                          selectedGradientColor:
                                              const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              HhColors.mainBlueColor,
                                              HhColors.mainBlueColor
                                            ],
                                          ),
                                          unselectedGradientColor:
                                              const LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              HhColors.mainBlueColorUn,
                                              HhColors.mainBlueColorUn
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.w * 3,
                                        ),
                                        Text(
                                            "${CommonUtils().parseCache(currentSize.value * 1.0)}/${CommonUtils().parseCache(totalSize.value * 1.0)}",
                                            style: TextStyle(
                                                letterSpacing: -1.w,
                                                decoration: TextDecoration.none,
                                                color: HhColors.gray9TextColor,
                                                fontSize: 14.sp * 3,
                                                fontWeight: FontWeight.w300))
                                      ],
                                    ),
                                  ),
                                ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0.1,
                              onPressed: () async {
                                if (versionStatus.value == 0) {
                                  ///立即更新
                                  //请求安装未知应用权限 (Android 8.0及以上)
                                  if (Platform.isAndroid) {
                                    if (await Permission
                                        .requestInstallPackages.isGranted) {
                                      versionStatus.value = 1;
                                      downloadStep.value = 0;
                                      downloadUrl =
                                          "${CommonData.endpoint}${update["apkUrl"]}";
                                      HhLog.d("downloadUrl $downloadUrl");
                                      downloadDir();
                                    } else {
                                      EventBusUtil.getInstance().fire(HhToast(
                                          title: '请先开启安装权限，开启后请重新打开应用'));
                                      Future.delayed(
                                          const Duration(milliseconds: 1600),
                                          () async {
                                        /*var installStatus = await Permission.requestInstallPackages.request();*/
                                        /*if (installStatus.isGranted) {
                                        versionStatus.value = 1;
                                        downloadStep.value = 0;
                                        downloadDir();
                                      } else {
                                        //未开启权限
                                      }*/

                                        // Get.offAll(() => HomePage(), binding: HomeBinding());
                                        try {
                                          await Permission
                                              .requestInstallPackages
                                              .request();
                                        } catch (e) {
                                          //
                                        }
                                      });
                                    }
                                  }
                                } else {
                                  ///确定
                                  if (currentSize.value == totalSize.value) {
                                    uploadAPK();
                                  }
                                }
                              },
                              child: Container(
                                width: 248.w * 3,
                                height: 44.w * 3,
                                margin: EdgeInsets.fromLTRB(0, 260.w * 3, 0, 0),
                                decoration: BoxDecoration(
                                    color: (versionStatus.value == 0 ||
                                            currentSize.value ==
                                                totalSize.value)
                                        ? HhColors.mainBlueColor
                                        : HhColors.mainBlueColorUn,
                                    borderRadius:
                                        BorderRadius.circular(8.w * 3)),
                                child: Center(
                                  child: Text(
                                    versionStatus.value == 0 ? "立即更新" : "确定",
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: HhColors.whiteColor,
                                        fontSize: 16.sp * 3,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          useRootNavigator: true,
          barrierDismissible: false);
    } catch (e) {
      HhLog.e("getVersion error  $e");
    }
  }

  Future<void> downloadDir() async {
    try {
      // 获取设备的存储目录
      final directory = await getApplicationCacheDirectory();
      savePath = '${directory.path}/iot.apk';

      // 开始下载文件
      await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // 计算下载进度
            currentSize.value = received;
            totalSize.value = total;
            downloadStep.value =
                int.parse(((received / total) * 100).toStringAsFixed(0));
          }
        },
      );
      HhLog.d('文件下载成功: $savePath');
      uploadAPK();
    } catch (e) {
      HhLog.d('下载失败: $e');
    }
  }

  Future<void> localVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    buildNumber.value = packageInfo.buildNumber;
    HhLog.d('localVersion ${buildNumber.value},${version.value}');
  }

  uploadAPK() async {
    await OpenFile.open(savePath,
        type: "application/vnd.android.package-archive");
  }
}
