import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/live_warning/info/info_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/MediaPreview.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WarningInfoPage extends StatelessWidget {
  final logic = Get.find<WarningInfoController>();

  WarningInfoPage({super.key});

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
          child: logic.testStatus.value ? infoPage() : const SizedBox(),
        ),
      ),
    );
  }

  infoPage() {
    return Stack(
      children: [
        ///背景-渐变色
        Image.asset(
          "assets/images/common/iot/main_background.png",
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),

        ///title
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 47.w*3),
            color: HhColors.trans,
            child: Text(
              '预警详情',
              style: TextStyle(
                  color: HhColors.blackTextColor,
                  fontSize: 18.sp*3,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () async {
            Get.back();
          },
          child: CommonUtils.backView(),
        ),

        ///菜单
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HhColors.trans,
              borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
          margin: EdgeInsets.only(top:95.w*3),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(14.w*3, 0, 14.w*3, 80.w*3),
                child: SmartRefresher(
                  controller: logic.refreshController,
                  enablePullUp: false,
                  onRefresh: (){
                    //logic.getDetail();
                    logic.refreshController.refreshCompleted();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///任务信息
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///类型
                              SizedBox(
                                height: 50.w*3,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.w*3),
                                        child: Text(
                                          "类型",
                                          style: TextStyle(
                                              color: HhColors.textBlackColor,
                                              fontSize: 15.sp*3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(100.w*3, 0, 15.w*3, 0),
                                        child: Text(
                                          parseType("${logic.detail["alarmMajor"]}"),
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 0.5.w,
                                          width: 1.sw,
                                          margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                                          color: HhColors.grayDDTextColor,
                                        ))
                                  ],
                                ),
                              ),
                              ///内容
                              Container(
                                margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10.w*3),
                                      child: Text(
                                        "内容",
                                        style: TextStyle(
                                            color: HhColors.textBlackColor,
                                            fontSize: 15.sp*3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5.w*3),
                                      child: Text(
                                        CommonUtils().parseNull("${logic.detail["alarmMessage"]}", ""),
                                        style: TextStyle(
                                            color: HhColors.gray9TextColor,
                                            fontSize: 14.sp*3,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      height: 0.5.w,
                                      width: 1.sw,
                                      margin: EdgeInsets.only(top: 10.w*3),
                                      color: HhColors.grayDDTextColor,
                                    )
                                  ],
                                ),
                              ),
                              ///报警时间
                              SizedBox(
                                height: 50.w*3,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.w*3),
                                        child: Text(
                                          "报警时间",
                                          style: TextStyle(
                                              color: HhColors.textBlackColor,
                                              fontSize: 15.sp*3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(100.w*3, 0, 15.w*3, 0),
                                        child: Text(
                                          CommonUtils().parseNull("${logic.detail["alarmDatetime"]}", ""),
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 0.5.w,
                                          width: 1.sw,
                                          margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                                          color: HhColors.grayDDTextColor,
                                        ))
                                  ],
                                ),
                              ),
                              ///经纬度
                              SizedBox(
                                height: 50.w*3,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15.w*3),
                                        child: Text(
                                          "经纬度",
                                          style: TextStyle(
                                              color: HhColors.textBlackColor,
                                              fontSize: 15.sp*3,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(100.w*3, 0, 15.w*3, 0),
                                        child: Text(
                                          CommonUtils().parseNullExpect("${logic.detail["alarmAddress"]}", ""),
                                          style: TextStyle(
                                              color: HhColors.gray9TextColor,
                                              fontSize: 15.sp*3),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 0.5.w,
                                          width: 1.sw,
                                          margin: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
                                          color: HhColors.grayDDTextColor,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.w*3)
                      ],
                    ),
                  ),
                ),
              ),
              ///按钮
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 80.w*3,
                  width: 1.sw,
                  padding: EdgeInsets.only(bottom: 10.w*3),
                  color: HhColors.whiteColor,
                  child: Row(
                    children: [
                      SizedBox(width: 10.w*3,),
                      Expanded(
                        child: BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 0.5,
                          onPressed: () async {
                            Get.back();
                          },
                          child: Container(
                              height: 45.w*3,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: HhColors.blueTextColor,
                              borderRadius: BorderRadius.circular(8.w*3),
                            ),
                              child: Text('确定',style: TextStyle(
                                  color: HhColors.whiteColor,
                                  fontSize: 16.sp*3,
                                  fontWeight: FontWeight.w400
                              ),)
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w*3,),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CommonUtils.line(color: HhColors.grayLineColor2,marginBottom: 80.w*3,height: 3.w),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? imageVideoBuilder(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        if(logic.imageVideos[index].endsWith("mp4")){
          ///视频
          EventBusUtil.getInstance().fire(HhLoading(show: true));
          CommonUtils().showVideoFileDialog(Get.context!, url:"${CommonData.endpoint}${logic.imageVideos[index]}");
        }else{
          ///图片
          CommonUtils().showPictureDialog(Get.context!,url: "${CommonData.endpoint}${logic.imageVideos[index]}");
        }
      },
      child: Container(
        width: 110.w*3,
        height: 110.w*3,
        margin: EdgeInsets.fromLTRB(0, 10.w*3, 10.w*3, 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w*3)
        ),
        child: Stack(
          children: [
            logic.imageVideos[index].endsWith("mp4")?MediaPreview(
              url: "${CommonData.endpoint}${logic.imageVideos[index]}",
              width: 110.w * 3,
              height: 110.w * 3,
              isVideo: true,
            ):Image.network(
              "${CommonData.endpoint}${logic.imageVideos[index]}",
              width: 110.w*3,
              height: 110.w*3,
              fit: BoxFit.fill,
              errorBuilder: (c, o, s) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w * 3)),
                  child: Image.asset(
                    "assets/images/common/ic_message_no.png",
                    width: 110.w*3,
                    height: 110.w*3,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            logic.imageVideos[index].endsWith("mp4")
                ?Align(alignment: Alignment.center,child: Icon(Icons.play_circle,size: 26.w*3,color: HhColors.gray9TextColor,))
                :const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget? uploadImageVideoBuilder(BuildContext context, int index) {
    return InkWell(
      onTap: (){
        if(logic.uploadImageVideos[index].endsWith("mp4")){
          ///视频
          EventBusUtil.getInstance().fire(HhLoading(show: true));
          CommonUtils().showVideoFileDialog(Get.context!, url:"${CommonData.endpoint}${logic.uploadImageVideos[index]}");
        }else{
          ///图片
          CommonUtils().showPictureDialog(Get.context!,url: "${CommonData.endpoint}${logic.uploadImageVideos[index]}");
        }
      },
      child: Container(
        width: 110.w*3,
        height: 110.w*3,
        margin: EdgeInsets.fromLTRB(0, 10.w*3, 10.w*3, 0),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w*3)
        ),
        child: Stack(
          children: [
            logic.uploadImageVideos[index].endsWith("mp4")?MediaPreview(
              url: "${CommonData.endpoint}${logic.uploadImageVideos[index]}",
              width: 110.w * 3,
              height: 110.w * 3,
              isVideo: true,
            ):Image.network(
              "${CommonData.endpoint}${logic.uploadImageVideos[index]}",
              width: 110.w*3,
              height: 110.w*3,
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w * 3)),
                  child: Image.asset(
                    "assets/images/common/ic_message_no.png",
                    width: 110.w*3,
                    height: 110.w*3,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            logic.uploadImageVideos[index].endsWith("mp4")
                ?Align(alignment: Alignment.center,child: Icon(Icons.play_circle,size: 26.w*3,color: HhColors.gray9TextColor,))
                :const SizedBox()
          ],
        ),
      ),
    );
  }

  String parseAlarmType(String str) {
    String type = CommonUtils().parseNull(str, "");
    if(str == "firePointMonitor"){
      type = "火点监测";
    }
    if(str == "fireworkDetection"){
      type = "烟火识别";
    }
    if(str == "thermalImagery"){
      type = "热成像";
    }
    if(str == "artificial"){
      type = "人工上报";
    }
    if(str == "publicOpinion"){
      type = "舆情分析";
    }
    return type;
  }

  String parseTaskStatus(String str) {
    String status = '';
    if(str == "1"){
      status = "进行中";
    }
    if(str == "2"){
      status = "已结束";
    }
    return status;
  }
  String parseTaskStatusBtn(String str) {
    String status = '开始任务';
    if(str == "1"){
      status = "结束任务";
    }
    if(str == "2"){
      status = "已结束";
    }
    return status;
  }

  String parseType(String code) {
    String type = '';
    if(code == "FireRiskLevel"){
      type = "火险等级预警";
    }
    if(code == "Meteorology"){
      type = "气象预警";
    }
    return type;
  }
}
