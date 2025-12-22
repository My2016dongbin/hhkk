import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/pages/common/share/share_binding.dart';
import 'package:iot/pages/common/share/share_view.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/device/detail/device_detail_binding.dart';
import 'package:iot/pages/home/device/detail/device_detail_view.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_binding.dart';
import 'package:iot/pages/home/device/detail/ligan/setting/ligan_detail_view.dart';
import 'package:iot/pages/home/device/manage/device_manage_controller.dart';
import 'package:iot/pages/home/home_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';

class DeviceManagePage extends StatelessWidget {
  final logic = Get.find<DeviceManageController>();

  DeviceManagePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 54.w*3),
                  color: HhColors.trans,
                  child: Text(
                    '智能设备',
                    style: TextStyle(
                        color: HhColors.blackTextColor,
                        fontSize: 18.sp*3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
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
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.to(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 54.h*3, 14.w*3, 0),
                    padding: EdgeInsets.fromLTRB(20.w, 10.w, 10.w, 10.w),
                    color: HhColors.trans,
                    child: Image.asset(
                      "assets/images/common/ic_add.png",
                      height: 24.w*3,
                      width: 24.w*3,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              ///列表
              logic.testStatus.value?deviceList():const SizedBox(),
              ///tab
              Container(
                margin: EdgeInsets.fromLTRB(24.w*3, 110.h*3, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: logic.tabsTag.value?buildTabs():[],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deviceList() {
    return Container(
      margin: EdgeInsets.only(top: 149.h*3),
      child: EasyRefresh(
        onRefresh: (){
          logic.pageNum = 1;
          logic.deviceList(logic.pageNum);
        },
        onLoad: (){
          logic.pageNum++;
          logic.deviceList(logic.pageNum);
        },
        controller: logic.easyController,
        child: PagedListView<int, dynamic>(
          pagingController: logic.deviceController,
          padding: EdgeInsets.zero,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            firstPageProgressIndicatorBuilder: (c){
              return Container();
            }, // 关闭首次加载动画
            newPageProgressIndicatorBuilder:  (c){
              return Container();
            },   // 关闭新页加载动画
            noItemsFoundIndicatorBuilder: (context) =>Column(
              children: [
                const Expanded(child: SizedBox()),
                Image.asset('assets/images/common/no_message.png',fit: BoxFit.fill,
                  height: 0.32.sw,
                  width: 0.6.sw,),
                SizedBox(height: 100.w,),
                const Expanded(child: SizedBox()),
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  child: Container(
                    width: 1.sw,
                    height: 44.w*3,
                    margin: EdgeInsets.fromLTRB(36.w*3, 20.w, 36.w*3, 25.w*3),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                    child: Center(
                      child: Text(
                        "没有设备？去添加",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.grayEEBackColor, fontSize: 15.sp*3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(()=>DeviceAddPage(snCode: ""),binding: DeviceAddBinding());
                  },
                ),
              ],
            ),
            itemBuilder: (context, item, index) =>
                InkWell(
                  onTap: (){
                    CommonUtils().parseRouteDetail(item);
                  },
                  child: Container(
                    height: 80.w*3,
                    margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
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
                                  CommonUtils().parseNull('${item['spaceName']}', ""),
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
                                padding: EdgeInsets.fromLTRB(6.w*3,2.w*3,6.w*3,2.w*3),
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
                ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTabs() {
    List<Widget> list = [];
    for(int i = 0;i < logic.spaceList.length;i++){
      dynamic model = logic.spaceList[i];
      list.add(
          Container(
            margin: EdgeInsets.only(left: i==0?0:30.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    logic.tabIndex.value = i;
                    logic.pageNum = 1;
                    logic.deviceList(logic.pageNum);
                  },
                  child: Text(
                    '${model['name']}',
                    style: TextStyle(
                        color: logic.tabIndex.value==i?HhColors.mainBlueColor:HhColors.gray9TextColor, fontSize: logic.tabIndex.value==i?18.sp*3:15.sp*3,fontWeight: logic.tabIndex.value==i?FontWeight.bold:FontWeight.w500),
                  ),
                ),
                SizedBox(height: 5.w,),
                logic.tabIndex.value==i?Container(
                  height: 2.w*3,
                  width: 9.w*3,
                  decoration: BoxDecoration(
                      color: HhColors.mainBlueColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.w))
                  ),
                ):const SizedBox()
              ],
            ),
          )
      );
    }

    return list;
  }
}
