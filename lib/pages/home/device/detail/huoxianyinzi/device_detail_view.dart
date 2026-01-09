import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/map_location_search/map_location_search_binding.dart';
import 'package:iot/pages/common/map_location_search/map_location_search_view.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/fijkpanel.dart';
import 'package:iot/pages/home/device/detail/huoxianyinzi/device_detail_controller.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/battery.dart';
// import 'package:qc_amap_navi/qc_amap_navi.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HXYZDeviceDetailPage extends StatelessWidget {
  final logic = Get.find<HXYZDeviceDetailController>();

  HXYZDeviceDetailPage(String deviceNo, String id, int shareMark, bool offlineTag, {super.key}) {
    logic.deviceNo = deviceNo;
    logic.id = id;
    logic.shareMark = shareMark;
    logic.offlineTag.value = offlineTag;
  }

  Widget buildCustomPanel() {
    return Stack(
      children: [
        // 在面板底部添加一个播放/暂停按钮
        Positioned(
          bottom: 50,
          left: 1.sw / 2 - 30, // 居中按钮
          child: IconButton(
            icon: Icon(
              logic.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              if (logic.isPlaying.value) {
                logic.player.pause();
              } else {
                logic.player.start();
              }
              logic.isPlaying.value = !logic.isPlaying.value;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    logic.initData();
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.light, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.light, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
          height: 1.sh,
          width: 1.sw,
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///背景图
              Image.asset(
                "assets/images/common/test_video.jpg",
                width: 1.sw,
                height: 254.h * 3,
                fit: BoxFit.fill,
              ),
              Container(
                width: 1.sw,
                height: 254.h * 3,
                color: HhColors.blackColor,
              ),
              logic.playTag.value
                  ? GestureDetector(
                      onLongPress: () {
                        logic.fix.value = true;
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          logic.fix.value = false;
                        });
                      },
                      child: InteractiveViewer(
                        panEnabled: true, // 是否允许拖动
                        minScale: 1.0,
                        maxScale: 10.0,
                        onInteractionEnd:(a){
                          logic.transformationController.value = Matrix4.identity();
                        },
                        transformationController: logic.transformationController,
                        child: SizedBox(
                          width: double.infinity,
                          height: 254.h * 3,
                          child: Stack(
                            children: [
                              Transform(
                                transform: Matrix4.identity()
                                  ..scale(logic.scale.value)//缩放比例
                                ..translate(logic.dx.value,logic.dy.value)
                                ,
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(top: 0.h * 3),
                                  child: ScreenRecorder(
                                    width: double.infinity,
                                    height: 254.h * 3,
                                    background: Colors.white,
                                    controller: logic.recordController,
                                    child: Screenshot(
                                      controller: logic.screenshotController,
                                      child: FijkView(
                                        width: double.infinity,
                                        height: 254.h * 3,
                                        player: logic.player,
                                        color: HhColors.blackColor,
                                        fit: FijkFit.fill,
                                        fsFit: FijkFit.ar16_9,
                                        panelBuilder: hhFijkPanelBuilder,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              logic.fix.value
                                  ? Center(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    4.h * 3,
                                                    0.h * 3,
                                                    4.h * 3,
                                                    1.h * 3),
                                                decoration: BoxDecoration(
                                                    color: HhColors
                                                        .mainGreenColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.h * 3)),
                                                child: Text(
                                                  '自动对焦',
                                                  style: TextStyle(
                                                      color:
                                                          HhColors.whiteColor,
                                                      fontSize: 12.sp * 3),
                                                )),
                                            SizedBox(
                                              height: 19.h * 3,
                                            ),
                                            Image.asset(
                                              "assets/images/common/icon_fix.png",
                                              width: 56.h * 3,
                                              height: 56.h * 3,
                                              fit: BoxFit.fill,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              logic.playLoadingTag.value
                  ? Container(
                width: 1.sw,
                height: 254.h * 3,
                color: HhColors.blackRealColor,
              ): const SizedBox(),
              logic.playErrorTag.value
                  ? Container(
                width: 1.sw,
                height: 254.h * 3,
                color: HhColors.blackRealColor,
                child: Stack(
                  children: [
                    Align(
                      alignment:Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 50.w*3,),
                          Image.asset(
                            "assets/images/common/ic_video_error.png",
                            width: 36.w*3,
                            height: 36.w*3,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 5.w*3,),
                          Text(
                            '火险因子监测站暂无视频展示',
                            style: TextStyle(
                                color: HhColors.gray6TextColor,
                                fontSize: 14.sp * 3,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : const SizedBox(),
              logic.offlineTag.value
                  ? Container(
                width: 1.sw,
                height: 254.h * 3,
                color: HhColors.blackRealColor,
                child: Stack(
                  children: [
                    Align(
                      alignment:Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 50.w*3,),
                          Image.asset(
                            "assets/images/common/ic_offline.png",
                            width: 30.w*3,
                            height: 30.w*3,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 5.w*3,),
                          Text(
                            '设备已离线',
                            style: TextStyle(
                                color: HhColors.gray6TextColor,
                                fontSize: 14.sp * 3,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : const SizedBox(),

              ///title
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.h * 3, 59.h * 3, 0, 0),
                  color: HhColors.trans,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/common/back_white.png",
                        height: 17.h * 3,
                        width: 10.h * 3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 12.h * 3,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.5.sw),
                        child: Text(
                          logic.name.value,
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 16.sp * 3,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: 5.h * 3,
                      ),
                      logic.videoTag.value
                          ? Container(
                              padding: EdgeInsets.fromLTRB(
                                  6.h * 3, 2.h * 3, 10.h * 3, 2.h * 3),
                              decoration: BoxDecoration(
                                color: HhColors.mainRedColor,
                                borderRadius: BorderRadius.circular(11.h * 3),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/common/luxiang.png",
                                    width: 12.h * 3,
                                    height: 12.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    width: 2.h * 3,
                                  ),
                                  Text(
                                    "${CommonUtils().parseZero(logic.videoMinute.value)}:${CommonUtils().parseZero(logic.videoSecond.value)}",
                                    style: TextStyle(
                                        color: HhColors.whiteColor,
                                        fontSize: 13.sp * 3,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),

              ///battery
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {

                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 57.h * 3, 50.h * 3, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BatteryWidget(
                          width: 14.w*3,
                          height: 20.w*3,
                          batteryLevel: parseBatteryValue(logic.energyQuantity.value),
                          // charging: true, //启用充电动画
                        ),
                        SizedBox(
                          height:2.w*3,
                        ),
                        Text(
                          "电量",
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 10.sp*3,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ///setting
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    if (logic.item['deviceNo'] == null) {
                      EventBusUtil.getInstance()
                          .fire(HhToast(title: '设备信息加载中..请稍候', type: 0));
                      return;
                    }
                    showEditDeviceDialog(logic.item);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 57.h * 3, 14.h * 3, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/common/icon_detail_more.png",
                          width: 24.w * 3,
                          height: 24.w * 3,
                          fit: BoxFit.fill,
                        ),
                        Text(
                          "更多",
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 10.sp*3,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              ///tab
              Container(
                height: 45.h * 3,
                color: HhColors.whiteColor,
                margin: EdgeInsets.fromLTRB(0, 259.h * 3, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 0.3.sw,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HhTap(
                              overlayColor: Colors.transparent,
                              onTapUp: () {
                                logic.tabIndex.value = 0;
                              },
                              child: Container(
                                height: 40.h * 3,
                                color: HhColors.trans,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5.h),
                                      child: Image.asset(
                                        logic.tabIndex.value == 0
                                            ? "assets/images/common/icon_live.png"
                                            : "assets/images/common/icon_live_.png",
                                        width: 16.h * 3,
                                        height: 16.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.h,
                                    ),
                                    Text(
                                      '实时视频',
                                      style: TextStyle(
                                          color: logic.tabIndex.value == 0
                                              ? HhColors.mainBlueColor
                                              : HhColors.gray6TextColor,
                                          fontSize: logic.tabIndex.value == 0
                                              ? 14.sp * 3
                                              : 14.sp * 3,
                                          fontWeight: logic.tabIndex.value == 0
                                              ? FontWeight.w500
                                              : FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            logic.tabIndex.value == 0
                                ? Container(
                              height: 4.h,
                              width: 140.h,
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.h))),
                            )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 0.3.sw,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HhTap(
                              overlayColor: Colors.transparent,
                              onTapUp: () {
                                logic.tabIndex.value = 1;
                              },
                              child: Container(
                                height: 40.h * 3,
                                color: HhColors.trans,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 5.h),
                                      child: Image.asset(
                                        logic.tabIndex.value == 1
                                            ? "assets/images/common/icon_datas.png"
                                            : "assets/images/common/icon_datas_un.png",
                                        width: 16.h * 3,
                                        height: 16.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.h,
                                    ),
                                    Text(
                                      '数据统计',
                                      style: TextStyle(
                                          color: logic.tabIndex.value == 1
                                              ? HhColors.mainBlueColor
                                              : HhColors.gray6TextColor,
                                          fontSize: logic.tabIndex.value == 1
                                              ? 14.sp * 3
                                              : 14.sp * 3,
                                          fontWeight: logic.tabIndex.value == 1
                                              ? FontWeight.w500
                                              : FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            logic.tabIndex.value == 1
                                ? Container(
                              height: 4.h,
                              width: 140.h,
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.h))),
                            )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 0.3.sw,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HhTap(
                              overlayColor: Colors.transparent,
                              onTapUp: () {
                                logic.tabIndex.value = 2;
                              },
                              child: Container(
                                height: 40.h * 3,
                                color: HhColors.trans,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 3.h),
                                      child: Image.asset(
                                        logic.tabIndex.value == 2
                                            ? "assets/images/common/icon_msg_.png"
                                            : "assets/images/common/icon_msg.png",
                                        width: 16.h * 3,
                                        height: 16.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.h,
                                    ),
                                    Text(
                                      '历史消息',
                                      style: TextStyle(
                                          color: logic.tabIndex.value == 2
                                              ? HhColors.mainBlueColor
                                              : HhColors.gray6TextColor,
                                          fontSize: logic.tabIndex.value == 2
                                              ? 14.sp * 3
                                              : 14.sp * 3,
                                          fontWeight: logic.tabIndex.value == 2
                                              ? FontWeight.w500
                                              : FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            logic.tabIndex.value == 2
                                ? Container(
                              height: 4.h,
                              width: 140.h,
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.h))),
                            )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 0.3.sw,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HhTap(
                              overlayColor: Colors.transparent,
                              onTapUp: () {
                                logic.tabIndex.value = 3;
                                logic.getLocationByDeviceNo();
                                logic.getNowWeatherByDeviceNo();
                              },
                              child: Container(
                                height: 40.h * 3,
                                color: HhColors.trans,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 3.h),
                                      child: Image.asset(
                                        logic.tabIndex.value == 3
                                            ? "assets/images/common/icon_weather_select.png"
                                            : "assets/images/common/icon_weather_un.png",
                                        width: 16.h * 3,
                                        height: 16.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.h,
                                    ),
                                    Text(
                                      '天气信息',
                                      style: TextStyle(
                                          color: logic.tabIndex.value == 3
                                              ? HhColors.mainBlueColor
                                              : HhColors.gray6TextColor,
                                          fontSize: logic.tabIndex.value == 3
                                              ? 14.sp * 3
                                              : 14.sp * 3,
                                          fontWeight: logic.tabIndex.value == 3
                                              ? FontWeight.w500
                                              : FontWeight.w200),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            logic.tabIndex.value == 3
                                ? Container(
                              height: 4.h,
                              width: 140.h,
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.h))),
                            )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 305.h * 3, 0, 0),
                child: parsePager(),
              ),

              logic.testStatus.value ? const SizedBox() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
  parsePager() {
    if(logic.tabIndex.value == 0){
      return livePage();
    }
    if(logic.tabIndex.value == 1){
      return dataPage();
    }
    if(logic.tabIndex.value == 2){
      return historyPage();
    }
    if(logic.tabIndex.value == 3){
      return weatherPage();
    }
    return Container();
  }

  weatherPage() {
    return EasyRefresh(
      onRefresh: (){
        logic.getLocationByDeviceNo();
        logic.getNowWeatherByDeviceNo();
        if(logic.weatherIndex.value==0){
          logic.get7daysWeatherByDeviceNo();
        }else{
          logic.getHistoricalWeatherByDeviceNo();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///现在天气
            Container(
              height: 194.w*3,
              margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w*3),
                gradient: const LinearGradient(
                  colors: [
                    HhColors.weatherLeft,
                    HhColors.weatherLeft2,
                    HhColors.weatherMid,
                    HhColors.weatherRight,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Column(
                children: [
                  ///省市国家&&时间
                  Container(
                    margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                    child: Row(
                      children: [
                        Text(
                          CommonUtils().parseNull("${logic.weatherModel.value["adm2"]}", ""),
                          style: TextStyle(
                              color: HhColors.blackTextColor,
                              fontSize: 14.sp * 3,fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 10.w*3,),
                        Text(
                          CommonUtils().parseNull("${logic.weatherModel.value["adm1"]}", ""),
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "/",
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 11.sp * 3,fontWeight: FontWeight.w400),
                        ),
                        Text(
                          CommonUtils().parseNull("${logic.weatherModel.value["country"]}", ""),
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          CommonUtils().parseNull("${logic.weatherModel.value["time"]}", ""),
                          style: TextStyle(
                              color: HhColors.gray9TextColor,
                              fontSize: 11.sp * 3,fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  ///天气
                  logic.weatherModel.value["temp"]!=null?Container(
                    margin: EdgeInsets.only(top: 10.w*3),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: 62.w*3,
                            height: 62.w*3,
                            child: WebViewWidget(controller: logic.webController,)),
                        SizedBox(width: 10.w*3,),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CommonUtils().parseNull("${logic.weatherModel.value["temp"]}°", ""),
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 32.sp * 3,fontWeight: FontWeight.w600),
                            ),
                            Text(
                              CommonUtils().parseNull("${logic.weatherModel.value["text"]}", ""),
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ):const SizedBox(),
                  Container(
                    height: 56.w*3,
                    width: 1.sw,
                    margin: EdgeInsets.only(top: 15.w*3,left: 14.w*3,right: 14.w*3),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(10.w*3)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15.w*3,),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5.w*3),
                                child: Text(
                                  "湿度",
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5.w*3,),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/common/icon_weather_sd.png",
                                    width: 20.w * 3,
                                    height: 20.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 2.w*3,),
                                  Expanded(
                                    child: Text(
                                      "${CommonUtils().parseNull("${logic.weatherModel.value["humidity"]}", "")}%",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HhColors.blackTextColor,
                                          fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5.w*3),
                                child: Text(
                                  CommonUtils().parseNull("${logic.weatherModel.value["windDir"]}", ""),
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5.w*3,),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/common/icon_weather_wind.png",
                                    width: 20.w * 3,
                                    height: 20.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 2.w*3,),
                                  Expanded(
                                    child: Text(
                                      "${CommonUtils().parseNull("${logic.weatherModel.value["windScale"]}", "")}级",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HhColors.blackTextColor,
                                          fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5.w*3),
                                child: Text(
                                  "气压",
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5.w*3,),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/common/icon_weather_sd.png",
                                    width: 20.w * 3,
                                    height: 20.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 2.w*3,),
                                  Expanded(
                                    child: Text(
                                      "${CommonUtils().parseNull("${logic.weatherModel.value["pressure"]}", "")}hpa",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HhColors.blackTextColor,
                                          fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5.w*3),
                                child: Text(
                                  "降水量",
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 11.sp * 3,fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: 5.w*3,),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/common/icon_weather_water.png",
                                    width: 20.w * 3,
                                    height: 20.w * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 2.w*3,),
                                  Expanded(
                                    child: Text(
                                      CommonUtils().parseNull("${logic.weatherModel.value["precip"]}", ""),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HhColors.blackTextColor,
                                          fontSize: 13.sp * 3,fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ///tab
            Row(
              children: [
                SizedBox(width: 14.w*3,),
                HhTap(
                  overlayColor: HhColors.trans,
                  onTapUp: (){
                    logic.weatherIndex.value = 0;
                    logic.get7daysWeatherByDeviceNo();
                  },
                  child: Container(
                    height: 40.w*3,
                    width: 88.w*3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.w*3),
                        border: Border.all(color: HhColors.grayDDTextColor, width: 2.w)
                    ),
                    child: Text(
                      '最新天气',
                      style: TextStyle(
                          color: logic.weatherIndex.value == 0
                              ? HhColors.mainBlueColor
                              : HhColors.blackTextColor,
                          fontSize: 14.sp * 3),
                    ),
                  ),
                ),
                SizedBox(width: 20.w*3,),
                HhTap(
                  overlayColor: HhColors.trans,
                  onTapUp: (){
                    logic.weatherIndex.value = 1;
                    logic.getHistoricalWeatherByDeviceNo();
                  },
                  child: Container(
                    height: 40.w*3,
                    width: 88.w*3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.w*3),
                        border: Border.all(color: HhColors.grayDDTextColor, width: 2.w)
                    ),
                    child: Text(
                      '过去7天',
                      style: TextStyle(
                          color: logic.weatherIndex.value == 1
                              ? HhColors.mainBlueColor
                              : HhColors.blackTextColor,
                          fontSize: 14.sp * 3),
                    ),
                  ),
                ),
              ],
            ),

            ///七天天气
            Container(
              width: 1.sw,
              margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
              padding: EdgeInsets.only(bottom: 15.w*3),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.circular(8.w*3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: build7Days(),
              ),
            )
          ],
        ),
      ),
    );
  }

  build7Days() {
    List<Widget> list = [];
    for (int i = 0; i < logic.weatherList.length; i++) {
      dynamic model = logic.weatherList.value[i];
      late WebViewController webController = WebViewController()
        ..setBackgroundColor(HhColors.trans)..runJavaScript(
            "document.documentElement.style.overflow = 'hidden';"
                "document.body.style.overflow = 'hidden';");
      webController.setJavaScriptMode(JavaScriptMode.unrestricted);
      webController.enableZoom(true);
      webController.runJavaScript(
          "document.documentElement.style.overflow = 'hidden';"
              "document.body.style.overflow = 'hidden';");
      webController.setBackgroundColor(HhColors.trans);
      String weatherUrl = CommonUtils().getHeFengIcon(
          ((logic.weatherIndex.value==0?"${model['textDay']}".contains("晴"):"${model['text']}".contains("晴") )? "FFB615" : "368EFF"), logic.weatherIndex.value==0?"${model['iconDay']}":"${model['icon']}", "100");
      webController.loadRequest(Uri.parse(weatherUrl));
      String week = CommonUtils().parseWeek(logic.weatherIndex.value==0?CommonUtils().parseNull('${model["fxDate"]}', "")
          :CommonUtils().parseNull('${model["date"]}', ""));
      String time = CommonUtils().parseTime(logic.weatherIndex.value==0?CommonUtils().parseNull('${model["fxDate"]}', "")
          :CommonUtils().parseNull('${model["date"]}', ""));
      list.add(
          Container(
            margin: EdgeInsets.fromLTRB(20.w*3, 15.w*3, 20.w*3, 0),
            child: Row(
              children: [
                SizedBox(
                  width: 100.w*3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        week,
                        style: TextStyle(
                            color: HhColors.blackTextColor,
                            fontSize: 14.sp * 3),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                            color: HhColors.gray9TextColor,
                            fontSize: 12.sp * 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: 26.w*3,
                    height: 26.w*3,
                    child: WebViewWidget(controller: webController,)),
                const Spacer(),
                Text(
                  '${CommonUtils().parseNull("${model["tempMax"]}", "")}°',
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp * 3),
                ),
                SizedBox(width: 3.w*3,),
                Container(
                  height: 4.w*3,
                  width: 63.w*3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.w*3),
                    gradient: const LinearGradient(
                      colors: [
                        HhColors.weather1,
                        HhColors.weather2,
                        HhColors.weather3,
                        HhColors.weather4,
                        HhColors.weather5,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                SizedBox(width: 5.w*3,),
                Text(
                  '${CommonUtils().parseNull("${model["tempMin"]}", "")}°',
                  style: TextStyle(
                      color: HhColors.blackTextColor,
                      fontSize: 14.sp * 3),
                ),
                SizedBox(width: 10.w*3,),
              ],
            ),
          )
      );
      webController.loadRequest(Uri.parse(weatherUrl));
    }
    return list;
  }

  livePage() {
    final size = MediaQuery.of(logic.context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        logic.liveStatus.value
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: buildCameraTabs(),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 240.h * 3,
                  height: 240.h * 3,
                  margin: EdgeInsets.only(top: 10.h*3),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120.h*3),
                          boxShadow: [
                            BoxShadow(
                              color: HhColors.shadowColor.withOpacity(0.9), // 阴影颜色及透明度
                              spreadRadius: 0.8,  // 阴影扩展的范围
                              blurRadius: 8,   // 阴影的模糊程度
                              offset: const Offset(0, 4),  // 阴影的偏移量
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/common/icon_board_clip.png",
                          width: 240.h * 3,
                          height: 240.h * 3,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTapDown: (v){
                            logic.upTap.value = true;
                            logic.command = "UP";
                            logic.controlPost(0);
                          },
                          onTapUp: (v){
                            logic.upTap.value = false;
                            logic.controlPost(1);
                          },
                          onTapCancel: (){
                            logic.upTap.value = false;
                            logic.controlPost(1);
                          },
                          child: SizedBox(
                            width: 85.h * 3,
                            height: 63.h * 3,
                            child: Stack(
                              children: [
                                Image.asset(
                                  logic.upTap.value?"assets/images/common/icon_tap_up.png":"assets/images/common/icon_null.png",
                                  width: 85.h * 3,
                                  height: 63.h * 3,
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/single_top.png",
                                    width: 22.h * 3,
                                    height: 13.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTapDown: (v){
                            logic.downTap.value = true;
                            logic.command = "DOWN";
                            logic.controlPost(0);
                          },
                          onTapUp: (v){
                            logic.downTap.value = false;
                            logic.controlPost(1);
                          },
                          onTapCancel: (){
                            logic.downTap.value = false;
                            logic.controlPost(1);
                          },
                          child: SizedBox(
                            width: 85.h * 3,
                            height: 63.h * 3,
                            child: Stack(
                              children: [
                                Image.asset(
                                  logic.downTap.value?"assets/images/common/icon_tap_down.png":"assets/images/common/icon_null.png",
                                  width: 85.h * 3,
                                  height: 63.h * 3,
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/single_bottom.png",
                                    width: 22.h * 3,
                                    height: 13.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTapDown: (v){
                            logic.leftTap.value = true;
                            logic.command = "LEFT";
                            logic.controlPost(0);
                          },
                          onTapUp: (v){
                            logic.leftTap.value = false;
                            logic.controlPost(1);
                          },
                          onTapCancel: (){
                            logic.leftTap.value = false;
                            logic.controlPost(1);
                          },
                          child: SizedBox(
                            width: 63.h * 3,
                            height: 85.h * 3,
                            child: Stack(
                              children: [
                                Image.asset(
                                  logic.leftTap.value?"assets/images/common/icon_tap_left.png":"assets/images/common/icon_null.png",
                                  width: 63.h * 3,
                                  height: 85.h * 3,
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/single_left.png",
                                    width: 13.h * 3,
                                    height: 22.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (v){
                            logic.rightTap.value = true;
                            logic.command = "RIGHT";
                            logic.controlPost(0);
                          },
                          onTapUp: (v){
                            logic.rightTap.value = false;
                            logic.controlPost(1);
                          },
                          onTapCancel: (){
                            logic.rightTap.value = false;
                            logic.controlPost(1);
                          },
                          child: SizedBox(
                            width: 63.h * 3,
                            height: 85.h * 3,
                            child: Stack(
                              children: [
                                Image.asset(
                                  logic.rightTap.value?"assets/images/common/icon_tap_right.png":"assets/images/common/icon_null.png",
                                  width: 63.h * 3,
                                  height: 85.h * 3,
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/images/common/single_right.png",
                                    width: 13.h * 3,
                                    height: 22.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 6.h*3,
                          height: 6.h*3,
                          margin: EdgeInsets.fromLTRB(0, 52.h*3, 52.h*3, 0),
                          decoration: BoxDecoration(
                            color: HhColors.grayC3TextColor,
                            borderRadius: BorderRadius.circular(3.h*3)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 6.h*3,
                          height: 6.h*3,
                          margin: EdgeInsets.fromLTRB(0, 0, 52.h*3, 52.h*3),
                          decoration: BoxDecoration(
                            color: HhColors.grayC3TextColor,
                            borderRadius: BorderRadius.circular(3.h*3)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 6.h*3,
                          height: 6.h*3,
                          margin: EdgeInsets.fromLTRB(52.h*3, 0, 0, 52.h*3),
                          decoration: BoxDecoration(
                            color: HhColors.grayC3TextColor,
                            borderRadius: BorderRadius.circular(3.h*3)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 6.h*3,
                          height: 6.h*3,
                          margin: EdgeInsets.fromLTRB(52.h*3, 52.h*3, 0, 0),
                          decoration: BoxDecoration(
                            color: HhColors.grayC3TextColor,
                            borderRadius: BorderRadius.circular(3.h*3)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "切换角度",
                          style: TextStyle(
                              color: HhColors.gray6TextColor,
                              fontSize: 14.sp * 3),
                        ),
                      ),
                      ///控制背景阴影
                      /*Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 215.h * 3,
                          height: 215.h * 3,
                          // margin: EdgeInsets.only(top: 60.h*3),
                          decoration: BoxDecoration(
                              color: HhColors.videoControlShadowColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(110.h * 3))),
                        ),
                      ),*/

                      ///控制拖动按钮
                      /*Align(
                          alignment: logic.animateAlign,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              logic.animateAlign += Alignment(
                                details.delta.dx / (size.width / 2),
                                details.delta.dy / (size.height / 2),
                              );
                              logic.testStatus.value = false;
                              logic.testStatus.value = true;

                              String msg = '';
                              double offset = 20;
                              double x = details.delta.dx;
                              double y = details.delta.dy;
                              int time = DateTime.now().millisecondsSinceEpoch;
                              if (time - logic.controlTime > 1000) {
                                HhLog.d(
                                    "move ${details.delta.dx} , ${details.delta.dy}");
                                logic.controlTime = time;
                                if (x > 0 && y < 0) {
                                  msg = "右上";
                                  logic.commandLast = logic.command;
                                  logic.command = "RIGHT_UP";
                                }
                                if (x > 0 && y == 0) {
                                  msg = "右";
                                  logic.commandLast = logic.command;
                                  logic.command = "RIGHT";
                                }
                                if (x > 0 && y > 0) {
                                  msg = "右下";
                                  logic.commandLast = logic.command;
                                  logic.command = "RIGHT_DOWN";
                                }
                                if (x == 0 && y > 0) {
                                  msg = "下";
                                  logic.commandLast = logic.command;
                                  logic.command = "DOWN";
                                }
                                if (x < 0 && y > 0) {
                                  msg = "左下";
                                  logic.commandLast = logic.command;
                                  logic.command = "LEFT_DOWN";
                                }
                                if (x < 0 && y == 0) {
                                  msg = "左";
                                  logic.commandLast = logic.command;
                                  logic.command = "LEFT";
                                }
                                if (x < 0 && y < 0) {
                                  msg = "左上";
                                  logic.commandLast = logic.command;
                                  logic.command = "LEFT_UP";
                                }
                                if (x == 0 && y < 0) {
                                  msg = "上";
                                  logic.commandLast = logic.command;
                                  logic.command = "UP";
                                }
                                // EventBusUtil.getInstance().fire(HhToast(title: msg));
                                logic.controlPost(0);
                              }
                            },
                            onPanEnd: (details) {
                              logic.animateAlign = Alignment.center;
                              logic.testStatus.value = false;
                              logic.testStatus.value = true;
                              // EventBusUtil.getInstance().fire(HhToast(title: 'STOP'));
                              logic.controlPost(1);
                            },
                            child: Container(
                              width: 240.h * 3,
                              height: 240.h * 3,
                              // margin: EdgeInsets.only(top: 60.h*3),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/common/video_board.png",
                                    width: 240.h * 3,
                                    height: 240.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0, 20.h * 3, 0, 0),
                                      child: Image.asset(
                                        "assets/images/common/top.png",
                                        width: 25.h * 3,
                                        height: 25.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0, 0, 0, 30.h * 3),
                                      child: Image.asset(
                                        "assets/images/common/bottom.png",
                                        width: 25.h * 3,
                                        height: 25.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          25.h * 3, 0, 0, 0),
                                      child: Image.asset(
                                        "assets/images/common/left.png",
                                        width: 25.h * 3,
                                        height: 25.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          0, 0, 23.h * 3, 0),
                                      child: Image.asset(
                                        "assets/images/common/right.png",
                                        width: 25.h * 3,
                                        height: 25.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 0, 0, 10.h),
                                      child: Text(
                                        "切换角度",
                                        style: TextStyle(
                                            color: HhColors.gray6TextColor,
                                            fontSize: 14.sp * 3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),*/

                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 126.h * 3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTapDown: (a) {
                            logic.fixLeft.value = true;
                            logic.command = "ZOOM_OUT";
                            logic.controlPost(0);
                          },
                          onTapUp: (a) {
                            logic.fixLeft.value = false;
                            logic.command = "ZOOM_OUT";
                            logic.controlPost(1);
                          },
                          onTapCancel: () {
                            logic.fixLeft.value = false;
                            logic.command = "ZOOM_OUT";
                            logic.controlPost(1);
                          },
                          child: Container(
                            width: 44.h * 3,
                            height: 44.h * 3,
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.circular(8.h * 3)),
                            child: Center(
                              child: Text(
                                '—',
                                style: TextStyle(
                                    color: logic.fixLeft.value
                                        ? HhColors.mainBlueColor
                                        : HhColors.gray6TextColor,
                                    fontSize: 17.sp * 3),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 90.h * 3,
                          height: 44.h * 3,
                          child: Center(
                            child: Text(
                              '焦距',
                              style: TextStyle(
                                  color: HhColors.blackColor,
                                  fontSize: 15.sp * 3),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (a) {
                            logic.fixRight.value = true;
                            logic.command = "ZOOM_IN";
                            logic.controlPost(0);
                          },
                          onTapUp: (a) {
                            logic.fixRight.value = false;
                            logic.command = "ZOOM_IN";
                            logic.controlPost(1);
                          },
                          onTapCancel: () {
                            logic.fixRight.value = false;
                            logic.command = "ZOOM_IN";
                            logic.controlPost(1);
                          },
                          child: Container(
                            width: 44.h * 3,
                            height: 44.h * 3,
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.circular(8.h * 3)),
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                    color: logic.fixRight.value
                                        ? HhColors.mainBlueColor
                                        : HhColors.gray6TextColor,
                                    fontSize: 20.sp * 3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.h * 3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        logic.functionItem.value.contains('录像')
                            ? BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  logic.videoTag.value = !logic.videoTag.value;
                                  if (logic.videoTag.value) {
                                    //开启录像
                                    logic.startRecord();
                                  } else {
                                    //关闭录像
                                    logic.stopRecord();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 0.h * 3),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        logic.videoTag.value
                                            ? "assets/images/common/ic_video_yes.png"
                                            : "assets/images/common/ic_video.png",
                                        width: 76.h * 3,
                                        height: 76.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        logic.videoTag.value ? '正在录像' : '录像',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 14.sp * 3),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        logic.functionItem.value.contains('截图')
                            ? BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  logic.saveImageToGallery();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 13.h * 3),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/common/ic_picture.png",
                                        width: 76.h * 3,
                                        height: 76.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        '拍照',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 14.sp * 3),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        logic.functionItem.value.contains('对讲')
                            ? BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  logic.recordTag.value =
                                      !logic.recordTag.value;
                                  if (logic.recordTag.value) {
                                    //开始
                                    logic.chatStatus();
                                  } else {
                                    //结束
                                    logic.recordTag2.value = false;
                                    logic.manager.stopRecording();
                                    logic.chatClose();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 13.h * 3),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /*logic.recordTag.value?Container(
                                    width: 230.h,
                                    height: 80.h,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.circular(20.h)
                                    ),
                                    child:  PolygonWaveform(
                                      samples: [1,2,3,444,9999,66,89,6,4,999999,13120],
                                      height: 230.h,
                                      width: 80.h,
                                    )):const SizedBox(),*/
                                      Image.asset(
                                        logic.recordTag.value
                                            ? (logic.recordTag2.value
                                                ? "assets/images/common/ic_yy_close.png"
                                                : "assets/images/common/ic_yy_ing.png")
                                            : "assets/images/common/ic_yy.png",
                                        width: 76.h * 3,
                                        height: 76.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        logic.recordTag.value
                                            ? (logic.recordTag2.value
                                                ? '挂断'
                                                : '呼叫中...')
                                            : '对讲',
                                        style: TextStyle(
                                            color: logic.recordTag.value
                                                ? (logic.recordTag2.value
                                                    ? HhColors.mainRedColor
                                                    : HhColors.mainBlueColor)
                                                : HhColors.blackTextColor,
                                            fontSize: 14.sp * 3),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        logic.functionItem.value.contains('设置')
                            ? BouncingWidget(
                                duration: const Duration(milliseconds: 100),
                                scaleFactor: 1.2,
                                onPressed: () {
                                  Get.to(
                                      () => LiGanDetailPage(
                                          logic.deviceNo, logic.id),
                                      binding: LiGanDetailBinding());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 13.h * 3),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/common/icon_setting_video.png",
                                        width: 76.h * 3,
                                        height: 76.h * 3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        '设置',
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 14.sp * 3),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  dataPage() {
    final size = MediaQuery.of(logic.context).size;
    return logic.dataStatus.value?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///园区火险因子展示--火险等级-电量-当日用电量
          Container(
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
            padding: EdgeInsets.all(15.w*3),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(8.w*3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(logic.name.value,style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w600),),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("火险等级",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text(logic.parseLevel(logic.fireLevel.value),style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("电量",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text(logic.energyQuantity.value,style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("当日用电量",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text(logic.energyConsumption.value,style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
              ],
            ),
          ),
          ///操作按钮--最新-上一条-下一条
          Container(
            margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 5.w*3),
            child: Row(
              children: [
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    logic.dataPageNum = 1;
                    logic.getDataPage();
                  },
                  child: Container(
                      height: 40.w*3,
                      width: 88.w*3,
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.w*3)
                      ),
                      child: Center(child: Text("最新",style: TextStyle(color: HhColors.blueTextColor,fontSize: 14.sp*3),))
                  ),
                ),
                const Expanded(child: SizedBox()),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    logic.dataPageNum--;
                    if(logic.dataPageNum<1){
                      logic.dataPageNum = 1;
                      EventBusUtil.getInstance().fire(HhToast(title: "当前已是第一条\n已为您加载最新一条数据",type: 0));
                    }
                    logic.getDataPage();
                  },
                  child: Container(
                      height: 40.w*3,
                      width: 88.w*3,
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.w*3)
                      ),
                      child: Center(child: Text("上一条",style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),))
                  ),
                ),
                const Expanded(child: SizedBox()),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    logic.dataPageNum++;
                    logic.getDataPage();
                  },
                  child: Container(
                      height: 40.w*3,
                      width: 88.w*3,
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(8.w*3)
                      ),
                      child: Center(child: Text("下一条",style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),))
                  ),
                ),

              ],
            ),
          ),
          ///太阳能控制器--
          Container(
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
            padding: EdgeInsets.all(15.w*3),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.circular(8.w*3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("太阳能控制器",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w600),),
                    Expanded(child: Text(CommonUtils().parseLongTime("${logic.energyModel["collectTime"]}"),style: TextStyle(color: HhColors.gray9TextColor,fontSize: 15.sp*3,),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("负载电压",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["loadVoltage"]??"-"}",1)}V",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("负载电流",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["loadCurrent"]??"-"}",1)}A",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("太阳能电压",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["solarVoltage"]??"-"}",1)}V",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("太阳能电流",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["solarCurrent"]??"-"}",1)}A",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("蓄电池剩余电量",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["batteryRemain"]??"-"}",1)}%",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("蓄电池电压",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["batteryVoltage"]??"-"}",1)}V",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("蓄电池电流",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["batteryCurrent"]??"-"}",1)}A",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
              ],
            ),
          ),
          ///土壤传感数据--
          Container(
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
            padding: EdgeInsets.all(15.w*3),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.circular(8.w*3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("土壤传感数据",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w600),),
                    Expanded(child: Text(CommonUtils().parseLongTime("${logic.energyModel["collectTime"]}"),style: TextStyle(color: HhColors.gray9TextColor,fontSize: 15.sp*3,),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("土壤质量含水率",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["soilMassMoisture"]??"-"}",3)}%",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("凋落物含水率",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["litterMassMoisture"]??"-"}",3)}%",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("地表温度",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["surfaceTemperature"]??"-"}",3)}°C",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("地表湿度",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["surfaceHumidity"]??"-"}",3)}%",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("倾角X",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["inclinationX"]??"0"}",1)}°",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("倾角Y",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["inclinationY"]??"0"}",1)}°",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("倾角Z",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["inclinationZ"]??"0"}",1)}°",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
              ],
            ),
          ),
          ///气象站信息-
          Container(
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 10.w*3),
            padding: EdgeInsets.all(15.w*3),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.circular(8.w*3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("气象站信息",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w600),),
                    Expanded(child: Text(CommonUtils().parseLongTime("${logic.energyModel["collectTime"]}"),style: TextStyle(color: HhColors.gray9TextColor,fontSize: 15.sp*3,),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("空气温度",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["airTemperature"]??"-"}",3)}°C",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("空气湿度",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["airHumidity"]??"-"}",3)}%",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("大气压力",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["airPressure"]??"-"}",3)}KPa",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("风向(0-360)",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${logic.energyModel["windDirection"]??"-"}",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("风速",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["windSpeed"]??"-"}",3)}m/s",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("光照强度",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["illuminance"]??"-"}",3)}Lux",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("雨量",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["rainfall"]??"0"}",3)}mm",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
                CommonUtils.line(marginTop: 13.w*3,marginBottom: 13.w*3),
                Row(
                  children: [
                    Text("降雪",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),),
                    Expanded(child: Text("${CommonUtils().parseDoubleNumber("${logic.energyModel["snowfall"]??"0"}",3)}mm",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3),textAlign: TextAlign.end,)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ):const SizedBox();
  }

  historyPage() {
    return EasyRefresh(
      onRefresh: () {
        logic.pageNum = 1;
        logic.getDeviceHistory();
      },
      onLoad: () {
        logic.pageNum++;
        logic.getDeviceHistory();
      },
      child: PagedListView<int, dynamic>(
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          noItemsFoundIndicatorBuilder: (context) =>
              CommonUtils().noneWidget(top: 0.3.sw),
          itemBuilder: (context, item, index) => InkWell(
            onTap: () {},
            child: Container(
              height: 70.h * 3,
              margin: EdgeInsets.fromLTRB(14.h * 3, 0, 14.h * 3, 0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.trans,
                  borderRadius: BorderRadius.all(Radius.circular(6.h * 3))),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.h))),
                      child: "${item['alarmType']}".contains("offline")?SizedBox(
                        width: 109.h * 3,
                        height: 59.h * 3,
                        child: Center(
                          child: Image.asset(
                            "assets/images/common/icon_offline_warn.png",
                            width: 109.h * 3,
                            height: 59.h * 3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ):item['alarmImageUrl']==null?SizedBox(
                        width: 109.h * 3,
                        height: 59.h * 3,
                        child: Center(
                          child: Image.asset(
                            "assets/images/common/ic_message_no.png",
                            width: 109.h * 3,
                            height: 59.h * 3,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ):InkWell(
                        onTap: (){
                          CommonUtils().showPictureDialog(context, url:"${CommonData.endpoint}${item['alarmImageUrl']}");
                        },
                        child: Image.network(
                          '${logic.endpoint}${item['alarmImageUrl']}',
                          width: 109.h * 3,
                          height: 59.h * 3,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              "assets/images/common/ic_message_no.png",
                              width: 109.h * 3,
                              height: 59.h * 3,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.h * 3, 10.h, 0, 50.h),
                    child: Text(
                      logic.parseDate(item['alarmTimestamp']),
                      style: TextStyle(
                          color: HhColors.textBlackColor,
                          fontSize: 15.sp * 3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20.h * 3, 30.h * 3, 0, 0),
                      child: Text(
                        logic.parseType(item['alarmType']),
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 14.sp * 3,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 1.5.h * 3,
                      margin: EdgeInsets.fromLTRB(6.h * 3, 20.h * 3, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.blueEAColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(3.h))),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 6.h * 3,
                      height: 6.h * 3,
                      margin: EdgeInsets.fromLTRB(10.h, 10.h * 3, 0, 0),
                      decoration: BoxDecoration(
                          color: HhColors.mainBlueColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(3.h * 3))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditDeviceDialog(dynamic item) {
    showCupertinoDialog(
        context: logic.context,
        builder: (context) => Center(
              child: Container(
                width: 1.sw,
                height: 70.h * 3,
                margin: EdgeInsets.fromLTRB(30.h, 0, 30.h, 0),
                padding: EdgeInsets.fromLTRB(30.h, 35.h, 45.h, 25.h),
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.h))),
                child: Row(
                  children: [
                    CommonData.personal
                        ? Expanded(
                            child: BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: () {
                                if (item["shareMark"] == 2) {
                                  return;
                                }
                                Get.back();
                                DateTime date = DateTime.now();
                                String time = date
                                    .toIso8601String()
                                    .substring(0, 19)
                                    .replaceAll("T", " ");
                                Get.to(() => SharePage(),
                                    binding: ShareBinding(),
                                    arguments: {
                                      "shareType": "2",
                                      "expirationTime": time,
                                      "appShareDetailSaveReqVOList": [
                                        {
                                          "spaceId": "${item["spaceId"]}",
                                          "spaceName": "${item["spaceName"]}",
                                          "deviceId": "${item["id"]}",
                                          "deviceName": "${item["name"]}"
                                        }
                                      ]
                                    });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    item["shareMark"] == 2
                                        ? "assets/images/common/icon_edit_share_no.png"
                                        : "assets/images/common/icon_edit_share.png",
                                    width: 24.h * 3,
                                    height: 24.h * 3,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    height: 2.h * 3,
                                  ),
                                  Text(
                                    '分享',
                                    style: TextStyle(
                                        color: item["shareMark"] == 2
                                            ? HhColors.grayCCTextColor
                                            : HhColors.blackTextColor,
                                        fontSize: 14.sp * 3,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    CommonData.personal
                        ? SizedBox(
                            width: 50.h,
                          )
                        : const SizedBox(),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          Get.to(
                              () => DeviceAddPage(
                                    snCode: '${item['deviceNo']}',
                                  ),
                              binding: DeviceAddBinding(),
                              arguments: item);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_edit_edit.png",
                              width: 24.h * 3,
                              height: 24.h * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.h * 3,
                            ),
                            Text(
                              '修改',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.h,
                    ),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          Get.to(
                                  () => MapLocationSearchPage(),
                              binding: MapLocationSearchBinding(),
                              arguments: {
                                "name": CommonUtils().parseNull("${item['name']}", "")
                              });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_pop_map.png",
                              width: 24.h * 3,
                              height: 24.h * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.h * 3,
                            ),
                            Text(
                              '地图',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.h,
                    ),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          logic.resetDevice();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_video_reset.png",
                              width: 24 * 3.h,
                              height: 24 * 3.h,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.h * 3,
                            ),
                            Text(
                              '重启',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.h,
                    ),
                    Expanded(
                      child: BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.back();
                          CommonUtils().showDeleteDialog(
                              context,
                              logic.shareMark == 2
                                  ? '确定要删除“${item['name']}”?\n此设备是好友分享给你的设备'
                                  : '确定要删除“${item['name']}”?\n删除设备后无法恢复', () {
                            Get.back();
                          }, () {
                            Get.back();
                            logic.deleteDevice(item);
                          }, () {
                            Get.back();
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/common/icon_edit_delete.png",
                              width: 24.h * 3,
                              height: 24.h * 3,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: 2.h * 3,
                            ),
                            Text(
                              '删除',
                              style: TextStyle(
                                  color: HhColors.mainRedColor,
                                  fontSize: 14.sp * 3,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        barrierDismissible: true);
  }

  buildCameraTabs() {
    List<Widget> list = [];
    for (int i = 0; i < logic.liveList.length; i++) {
      dynamic live = logic.liveList[i];
      list.add(InkWell(
        onTap: () {
          logic.liveIndex.value = i;
          logic.deviceId = "${logic.liveList[logic.liveIndex.value]["deviceId"]}";
          logic.channelNumber = "${logic.liveList[logic.liveIndex.value]["channelId"]}";
          logic.getPlayUrl(logic.deviceId, logic.channelNumber);
        },
        child: Container(
            padding:
                EdgeInsets.fromLTRB(13.h * 3, 10.h * 3, 12.h * 3, 10.h * 3),
            margin: EdgeInsets.fromLTRB(10.h * 3, 10.h * 3, 0, 0),
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.h * 3)),
                border: Border.all(
                    color: HhColors.grayDDTextColor, width: 0.5.h * 3)),
            child: Text(
              '${live['channelName']}',
              style: TextStyle(
                  color: logic.liveIndex.value == i
                      ? HhColors.mainBlueColor
                      : HhColors.blackColor,
                  fontSize: 14.sp * 3),
            )),
      ));
    }
    list.add(SizedBox(
      width: 10.h * 3,
    ));
    return list;
  }

  parseBatteryValue(String value) {
    int battery = 100;
    try{
      battery = int.parse(value.replaceAll("%", ""));
    }catch(e){
      //
    }
    return battery;
  }
}
