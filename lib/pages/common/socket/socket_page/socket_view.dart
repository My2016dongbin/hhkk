import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/location/location_controller.dart';
import 'package:iot/pages/common/socket/socket_page/socket_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:web_socket_channel/io.dart';

class SocketPage extends StatelessWidget {
  final logic = Get.find<SocketController>();

  SocketPage({super.key});

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
        Container(color: HhColors.whiteColor,width: 1.sw,height: 1.sh,),
        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 90.w),
            color: HhColors.trans,
            child: Text(
              'Socket',
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(36.w, 90.w, 0, 0),
            padding: EdgeInsets.all(10.w),
            color: HhColors.trans,
            child: Image.asset(
              "assets/images/common/back.png",
              height: 17.w*3,
              width: 10.w*3,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
              padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
              decoration: BoxDecoration(
                color: HhColors.mainBlueColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w),),
              ),
              child: Text(
                '确定',
                style: TextStyle(
                    color: HhColors.whiteColor,
                    fontSize: 26.sp,),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 160.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///查询状态 1
              InkWell(
                onTap: (){
                  // final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
                  logic.chatStatus();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '查询状态',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///连接 2
              InkWell(
                onTap: (){
                  logic.connect();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '连接ws',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///创建会话 3
              InkWell(
                onTap: (){
                  logic.chatCreate();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '创建会话',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///关闭 4
              InkWell(
                onTap: (){
                  logic.chatClose();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '关闭',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///流 5
              InkWell(
                onTap: (){
                  // Navigator.push(logic.context,
                  //     MaterialPageRoute<void>(builder: (BuildContext context) {
                  //       return const RecordToStreamExample();
                  //     }));
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '流',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///录制 6
              InkWell(
                onTap: (){
                  // logic.startRecording();
                  logic.manager.recordAudio();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '录制',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
                    ),
                  ),
                ),
              ),
              ///停止录制 7
              InkWell(
                onTap: (){
                  // logic.stopRecording();
                  logic.manager.stopRecording();
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 90.w, 36.w, 0),
                    padding: EdgeInsets.fromLTRB(23.w, 8.w, 23.w, 10.w),
                    decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w),),
                    ),
                    child: Text(
                      '停止录制',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 26.sp,),
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

}
