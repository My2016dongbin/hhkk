import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/personal/forget/password/personal_password_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class PersonalPasswordPage extends StatelessWidget {
  final logic = Get.find<PersonalPasswordController>();

  PersonalPasswordPage({super.key});

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
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset('assets/images/common/icon_bg.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(36.w*3, 135.h*3, 0, 0),
              child: Text('设置新密码',style: TextStyle(color: HhColors.textBlackColor,fontSize: 20.sp*3,fontWeight: FontWeight.bold),)
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
                "assets/images/common/back_white.png",
                height: 17.w*3,
                width: 10.w*3,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(36.w*3, 191.h*3, 36.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///新密码
                Container(
                  height: 48.h*3,
                  decoration: BoxDecoration(
                      color: HhColors.mainGrayColorTrans,
                      borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 20,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !logic.passwordShowStatus.value,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.w*3, 0, 0, 0),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入新密码',
                            hintStyle: TextStyle(
                                color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w300),
                          onChanged: (s){
                            logic.passwordStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.passwordStatus.value?
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.passwordController!.clear();
                          logic.passwordStatus.value = false;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close_white.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      SizedBox(width: 5.w*3,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.passwordShowStatus.value = !logic.passwordShowStatus.value;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset(logic.passwordShowStatus.value?'assets/images/common/icon_bi_white.png':'assets/images/common/icon_zheng_white.png',height:17.w*3,width: 17.w*3,fit: BoxFit.fill,)
                        ),
                      ),
                      SizedBox(width: 18.w*3,),
                    ],
                  ),
                ),
                SizedBox(height: 36.w,),
                ///再次输入新密码
                Container(
                  height: 48.h*3,
                  decoration: BoxDecoration(
                      color: HhColors.mainGrayColorTrans,
                      borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 20,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.password2Controller,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !logic.password2ShowStatus.value,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.w*3, 0, 0, 0),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请再次输入新密码',
                            hintStyle: TextStyle(
                                color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w300),
                          onChanged: (s){
                            logic.password2Status.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.password2Status.value?
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.password2Controller!.clear();
                          logic.password2Status.value = false;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close_white.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      SizedBox(width: 5.w*3,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.password2ShowStatus.value = !logic.password2ShowStatus.value;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset(logic.password2ShowStatus.value?'assets/images/common/icon_bi_white.png':'assets/images/common/icon_zheng_white.png',height:17.w*3,width: 17.w*3,fit: BoxFit.fill,)
                        ),
                      ),
                      SizedBox(width: 18.w*3,),
                    ],
                  ),
                ),
                SizedBox(height: 10.w,),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(0, 16.h*3, 0, 0),
                  padding: EdgeInsets.fromLTRB(16.w*3, 14.w*3, 16.w*3, 14.w*3),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColorTrans,
                    borderRadius: BorderRadius.circular(16.w)
                  ),
                  child: Text(
                    "8-16位由字母、数字、特殊字符两种以上组成（例如：haohai123)",
                    style: TextStyle(
                      color: HhColors.textBlackColor,
                      fontSize: 14.sp*3
                    ),
                  ),
                ),
                SizedBox(height: 20.w,),
                ///提交
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    if(!CommonUtils().validatePassword(logic.passwordController!.text)){
                      EventBusUtil.getInstance().fire(HhToast(title: '密码必须为8-16位由字母、数字、特殊字符两种以上组成'));
                      return;
                    }
                    if(logic.passwordController!.text != logic.password2Controller!.text){
                      EventBusUtil.getInstance().fire(HhToast(title: '两次密码输入不一致'));
                      return;
                    }
                    Future.delayed(const Duration(milliseconds: 500),(){
                      logic.submit();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48.w*3,
                    margin: EdgeInsets.fromLTRB(0, 25.w*3, 0, 20.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColorTrans,
                        borderRadius: BorderRadius.all(Radius.circular(24.w*3))),
                    child: Center(
                      child: Text(
                        "提交",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.whiteColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showWebDialog() {
    showCupertinoDialog(context: logic.context, builder: (context) => Center(
      child: Container(
        width: 1.sw,
        height: 360.w,
        margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
        padding: EdgeInsets.fromLTRB(30.w, 25.w, 30.w, 25.w),
        decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(CommonData.info,
                style: TextStyle(color: HhColors.textColor,fontSize: 21.sp),
              ),
            ],
          ),
        ),
      ),
    ));
  }

}
