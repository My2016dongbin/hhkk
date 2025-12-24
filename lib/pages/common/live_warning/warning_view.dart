import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'warning_controller.dart';

class LiveWarningPage extends StatelessWidget {
  final logic = Get.find<LiveWarningController>();

  LiveWarningPage({super.key});

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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: CommonUtils().gradientColors3(),
                    stops: const [0,0.1,0.2,1]
                  ),
                ),
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 0.5,
                      onPressed: () async {
                        Get.back();
                      },
                      child: CommonUtils.backView(),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 80.w*3,
                        width: 100.w*3,
                        margin: EdgeInsets.only(top: 45.h*3),
                        padding: EdgeInsets.fromLTRB(0, 10.w, 0, 10.w),
                        color: HhColors.trans,
                        child: Stack(
                          children: [
                            Align(alignment: Alignment.topRight,
                                child: Container(
                                    color: HhColors.trans,
                                    margin: EdgeInsets.fromLTRB(0, 0, 40.w, 0),
                                    child: Text("火险预警",style: TextStyle(color: HhColors.blackColor,fontSize: 18.sp*3,fontWeight: FontWeight.bold),))),
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 42.w*3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 0.5,
                              onPressed: (){
                                showListTypeFilter();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.w*3),
                                color: HhColors.trans,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${parseFireType(logic.fireType.value)}",style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w400),),
                                    SizedBox(width: 3.w*3,),
                                    Image.asset(
                                      "assets/images/common/icon_down_choose.png",
                                      width: 8.w*3,
                                      height: 6.w*3,
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 18.w,),

                            SizedBox(width: 30.w,),
                          ],
                        ),
                      ),
                    ),

                    leftMessage()
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
      margin: EdgeInsets.only(top: 95.w*3),
      child: Column(
        children: [
          ///报警列表
          Expanded(
            child: SmartRefresher(
              controller: logic.refreshController,
              enablePullUp: false,
              onRefresh: (){
                logic.dateList = [];
                logic.pageNum = 1;
                logic.fetchPage(1);
                logic.refreshController.refreshCompleted();
              },
              /*onLoading: (){
                logic.pageNum++;
                logic.fetchPage(logic.pageNum);
                logic.refreshController.loadComplete();
              },*/
              child: PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: logic.deviceController,
                builderDelegate: PagedChildBuilderDelegate<dynamic>(
                  firstPageProgressIndicatorBuilder: (context) => Container(),
                  noItemsFoundIndicatorBuilder: (context) => CommonUtils().noneWidget(image:'assets/images/common/icon_no_message.png',info: '暂无消息',mid: 20.w,
                    height: 0.36.sw,
                    width: 0.44.sw,),
                  itemBuilder: (context, item, index) {
                    /*if(item["showDate"]==null){
                      if(logic.dateList.contains(CommonUtils().parseStringTimeYearDay('${item['createTime']}'))){
                        item["showDate"] = 0;
                      }else{
                        item["showDate"] = 1;
                        logic.dateList.add(CommonUtils().parseStringTimeYearDay('${item['createTime']}'));
                      }
                    }*/
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        item["showDate"]==1?Container(
                          margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 10.w*3),
                          child: Row(
                            children: [
                              Text(
                                today == CommonUtils().parseStringTimeYearDay('${item['createTime']}')?'今天':CommonUtils().parseStringTimeYearDay('${item['createTime']}'),
                                style: TextStyle(
                                    color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10.w,),
                              Expanded(
                                child: Text(
                                  '------------------------------------------------------------------------------',
                                  maxLines: 1,
                                  style: TextStyle(
                                      letterSpacing: 6.w,
                                      color: HhColors.grayD6TextColor, fontSize: 60.sp),
                                ),
                              ),
                            ],
                          ),
                        ):const SizedBox(),
                        InkWell(
                          onTap: (){
                            if(logic.edit.value){
                              item["selected"] == 1?item["selected"]=0:item["selected"]=1;
                              logic.pageStatus.value = false;
                              logic.pageStatus.value = true;
                              if(item["selected"] == 1){
                                if(!logic.chooseList.contains(item["id"])){
                                  logic.chooseList.add(item["id"]);
                                }
                              }else{
                                if(logic.chooseList.contains(item["id"])){
                                  logic.chooseList.remove(item["id"]);
                                }
                              }
                              logic.chooseListNumber.value = logic.chooseList.length;
                              HhLog.d("list -- ${logic.chooseList}");
                            }else{
                              ///根据类型跳转详情
                              HhLog.d("item $item");
                              /*Get.to(()=>WarningInfoPage(),binding: WarningInfoBinding(),arguments: {
                                "info":item,
                              });*/
                            }
                          },
                          child: Row(
                            children: [
                              logic.edit.value?Container(
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
                                  margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 10.w*3),
                                  padding: EdgeInsets.fromLTRB(18.w*3, 13.w*3, 10.w*3, 13.w*3),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      color: HhColors.whiteColor,
                                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 36.w*3,
                                        height: 36.w*3,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              parseIcon(item),
                                              width: 36.w*3,
                                              height: 36.w*3,
                                              fit: BoxFit.fill,
                                            ),
                                            "${item['messageStatus']}" == "null"?const SizedBox():Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 8.w*3,
                                                width: 8.w*3,
                                                decoration: BoxDecoration(
                                                    color: HhColors.circleRedColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(4.w*3))
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(30.w, 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                CommonUtils().parseNull('${item['alarmMessage']}',""),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: HhColors.blackRealColor, fontSize: 15.sp*3,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              SizedBox(height: 5.w*3,),
                                              Text(
                                                CommonUtils().parseStringTimeAll('${item['alarmDatetime']}'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: HhColors.gray9TextColor, fontSize: 14.sp*3),
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
        ],
      ),
    );
  }

  void showListTypeFilter() {
    showCupertinoDialog(context: Get.context!, builder: (BuildContext context) {
      return Obx(() =>GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Material(
          color: HhColors.trans,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 0.7.sw,
                  height: 175.w*3,
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.w*3)
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            height: 30.w*3,
                            width: 1.sw,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(0, 15.w*3, 0, 0),
                            child: Text("预警分类",style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,height: 1.2,fontWeight: FontWeight.bold),)
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 0.5.w,
                              width: 1.sw,
                              margin: EdgeInsets.fromLTRB(15.w*3, 50.w*3, 15.w*3, 0),
                              color: HhColors.grayDDTextColor,
                            ),
                            HhTap(
                              overlayColor: HhColors.grayDDTextColor.withAlpha(80),
                              onTapUp: () async {
                                logic.fireType.value = 0;
                                logic.fetchPage(1);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40.w*3,
                                width: 1.sw,
                                color: HhColors.trans,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 10.w*3, 0, 10.w*3),
                                child: Text("全部",style: TextStyle(color: logic.fireType.value==0?HhColors.blueTextColor:HhColors.blackColor,fontSize: 14.sp*3,height: 1.2),),
                              ),
                            ),
                            Container(
                              height: 0.5.w,
                              width: 1.sw,
                              margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                              color: HhColors.grayDDTextColor,
                            ),
                            HhTap(
                              overlayColor: HhColors.grayDDTextColor.withAlpha(80),
                              onTapUp: () async {
                                logic.fireType.value = 1;
                                logic.fetchPage(1);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40.w*3,
                                width: 1.sw,
                                color: HhColors.trans,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 5.w*3, 0, 10.w*3),
                                child: Text("火险等级",style: TextStyle(color: logic.fireType.value==1?HhColors.blueTextColor:HhColors.blackColor,fontSize: 14.sp*3,height: 1.2),),
                              ),
                            ),
                            Container(
                              height: 0.5.w,
                              width: 1.sw,
                              margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                              color: HhColors.grayDDTextColor,
                            ),
                            HhTap(
                              overlayColor: HhColors.grayDDTextColor.withAlpha(80),
                              onTapUp: () async {
                                logic.fireType.value = 2;
                                logic.fetchPage(1);
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40.w*3,
                                width: 1.sw,
                                color: HhColors.trans,
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 5.w*3, 0, 10.w*3),
                                child: Text("气象",style: TextStyle(color: logic.fireType.value==2?HhColors.blueTextColor:HhColors.blackColor,fontSize: 14.sp*3,height: 1.2),),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.5,
                          onPressed: () async {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 14.w*3, 20.w*3, 0),
                            padding: EdgeInsets.all(10.w),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/icon_up_x.png",
                              width: 12.w*3,
                              height: 12.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    },barrierDismissible: true);
  }

  parseFireType(int fireType) {
    if(fireType==0){
      return "全部";
    }
    if(fireType==1){
      return "火险等级";
    }
    if(fireType==2){
      return "气象";
    }
    return "全部";
  }

  ///消息类型：fire-火警，task-任务，warning-预警
  ///消息子类型（火警：satellite-卫星监测，airPatrol-航空巡护，drone-无人机监测，videoMonitor-视频监控，towerObservation-塔台瞭望，groundPatrol-地面巡护，publicOpinion-舆情监测）、
  ///（任务:task）、（预警-level，气象-）
  String parseIcon(item) {
    String icon = "assets/images/common/icon_camera_space.png";
    return icon;
  }

}
