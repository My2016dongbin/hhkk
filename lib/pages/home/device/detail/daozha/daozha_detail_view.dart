import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/daozha/daozha_detail_controller.dart';
import 'package:iot/pages/home/device/detail/fijkpanel.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/custom_ext.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:screenshot/screenshot.dart';

class DaoZhaDetailPage extends StatelessWidget {
  final logic = Get.find<DaoZhaDetailController>();

  DaoZhaDetailPage(String deviceNo, String id, int shareMark, bool offlineTag, {super.key}) {
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
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
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
              ///title
              Container(
                color: HhColors.whiteColor,
                height: 98.w * 3,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 54.w * 3),
                  color: HhColors.trans,
                  child: Text(
                    "道闸设备",
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 18.sp * 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.w * 3, 59.h * 3, 0, 0),
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
              ///setting
              /*Align(
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
                    child: Image.asset(
                      "assets/images/common/icon_set.png",
                      width: 24.h * 3,
                      height: 24.h * 3,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),*/

              ///设备名
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w*3, 100.w * 3, 0, 0),
                  color: HhColors.trans,
                  child: Text(
                    CommonUtils().parseNameCount(logic.name.value, 16),
                    style: TextStyle(
                        color: HhColors.mainBlueColor,
                        fontSize: 12.sp * 3,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(26.w*3,130.w*3,26.w*3,0),
                width: 1.sw,
                height: 254.h * 3,
                decoration: BoxDecoration(
                  color: HhColors.blackColor,
                  borderRadius: BorderRadius.circular(6.w*3),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              logic.playTag.value
                  ? Container(
                margin: EdgeInsets.fromLTRB(26.w*3,130.w*3,26.w*3,0),
                decoration: BoxDecoration(
                    color: HhColors.blackColor,
                    borderRadius: BorderRadius.circular(6.w*3)
                ),
                clipBehavior: Clip.hardEdge,
                    child: GestureDetector(
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
                      ),
                  )                  : const SizedBox(),

              logic.playLoadingTag.value
                  ? Container(
                margin: EdgeInsets.fromLTRB(26.w*3,130.w*3,26.w*3,0),
                width: double.infinity,
                height: 254.h * 3,
                decoration: BoxDecoration(
                    color: HhColors.blackRealColor,
                    borderRadius: BorderRadius.circular(6.w*3)
                ),
              ): const SizedBox(),
              logic.playErrorTag.value
                  ? Container(
                margin: EdgeInsets.fromLTRB(26.w*3,130.w*3,26.w*3,0),
                width: double.infinity,
                height: 254.h * 3,
                decoration: BoxDecoration(
                    color: HhColors.blackRealColor,
                    borderRadius: BorderRadius.circular(6.w*3)
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment:Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.w*3,),
                          Image.asset(
                            "assets/images/common/ic_video_error.png",
                            width: 30.w*3,
                            height: 30.w*3,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(height: 5.w*3,),
                          Text(
                            '视频加载错误，请重试',
                            style: TextStyle(
                                color: HhColors.gray6TextColor,
                                fontSize: 14.sp * 3,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 300),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.getDeviceStream();
                              logic.playErrorTag.value = false;
                              logic.playLoadingTag.value = false;
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.w*3),
                              padding: EdgeInsets.fromLTRB(15.w*3, 5.w*3, 15.w*3, 5.w*3),
                              decoration: BoxDecoration(
                                  color: HhColors.gray9TextColor.withAlpha(130),
                                  borderRadius: BorderRadius.circular(4.w*3)
                              ),
                              child:
                              Text(
                                '重试',
                                style: TextStyle(
                                    color: HhColors.whiteColorD5,
                                    fontSize: 14.sp * 3,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
                  : const SizedBox(),
              logic.offlineTag.value
                  ? Container(
                margin: EdgeInsets.fromLTRB(26.w*3,130.w*3,26.w*3,0),
                width: double.infinity,
                height: 254.h * 3,
                decoration: BoxDecoration(
                    color: HhColors.blackRealColor,
                    borderRadius: BorderRadius.circular(6.w*3)
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment:Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.w*3,),
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

              ///tab
              Container(
                height: 45.h * 3,
                decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.circular(4.w*3)
                ),
                margin: EdgeInsets.fromLTRB(26.w*3, 259.h * 3 + 140.w*3, 26.w*3, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BouncingWidget(
                            duration: const Duration(milliseconds: 300),
                            scaleFactor: 1.2,
                            onPressed: () {
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
                                    '控制',
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
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BouncingWidget(
                            duration: const Duration(milliseconds: 300),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.tabIndex.value = 1;
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
                                      logic.tabIndex.value == 1
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
                                    '历史记录',
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
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(0, 330.h * 3 + 130.w*3, 0, 0),
                child: logic.tabIndex.value == 0 ? livePage() : historyPage(),
              ),

              logic.testStatus.value ? const SizedBox() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  livePage() {
    final size = MediaQuery.of(logic.context).size;
    return Column(
      children: [
        /*Container(
          width: 1.sw,
          height: 510.h,
          margin: EdgeInsets.fromLTRB(26.w*3, 0, 26.w*3, 10.w*3),
          decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.circular(16.w*3)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25.h*3,),
              ///抬起
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: () {
                  logic.openDoor();
                },
                child: Container(
                  height: 50.w*3,
                  width: 100.w*3,
                  decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.circular(26.w*3),
                    boxShadow: const [
                      BoxShadow(
                        color: HhColors.trans_777,
                        ///控制阴影的位置
                        offset: Offset(0, 1),
                        ///控制阴影的大小
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text("抬起",style: TextStyle(color: HhColors.gray6TextColor,fontSize: 18.sp*3,fontWeight: FontWeight.w600),),
                  ),
                ),
              ),
              SizedBox(height: 15.h*3,),
              ///关闭
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    width: 6.w*3,
                    height: 6.w*3,
                    decoration: BoxDecoration(
                      color: HhColors.gray8TextColor,
                      borderRadius: BorderRadius.circular(3.w*3)
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  ///关闭按钮
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: () {
                      logic.closeDoor();
                    },
                    child: Container(
                      height: 50.w*3,
                      width: 100.w*3,
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(26.w*3),
                        boxShadow: const [
                          BoxShadow(
                            color: HhColors.trans_777,
                            ///控制阴影的位置
                            offset: Offset(0, 1),
                            ///控制阴影的大小
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("关闭",style: TextStyle(color: HhColors.gray6TextColor,fontSize: 18.sp*3,fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    width: 6.w*3,
                    height: 6.w*3,
                    decoration: BoxDecoration(
                        color: HhColors.gray8TextColor,
                        borderRadius: BorderRadius.circular(3.w*3)
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),*/


        SizedBox(height: 10.h*3,),
        ///开一次
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () {
            logic.openOnce();
          },
          child: Container(
            height: 60.w*3,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(26.w*3, 10.w*3, 26.w*3, 0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w*3),
              // border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
              boxShadow: const [
                BoxShadow(
                  color: HhColors.trans_777,
                  ///控制阴影的位置
                  offset: Offset(0, 1),
                  ///控制阴影的大小
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Align(alignment: Alignment.center,
                child: Text("开一次",style: TextStyle(color: HhColors.mainBlueColor,fontSize: 20.sp*3,fontWeight: FontWeight.w500),)),
          ),
        ),
        SizedBox(height: 10.h*3,),
        ///关闸
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () {
            logic.closeDoor();
          },
          child: Container(
            height: 50.w*3,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(26.w*3, 10.w*3, 26.w*3, 0),
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.circular(16.w*3),
              boxShadow: const [
                BoxShadow(
                  color: HhColors.trans_777,
                  ///控制阴影的位置
                  offset: Offset(0, 1),
                  ///控制阴影的大小
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Center(
              child: Text("关闸",style: TextStyle(color: HhColors.gray6TextColor,fontSize: 18.sp*3,fontWeight: FontWeight.w600),),
            ),
          ),
        ),
        ///常开
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () {
            logic.openDoor();
          },
          child: Container(
            height: 50.w*3,
            width: 1.sw,
            margin: EdgeInsets.fromLTRB(26.w*3, 10.w*3, 26.w*3, 0),
            decoration: BoxDecoration(
              color: HhColors.mainBlueColor,
              borderRadius: BorderRadius.circular(16.w*3),
              // border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
              boxShadow: const [
                BoxShadow(
                  color: HhColors.trans_777,
                  ///控制阴影的位置
                  offset: Offset(0, 1),
                  ///控制阴影的大小
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Center(
              child: Text("常开",style: TextStyle(color: HhColors.whiteColor,fontSize: 18.sp*3,fontWeight: FontWeight.w600),),
            ),
          ),
        ),
      ],
    );
  }

  historyPage() {
    return EasyRefresh(
      onRefresh: () {
        logic.pageNum = 1;
        logic.getDeviceHistory(logic.pageNum);
      },
      onLoad: () {
        logic.pageNum++;
        logic.getDeviceHistory(logic.pageNum);
      },
      child: PagedListView<int, dynamic>(
        padding: EdgeInsets.zero,
        pagingController: logic.deviceController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          noItemsFoundIndicatorBuilder: (context) =>
              CommonUtils().noneWidget(top: 0.08.sw),
          itemBuilder: (context, item, index) => InkWell(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(
                minHeight: 70.h * 3
              ),
              margin: EdgeInsets.fromLTRB(26.w * 3, 0, 26.w * 3, 0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.trans,
                  borderRadius: BorderRadius.all(Radius.circular(6.h * 3))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 6.h * 3,
                        height: 6.h * 3,
                        margin: EdgeInsets.fromLTRB(10.h, 10.h * 3, 0, 0),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(3.h * 3))),
                      ),
                      Container(
                        width: 1.5.h * 3,
                        height: 188.w*3,
                        margin: EdgeInsets.fromLTRB(3.h * 3, 10.h * 3, 0, 0),
                        decoration: BoxDecoration(
                            color: HhColors.blueEAColor,
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(3.h))),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///时间
                      Container(
                        margin: EdgeInsets.fromLTRB(15.w * 3, 10.h, 0, 0),
                        child: Text(
                          logic.parseDate(item['recordTime']),
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 15.sp * 3,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ///类型
                      Container(
                        margin: EdgeInsets.fromLTRB(15.w*3, 5.h * 3, 0, 0),
                        child: Text(
                          "车牌：${item['plate']}",
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 14.sp * 3,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ///图片
                      InkWell(
                        onTap: (){
                          CommonUtils().showPictureDialog(
                            logic.context,
                            url: '${logic.endpoint}${item['imageUrl']}'
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.fromLTRB(15.w*3, 10.w*3, 15.w*3, 20.w*3),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.h))),
                          child: Image.network(
                            '${logic.endpoint}${item['imageUrl']}',
                            width: 260.w * 3,
                            height: 140.w * 3,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                "assets/images/common/ic_message_no.png",
                                width: 260.w * 3,
                                height: 140.w * 3,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
}
