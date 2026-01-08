import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/pages/home/message/message_detail/message_detail_binding.dart';
import 'package:iot/pages/home/message/message_detail/message_detail_view.dart';
import 'package:iot/pages/home/message/message_setting/warn_setting_binding.dart';
import 'package:iot/pages/home/message/message_setting/warn_setting_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import '../../../utils/HhColors.dart';
import 'message_controller.dart';

class MessagePage extends StatelessWidget {
  final logic = Get.find<MessageController>();

  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return OverlayTooltipScaffold(
      overlayColor: Colors.red.withOpacity(.4),
      tooltipAnimationCurve: Curves.linear,
      tooltipAnimationDuration: const Duration(milliseconds: 0),
      controller: logic.tipController,
      preferredOverlay: GestureDetector(
        onTap: () {
          logic.tipController.dismiss();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: HhColors.mainGrayColor,
        ),
      ),
      builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: HhColors.backColor,
            body: Obx(
                  () => Container(
                height: 1.sh,
                width: 1.sw,
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    ///背景-渐变色
                    Image.asset(
                      "assets/images/common/main_background.png",
                      width: 1.sw,
                      height: 1.sh,
                      fit: BoxFit.fill,
                    ),
                    (logic.editLeft.value||logic.editRight.value)?BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        //logicHome.index.value = 0;
                        if(logic.tabIndex.value==0){
                          logic.editLeft.value = false;
                        }else{
                          logic.editRight.value = false;
                        }
                        logic.pageStatus.value = false;
                        logic.pageStatus.value = true;
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(12.w*3, 58.h*3, 0, 0),
                        padding: EdgeInsets.all(10.w),
                        child: Image.asset(
                          "assets/images/common/ic_x.png",
                          height: 17.w*3,
                          width: 17.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ):const SizedBox(),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 44.w*3,
                        margin: EdgeInsets.only(top: 51.h*3),
                        child: Row(
                          children: [
                            (logic.editLeft.value||logic.editRight.value)?SizedBox(width: 59.w*3,):SizedBox(width: 10.w*3,),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                logic.tabIndex.value = 0;
                                resetEdit();
                                logic.pageNumRight = 1;
                                logic.fetchPageRight(1);
                              },
                              child: Container(
                                width: 55.w*3,
                                padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topRight,
                                        child: Container(
                                            color: HhColors.trans,
                                            margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==0?0:10.w, 40.w, 0),
                                            child: Text("报警",style: TextStyle(color: logic.tabIndex.value==0?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==0?18.sp*3:14.sp*3,fontWeight: logic.tabIndex.value==0?FontWeight.bold:FontWeight.w200),))),
                                    logic.warnCount.value=="0"?const SizedBox():Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HhColors.mainRedColor,
                                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                                        ),
                                        width: 15.w*3 + ((logic.warnCount.value.length-1) * (3.w*3)),
                                        height: 15.w*3,
                                        child: Center(child: Text(logic.warnCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                logic.tabIndex.value = 1;
                                resetEdit();
                                logic.dateListLeft = [];
                                logic.pageNumLeft = 1;
                                logic.fetchPageLeft(1);
                              },
                              child: Container(
                                width: 55.w*3,
                                padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topRight,
                                        child: Container(
                                            color: HhColors.trans,
                                            margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==1?0:10.w, 40.w, 0),
                                            child: Text("通知",style: TextStyle(color: logic.tabIndex.value==1?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==1?18.sp*3:14.sp*3,fontWeight: logic.tabIndex.value==1?FontWeight.bold:FontWeight.w200),))),
                                    logic.noticeCount.value=="0"?const SizedBox():Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HhColors.mainRedColor,
                                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                                        ),
                                        width: 15.w*3 + ((logic.noticeCount.value.length-1) * (3.w*3)),
                                        height: 15.w*3,
                                        child: Center(child: Text(logic.noticeCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.0,
                              onPressed: (){
                                logic.tabIndex.value = 2;
                                resetEdit();
                                logic.dateListLeft = [];
                                logic.pageNumLeft = 1;
                                logic.fetchPageLeft(1);
                              },
                              child: Container(
                                width: 55.w*3,
                                padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                                color: HhColors.trans,
                                child: Stack(
                                  children: [
                                    Align(alignment: Alignment.topRight,
                                        child: Container(
                                            color: HhColors.trans,
                                            margin: EdgeInsets.fromLTRB(0, logic.tabIndex.value==2?0:10.w, 40.w, 0),
                                            child: Text("通话",style: TextStyle(color: logic.tabIndex.value==2?HhColors.blackColor:HhColors.gray9TextColor,fontSize: logic.tabIndex.value==2?18.sp*3:14.sp*3,fontWeight: logic.tabIndex.value==2?FontWeight.bold:FontWeight.w200),))),
                                    /*logic.noticeCount.value=="0"?const SizedBox():Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: HhColors.mainRedColor,
                                            borderRadius: BorderRadius.all(Radius.circular(20.w))
                                        ),
                                        width: 15.w*3 + ((logic.noticeCount.value.length-1) * (3.w*3)),
                                        height: 15.w*3,
                                        child: Center(child: Text(logic.noticeCount.value,style: TextStyle(color: HhColors.whiteColor,fontSize: 10.sp*3),)),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    logic.tabIndex.value==2?const SizedBox():Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 54.w*3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0.2,
                              onPressed: (){
                                CommonUtils().showDeleteDialog(context, "确定要已读所有消息记录？", (){
                                  Get.back();
                                }, (){
                                  logic.readAll();
                                  Get.back();
                                },(){
                                  Get.back();
                                },leftStr: "取消",rightStr: "确定");
                              },
                              child: Container(
                                color: HhColors.trans,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/images/common/icon_clear_message.png",
                                      width: 22.w*3,
                                      height: 22.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                    Text(
                                      "一键已读",
                                      style: TextStyle(
                                          color: HhColors.blackTextColor,
                                          fontSize: 10.sp*3,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w*3,),

                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0,
                              onPressed: (){
                                logic.tipController.start();
                              },
                              child: OverlayTooltipItem(
                                displayIndex: 0,
                                tooltip: (controller) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10.w*3),
                                    decoration: BoxDecoration(
                                        color: HhColors.whiteColor,
                                        borderRadius: BorderRadius.circular(16.w*3)
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BouncingWidget(
                                          duration: const Duration(milliseconds: 100),
                                          scaleFactor: 0.2,
                                          onPressed: (){
                                            logic.tipController.dismiss();
                                            if(logic.tabIndex.value==0){
                                              // logic.editLeft.value = true;
                                              logic.editLeft.value = !logic.editLeft.value;
                                            }else{
                                              // logic.editRight.value = true;
                                              logic.editRight.value = !logic.editRight.value;
                                            }
                                            logic.pageStatus.value = false;
                                            logic.pageStatus.value = true;
                                          },
                                          child: Container(
                                            color:HhColors.trans,
                                            padding: EdgeInsets.fromLTRB(22.w*3, 17.w*3, 15.w*3, 10.w*3),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('管理消息', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                                SizedBox(width: 20.w*3,),
                                                Image.asset(
                                                  "assets/images/common/ic_setting.png",
                                                  width: 18.w*3,
                                                  height: 18.w*3,
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        BouncingWidget(
                                          duration: const Duration(milliseconds: 100),
                                          scaleFactor: 0.2,
                                          onPressed: (){
                                            logic.tipController.dismiss();
                                            Get.to(()=>WarnSettingPage(),binding: WarnSettingBinding());
                                          },
                                          child: Container(
                                            color:HhColors.trans,
                                            padding: EdgeInsets.fromLTRB(22.w*3, 10.w*3, 15.w*3, 17.w*3),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('报警设置', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                                SizedBox(width: 20.w*3,),
                                                Image.asset(
                                                  "assets/images/common/icon_warn_setting.png",
                                                  width: 18.w*3,
                                                  height: 18.w*3,
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  color: HhColors.trans,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/common/icon_more_message.png",
                                        width: 22.w*3,
                                        height: 22.w*3,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        "更多",
                                        style: TextStyle(
                                            color: HhColors.blackTextColor,
                                            fontSize: 10.sp*3,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 30.w,),
                          ],
                        ),
                      ),
                    ),

                    logic.pageStatus.value ? (logic.tabIndex.value==0 ? leftMessage() : (logic.tabIndex.value==1 ? rightMessage() : callMessage())):const SizedBox(),
                  ],
                ),
              ),
            ));
      },
    );
  }

  leftMessage() {
    DateTime dateTime = DateTime.now();
    String today = CommonUtils().parseLongTimeYearDay("${dateTime.millisecondsSinceEpoch}");
    return Container(
      margin: EdgeInsets.only(top: 88.w*3),
      child: Column(
        children: [
          ///筛选
          Container(
            width: 1.sw,
            height: 44.w*3,
            color: HhColors.trans,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 14.w*3,),
                  ///搜索
                  Container(
                    width: 118.w*3,
                      padding:EdgeInsets.fromLTRB(7.w*3, 0, 8.w*3, 0),
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.w*3),
                          border: Border.all(width: 0.5.w,color: HhColors.gray9TextColor)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/icon_search.png",
                            width: 14.w*3,
                            height: 14.w*3,
                            fit: BoxFit.fill,
                          ),
                          // Text('请输入设备名称',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 23.sp),),
                          Expanded(
                            child: SizedBox(
                              height: 30.w*3,
                              child: TextField(
                                // maxLines: 1,
                                maxLength: 8,
                                cursorColor: HhColors.titleColor_99,
                                controller: logic.deviceNameController,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (s){
                                  logic.dateListLeft = [];
                                  logic.pageNumLeft = 1;
                                  logic.fetchPageLeft(1);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  counterText: '',
                                  hintText: '请输入设备名称',
                                  hintStyle: TextStyle(
                                      color: HhColors.gray9TextColor, fontSize: 12.sp*3),
                                  floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                                ),
                                style:
                                TextStyle(color: HhColors.gray9TextColor, fontSize: 12.sp*3),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  ///分组
                  InkWell(
                    onTap: (){
                      logic.isChooseType.value = false;
                      logic.isChooseDate.value = false;
                      logic.isChooseSpace.value = !logic.isChooseSpace.value;
                    },
                    child: Container(
                      height: 30.w*3,
                        margin: EdgeInsets.only(left: 24.w*3),
                        padding:EdgeInsets.fromLTRB(12.w*3, 0, 12.w*3, 0),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.circular(8.w*3),
                            border: Border.all(width: logic.isChooseSpace.value?1.5.w:0.5.w,color: logic.isChooseSpace.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${logic.spaceList[logic.spaceSelectIndex.value]["name"]}',style: TextStyle(color: logic.isChooseSpace.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 12.sp*3),),
                            Image.asset(
                              "assets/images/common/icon_down_status.png",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.fill,
                            ),
                          ],
                        )),
                  ),
                  ///类型
                  InkWell(
                    onTap: (){
                      logic.isChooseSpace.value = false;
                      logic.isChooseDate.value = false;
                      logic.isChooseType.value = !logic.isChooseType.value;
                    },
                    child: Container(
                        height: 30.w*3,
                        margin: EdgeInsets.only(left: 24.w*3),
                        padding:EdgeInsets.fromLTRB(12.w*3, 0, 12.w*3, 0),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.circular(8.w*3),
                            border: Border.all(width: logic.isChooseType.value?1.5.w:0.5.w,color: logic.isChooseType.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),child: Row(
                      mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${logic.typeList[logic.typeSelectIndex.value]["alarmName"]}',style: TextStyle(color: logic.isChooseType.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 12.sp*3),),
                            Image.asset(
                              "assets/images/common/icon_down_status.png",
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.fill,
                            ),
                          ],
                        )),
                  ),
                  ///日期
                  InkWell(
                    onTap: (){
                      logic.isChooseSpace.value = false;
                      logic.isChooseType.value = false;
                      logic.isChooseDate.value = !logic.isChooseDate.value;
                      if(logic.isChooseDate.value){
                        chooseDate();
                      }
                    },
                    child: Container(
                        height: 30.w*3,
                        margin: EdgeInsets.only(left: 24.w*3),
                        padding:EdgeInsets.fromLTRB(7.w*3, 0, 8.w*3, 0),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            borderRadius: BorderRadius.circular(8.w*3),
                            border: Border.all(width: logic.isChooseDate.value?1.5.w:0.5.w,color: logic.isChooseDate.value?HhColors.mainBlueColor:HhColors.gray9TextColor)
                        ),child: Row(
                      mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              logic.isChooseDate.value?"assets/images/common/icon_message_date_yes.png":"assets/images/common/icon_date_message.png",
                              width: 14.w*3,
                              height: 14.w*3,
                              fit: BoxFit.fill,
                            ),
                            Text('${logic.dateStr}',style: TextStyle(color: logic.isChooseDate.value?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 12.sp*3),),
                          ],
                        )),
                  ),
                  SizedBox(width: 14.w*3,),
                ],
              ),
            ),
          ),
          //分组
          logic.isChooseSpace.value?Container(
            width: 1.sw,
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.w*3),
                  bottomRight: Radius.circular(8.w*3)
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.w*3,),
                Wrap(
                  children: logic.spaceListStatus.value?buildSpaceListView():const SizedBox(),
                ),
                SizedBox(height: 5.w*3,),
                Stack(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      child: Container(
                        width: 1.sw,
                        height: 44.w*3,
                        margin: EdgeInsets.fromLTRB(14.w*3, 10.w, 14.w*3, 10.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                        child: Center(
                          child: Text(
                            "确定",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3),
                          ),
                        ),
                      ),
                      onPressed: () {
                        logic.isChooseSpace.value = false;
                        logic.dateListLeft = [];
                        logic.pageNumLeft = 1;
                        logic.fetchPageLeft(1);
                      },
                    )
                  ],
                ),
                SizedBox(height: 5.w*3,),
              ],
            ),
          ):const SizedBox(),
          //类型
          logic.isChooseType.value?
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
              color: HhColors.whiteColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.w*3),
                  bottomRight: Radius.circular(8.w*3)
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.w*3,),
                Wrap(
                  children: buildTypeListView(),
                ),
                SizedBox(height: 5.w*3,),
                Stack(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      child: Container(
                        width: 1.sw,
                        height: 44.w*3,
                        margin: EdgeInsets.fromLTRB(14.w*3, 10.w, 14.w*3, 10.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                        child: Center(
                          child: Text(
                            "确定",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3),
                          ),
                        ),
                      ),
                      onPressed: () {
                        logic.isChooseType.value = false;
                        logic.dateListLeft = [];
                        logic.pageNumLeft = 1;
                        logic.fetchPageLeft(1);
                      },
                    )
                  ],
                ),
                SizedBox(height: 5.w*3,),
              ],
            ),
          ):const SizedBox(),
          ///报警列表
          Expanded(
            child: EasyRefresh(
              onRefresh: (){
                logic.dateListLeft = [];
                logic.pageNumLeft = 1;
                logic.fetchPageLeft(1);
              },
              onLoad: (){
                logic.pageNumLeft++;
                logic.fetchPageLeft(logic.pageNumLeft);
              },
              controller: logic.easyControllerLeft,
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.deviceController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无消息',mid: 20.w,
                    height: 0.36.sw,
                    width: 0.44.sw,),
                  itemBuilder: (context, item, index) {
                    if(item["showDate"]==null){
                      if(logic.dateListLeft.contains(CommonUtils().parseLongTimeYearDay('${item['createTime']}'))){
                        item["showDate"] = 0;
                      }else{
                        item["showDate"] = 1;
                        logic.dateListLeft.add(CommonUtils().parseLongTimeYearDay('${item['createTime']}'));
                      }
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        item["showDate"]==1?Container(
                          margin: EdgeInsets.fromLTRB(14.w*3, 15.w, 14.w*3, 0),
                          child: Row(
                            children: [
                              Text(
                                today == CommonUtils().parseLongTimeYearDay('${item['createTime']}')?'今天':CommonUtils().parseLongTimeDay('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5.w,),
                              Expanded(
                                child: Text(
                                  '————————————————————————————————————————————————————————————————————————————',
                                  maxLines: 1,
                                  style: TextStyle(
                                      letterSpacing: 10.w,
                                      color: HhColors.grayCCTextColor, fontSize: 20.sp),
                                ),
                              ),
                            ],
                          ),
                        ):const SizedBox(),
                        HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: (){
                            if(logic.editLeft.value){
                              item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                              logic.pageStatus.value = false;
                              logic.pageStatus.value = true;
                              if(item["selected"] == 1){
                                if(!logic.chooseListLeft.contains(item["id"])){
                                  logic.chooseListLeft.add(item["id"]);
                                }
                              }else{
                                if(logic.chooseListLeft.contains(item["id"])){
                                  logic.chooseListLeft.remove(item["id"]);
                                }
                              }
                              logic.chooseListLeftNumber.value = logic.chooseListLeft.length;
                              HhLog.d("list -- ${logic.chooseListLeft}");
                            }else{
                              logic.readOneLeft("${item["id"]}");
                              Get.to(()=>MessageDetailPage(),binding: MessageDetailBinding(),arguments: {
                                "id": "${item["id"]}",
                              });
                            }
                          },
                          child: Row(
                            children: [
                              logic.editLeft.value?Container(
                                padding: EdgeInsets.fromLTRB(14.w*3, 14.w*3, 0, 14.w*3),
                                child: Image.asset(
                                  item["selected"] == 1?"assets/images/common/yes.png":"assets/images/common/no.png",
                                  width: 14.w*3,
                                  height: 14.w*3,
                                  fit: BoxFit.fill,
                                ),
                              ):const SizedBox(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
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
                                              ):("${item['alarmType']}".contains("offline"))?Image.asset(
                                                "assets/images/common/icon_offline_warn.png",
                                                width: 113.w*3,
                                                height: 70.w*3,
                                                fit: BoxFit.fill,
                                              ):InkWell(
                                                onTap: (){
                                                  CommonUtils().showPictureDialog(context, url:"${CommonData.endpoint}${item['alarmImageUrl']}");
                                                  logic.readOneLeft("${item["id"]}");
                                                },
                                                child: Image.network("${CommonData.endpoint}${item['alarmImageUrl']}",errorBuilder: (a,b,c){
                                                  return Image.asset(
                                                    "assets/images/common/ic_message_no.png",
                                                    width: 113.w*3,
                                                    height: 70.w*3,
                                                    fit: BoxFit.fill,
                                                  );
                                                },
                                                  width: 113.w*3,
                                                  height: 70.w*3,
                                                  fit: BoxFit.fill,),
                                              ),
                                            ),
                                            item['alarmType']=='tilt'?Align(
                                              alignment:Alignment.center,
                                              child: Image.asset(
                                                "assets/images/common/icon_message_y.png",
                                                width: 30.w*3,
                                                height: 30.w*3,
                                                fit: BoxFit.fill,
                                              ),
                                            ):item['alarmType']=='openCap'||item['alarmType']=='openSensor'?Align(
                                              alignment:Alignment.center,
                                              child: Image.asset(
                                                "assets/images/common/icon_message_open.png",
                                                width: 30.w*3,
                                                height: 30.w*3,
                                                fit: BoxFit.fill,
                                              ),
                                            ):const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 70.w*3,
                                          child: Stack(
                                            children: [
                                              item['status'] == true?const SizedBox():Container(
                                                height: 6.w*3,
                                                width: 6.w*3,
                                                margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                                                decoration: BoxDecoration(
                                                    color: HhColors.backRedInColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(3.w*3))
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(30.w, 5.w, 0, 0),
                                                child: Text(
                                                  parseLeftType("${item['alarmType']}"),
                                                  style: TextStyle(
                                                      color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(30.w, 26.w*3, 0, 0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      CommonUtils().parseNull('${item['deviceName']}',""),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: HhColors.gray9TextColor, fontSize: 14.sp*3),
                                                    ),
                                                    SizedBox(height: 5.w,),
                                                    Text(
                                                      CommonUtils().parseNull('${item['spaceName']}', ""),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: HhColors.gray9TextColor, fontSize: 13.sp*3),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          ///编辑操作面板
          logic.editLeft.value?Container(
            height: 50.w*3,
            width: 1.sw,
            color: HhColors.whiteColor,
            child: Row(
              children: [
                SizedBox(width: 21.w*3,),
                Text(
                  '已选：',
                  style: TextStyle(
                      color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                ),
                Text(
                  '${logic.chooseListLeftNumber.value}条',
                  style: TextStyle(
                      color: HhColors.gray6TextColor, fontSize: 14.sp*3),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.0,
                        onPressed: (){
                          if(logic.chooseListLeftNumber.value == 0){
                            EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                            return;
                          }
                          logic.readLeft();
                        },
                        child: Container(
                          padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                          decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(8.w*3)
                          ),
                          child: Text(
                            '全部已读',
                            style: TextStyle(
                                color: HhColors.whiteColor, fontSize: 14.sp*3),
                          ),
                        ),
                      ),
                      SizedBox(width: 9.w*3,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.0,
                        onPressed: (){
                          if(logic.chooseListLeftNumber.value == 0){
                            EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                            return;
                          }

                          CommonUtils().showDeleteDialog(logic.context, "确定要删除所选消息记录？", (){
                            Get.back();
                          }, (){
                            logic.deleteLeft();
                            Get.back();
                          },(){
                            Get.back();
                          },leftStr: "取消",rightStr: "删除");
                        },
                        child: Container(
                          padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                          decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
                            borderRadius: BorderRadius.circular(8.w*3)
                          ),
                          child: Text(
                            '全部删除',
                            style: TextStyle(
                                color: HhColors.mainBlueColor, fontSize: 14.sp*3),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w*3,),
                    ],
                  ),
                ),
              ],
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }

  rightMessage() {
    return Column(
      children: [
        ///通知列表
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 88.w*3),
            child: EasyRefresh(
              onRefresh: (){
                logic.pageNumRight = 1;
                logic.fetchPageRight(1);
              },
              onLoad: (){
                logic.pageNumRight++;
                logic.fetchPageRight(logic.pageNumRight);

              },
              controller: logic.easyControllerRight,
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.warnController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无消息',mid: 50.w,
                    height: 0.32.sw,
                    width: 0.4.sw,),
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: (){
                        if(logic.editRight.value){
                          item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                          logic.pageStatus.value = false;
                          logic.pageStatus.value = true;
                          if(item["selected"] == 1){
                            if(!logic.chooseListRight.contains(item["id"])){
                              logic.chooseListRight.add(item["id"]);
                            }
                          }else{
                            if(logic.chooseListRight.contains(item["id"])){
                              logic.chooseListRight.remove(item["id"]);
                            }
                          }
                          logic.chooseListRightNumber.value = logic.chooseListRight.length;
                          HhLog.d("list right -- ${logic.chooseListRight}");
                        }else{
                          logic.readOneRight("${item["id"]}");
                        }
                      },
                      child: Row(
                        children: [
                          logic.editRight.value?Container(
                            padding: EdgeInsets.fromLTRB(14.w*3, 14.w*3, 0, 14.w*3),
                            child: Image.asset(
                              item["selected"] == 1?"assets/images/common/yes.png":"assets/images/common/no.png",
                              width: 14.w*3,
                              height: 14.w*3,
                              fit: BoxFit.fill,
                            ),
                          ):const SizedBox(),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                              padding: EdgeInsets.all(20.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                              ),
                              child: Stack(
                                children: [
                                  item['status']==true?const SizedBox():Container(
                                    height: 6.w*3,
                                    width: 6.w*3,
                                    margin: EdgeInsets.fromLTRB(0, 7.w*3, 0, 0),
                                    decoration: BoxDecoration(
                                        color: HhColors.backRedInColor,
                                        borderRadius: BorderRadius.all(Radius.circular(3.w*3))
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                                    child: Text(
                                      parseRightType("${item['messageType']}"),
                                      style: TextStyle(
                                          color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 26.w*3, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "时间:${CommonUtils().parseLongTime('${item['createTime']}')}",
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 13.sp*3),
                                        ),
                                        SizedBox(height: 8.w,),
                                        Text(
                                          '${item['content']}',
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 14.sp*3),
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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ///编辑操作面板
        logic.editRight.value?Container(
          height: 50.w*3,
          width: 1.sw,
          color: HhColors.whiteColor,
          child: Row(
            children: [
              SizedBox(width: 21.w*3,),
              Text(
                '已选：',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
              ),
              Text(
                '${logic.chooseListRightNumber.value}条',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListRightNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        logic.readRight();
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(8.w*3)
                        ),
                        child: Text(
                          '全部已读',
                          style: TextStyle(
                              color: HhColors.whiteColor, fontSize: 14.sp*3),
                        ),
                      ),
                    ),
                    SizedBox(width: 9.w*3,),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListRightNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        CommonUtils().showDeleteDialog(logic.context, "确定要删除所选消息记录？", (){
                          Get.back();
                        }, (){
                          logic.deleteRight();
                          Get.back();
                        },(){
                          Get.back();
                        },leftStr: "取消",rightStr: "删除");
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
                            borderRadius: BorderRadius.circular(8.w*3)
                        ),
                        child: Text(
                          '全部删除',
                          style: TextStyle(
                              color: HhColors.mainBlueColor, fontSize: 14.sp*3),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w*3,),
                  ],
                ),
              ),
            ],
          ),
        ):const SizedBox(),
      ],
    );

      /*Container(
        margin: EdgeInsets.only(top: 160.w),
        child: EasyRefresh(
          controller: logic.rightRefreshController,
          onRefresh: (){
            logic.pageNumRight = 1;
            logic.fetchPageRight(1);
          },
          onLoad: (){
            logic.pageNumRight++;
            logic.fetchPageRight(logic.pageNumRight);
            logic.rightRefreshController.finishLoad();

          },
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.zero,
            pagingController: logic.warnController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/no_message.png',info: '暂无消息',mid: 50.w,
                height: 0.32.sw,
                width: 0.6.sw,),
              itemBuilder: (context, item, index) => Container(
                margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                padding: EdgeInsets.all(20.w),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: Stack(
                  children: [
                    Container(
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
                        "${item['messageType']}",
                        style: TextStyle(
                            color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 40.w, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "时间:${item['id']}",
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
              ),
            ),
          ),
        ),
      );*/
  }

  callMessage() {
    return Column(
      children: [
        ///通话列表
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 88.w*3),
            child: EasyRefresh(
              onRefresh: (){
                logic.pageNumCall = 1;
                logic.fetchPageCall(1);
              },
              onLoad: (){
                logic.pageNumCall++;
                logic.fetchPageCall(logic.pageNumCall);

              },
              controller: logic.easyControllerCall,
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.callController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无消息',mid: 50.w,
                    height: 0.32.sw,
                    width: 0.4.sw,),
                  itemBuilder: (context, item, index) {
                    return InkWell(
                      onTap: (){
                        /*if(logic.editCall.value){
                          item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                          logic.pageStatus.value = false;
                          logic.pageStatus.value = true;
                          if(item["selected"] == 1){
                            if(!logic.chooseListCall.contains(item["id"])){
                              logic.chooseListCall.add(item["id"]);
                            }
                          }else{
                            if(logic.chooseListCall.contains(item["id"])){
                              logic.chooseListCall.remove(item["id"]);
                            }
                          }
                          logic.chooseListCallNumber.value = logic.chooseListCall.length;
                          HhLog.d("list call -- ${logic.chooseListCall}");
                        }*/
                        showCallDialog(item);
                      },
                      child: Row(
                        children: [
                          logic.editCall.value?Container(
                            padding: EdgeInsets.fromLTRB(14.w*3, 14.w*3, 0, 14.w*3),
                            child: Image.asset(
                              item["selected"] == 1?"assets/images/common/yes.png":"assets/images/common/no.png",
                              width: 14.w*3,
                              height: 14.w*3,
                              fit: BoxFit.fill,
                            ),
                          ):const SizedBox(),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(14.w*3, 10.w*3, 14.w*3, 0),
                              padding: EdgeInsets.all(20.w),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: HhColors.whiteColor,
                                  borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                              ),
                              child: Stack(
                                children: [
                                  /*item['status']==true?const SizedBox():Container(
                                    height: 6.w*3,
                                    width: 6.w*3,
                                    margin: EdgeInsets.fromLTRB(0, 7.w*3, 0, 0),
                                    decoration: BoxDecoration(
                                        color: HhColors.backRedInColor,
                                        borderRadius: BorderRadius.all(Radius.circular(3.w*3))
                                    ),
                                  ),*/
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                                    child: Text(
                                      "${parseCall("${item['callStatus']}")}【${item['deviceNo']}】",
                                      style: TextStyle(
                                          color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(30.w, 26.w*3, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "时间:${CommonUtils().parseLongTime('${item['callTime']}')}",
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 13.sp*3),
                                        ),
                                        SizedBox(height: 8.w,),
                                        Text(
                                          '通话时长${item['callMarket']}秒',
                                          style: TextStyle(
                                              color: HhColors.textColor, fontSize: 14.sp*3),
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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ///编辑操作面板
        logic.editCall.value?Container(
          height: 50.w*3,
          width: 1.sw,
          color: HhColors.whiteColor,
          child: Row(
            children: [
              SizedBox(width: 21.w*3,),
              Text(
                '已选：',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
              ),
              Text(
                '${logic.chooseListCallNumber.value}条',
                style: TextStyle(
                    color: HhColors.gray6TextColor, fontSize: 14.sp*3),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListCallNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        logic.readCall();
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.mainBlueColor,
                            borderRadius: BorderRadius.circular(8.w*3)
                        ),
                        child: Text(
                          '全部已读',
                          style: TextStyle(
                              color: HhColors.whiteColor, fontSize: 14.sp*3),
                        ),
                      ),
                    ),
                    SizedBox(width: 9.w*3,),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.0,
                      onPressed: (){
                        if(logic.chooseListCallNumber.value == 0){
                          EventBusUtil.getInstance().fire(HhToast(title: "请至少选择一条数据"));
                          return;
                        }
                        CommonUtils().showDeleteDialog(logic.context, "确定要删除所选消息记录？", (){
                          Get.back();
                        }, (){
                          logic.deleteCall();
                          Get.back();
                        },(){
                          Get.back();
                        },leftStr: "取消",rightStr: "删除");
                      },
                      child: Container(
                        padding:EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
                        decoration: BoxDecoration(
                            color: HhColors.whiteColor,
                            border: Border.all(color: HhColors.mainBlueColor,width: 2.w),
                            borderRadius: BorderRadius.circular(8.w*3)
                        ),
                        child: Text(
                          '全部删除',
                          style: TextStyle(
                              color: HhColors.mainBlueColor, fontSize: 14.sp*3),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w*3,),
                  ],
                ),
              ),
            ],
          ),
        ):const SizedBox(),
      ],
    );

      /*Container(
        margin: EdgeInsets.only(top: 160.w),
        child: EasyRefresh(
          controller: logic.rightRefreshController,
          onRefresh: (){
            logic.pageNumRight = 1;
            logic.fetchPageRight(1);
          },
          onLoad: (){
            logic.pageNumRight++;
            logic.fetchPageRight(logic.pageNumRight);
            logic.rightRefreshController.finishLoad();

          },
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.zero,
            pagingController: logic.warnController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/no_message.png',info: '暂无消息',mid: 50.w,
                height: 0.32.sw,
                width: 0.6.sw,),
              itemBuilder: (context, item, index) => Container(
                margin: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                padding: EdgeInsets.all(20.w),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: HhColors.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.w))
                ),
                child: Stack(
                  children: [
                    Container(
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
                        "${item['messageType']}",
                        style: TextStyle(
                            color: HhColors.textBlackColor, fontSize: 26.sp,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30.w, 40.w, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "时间:${item['id']}",
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
              ),
            ),
          ),
        ),
      );*/
  }

  void resetEdit() {
    logic.editLeft.value = false;
    logic.editRight.value = false;
  }

  String parseRightType(String s) {
    if(s == "deviceAlarm"){
      return "设备报警通知";
    }
    if(s == "deviceShare"){
      return "设备分享通知";
    }
    return "通知";
  }

  String parseLeftType(String s) {
    for(int i = 0;i < logic.typeList.length;i++){
      dynamic model = logic.typeList[i];
      if(model["alarmType"] == s){
        return model["alarmName"];
      }
    }
    return "报警";
  }

  buildSpaceListView() {
    List<Widget> list = [];
    for(int i = 0; i < logic.spaceList.length; i++){
      dynamic type = logic.spaceList[i];
      list.add(
        InkWell(
          onTap: (){
            logic.spaceSelectIndex.value = i;
          },
          child: Container(
            width: 0.45.sw,
            padding: EdgeInsets.fromLTRB(14.w*3, 15.w, 14.w*3, 15.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(constraints: BoxConstraints(maxWidth: 0.9.sw),child: Text(CommonUtils().parseNameCount('${type["name"]}', 5),style: TextStyle(color: logic.spaceSelectIndex.value == i?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 14.sp*3,overflow: TextOverflow.ellipsis),)),
                SizedBox(width: 10.w,),
                logic.spaceSelectIndex.value == i?Image.asset(
                  "assets/images/common/icon_yes.png",
                  width: 15.w*3,
                  height: 15.w*3,
                  fit: BoxFit.fill,
                ):const SizedBox(),
              ],
            ),
          ),
        )
      );
    }
    return list;
  }

  buildTypeListView() {
    List<Widget> list = [];
    for(int i = 0; i < logic.typeList.length; i++){
      dynamic type = logic.typeList[i];
      list.add(
        InkWell(
          onTap: (){
            logic.typeSelectIndex.value = i;
          },
          child: Container(
            width: 0.45.sw,
            padding: EdgeInsets.fromLTRB(14.w*3, 15.w, 14.w*3, 15.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${type["alarmName"]}',style: TextStyle(color: logic.typeSelectIndex.value == i?HhColors.mainBlueColor:HhColors.blackColor,fontSize: 14.sp*3),),
                SizedBox(width: 10.w,),
                logic.typeSelectIndex.value == i?Image.asset(
                  "assets/images/common/icon_yes.png",
                  width: 15.w*3,
                  height: 15.w*3,
                  fit: BoxFit.fill,
                ):const SizedBox(),
              ],
            ),
          ),
        )
      );
    }
    return list;
  }

  void chooseDate() {
    showModalBottomSheet(context: logic.context, builder: (a){
      bool choose = false;
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.w))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.w,),
            Stack(
              children: [
                Container(margin: EdgeInsets.only(top: 15.w),
                    child: Center(child: Text('选择日期',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),))),
                Align(
                  alignment: Alignment.topRight,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      logic.isChooseDate.value = false;
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20.w, 20.w, 30.w, 20.w),
                      margin: EdgeInsets.only(right: 10.w),
                      child: Image.asset(
                        "assets/images/common/ic_x.png",
                        width: 15.w*3,
                        height: 15.w*3,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: (){
                      logic.dateStr.value="日期";

                      Get.back();
                      logic.isChooseDate.value = false;
                      logic.dateListLeft = [];
                      logic.pageNumLeft = 1;
                      logic.fetchPageLeft(1);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50.w, 20.w, 20.w, 20.w),
                      child: Text('重置',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: RangeDatePicker(
                centerLeadingDate: true,
                minDate: DateTime(2000, 10, 10),
                maxDate: DateTime(2099, 10, 30),
                onRangeSelected: (value) {
                  choose = true;
                  logic.start = value.start;
                  logic.end = value.end;
                  HhLog.d("RangeDatePicker ${value.start.toIso8601String()} , ${value.end.toIso8601String()}");
                },
                slidersColor: HhColors.blackColor,
                leadingDateTextStyle:TextStyle(color: HhColors.blackColor,fontSize: 32.sp,fontWeight: FontWeight.bold),
                splashColor: HhColors.mainBlueColor,
                highlightColor: HhColors.mainBlueColor,
                currentDateTextStyle:TextStyle(color: HhColors.whiteColor,fontSize: 32.sp),
                currentDateDecoration:BoxDecoration(color:HhColors.mainBlueColor.withAlpha(100)),
                disabledCellsTextStyle:TextStyle(color: HhColors.grayEDBackColor,fontSize: 32.sp),
                enabledCellsTextStyle:TextStyle(color: HhColors.gray8TextColor,fontSize: 32.sp),
                selectedCellsTextStyle:TextStyle(color: HhColors.mainBlueColor.withAlpha(100),fontSize: 32.sp),
                selectedCellsDecoration:BoxDecoration(color:HhColors.mainBlueColor.withAlpha(60)),
                singleSelectedCellDecoration:BoxDecoration(color:HhColors.mainBlueColor,borderRadius: BorderRadius.circular(100.w)),
                singleSelectedCellTextStyle: TextStyle(color: HhColors.whiteColor,fontSize: 36.sp),
              ),
            ),
            BouncingWidget(
              duration: const Duration(milliseconds: 100),
              scaleFactor: 1.2,
              child: Container(
                width: 1.sw,
                height: 44.w*3,
                margin: EdgeInsets.fromLTRB(14.w*3, 10.w, 14.w*3, 10.w),
                decoration: BoxDecoration(
                    color: HhColors.mainBlueColor,
                    borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                child: Center(
                  child: Text(
                    "确定",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: HhColors.whiteColor, fontSize: 14.sp*3),
                  ),
                ),
              ),
              onPressed: () {
                if(!choose){
                  EventBusUtil.getInstance().fire(HhToast(title: '请先选择日期'));
                  return;
                }
                logic.dateStr.value = "${logic.start.toIso8601String().substring(0,10)} 00:00:00-${logic.end.toIso8601String().substring(0,10)} 23:59:59";
                Get.back();
                logic.isChooseDate.value = false;
                logic.dateListLeft = [];
                logic.pageNumLeft = 1;
                logic.fetchPageLeft(1);
              },
            )
          ],
        ),
      );
    },isDismissible: false,enableDrag: false);
  }

  String parseCall(item) {
    if(item == "-1"){
      return '呼叫';
    }
    if(item == "0"){
      return '呼入';
    }
    return '';
  }

  void showCallDialog(item) {
    showCupertinoDialog(
        context: logic.context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: 160.w*3,
              width: 1.sw,
              margin: EdgeInsets.fromLTRB(14.w * 3, 0, 14.w * 3, 0),
              decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(12.w * 3)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 15.h*3, 18.w*3, 0),
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset(
                            'assets/images/common/ic_x.png',
                            height: 15.w*3,
                            width: 15.w*3,
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(15.w, 15.h*3, 15.w*3, 0),
                          padding: EdgeInsets.all(5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  parseCall(item['callStatus']),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: HhColors.blackColor, fontSize: 18.sp*3,fontWeight:FontWeight.w600,decoration: TextDecoration.none),
                                ),
                              ),
                              SizedBox(height: 10.w,),
                              Center(
                                child: Text(
                                  "设备名称:${item['name']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3,fontWeight:FontWeight.w500,decoration: TextDecoration.none),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "设备编码:${item['deviceNo']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3,fontWeight:FontWeight.w500,decoration: TextDecoration.none),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "通话时长:${item['callMarket']}秒",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3,fontWeight:FontWeight.w500,decoration: TextDecoration.none),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "呼叫时间:${CommonUtils().parseLongTime('${item['callTime']}')}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: HhColors.blackColor, fontSize: 15.sp*3,fontWeight:FontWeight.w500,decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }
}
