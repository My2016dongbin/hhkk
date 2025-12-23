import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/pages/home/video/search/search_controller.dart';
import 'package:iot/utils/HhLog.dart';

class SearchPage extends StatelessWidget {
  final logic = Get.find<SearchedController>();

  SearchPage({super.key});

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
          color: HhColors.backColorF5,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? buildSearch() : const SizedBox(),
        ),
      ),
    );
  }

  buildSearch() {
    return Stack(
      children: [
        ///背景色
        Container(
          height: 103.h*3,
          color: HhColors.whiteColor,
        ),
        ///title
        Container(
          height: 44.h*3,
          margin: EdgeInsets.only(top: 59.h*3),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.w*3, 0, 0, 0),
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
              Expanded(
                child: Container(
                  height: 32.h*3,
                  margin: EdgeInsets.fromLTRB(12.w*3, 0, 10.w, 0),
                  padding: EdgeInsets.fromLTRB(12.w*3, 0, 12.w*3, 0),
                  decoration: BoxDecoration(
                      color: HhColors.grayEEBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(50.w))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/common/icon_search.png",
                        width: 18.w*3,
                        height: 18.w*3,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 3.w*3,
                      ),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (s){
                            logic.mainSearch();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            hintText: '搜索设备、空间、消息...',
                            hintStyle: TextStyle(
                                color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                          ),
                          style:
                          TextStyle(color: HhColors.textColor, fontSize: 14.sp*3),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  // logic.mainSearch();
                  logic.listStatus.value = false;
                  logic.searchController!.text = '';
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(21.w*3, 0, 14.w*3, 0),
                  padding: EdgeInsets.fromLTRB(0, 5.w, 0, 5.w),
                  child: Text(
                    "取消",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 15.sp*3,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
        logic.listStatus.value?Container(
          margin: EdgeInsets.only(top: 102.w*3),
          child: EasyRefresh(
            onRefresh: (){
              logic.mainSearch();
            },
            child: SingleChildScrollView(
              key: const Key("out"),
              child: (logic.deviceList.isEmpty&&logic.spaceList.isEmpty&&logic.messageList.isEmpty)?SizedBox(
                child: Center(child: CommonUtils().noneWidget(image: 'assets/images/common/icon_no_message_search.png',info: '没有找到匹配的结果',height: 136.w*3,width:176.w*3,top: 0.4.sw,mid: 6.w*3),),
              ):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: getListWidgets(),
              ),
            ),
          ),
        ):const SizedBox(),

      ],
    );
  }

  getListWidgets() {
    List<Widget> list = [];
    try{
      ///我的设备
      list.add(logic.deviceList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(24.w*3, 30.w, 0, 30.w),
        child: Text('我的设备',style: TextStyle(color: HhColors.blackTextColor,fontSize: 18.sp*3,fontWeight: FontWeight.bold),),
      ));
      for(int i = 0;i < logic.deviceList.length; i++){
        dynamic item = logic.deviceList[i];
        list.add(InkWell(
          onTap: (){
            CommonUtils().parseRouteDetail(item);
            /*if(item['productName']=='浩海一体机'){
              Get.to(()=>DeviceDetailPage('${item['deviceNo']}','${item['id']}'),binding: DeviceDetailBinding());
            }else if(item['productName']=='智慧立杆'){
              Get.to(()=>LiGanDetailPage('${item['deviceNo']}','${item['id']}'),binding: LiGanDetailBinding());
            }*/
          },
          child: Container(
            height: 80.w*3,
            margin: EdgeInsets.fromLTRB(14.w*3, 20.w, 14.w*3, 0),
            padding: EdgeInsets.fromLTRB(10.w*3, 14.w*3, 15.w*3, 14.w*3),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w*3))
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                    child: Image.asset(
                      CommonUtils().parseDeviceImage(item),
                      // item['productName']=='浩海一体机'?"assets/images/common/icon_c.png":"assets/images/common/icon_d.png",
                      width: 52.w*3,
                      height: 52.w*3,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(60.w*3, 0, 0, 50.w),
                    child: Text(
                      CommonUtils().parseNull('${item['name']}',""),
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 16.sp*3,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(60.w*3, 32.w*3, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      item['spaceName']==""?const SizedBox():Container(
                        constraints: BoxConstraints(maxWidth: 0.25.sw),
                        child: Text(
                          CommonUtils().parseNull('${item['spaceName']}', "默认空间"),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 13.sp*3),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.w, 0, 20.w, 0),
                        padding: EdgeInsets.fromLTRB(6.w*3,2.w*3,6.w*3,2.w*3),
                        decoration: BoxDecoration(
                          color: item['status']==1?HhColors.transBlueColors:HhColors.transRedColors,
                          border: Border.all(color: item['status']==1?HhColors.mainBlueColor:HhColors.mainRedColor,width: 1.w),
                          borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                        ),
                        child: Text(
                          item['status']==1?'在线':"离线",
                          style: TextStyle(
                              color: item['status']==1?HhColors.mainBlueColor:HhColors.mainRedColor, fontSize: 12.sp*3),
                        ),
                      ),
                      CommonData.personal?(item['shareMark']!=0?Container(//设备分享标识 0未分享 1分享中 2好友分享
                        margin: EdgeInsets.only(left:10.w),
                        padding: EdgeInsets.fromLTRB(15.w,5.w,15.w,5.w),
                        decoration: BoxDecoration(
                            color: item['shareMark']==1?HhColors.mainBlueColor:HhColors.grayEEBackColor,
                            borderRadius: BorderRadius.all(Radius.circular(4.w*3))
                        ),
                        child: Text(
                          item['shareMark']==1?'分享中*${item['shareCount']}': item['shareMark']==2?"好友分享":"",
                          style: TextStyle(
                              color: item['shareMark']==1?HhColors.whiteColor:HhColors.gray9TextColor, fontSize: 12.sp*3),
                        ),
                      ):const SizedBox()):const SizedBox(),
                    ],
                  ),
                ),
                CommonData.personal?Align(
                  alignment: Alignment.centerRight,
                  child:
                  BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      if(item['shareMark']==2){
                        return;
                      }
                      DateTime date = DateTime.now();
                      String time = date.toIso8601String().substring(0,19).replaceAll("T", " ");
                      Get.to(()=>SharePage(),binding: ShareBinding(),arguments: {
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
                    child: Container(
                      margin: EdgeInsets.only(right: 0.w),
                      child: Image.asset(
                        item['shareMark']==2?"assets/images/common/shared.png":"assets/images/common/share.png",
                        width: 28.w*3,
                        height: 28.w*3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
        ));
      }
      HhLog.d("device--");
      ///空间
      for(int i = 0; i < logic.spaceList.length; i++){
        dynamic space = logic.spaceList[i];
        List<dynamic> deviceList = space['deviceBaseDOList']??[];

        list.add(deviceList.isEmpty?const SizedBox():Container(
          margin: EdgeInsets.fromLTRB(24.w*3, 30.w, 0, 25.w),
          child: Text(CommonUtils().parseNameCount('${space['name']}', 10),style: TextStyle(color: HhColors.blackTextColor,fontSize: 18.sp*3,fontWeight: FontWeight.bold),),
        ));
        for(int i = 0;i < ((deviceList.length%2==0)?(deviceList.length/2):(deviceList.length/2+1-1)); i++){
          dynamic itemLeft = deviceList[i*2];//0 2 4
          dynamic itemRight = {};
          HhLog.d("space -- ${i*2}");
          if(deviceList.length>(i*2+1)){
            itemRight = deviceList[i*2+1];//1 3 5
            HhLog.d("space -- ${i*2+1}");
          }
          list.add(
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      CommonUtils().parseRouteDetail(itemLeft);
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge, //裁剪
                      width: 0.44.sw,
                      margin: EdgeInsets.fromLTRB(0.04.sw, 30.w, 0.02.sw, 0),
                      decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(16.w*3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 0.25.sw,
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.vertical(top:Radius.circular(16.w*3))),
                            child: Image.asset(
                              CommonUtils().parseDeviceBackImage(itemLeft),
                              // "assets/images/common/test_video.jpg",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(18.w*3, 16.w, 16.w, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    CommonUtils().parseNameCount("${itemLeft['name']}", 4),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 15.sp*3,),
                                  ),
                                ),
                                SizedBox(width: 8.w,),

                              ],
                            ),
                          ),
                          SizedBox(height: 20.w,),
                        ],
                      ),
                    ),
                  ),
                  itemRight['name'] == null?const SizedBox():InkWell(
                    onTap: (){
                      CommonUtils().parseRouteDetail(itemRight);
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge, //裁剪
                      width: 0.44.sw,
                      margin: EdgeInsets.fromLTRB(0.02.sw, 30.w, 0.04.sw, 0),
                      decoration: BoxDecoration(
                          color: HhColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(16.w*3))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 0.25.sw,
                            decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.vertical(top:Radius.circular(16.w*3))),
                            child: Image.asset(
                              // "assets/images/common/test_video.jpg",
                              CommonUtils().parseDeviceBackImage(itemRight),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    CommonUtils().parseNameCount("${itemRight['name']}", 4),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: HhColors.blackColor,
                                      fontSize: 15.sp*3,),
                                  ),
                                ),
                                SizedBox(width: 8.w,),

                              ],
                            ),
                          ),
                          SizedBox(height: 20.w,),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          );
        }
      }
      HhLog.d("space--");
      HhLog.d("logic.messageList-- ${logic.messageList}");
      ///我的消息
      list.add(logic.messageList.isEmpty?const SizedBox():Container(
        margin: EdgeInsets.fromLTRB(24.w*3, 30.w, 0, 30.w),
        child: Text('我的消息',style: TextStyle(color: HhColors.blackTextColor,fontSize: 18.sp*3,fontWeight: FontWeight.bold),),
      ));
      /*for(int i = 0;i < logic.messageList.length; i++){
        dynamic item = logic.messageList[i];
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 130.w,
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                            "assets/images/common/icon_message_back.png",
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,
                          ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                            return Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 200.w,
                              height: 130.w,
                              fit: BoxFit.fill,
                            );
                          },
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,),
                        ),
                        item['alarmType']=='tilt'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_y.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_open.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 130.w,
                      child: Stack(
                        children: [
                          item['status'] == true?const SizedBox():Container(
                            height: 10.w,
                            width: 10.w,
                            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                            decoration: BoxDecoration(
                                color: HhColors.backRedInColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                            child: Text(
                              parseLeftType("${item['alarmType']}"),
                              style: TextStyle(
                                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CommonUtils().parseNull('${item['deviceName']}',""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                                SizedBox(height: 5.w,),
                                Text(
                                  CommonUtils().parseNull('${item['spaceName']}', ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.w),
                              child: Text(
                                CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textColor, fontSize: 22.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }*/
      list.add(logic.messageList.isEmpty?const SizedBox():Container(
        constraints: BoxConstraints(
          minHeight: 1.sh,
          maxHeight: 1000.sh
        ),
        child: ListView.builder(padding: EdgeInsets.zero,physics: const NeverScrollableScrollPhysics(),itemCount: logic.messageList.length,itemBuilder: (BuildContext context, int index){
          dynamic item = logic.messageList[index];
          return messageItem(context,index,item);
        }),
      ));
      HhLog.d("message--");
    }catch(e){
      HhLog.e("search error ${e.toString()}");
    }
    return list;
  }


  String parseLeftType(String s) {
    if(s == "openCap"){
      return "箱盖开箱报警";
    }
    if(s == "human"){
      return "人员入侵报警";
    }
    if(s == "car"){
      return "车辆入侵报警";
    }
    if(s == "openSensor"){
      return "传感器开箱报警";
    }
    if(s == "tilt"){
      return "设备倾斜报警";
    }
    return "报警";
  }

  messageItem(BuildContext context, int index, dynamic item) {

    /*
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
      padding: EdgeInsets.all(20.w),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10.w))
      ),
      child: Stack(
        children: [
          item['status']==true?const SizedBox():Container(
            height: 10.w,
            width: 10.w,
            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
            decoration: BoxDecoration(
                color: HhColors.backRedInColor,
                borderRadius: BorderRadius.all(Radius.circular(5.w))
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
            child: Text(
              parseRightType("${item['messageType']}"),
              style: TextStyle(
                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "时间:${CommonUtils().parseLongTime('${item['createTime']}')}",
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
                SizedBox(height: 8.w,),
                Text(
                  '${item['content']}',
                  style: TextStyle(
                      color: HhColors.textColor, fontSize: 22.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );*/
    return Container(
      margin: EdgeInsets.fromLTRB(14.w*3, 20.w, 14.w*3, 0),
      padding: EdgeInsets.fromLTRB(8.w*3, 12.w*3, 10.w*3, 12.w*3),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: HhColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(8.w*3))
      ),
      child: Row(
        children: [
          SizedBox(
            width: 113.w*3,
            height: 70.w*3,
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.w*3),
                  ),
                  child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                    "assets/images/common/icon_message_back.png",
                    width: 113.w*3,
                    height: 70.w*3,
                    fit: BoxFit.fill,
                  ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                    return Image.asset(
                      "assets/images/common/test_video.jpg",
                      width: 113.w*3,
                      height: 70.w*3,
                      fit: BoxFit.fill,
                    );
                  },
                    width: 113.w*3,
                    height: 70.w*3,
                    fit: BoxFit.fill,),
                ),
                item['alarmType']=='tilt'?Align(
                  alignment:Alignment.center,
                  child: Image.asset(
                    "assets/images/common/icon_message_y.png",
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.fill,
                  ),
                ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                  alignment:Alignment.center,
                  child: Image.asset(
                    "assets/images/common/icon_message_open.png",
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.fill,
                  ),
                ):const SizedBox(),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              // height: 130.w,
              child: Stack(
                children: [
                  /*item['status'] == true?const SizedBox():Container(
                    height: 10.w,
                    width: 10.w,
                    margin: EdgeInsets.fromLTRB(10.w*3, 15.w, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.backRedInColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                  ),*/
                  Container(
                    margin: EdgeInsets.fromLTRB(10.w*3, 5.w, 0, 0),
                    child: Text(
                      parseLeftType("${item['alarmType']}"),
                      style: TextStyle(
                          color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10.w*3, 27.w*3, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CommonUtils().parseNull('${item['deviceName']}',""),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 14.sp*3),
                        ),
                        SizedBox(height: 3.w*3,),
                        Text(
                          CommonUtils().parseNull('${item['spaceName']}', ""),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: HhColors.textColor, fontSize: 13.sp*3),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 5.w),
                      child: Text(
                        CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                        style: TextStyle(
                            color: HhColors.textColor, fontSize: 12.sp*3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildMessage() {
    List<Widget> list = [];
    for(int i = 0;i < logic.messageList.length; i++){
        dynamic item = logic.messageList[i];
        list.add(
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              padding: EdgeInsets.all(20.w),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: HhColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 130.w,
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: item['alarmType']=='openCap'||item['alarmType']=='openSensor'||item['alarmType']=='tilt'?Image.asset(
                            "assets/images/common/icon_message_back.png",
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,
                          ):Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                            return Image.asset(
                              "assets/images/common/test_video.jpg",
                              width: 200.w,
                              height: 130.w,
                              fit: BoxFit.fill,
                            );
                          },
                            width: 200.w,
                            height: 130.w,
                            fit: BoxFit.fill,),
                        ),
                        item['alarmType']=='tilt'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_y.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                          alignment:Alignment.center,
                          child: Image.asset(
                            "assets/images/common/icon_message_open.png",
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.fill,
                          ),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 130.w,
                      child: Stack(
                        children: [
                          item['status'] == true?const SizedBox():Container(
                            height: 10.w,
                            width: 10.w,
                            margin: EdgeInsets.fromLTRB(5, 15.w, 0, 0),
                            decoration: BoxDecoration(
                                color: HhColors.backRedInColor,
                                borderRadius: BorderRadius.all(Radius.circular(5.w))
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                            child: Text(
                              parseLeftType("${item['alarmType']}"),
                              style: TextStyle(
                                  color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30.w, 50.w, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CommonUtils().parseNull('${item['deviceName']}',""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                                SizedBox(height: 5.w,),
                                Text(
                                  CommonUtils().parseNull('${item['spaceName']}', ""),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HhColors.textColor, fontSize: 22.sp),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.w),
                              child: Text(
                                CommonUtils().parseLongTimeHourMinute('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textColor, fontSize: 22.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }
    return list;
  }


  String parseRightType(String s) {
    if(s == "deviceAlarm"){
      return "设备报警通知";
    }
    return "通知";
  }

}
