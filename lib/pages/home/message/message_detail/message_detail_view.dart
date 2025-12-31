import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/home/cell/HhTap.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/widgets/pop_menu.dart';
import 'message_detail_controller.dart';

class MessageDetailPage extends StatelessWidget {
  final logic = Get.find<MessageDetailController>();

  MessageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: logic.testStatus.value ? modelPage(context) : const SizedBox(),
        ),
      ),
    );
  }

  modelPage(context) {
    return Stack(
      children: [
        ///背景-渐变色
        Image.asset(
          "assets/images/common/main_background.png",
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),

        ///title
        BouncingWidget(
          duration: const Duration(milliseconds: 100),
          scaleFactor: 0.5,
          onPressed: () async {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(top: 30.w*3),
            padding: EdgeInsets.all(20.w*3),
            color: HhColors.trans,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/common/icon_back_left.png",
                  width: 9.w*3,
                  height: 16.w*3,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 12.w*3,),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 42.w*3),
            child: Text('报警详情',style: TextStyle(
                color: HhColors.blackTextColor,
                fontSize: 18.sp*3,
                fontWeight: FontWeight.w600
            ),),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: HhTap(
            overlayColor: HhColors.trans,
            onTapUp: (){

            },
            child: Container(
              height: 28.w*3,
              width: 50.w*3,
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 43.w*3, 15.w*3, 0),
              decoration: BoxDecoration(
                color: HhColors.mainBlueColor,
                borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
              ),
              child: Text('导航',style: TextStyle(
                  color: HhColors.whiteColor,
                  fontSize: 14.sp*3,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
        ),

        ///菜单
        Container(
          margin: EdgeInsets.fromLTRB(14.w*3, 85.w*3, 14.w*3, 20.w*3),
          child: EasyRefresh(
            onRefresh: (){
              logic.getWarnType();
              logic.getLiveWarningInfo(logic.id);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///报警时间
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                    child: Row(
                      children: [
                        Text('报警时间',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                        SizedBox(width: 10.w*3,),
                        Expanded(child: Text(CommonUtils().parseLongTime('${logic.fireInfo["alarmTimestamp"]}'),textAlign:TextAlign.end,style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),)),
                      ],
                    ),
                  ),
                  ///报警类型
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                    child: Row(
                      children: [
                        Text('报警类型',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                        SizedBox(width: 10.w*3,),
                        Expanded(child: Text(parseAlarmType("${logic.fireInfo["alarmType"]}"),textAlign:TextAlign.end,style: TextStyle(color: HhColors.mainBlueColor,fontSize: 14.sp*3),)),
                      ],
                    ),
                  ),
                  ///报警经纬度
                  Container(
                    margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                    child: Row(
                      children: [
                        Text('报警经纬度',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                        SizedBox(width: 10.w*3,),
                        Expanded(child: Text("${CommonUtils().parseNull('${logic.fireInfo["longitude"]}', "")},${CommonUtils().parseNull('${logic.fireInfo["latitude"]}', "")}",textAlign:TextAlign.end,style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),)),
                      ],
                    ),
                  ),
                  ///详细地址
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('详细地址',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                        SizedBox(height: 5.w*3,),
                        Text(CommonUtils().parseNull('${logic.fireInfo["location"]}', ""),style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3),),
                      ],
                    ),
                  ),
                  ///报警图片
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(20.w*3, 10.w*3, 20.w*3, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('报警图片',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3),),
                        SizedBox(height: 10.w*3,),
                        HhTap(
                          overlayColor: HhColors.trans,
                          onTapUp: (){
                            CommonUtils().showPictureDialog(Get.context, url:"${CommonData.endpoint}${logic.fireInfo['alarmImageUrl']}");
                          },
                          child: Image.network(
                            "${CommonData.endpoint}${logic.fireInfo["alarmImageUrl"]}",
                            width: 50.w*3,
                            height: 50.w*3,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context,Object exception,StackTrace? stackTrace){
                              return Image.asset(
                                "assets/images/common/icon_no_picture_big.png",
                                width: 1.sw,
                                height: 0.45.sw,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  ///按钮
                  Container(
                    height: 32.w*3,
                    width: 1.sw,
                    margin: EdgeInsets.fromLTRB(20.w*3, 20.w*3, 20.w*3, 0),
                    child: Row(
                      children: [
                        ///视频
                        Expanded(
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: (){
                              CommonUtils().parseRouteDetail(logic.fireInfo);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                              ),
                              child: Text('视频',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w*3,),
                        ///auditStatus处理状态 1已处理 0未处理   ///auditResult处理结果 1真实 0误报
                        "${logic.fireInfo["auditStatus"]}" == "1"?Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                              border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                            ),
                            child: Text("${logic.fireInfo["auditResult"]}" == "1"?'真实':"误报",style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                          ),
                        ):Expanded(
                          child: GestureDetector(
                            onTapDown: (details) {
                              HhActionMenu.show(
                                context: context,
                                offset: details.globalPosition,
                                direction: HhMenuDirection.top,
                                itemDirection: HhItemDirection.vertical,
                                //backgroundImage: 'assets/images/common/icon_pop_background.png',
                                dx: 50.w*3,
                                items: [
                                  BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
                                    scaleFactor: 1.2,
                                    onPressed: (){
                                      HhActionMenu.dismiss();
                                      logic.alarmHandle("${logic.fireInfo["id"]}", "1");
                                    },
                                    child: Container(
                                      color:HhColors.trans,
                                      padding: EdgeInsets.fromLTRB(35.w*3, 10.w*3, 35.w*3, 10.w*3),
                                      child: Text('真实', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                    ),
                                  ),
                                  BouncingWidget(
                                    duration: const Duration(milliseconds: 100),
                                    scaleFactor: 1.2,
                                    onPressed: (){
                                      HhActionMenu.dismiss();
                                      logic.alarmHandle("${logic.fireInfo["id"]}", "0");
                                    },
                                    child: Container(
                                      color:HhColors.trans,
                                      padding: EdgeInsets.fromLTRB(35.w*3, 10.w*3, 35.w*3, 10.w*3),
                                      child: Text('误报', style: TextStyle(color: HhColors.blackColor,fontSize: 15.sp*3,fontWeight: FontWeight.w200),),
                                    ),
                                  )
                                ],
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                              ),
                              child: Text('处理',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w*3,),
                        ///定位
                        Expanded(
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: (){

                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HhColors.whiteColor,
                                borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                                border: Border.all(color: HhColors.grayEEBackColor,width: 3.w),
                              ),
                              child: Text('定位',style: TextStyle(color: HhColors.blackColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w*3,),
                        ///导航
                        Expanded(
                          child: HhTap(
                            overlayColor: HhColors.trans,
                            onTapUp: (){

                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: HhColors.mainBlueColor,
                                borderRadius: BorderRadius.all(Radius.circular(4.w*3)),
                              ),
                              child: Text('导航',style: TextStyle(color: HhColors.whiteColor,fontSize: 14.sp*3,fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String parseAlarmType(String s) {
    for(int i = 0;i < logic.typeList.length;i++){
      dynamic model = logic.typeList[i];
      if(model["alarmType"] == s){
        return model["alarmName"];
      }
    }
    return "报警";
  }

}
