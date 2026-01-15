import 'dart:math';
import 'dart:ui';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/widgets/jump_view.dart';

class LiGanDetailPage extends StatelessWidget {
  final logic = Get.find<LiGanDetailController>();

  LiGanDetailPage(String deviceNo, String id, {super.key}) {
    logic.deviceNo = deviceNo;
    logic.id = id;
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
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
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? loginView() : const SizedBox(),
        ),
      ),
    );
  }

  loginView() {
    return Stack(
      children: [
        // Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
        Container(
          color: HhColors.backColorSetting,
          width: 1.sw,
          height: 1.sh,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 88.w * 3,
            color: HhColors.whiteColor,
          ),
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 54.w * 3),
            color: HhColors.trans,
            child: Text(
              '设置',
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
              height: 17.w * 3,
              width: 10.w * 3,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(14.w * 3, 98.w * 3, 14.w * 3, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Tab页
                Container(
                  height: 50.w * 3,
                  padding: EdgeInsets.only(right:10.w*3),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w * 3))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 0;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '呼叫音',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 0
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 0
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 1;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '走字屏',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 1
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 1
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 2;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '设置',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 2
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                ),
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 2
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            logic.tabIndex.value = 3;
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 20.w,
                              ),
                              Text(
                                '太阳能电池',
                                style: TextStyle(
                                  color: logic.tabIndex.value == 3
                                      ? HhColors.mainBlueColor
                                      : HhColors.gray9TextColor,
                                  fontSize: 15.sp * 3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                              logic.tabIndex.value == 3
                                  ? Container(
                                      height: 6.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: HhColors.mainBlueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(3.w))),
                                    )
                                  : SizedBox(
                                      height: 6.w,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                logic.tabIndex.value == 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///呼叫音
                          //可用提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '可用提示音',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              logic.getVoiceUse();
                                              logic.getDeviceConfig();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(9.w * 3,
                                                  4.w * 3, 9.w * 3, 4.w * 3),
                                              margin: EdgeInsets.only(
                                                  right: 70.w*3),
                                              decoration: BoxDecoration(
                                                  color: HhColors.whiteColor,
                                                  border: Border.all(
                                                      color:
                                                      HhColors.grayBBTextColor,
                                                      width: 1.w),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.w * 3))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/common/icon_refresh.png",
                                                      height: 13.w * 3,
                                                      width: 13.w * 3),
                                                  SizedBox(
                                                    width: 4.w * 3,
                                                  ),
                                                  Text('刷新',
                                                      style: TextStyle(
                                                        color:
                                                        HhColors.mainBlueColor,
                                                        fontSize: 13.sp * 3,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              showRecordDialog();
                                            },
                                            child: Container(
                                                margin:EdgeInsets.only(right: 5.w),
                                              padding: EdgeInsets.fromLTRB(
                                                  9.w * 3,
                                                  4.w * 3,
                                                  9.w * 3,
                                                  4.w * 3),
                                              decoration: BoxDecoration(
                                                  color: HhColors.whiteColor,
                                                  border: Border.all(
                                                      color: HhColors
                                                          .grayBBTextColor,
                                                      width: 1.w),
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          4.w * 3))),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "assets/images/common/yes2.png",
                                                      height: 13.w * 3,
                                                      width: 13.w * 3),
                                                  SizedBox(
                                                    width: 4.w * 3,
                                                  ),
                                                  Text('录音',
                                                      style: TextStyle(
                                                        color: HhColors
                                                            .mainBlueColor,
                                                        fontSize: 13.sp * 3,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.w * 3),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: logic.voiceTopStatus.value
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: buildVoiceList(),
                                  )
                                : const SizedBox(),
                          ),
                          //设备提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '设备提示音',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                    child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          logic.getVoiceUse();
                                          logic.getDeviceConfig();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(9.w * 3,
                                              4.w * 3, 9.w * 3, 4.w * 3),
                                          margin: EdgeInsets.only(
                                              right: logic.playing.value == 1
                                                  ? 95.w * 3
                                                  : 5.w),
                                          decoration: BoxDecoration(
                                              color: HhColors.whiteColor,
                                              border: Border.all(
                                                  color:
                                                      HhColors.grayBBTextColor,
                                                  width: 1.w),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.w * 3))),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  "assets/images/common/icon_refresh.png",
                                                  height: 13.w * 3,
                                                  width: 13.w * 3),
                                              SizedBox(
                                                width: 4.w * 3,
                                              ),
                                              Text('刷新',
                                                  style: TextStyle(
                                                    color:
                                                        HhColors.mainBlueColor,
                                                    fontSize: 13.sp * 3,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    logic.playing.value == 1
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                logic.stopVoice();
                                              },
                                              child: Container(
                                                  margin:EdgeInsets.only(right: 5.w),
                                                padding: EdgeInsets.fromLTRB(
                                                    9.w * 3,
                                                    4.w * 3,
                                                    9.w * 3,
                                                    4.w * 3),
                                                decoration: BoxDecoration(
                                                    color: HhColors.whiteColor,
                                                    border: Border.all(
                                                        color: HhColors
                                                            .grayBBTextColor,
                                                        width: 1.w),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.w * 3))),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/common/icon_pause.png",
                                                        height: 13.w * 3,
                                                        width: 13.w * 3),
                                                    SizedBox(
                                                      width: 4.w * 3,
                                                    ),
                                                    Text('停止播放',
                                                        style: TextStyle(
                                                          color: HhColors
                                                              .mainBlueColor,
                                                          fontSize: 13.sp * 3,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: buildVoiceListBottom(),
                            ),
                          ),
                          //配置提示音
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '配置提示音',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '人形检测',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (logic.voiceBottomList.isEmpty) {
                                      EventBusUtil.getInstance()
                                          .fire(HhToast(title: '没有可用提示音'));
                                      return;
                                    }
                                    showChoosePersonDialog();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '提示音',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            CommonUtils().parseNull(
                                                '${logic.config["audioHumanName"]}',
                                                ''),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '音量',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(
                                            value: logic.voiceHuman.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceHuman.value =
                                                  int.parse(s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          /*Text(
                                            '${logic.voiceHuman.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                                fontSize: 15.sp*3,fontWeight: FontWeight.w400
                                            ),
                                          )*/
                                        ],
                                      ),
                                      /*SizedBox(
                                        width: 10.w,
                                      ),*/
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    DateTime left = DateTime.now();
                                    DateTime right = DateTime.now();
                                    ///left
                                    DatePicker.showTimePicker(logic.context,
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh,
                                        showSecondsColumn: true,
                                        onConfirm: (date) {
                                          left = date;
                                      logic.personStart.value = CommonUtils()
                                          .parseLongTimeHourMinuteSecond(
                                              "${date.millisecondsSinceEpoch}");

                                      ///right
                                      DatePicker.showTimePicker(logic.context,
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.zh,
                                          showSecondsColumn: true,
                                          onConfirm: (date) {
                                            right = date;
                                            if(right.millisecondsSinceEpoch < left.millisecondsSinceEpoch){
                                              EventBusUtil.getInstance().fire(HhToast(title: '结束时间不能早于开始时间'));
                                              return;
                                            }
                                        logic.personEnd.value = CommonUtils()
                                            .parseLongTimeHourMinuteSecond(
                                                "${date.millisecondsSinceEpoch}");
                                        logic.config["audioHumanTime"] =
                                            '${logic.personStart}-${logic.personEnd}';
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '播放时间段',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${logic.personStart}-${logic.personEnd}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            logic.personStatus.value
                                                ? "assets/images/common/icon_top_status.png"
                                                : "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '车辆检测',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (logic.voiceBottomList.isEmpty) {
                                      EventBusUtil.getInstance()
                                          .fire(HhToast(title: '没有可用提示音'));
                                      return;
                                    }
                                    showChooseCarDialog();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '提示音',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            CommonUtils().parseNull(
                                                '${logic.config["audioCarName"]}',
                                                ''),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '音量',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(
                                            value: logic.voiceCar.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceCar.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          /*Text(
                                            '${logic.voiceCar.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3,
                                            ),
                                          )*/
                                        ],
                                      ),
                                      /*SizedBox(
                                        width: 10.w,
                                      ),*/
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    DateTime left = DateTime.now();
                                    DateTime right = DateTime.now();
                                    ///left
                                    DatePicker.showTimePicker(logic.context,
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh,
                                        showSecondsColumn: true,
                                        onConfirm: (date) {
                                          left = date;
                                      logic.carStart.value = CommonUtils()
                                          .parseLongTimeHourMinuteSecond(
                                              "${date.millisecondsSinceEpoch}");

                                      ///right
                                      DatePicker.showTimePicker(logic.context,
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.zh,
                                          showSecondsColumn: true,
                                          onConfirm: (date) {
                                            right = date;
                                            if(right.millisecondsSinceEpoch < left.millisecondsSinceEpoch){
                                              EventBusUtil.getInstance().fire(HhToast(title: '结束时间不能早于开始时间'));
                                              return;
                                            }
                                        logic.carEnd.value = CommonUtils()
                                            .parseLongTimeHourMinuteSecond(
                                                "${date.millisecondsSinceEpoch}");
                                        logic.config["audioCarTime"] =
                                            '${logic.carStart}-${logic.carEnd}';
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '播放时间段',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${logic.carStart}-${logic.carEnd}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            logic.carStatus.value
                                                ? "assets/images/common/icon_top_status.png"
                                                : "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '开盖检测',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (logic.voiceBottomList.isEmpty) {
                                      EventBusUtil.getInstance()
                                          .fire(HhToast(title: '没有可用提示音'));
                                      return;
                                    }
                                    showChooseOpenDialog();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '提示音',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            CommonUtils().parseNull(
                                                '${logic.config["audioOpenName"]}',
                                                ''),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '音量',
                                          style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(
                                            value: logic.voiceCap.value * 1.0,
                                            max: 5,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.voiceCap.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          /*Text(
                                            '${logic.voiceCap.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3,
                                            ),
                                          )*/
                                        ],
                                      ),
                                      /*SizedBox(
                                        width: 10.w,
                                      ),*/
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    DateTime left = DateTime.now();
                                    DateTime right = DateTime.now();
                                    ///left
                                    DatePicker.showTimePicker(logic.context,
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh,
                                        showSecondsColumn: true,
                                        onConfirm: (date) {
                                          left = date;
                                      logic.openStart.value = CommonUtils()
                                          .parseLongTimeHourMinuteSecond(
                                              "${date.millisecondsSinceEpoch}");

                                      ///right
                                      DatePicker.showTimePicker(logic.context,
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.zh,
                                          showSecondsColumn: true,
                                          onConfirm: (date) {
                                            right = date;
                                            if(right.millisecondsSinceEpoch < left.millisecondsSinceEpoch){
                                              EventBusUtil.getInstance().fire(HhToast(title: '结束时间不能早于开始时间'));
                                              return;
                                            }
                                        logic.openEnd.value = CommonUtils()
                                            .parseLongTimeHourMinuteSecond(
                                                "${date.millisecondsSinceEpoch}");
                                        logic.config["audioOpenTime"] =
                                            '${logic.openStart}-${logic.openEnd}';
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '播放时间段',
                                            style: TextStyle(
                                                color: HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${logic.openStart}-${logic.openEnd}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w * 3,
                                        ),
                                        Image.asset(
                                            logic.openStatus.value
                                                ? "assets/images/common/icon_top_status.png"
                                                : "assets/images/common/icon_down_status.png",
                                            height: 13.w * 3,
                                            width: 13.w * 3),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.voiceSubmitHuman();
                              logic.voiceSubmitCar();
                              logic.voiceSubmitCap();
                            },
                            child: Container(
                              width: 1.sw,
                              height: 40.w * 3,
                              margin:
                                  EdgeInsets.fromLTRB(0, 10.w * 3, 0, 10.w * 3),
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.w * 3))),
                              child: Center(
                                child: Text(
                                  "确定",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HhColors.whiteColor,
                                      fontSize: 15.sp * 3,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),

                logic.tabIndex.value == 1
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///走字屏
                          //显示设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '显示设置',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '滑动速度',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Slider(
                                            value: logic.speed.value * 1.0,
                                            max: 10,
                                            min: 0,
                                            thumbColor: HhColors.mainBlueColor,
                                            activeColor: HhColors.mainBlueColor,
                                            onChanged: (double value) {
                                              String s = "$value";
                                              logic.speed.value = int.parse(
                                                  s.substring(
                                                      0, s.indexOf(".")));
                                            },
                                          ),
                                          /*Text(
                                            '${logic.speed.value}',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3,
                                            ),
                                          )*/
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '滑动方向',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            30.w, 30.w, 30.w, 30.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                logic.direction.value = 0;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 0
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w*3,
                                                  width: 16.w*3),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              '向上',
                                              style: TextStyle(
                                                color: logic.direction.value == 0?HhColors.mainBlueColor:HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                logic.direction.value = 1;
                                              },
                                              child: Image.asset(
                                                  logic.direction.value == 1
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w*3,
                                                  width: 16.w*3),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Text(
                                              '向下',
                                              style: TextStyle(
                                                color: logic.direction.value == 1?HhColors.mainBlueColor:HhColors.blackColor,
                                                fontSize: 15.sp * 3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '显示内容',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  padding: EdgeInsets.fromLTRB(
                                      6.w * 3, 5.w * 3, 6.w * 3, 5.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.backColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.w * 3))),
                                  child: TextField(
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    maxLength: 100,
                                    cursorColor: HhColors.titleColor_99,
                                    controller: logic.showContentController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15.w),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      counterText: '',
                                      hintText: '此处设置显示内容',
                                      hintStyle: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp * 3,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    onChanged: (s) {
                                      logic.ledContent.value = s;
                                    },
                                    style: TextStyle(
                                        color: HhColors.textBlackColor,
                                        fontSize: 15.sp * 3),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //息屏设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  'LED屏设置',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '控制',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                              onTap: (){
                                                logic.closeTab.value=1;
                                              },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [//closeTab
                                                    Image.asset(
                                                        logic.closeTab.value==1
                                                            ? "assets/images/common/yes2.png"
                                                            : "assets/images/common/no.png",
                                                        height: 16.w * 3,
                                                        width: 16.w * 3),
                                                    SizedBox(width: 10.w,),
                                                    Text(
                                                      '常开',
                                                      style: TextStyle(
                                                        color: logic.closeTab.value==1?HhColors.mainBlueColor:HhColors.blackColor,
                                                        fontSize: 15.sp * 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 26.w,),
                                              InkWell(
                                              onTap: (){
                                                logic.closeTab.value=0;
                                              },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [//closeTab
                                                    Image.asset(
                                                        logic.closeTab.value==0
                                                            ? "assets/images/common/yes2.png"
                                                            : "assets/images/common/no.png",
                                                        height: 16.w * 3,
                                                        width: 16.w * 3),
                                                    SizedBox(width: 10.w,),
                                                    Text(
                                                      '常闭',
                                                      style: TextStyle(
                                                        color: logic.closeTab.value==0?HhColors.mainBlueColor:HhColors.blackColor,
                                                        fontSize: 15.sp * 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 26.w,),
                                              InkWell(
                                              onTap: (){
                                                logic.closeTab.value=2;
                                              },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [//closeTab
                                                    Image.asset(
                                                        logic.closeTab.value==2
                                                            ? "assets/images/common/yes2.png"
                                                            : "assets/images/common/no.png",
                                                        height: 16.w * 3,
                                                        width: 16.w * 3),
                                                    SizedBox(width: 10.w,),
                                                    Text(
                                                      '触发',
                                                      style: TextStyle(
                                                        color: logic.closeTab.value==2?HhColors.mainBlueColor:HhColors.blackColor,
                                                        fontSize: 15.sp * 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    DateTime left = DateTime.now();
                                    DateTime right = DateTime.now();
                                    ///left
                                    DatePicker.showTimePicker(logic.context,
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.zh,
                                        showSecondsColumn: true,
                                        onConfirm: (date) {
                                      left = date;
                                      logic.closeStart.value = CommonUtils()
                                          .parseLongTimeHourMinuteSecond(
                                              "${date.millisecondsSinceEpoch}");

                                      ///right
                                      DatePicker.showTimePicker(logic.context,
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.zh,
                                          showSecondsColumn: true,
                                          onConfirm: (date) {
                                            right = date;
                                            if(right.millisecondsSinceEpoch < left.millisecondsSinceEpoch){
                                              EventBusUtil.getInstance().fire(HhToast(title: '结束时间不能早于开始时间'));
                                              return;
                                            }
                                        logic.closeEnd.value = CommonUtils()
                                            .parseLongTimeHourMinuteSecond(
                                                "${date.millisecondsSinceEpoch}");
                                        logic.config["ledTime"] =
                                            '${logic.closeStart}-${logic.closeEnd}';
                                        logic.ledTime.value =
                                            '${logic.closeStart}-${logic.closeEnd}';
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '亮屏时间',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                        Align(
                                        alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height:40.w*3,
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.w*3),
                                                    border: Border.all(color: HhColors.grayE6BackColor,width: 1.w*3)
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: 10.w * 3,
                                                        ),
                                                        Image.asset(
                                                                "assets/images/common/icon_times.png",
                                                            height: 13.w * 3,
                                                            width: 13.w * 3),
                                                        SizedBox(
                                                          width: 5.w * 3,
                                                        ),
                                                        Text(
                                                          '${logic.closeStart}',
                                                          textAlign: TextAlign.end,
                                                          style: TextStyle(
                                                            color: HhColors.gray9TextColor,
                                                            fontSize: 15.sp * 3,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w * 3,
                                                        ),
                                                      ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 6.w * 3,
                                                ),
                                                Text(
                                                  '至',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    color: HhColors.blackColor,
                                                    fontSize: 15.sp * 3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 6.w * 3,
                                                ),
                                                Container(
                                                  height:40.w*3,
                                                  decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.w*3),
                                                    border: Border.all(color: HhColors.grayE6BackColor,width: 1.w*3)
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: 10.w * 3,
                                                        ),
                                                        Image.asset(
                                                                "assets/images/common/icon_times.png",
                                                            height: 13.w * 3,
                                                            width: 13.w * 3),
                                                        SizedBox(
                                                          width: 5.w * 3,
                                                        ),
                                                        Text(
                                                          '${logic.closeEnd}',
                                                          textAlign: TextAlign.end,
                                                          style: TextStyle(
                                                            color: HhColors.gray9TextColor,
                                                            fontSize: 15.sp * 3,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w * 3,
                                                        ),
                                                      ],
                                                  ),
                                                ),
                                              ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.postScreenTop();
                              logic.postScreenBottom();
                            },
                            child: Container(
                              width: 1.sw,
                              height: 40.w*3,
                              margin: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
                              decoration: BoxDecoration(
                                  color: HhColors.mainBlueColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.w * 3))),
                              child: Center(
                                child: Text(
                                  "确定",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HhColors.whiteColor,
                                      fontSize: 15.sp * 3,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),

                logic.tabIndex.value == 2
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///设置
                          //报警设置
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '报警设置',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机1',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: FlutterSwitch(
                                            width: 100.w,
                                            height: 55.w,
                                            activeColor: HhColors.mainBlueColor,
                                            valueFontSize: 25.w,
                                            toggleSize: 45.w,
                                            value: logic.warnGANG1.value,
                                            borderRadius: 30.w,
                                            padding: 8.w,
                                            onToggle: (val) {
                                              logic.warnGANG1.value = val;
                                              logic.warnSet(
                                                  "gCam1", val ? "ON" : "OFF");
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机2',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: FlutterSwitch(
                                          width: 100.w,
                                          height: 55.w,
                                          activeColor: HhColors.mainBlueColor,
                                          valueFontSize: 25.w,
                                          toggleSize: 45.w,
                                          value: logic.warnGANG2.value,
                                          borderRadius: 30.w,
                                          padding: 8.w,
                                          onToggle: (val) {
                                            logic.warnGANG2.value = val;
                                            logic.warnSet(
                                                "gCam2", val ? "ON" : "OFF");
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '枪机3',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: FlutterSwitch(
                                            width: 100.w,
                                            height: 55.w,
                                            activeColor: HhColors.mainBlueColor,
                                            valueFontSize: 25.w,
                                            toggleSize: 45.w,
                                            value: logic.warnGANG3.value,
                                            borderRadius: 30.w,
                                            padding: 8.w,
                                            onToggle: (val) {
                                              logic.warnGANG3.value = val;
                                              logic.warnSet(
                                                  "gCam3", val ? "ON" : "OFF");
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '球机',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: FlutterSwitch(
                                            width: 100.w,
                                            height: 55.w,
                                            activeColor: HhColors.mainBlueColor,
                                            valueFontSize: 25.w,
                                            toggleSize: 45.w,
                                            value: logic.warnBALL.value,
                                            borderRadius: 30.w,
                                            padding: 8.w,
                                            onToggle: (val) {
                                              logic.warnBALL.value = val;
                                              logic.warnSet(
                                                  "sCam1", val ? "ON" : "OFF");
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '传感器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: FlutterSwitch(
                                            width: 100.w,
                                            height: 55.w,
                                            activeColor: HhColors.mainBlueColor,
                                            valueFontSize: 25.w,
                                            toggleSize: 45.w,
                                            value: logic.warnSENSOR.value,
                                            borderRadius: 30.w,
                                            padding: 8.w,
                                            onToggle: (val) {
                                              logic.warnSENSOR.value = val;
                                              logic.warnSet(
                                                  "sensor", val ? "ON" : "OFF");
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                                  height: 1.w,
                                  color: HhColors.backColor,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '开盖报警',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: FlutterSwitch(
                                            width: 100.w,
                                            height: 55.w,
                                            activeColor: HhColors.mainBlueColor,
                                            valueFontSize: 25.w,
                                            toggleSize: 45.w,
                                            value: logic.warnOPEN.value,
                                            borderRadius: 30.w,
                                            padding: 8.w,
                                            onToggle: (val) {
                                              logic.warnOPEN.value = val;
                                              logic.warnSet(
                                                  "cap", val ? "ON" : "OFF");
                                            },
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //数据上报间隔
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '数据上报间隔',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '太阳能控制器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      FlutterSwitch(
                                        width: 100.w,
                                        height: 55.w,
                                        activeColor: HhColors.mainBlueColor,
                                        valueFontSize: 25.w,
                                        toggleSize: 45.w,
                                        value: logic.energyAction.value,
                                        borderRadius: 30.w,
                                        padding: 8.w,
                                        onToggle: (val) {
                                          logic.energyAction.value = val;
                                        },
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time1Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.energyDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '一体式气象站',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      FlutterSwitch(
                                        width: 100.w,
                                        height: 55.w,
                                        activeColor: HhColors.mainBlueColor,
                                        valueFontSize: 25.w,
                                        toggleSize: 45.w,
                                        value: logic.weatherAction.value,
                                        borderRadius: 30.w,
                                        padding: 8.w,
                                        onToggle: (val) {
                                          logic.weatherAction.value = val;
                                        },
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time2Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.grayCCTextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.weatherDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      30.w, 10.w, 30.w, 10.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '土壤传感器',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      FlutterSwitch(
                                        width: 100.w,
                                        height: 55.w,
                                        activeColor: HhColors.mainBlueColor,
                                        valueFontSize: 25.w,
                                        toggleSize: 45.w,
                                        value: logic.soilAction.value,
                                        borderRadius: 30.w,
                                        padding: 8.w,
                                        onToggle: (val) {
                                          logic.soilAction.value = val;
                                        },
                                      ),
                                      Expanded(
                                        child: TextField(
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          maxLength: 10,
                                          cursorColor: HhColors.titleColor_99,
                                          controller: logic.time3Controller,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            counterText: '',
                                            hintText: '',
                                            hintStyle: TextStyle(
                                                color: HhColors.gray9TextColor,
                                                fontSize: 15.sp * 3,
                                                fontWeight: FontWeight.w200),
                                          ),
                                          onChanged: (s) {
                                            logic.soilDelay.value = s;
                                          },
                                          style: TextStyle(
                                              color: HhColors.blueTextColor,
                                              fontSize: 15.sp * 3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Text(
                                        '分',
                                        style: TextStyle(
                                          color: HhColors.gray9TextColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: () {
                                    int energy = 0;
                                    int weather = 0;
                                    int soil = 0;
                                    try {
                                      energy = int.parse(
                                              logic.time1Controller!.text) *
                                          60;
                                      weather = int.parse(
                                              logic.time2Controller!.text) *
                                          60;
                                      soil = int.parse(
                                              logic.time3Controller!.text) *
                                          60;
                                    } catch (e) {
                                      EventBusUtil.getInstance()
                                          .fire(HhToast(title: "间隔时间格式错误"));
                                      return;
                                    }
                                    logic.warnUploadSet(
                                        "energy",
                                        logic.energyAction.value ? "ON" : "OFF",
                                        energy,
                                        logic.config["energyOpenTime"] ?? "");
                                    logic.warnUploadSet(
                                        "weather",
                                        logic.weatherAction.value
                                            ? "ON"
                                            : "OFF",
                                        weather,
                                        logic.config["weatherOpenTime"] ?? "");
                                    logic.warnUploadSet(
                                        "soil",
                                        logic.soilAction.value ? "ON" : "OFF",
                                        soil,
                                        logic.config["soilOpenTime"] ?? "");
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    height: 40.w * 3,
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 10.w, 30.w, 30.w),
                                    decoration: BoxDecoration(
                                        color: HhColors.whiteColor,
                                        border: Border.all(
                                            color: HhColors.gray9TextColor,
                                            width: 0.5.w),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.w * 3))),
                                    child: Center(
                                      child: Text(
                                        "确定",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 15.sp * 3,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // child: ,
                          ),
                          //防火等级
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '防火等级',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 5;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 5
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '极高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 4;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 4
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 3;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 3
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '较高风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 2;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 2
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '较低风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.fireLevel.value = 1;
                                    logic.settingLevel();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.fireLevel.value == 1
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '低风险',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp * 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*//枪球联动
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30.w,
                                  width: 5.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.w))),
                                ),
                                Text(
                                  '枪球联动',
                                  style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 15.sp*3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w*3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    logic.circle.value = 0;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.circle.value == 0
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '关闭',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp*3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    logic.circle.value = 1;
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.w, 30.w, 30.w, 30.w),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            logic.circle.value == 1
                                                ? "assets/images/common/yes2.png"
                                                : "assets/images/common/no.png",
                                            height: 20,
                                            width: 20),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Text(
                                          '开启',
                                          style: TextStyle(
                                            color: HhColors.blackColor,
                                            fontSize: 15.sp*3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          //固件版本号
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '固件版本号',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.w * 3))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        '当前版本:',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        '${logic.deviceVer}',
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 15.sp * 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                logic.versionStatus.value
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: buildVersionChild(),
                                      )
                                    : const SizedBox(),
                                logic.versionStatus.value
                                    ? BouncingWidget(
                                      duration: const Duration(milliseconds: 100),
                                      scaleFactor: 0.6,
                                      onPressed: () {
                                        showChooseVersionDialog();
                                      },
                                      child: SizedBox(
                                          height: 45.w * 3,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 15.w*3,),
                                              Expanded(
                                                child: Text(
                                                  logic.versionStr.value,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                      color: HhColors.blackColor,
                                                      fontSize: 15.sp * 3),
                                                ),
                                              ),
                                              SizedBox(width: 15.w*3,),
                                              Image.asset(
                                                  "assets/images/common/icon_down_status.png",
                                                  height: 16.w * 3,
                                                  width: 16.w * 3),
                                              SizedBox(width: 15.w*3,),
                                            ],
                                          ),
                                        ),
                                    )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              if(logic.versionStr.value == ''){
                                EventBusUtil.getInstance().fire(HhToast(title: '请先选择要升级的固件版本号'));
                                return;
                              }
                              CommonUtils().showCommonDialog(logic.context, '确定要进行固件升级吗？', (){
                                Get.back();
                              }, (){
                                Get.back();
                                if(logic.versionList.isNotEmpty){
                                  logic.versionUpdate();
                                }else{
                                  EventBusUtil.getInstance().fire(HhToast(title: "当前版本已是该版本号"));
                                }
                              });
                            },
                            child: Container(
                              width: 1.sw,
                              height: 40.w * 3,
                              margin: EdgeInsets.only(top: 20.w),
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  border: Border.all(
                                      color: HhColors.gray9TextColor,
                                      width: 0.5.w),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.w * 3))),
                              child: Center(
                                child: Text(
                                  "升级",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          ),
                          //设备重启
                          Container(
                            margin: EdgeInsets.only(top: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 19.w * 3,
                                  width: 3.w * 3,
                                  margin: EdgeInsets.only(right: 7.w * 3),
                                  decoration: BoxDecoration(
                                      color: HhColors.mainBlueColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.w * 3))),
                                ),
                                Text(
                                  '设备重启',
                                  style: TextStyle(
                                      color: HhColors.blackTextColor,
                                      fontSize: 15.sp * 3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showReStartDialog();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10.w * 3),
                              padding: EdgeInsets.fromLTRB(
                                  16.w * 3, 9.w * 3, 16.w * 3, 9.w * 3),
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.w * 3)),
                                  border: Border.all(
                                      color: HhColors.grayCCTextColor,
                                      width: 0.5.w * 3)),
                              child: Text(
                                '设备重启',
                                style: TextStyle(
                                  color: HhColors.blackColor,
                                  fontSize: 15.sp * 3,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.w,
                          ),
                        ],
                      )
                    : const SizedBox(),

                logic.tabIndex.value == 3
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///太阳能电池
                    //电池类型
                    Container(
                      margin: EdgeInsets.only(top: 30.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 19.w * 3,
                            width: 3.w * 3,
                            margin: EdgeInsets.only(right: 7.w * 3),
                            decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(2.w * 3))),
                          ),
                          Text(
                            '电池类型',
                            style: TextStyle(
                                color: HhColors.blackTextColor,
                                fontSize: 15.sp * 3,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.w),
                      padding:EdgeInsets.fromLTRB(5.w*3, 0, 10.w*3, 0),
                      decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.w * 3))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                12.w * 3, 15.w * 3, 12.w * 3, 15.w * 3),
                            child: Row(
                              children: [
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            logic.energySetType.value=0;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [//closeTab
                                              Image.asset(
                                                  logic.energySetType.value==0
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w * 3,
                                                  width: 16.w * 3),
                                              SizedBox(width: 10.w,),
                                              Text(
                                                '锂电',
                                                style: TextStyle(
                                                  color: logic.energySetType.value==0?HhColors.mainBlueColor:HhColors.blackColor,
                                                  fontSize: 15.sp * 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16.w*3,),
                                        InkWell(
                                          onTap: (){
                                            logic.energySetType.value=1;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [//closeTab
                                              Image.asset(
                                                  logic.energySetType.value==1
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w * 3,
                                                  width: 16.w * 3),
                                              SizedBox(width: 10.w,),
                                              Text(
                                                '液体',
                                                style: TextStyle(
                                                  color: logic.energySetType.value==1?HhColors.mainBlueColor:HhColors.blackColor,
                                                  fontSize: 15.sp * 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16.w*3,),
                                        InkWell(
                                          onTap: (){
                                            logic.energySetType.value=2;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [//closeTab
                                              Image.asset(
                                                  logic.energySetType.value==2
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w * 3,
                                                  width: 16.w * 3),
                                              SizedBox(width: 10.w,),
                                              Text(
                                                '胶体',
                                                style: TextStyle(
                                                  color: logic.energySetType.value==2?HhColors.mainBlueColor:HhColors.blackColor,
                                                  fontSize: 15.sp * 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16.w*3,),
                                        InkWell(
                                          onTap: (){
                                            logic.energySetType.value=3;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [//closeTab
                                              Image.asset(
                                                  logic.energySetType.value==3
                                                      ? "assets/images/common/yes2.png"
                                                      : "assets/images/common/no.png",
                                                  height: 16.w * 3,
                                                  width: 16.w * 3),
                                              SizedBox(width: 10.w,),
                                              Text(
                                                'AMG',
                                                style: TextStyle(
                                                  color: logic.energySetType.value==3?HhColors.mainBlueColor:HhColors.blackColor,
                                                  fontSize: 15.sp * 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.w*3, 0, 10.w*3, 0),
                            height: 1.w,
                            color: HhColors.backColor,
                          ),

                          logic.energySetType.value==0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '过充保护',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.liVP.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.liVP.value = double.tryParse(text) ?? logic.liVP.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.liVP.value = double.tryParse(text) ?? logic.liVP.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.liVP.value = (logic.liVP.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.liVP.value = (logic.liVP.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          ///电压等级//公共 ratedL
                          Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '电压等级',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withAlpha(80)),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          controller: TextEditingController(
                                            text: logic.ratedL.value.toString(),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.ratedL.value = int.tryParse(text) ?? logic.ratedL.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.ratedL.value = double.tryParse(text) ?? logic.ratedL.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          '  ',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    // logic.ratedL.value = (logic.ratedL.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    // logic.ratedL.value = (logic.ratedL.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///过充恢复//锂电 liVR
                          logic.energySetType.value==0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '过充恢复',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.liVR.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.liVR.value = double.tryParse(text) ?? logic.liVR.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.liVR.value = double.tryParse(text) ?? logic.liVR.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.liVR.value = (logic.liVR.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.liVR.value = (logic.liVR.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          ///零度充电//锂电 liS
                          logic.energySetType.value==0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '零度充电',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                InkWell(
                                  onTap: (){
                                    logic.liS.value++;
                                    if(logic.liS.value >= logic.liSList.length){
                                      logic.liS.value = 0;
                                    }
                                  },
                                  child: Container(
                                    width: 130.w*3, // 控制控件的宽度
                                    height: 35.w*3, // 控制控件的高度
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(6.w*3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        logic.liSList[logic.liS.value],
                                        style: TextStyle(
                                          color: HhColors.blackColor,
                                          fontSize: 14.sp * 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          ///均衡充电压//液体、胶体、AMG equalV
                          logic.energySetType.value!=0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '均衡充电压',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.equalV.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.equalV.value = double.tryParse(text) ?? logic.equalV.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.equalV.value = double.tryParse(text) ?? logic.equalV.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.equalV.value = (logic.equalV.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.equalV.value = (logic.equalV.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          ///强充电压//液体、胶体、AMG strongV
                          logic.energySetType.value!=0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '强充电压',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.strongV.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.strongV.value = double.tryParse(text) ?? logic.strongV.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.strongV.value = double.tryParse(text) ?? logic.strongV.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.strongV.value = (logic.strongV.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.strongV.value = (logic.strongV.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),
                          ///浮充电压//液体、胶体、AMG floatV
                          logic.energySetType.value!=0?Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '浮充电压',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.floatV.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.floatV.value = double.tryParse(text) ?? logic.floatV.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.floatV.value = double.tryParse(text) ?? logic.floatV.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.floatV.value = (logic.floatV.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.floatV.value = (logic.floatV.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):const SizedBox(),

                          ///低压保护//公共 lowVP
                          Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '低压保护',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.lowVR.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.lowVR.value = double.tryParse(text) ?? logic.lowVR.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.lowVR.value = double.tryParse(text) ?? logic.lowVR.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.lowVR.value = (logic.lowVR.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.lowVR.value = (logic.lowVR.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///低压恢复//公共 lowVR
                          Container(
                            padding: EdgeInsets.fromLTRB(10.w*3, 10.w*3, 0.w*3, 10.w*3),
                            child:Row(
                              children: [
                                Text(
                                  '低压恢复',
                                  style: TextStyle(
                                    color: HhColors.blackColor,
                                    fontSize: 15.sp * 3,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  width: 130.w*3, // 控制控件的宽度
                                  height: 35.w*3, // 控制控件的高度
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(6.w*3),
                                  ),
                                  child: Row(
                                    children: [
                                      // 数字输入框
                                      Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: logic.lowVP.value.toStringAsFixed(1),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                          ),
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          onChanged: (text) {
                                            logic.lowVP.value = double.tryParse(text) ?? logic.lowVP.value;
                                          },
                                          /*onSubmitted: (text) {
                                  logic.lowVP.value = double.tryParse(text) ?? logic.lowVP.value;
                                },*/
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(5.w*3, 0, 5.w*3, 0),
                                        child: Text(
                                          'V',
                                          style: TextStyle(
                                            color: HhColors.grayAATextColor,
                                            fontSize: 18.sp * 3,
                                          ),
                                        ),
                                      ),
                                      // 上下按钮
                                      SizedBox(
                                        width: 30.w*3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 向上按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.lowVP.value = (logic.lowVP.value + 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            Container(
                                              color:HhColors.whiteColor,
                                              height: 1.w,
                                            ),
                                            Container(
                                              color:HhColors.mainTabLine,
                                              height: 2.w,
                                            ),
                                            // 向下按钮
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(color: HhColors.mainTabLine,width: 2.w),
                                                  ),
                                                ),
                                                child: BouncingWidget(
                                                  duration: const Duration(milliseconds: 100),
                                                  scaleFactor: 1.5,
                                                  onPressed: () {
                                                    logic.lowVP.value = (logic.lowVP.value - 0.1).clamp(0, 220);
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: HhColors.gray9TextColor,
                                                      size: 20.w*3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    

                    ///确定
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 0.5,
                      onPressed: () {
                        logic.sunSetting();
                      },
                      child: Container(
                        width: 1.sw,
                        height: 40.w*3,
                        margin: EdgeInsets.fromLTRB(0, 30.w, 0, 30.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(8.w * 3))),
                        child: Center(
                          child: Text(
                            "确定",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: HhColors.whiteColor,
                                fontSize: 15.sp * 3,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                    )
                  ],
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showReStartDialog() {
    CommonUtils().showCommonDialog(logic.context, "确定要重启设备吗？", () {
      Get.back();
    }, () {
      Get.back();
      logic.resetDevice();
    });
  }

  void showChooseVersionDialog() {
    showModalBottomSheet(
        context: logic.context,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: min(100.w*3+logic.versionList.length*45.w*3, 0.36.sh),
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(8.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.w * 3))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15.w * 3,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: buildDialogVersion(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8.w * 3,
                  color: HhColors.grayEFEFBackColor,
                ),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 50.w * 3,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(0.w * 3))),
                    child: Center(
                      child: Text(
                        "取消",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor, fontSize: 15.sp * 3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        backgroundColor: HhColors.trans);
  }
  buildDialogVersion() {
    List<Widget> list = [];
    for (int i = 0; i < logic.versionList.length; i++) {
      dynamic model = logic.versionList[i];
      list.add(InkWell(
        onTap: () {
          logic.version.value = i;
          logic.versionStr.value = "${model['version']}";
          Get.back();
        },
        child: Container(
          width: 1.sw,
          height: 45.w * 3,
          margin: EdgeInsets.fromLTRB(13.w * 3, 5.w * 3, 13.w * 3, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 200.w * 3),
                      child: Text(
                        "${model['version']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 15.sp * 3,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                  color: HhColors.grayLineColor,
                  height: 2.w,
                  width: 1.sw),
            ],
          ),
        ),
      ));
    }
    return list;
  }

  buildVoiceList() {
    List<Widget> list = [];
    list.add(
      Container(
        padding: EdgeInsets.fromLTRB(16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '名称',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Expanded(
              child: SizedBox()
            ),
            Container(
              margin: EdgeInsets.only(right: 42.w*3),
              child: Text(
                '操作',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    for (int i = 0; i < logic.voiceTopList.length; i++) {
      dynamic model = logic.voiceTopList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(
        Container(
          padding: EdgeInsets.fromLTRB(16.w * 3, 13.w * 3, 16.w * 3, 13.w * 3),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width:0.55.sw,
                      child: Text(
                        '${model["name"]}',
                        style: TextStyle(
                          color: HhColors.blackColor,
                          fontSize: 14.sp * 3,
                        ),
                      ),
                    ),
                    logic.localVoice.value=="${model["id"]}"? Container(
                      margin: EdgeInsets.only(left: 5.w*3),
                      child: Image.asset("assets/images/common/icon_device_playing.png",
                          height: 20.w*3,
                          width: 20.w*3),
                    ):const SizedBox()
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if(logic.localVoice.value=="${model["id"]}"){
                    //停止
                    logic.localVoice.value = "";
                    logic.stopVoiceLocal();
                  }else{
                    //播放
                    logic.playVoiceLocal("${CommonData.endpoint}${model["pcmUrl"]}");
                    logic.localVoice.value = "${model["id"]}";
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  child: Text(
                    logic.localVoice.value=="${model["id"]}"?"停止":'播放',
                    style: TextStyle(
                      color: logic.localVoice.value=="${model["id"]}"?HhColors.titleColorRed:HhColors.mainBlueColor,
                      fontSize: 14.sp * 3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
              InkWell(
                onTap: () {
                  logic.uploadVoice(model["name"], model["pcmUrl"]);
                },
                child: Text(
                  '上传',
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 14.sp * 3,
                  ),
                ),
              ),
              /*SizedBox(
                width: 30.w,
              ),
              InkWell(
                onTap: () {
                  logic.deleteWebVoice(model);
                },
                child: Text(
                  '删除',
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 14.sp * 3,
                  ),
                ),
              ),*/
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  buildVoiceListBottom() {
    List<Widget> list = [];
    list.add(
      Container(
        padding: EdgeInsets.fromLTRB(16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '名称',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Expanded(
                child: SizedBox()
            ),
            Container(
              margin: EdgeInsets.only(right: 42.w*3),
              child: Text(
                '操作',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 15.sp * 3,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    for (int i = 0; i < logic.voiceBottomList.length; i++) {
      dynamic model = logic.voiceBottomList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(
        Container(
          padding: EdgeInsets.fromLTRB(16.w * 3, 13.w * 3, 16.w * 3, 13.w * 3),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  width:0.55.sw,
                  child: Text(
                    '${model["name"]}',
                    style: TextStyle(
                      color: HhColors.blackColor,
                      fontSize: 14.sp * 3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
              InkWell(
                onTap: () {
                  logic.playVoice(model["name"]);
                },
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  child: Text(
                    '播放',
                    style: TextStyle(
                      color: HhColors.mainBlueColor,
                      fontSize: 14.sp * 3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30.w,
              ),
              InkWell(
                onTap: () {
                  logic.deleteVoice(model["name"]);
                },
                child: Text(
                  '删除',
                  style: TextStyle(
                    color: HhColors.mainBlueColor,
                    fontSize: 14.sp * 3,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      );
    }
    return list;
  }

  buildVersionChild() {
    List<Widget> list = [];

    for (int i = 0; i < logic.versionList.length; i++) {
      dynamic model = logic.versionList[i];
      list.add(
        Container(
          height: 1.w,
          color: HhColors.backColor,
        ),
      );
      list.add(InkWell(
        onTap: () {
          logic.version.value = i;
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(16.w * 3, 15.w * 3, 16.w * 3, 15.w * 3),
          child: Row(
            children: [
              Image.asset(
                  logic.version.value == i
                      ? "assets/images/common/yes2.png"
                      : "assets/images/common/no.png",
                  height: 20,
                  width: 20),
              SizedBox(
                width: 15.w,
              ),
              Text(
                '${model["version"]}',
                style: TextStyle(
                  color: HhColors.blackColor,
                  fontSize: 15.sp * 3,
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return list;
  }

  void showRecordDialog() {
    logic.recordDateTime = DateTime(2025);
    logic.recordTimes.value = "00:00:00";
    showModalBottomSheet(
        context: logic.context,
        builder: (a) {
          return Obx(
                  () => Container(
            width: 1.sw,
            height: 260.w*3,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HhColors.blue25InColor,
                    HhColors.whiteColor,
                    HhColors.whiteColor,
                    HhColors.whiteColor,
                    HhColors.blue25InColor,
                  ],
                ),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(8.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height:40.w*3),
                Text(
                  "新录音1",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HhColors.blackColor, fontSize: 20.sp * 3),
                ),
                SizedBox(height:8.w*3),
                Text(
                  logic.recordTimes.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HhColors.gray9TextColor, fontSize: 14.sp * 3),
                ),
                SizedBox(height:10.w*3),
                AudioDotsVisualizer(
                  key: logic.visualizerKey,
                  width: 60.w * 3,
                  height: 30.w * 3,
                  barCount: 14,
                  color: HhColors.mainBlueColor,
                ),
                SizedBox(height:10.w*3),

                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: HhColors.trans,
                        borderRadius:
                        BorderRadius.all(Radius.circular(0.w * 3))),
                    child: Center(
                      child: Image.asset(
                          "assets/images/common/icon_record_setting.png",
                          height: 80.w * 3,
                          width: 80.w * 3,fit: BoxFit.fill,),
                    ),
                  ),
                  onPressed: () {
                    if(!logic.videoTag.value){
                      logic.startRecord();
                      EventBusUtil.getInstance().fire(HhToast(title: "开始录音",type: 0));
                    }else{
                      Get.back();
                      //logic.stopRecord();
                    }
                  },
                )
              ],
            ),
          ));
        },
        isDismissible: true,
        enableDrag: false,
        backgroundColor: HhColors.trans).then((value) => {
    logic.stopRecord()
    });

    ///默认开启录音
    Future.delayed(const Duration(microseconds: 2000),(){
      logic.startRecord();
      EventBusUtil.getInstance().fire(HhToast(title: "开始录音",type: 0));
    });
  }

  void showChoosePersonDialog() {
    showModalBottomSheet(
        context: logic.context,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: 0.36.sh,
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.w * 3))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15.w * 3,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: buildDialogPerson(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8.w * 3,
                  color: HhColors.grayEFEFBackColor,
                ),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 50.w * 3,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(0.w * 3))),
                    child: Center(
                      child: Text(
                        "取消",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor, fontSize: 15.sp * 3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        backgroundColor: HhColors.trans);
  }

  void showChooseCarDialog() {
    showModalBottomSheet(
        context: logic.context,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: 0.36.sh,
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.w * 3))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15.w * 3,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: buildDialogCar(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8.w * 3,
                  color: HhColors.grayEFEFBackColor,
                ),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 50.w * 3,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(0.w * 3))),
                    child: Center(
                      child: Text(
                        "取消",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor, fontSize: 15.sp * 3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        backgroundColor: HhColors.trans);
  }

  void showChooseOpenDialog() {
    showModalBottomSheet(
        context: logic.context,
        builder: (a) {
          return Container(
            width: 1.sw,
            height: 0.36.sh,
            decoration: BoxDecoration(
                color: HhColors.trans,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(8.w * 3))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.w * 3))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15.w * 3,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: buildDialogOpen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 8.w * 3,
                  color: HhColors.grayEFEFBackColor,
                ),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 50.w * 3,
                    decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius:
                            BorderRadius.all(Radius.circular(0.w * 3))),
                    child: Center(
                      child: Text(
                        "取消",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor, fontSize: 15.sp * 3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
          );
        },
        isDismissible: true,
        enableDrag: false,
        backgroundColor: HhColors.trans);
  }

  buildDialogPerson() {
    List<Widget> list = [];
    for (int i = 0; i < logic.voiceBottomList.length; i++) {
      dynamic model = logic.voiceBottomList[i];
      list.add(InkWell(
        onTap: () {
          logic.config["audioHumanName"] = "${model['name']}";
          logic.testStatus.value = false;
          logic.testStatus.value = true;
          Get.back();
        },
        child: Container(
          width: 1.sw,
          height: 45.w * 3,
          margin: EdgeInsets.fromLTRB(13.w * 3, 5.w * 3, 13.w * 3, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 200.w * 3),
                      child: Text(
                        "${model['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 15.sp * 3,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                  color: HhColors.grayLineColor,
                  height: 2.w,
                  width: 1.sw),
            ],
          ),
        ),
      ));
    }
    return list;
  }

  buildDialogCar() {
    List<Widget> list = [];
    for (int i = 0; i < logic.voiceBottomList.length; i++) {
      dynamic model = logic.voiceBottomList[i];
      list.add(InkWell(
        onTap: () {
          logic.config["audioCarName"] = "${model['name']}";
          logic.testStatus.value = false;
          logic.testStatus.value = true;
          Get.back();
        },
        child: Container(
          width: 1.sw,
          height: 45.w * 3,
          margin: EdgeInsets.fromLTRB(13.w * 3, 5.w * 3, 13.w * 3, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 200.w * 3),
                      child: Text(
                        "${model['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 15.sp * 3,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                  color: HhColors.grayLineColor,
                  height: 2.w,
                  width: 1.sw),
            ],
          ),
        ),
      ));
    }
    return list;
  }

  buildDialogOpen() {
    List<Widget> list = [];
    for (int i = 0; i < logic.voiceBottomList.length; i++) {
      dynamic model = logic.voiceBottomList[i];
      list.add(InkWell(
        onTap: () {
          logic.config["audioOpenName"] = "${model['name']}";
          logic.testStatus.value = false;
          logic.testStatus.value = true;
          Get.back();
        },
        child: Container(
          width: 1.sw,
          height: 45.w * 3,
          margin: EdgeInsets.fromLTRB(13.w * 3, 5.w * 3, 13.w * 3, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 200.w * 3),
                      child: Text(
                        "${model['name']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.blackColor,
                            fontSize: 15.sp * 3,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15.w * 3, 0, 0),
                  color: HhColors.grayLineColor,
                  height: 2.w,
                  width: 1.sw),
            ],
          ),
        ),
      ));
    }
    return list;
  }
}

