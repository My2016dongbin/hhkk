import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/login/regist/regist_controller.dart';
import 'package:iot/pages/common/web/WebViewPage.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterController>();

  RegisterPage({super.key});

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
      backgroundColor: HhColors.backColorRegister,
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
          ///title
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 54.h*3),
              color: HhColors.trans,
              child: Text(
                '新用户注册',
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
              padding: EdgeInsets.fromLTRB(0, 10.w, 26.w, 10.w),
              color: HhColors.trans,
              child: Image.asset(
                "assets/images/common/back.png",
                height: 17.w*3,
                width: 10.w*3,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 200.h*3,
            decoration: BoxDecoration(color: HhColors.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
            margin: EdgeInsets.fromLTRB(14.w*3, 98.h*3, 14.w*3, 0),
            padding: EdgeInsets.fromLTRB(15.w*3, 0, 15.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 2.h*3,),
                ///账号
                SizedBox(
                  height:45.h*3,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 20,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.accountController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入账号',
                            hintStyle: TextStyle(
                                color: HhColors.grayCCTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          onChanged: (s){
                            logic.accountStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.accountStatus.value? BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.accountController!.clear();
                          logic.accountStatus.value = false;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox()
                    ],
                  ),
                ),
                SizedBox(height: 2.h*3,),
                Container(
                  color: HhColors.grayLineColor,
                  height: 1.h*3,
                ),
                SizedBox(height: 2.h*3,),
                ///密码
                SizedBox(
                  height:45.h*3,
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
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入密码',
                            hintStyle: TextStyle(
                                color: HhColors.grayCCTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.w300),
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
                            child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      SizedBox(width: 10.w,),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.passwordShowStatus.value = !logic.passwordShowStatus.value;
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                            child: Image.asset(logic.passwordShowStatus.value?'assets/images/common/icon_bi.png':'assets/images/common/icon_zheng.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 3.h*3,),
                Container(
                  color: HhColors.grayLineColor,
                  height: 1.h*3,
                ),
                SizedBox(height: 3.h*3,),
                ///手机号
                SizedBox(
                  height:45.h*3,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 11,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.phoneController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入手机号',
                            hintStyle: TextStyle(
                                color: HhColors.grayCCTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          onChanged: (s){
                            logic.phoneStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.phoneStatus.value? BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.phoneController!.clear();
                          logic.phoneStatus.value = false;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: 2.h*3,),
                Container(
                  color: HhColors.grayLineColor,
                  height: 1.h*3,
                ),
                SizedBox(height: 2.h*3,),
                ///验证码
                SizedBox(
                  height: 44.h*3,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          maxLength: 6,
                          cursorColor: HhColors.titleColor_99,
                          controller: logic.codeController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            counterText: '',
                            hintText: '请输入验证码',
                            hintStyle: TextStyle(
                                color: HhColors.grayCCTextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                          ),
                          style:
                          TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                          onChanged: (s){
                            logic.codeStatus.value = s.isNotEmpty;
                          },
                        ),
                      ),
                      logic.codeStatus.value? BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: (){
                          logic.codeController!.clear();
                          logic.codeStatus.value = false;
                        },
                        child: Container(
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                        ),
                      ):const SizedBox(),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          //隐藏输入法
                          FocusScope.of(logic.context).requestFocus(FocusNode());
                          if(logic.phoneController!.text.length<11){
                            EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                            return;
                          }
                          if(logic.time.value!=0){
                            return;
                          }
                          Future.delayed(const Duration(milliseconds: 500),(){
                            logic.sendCode();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                          padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                          child: Center(
                            child: Text(
                              logic.time.value==0?'获取验证码':"${logic.time.value}s后重新发送",
                              style: TextStyle(
                                  color: HhColors.backBlueOutColor,
                                  fontSize: 15.sp*3,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h*3,),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(14.w*3, 313.h*3, 14.w*3, 20.w*3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///协议
                Row(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.confirmStatus.value = !logic.confirmStatus.value;
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 4.w*3),
                          child: Image.asset(logic.confirmStatus.value?'assets/images/common/yes.png':'assets/images/common/no.png',height:12.w*3,width: 12.w*3,fit: BoxFit.fill,)
                      ),
                    ),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: (){
                        logic.confirmStatus.value = !logic.confirmStatus.value;
                      },
                      child: Text('我已阅读并同意',
                        style: TextStyle(color: HhColors.grayBBTextColor,fontSize: 12.sp*3,fontWeight: FontWeight.w500),
                      ),
                    ),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        Get.to(WebViewPage(title: '隐私协议', url: 'http://117.132.5.139:18034/admin-file/iot-test/public/2024/9/24/haohai_iot_privacy_agreement.html',));
                      },
                      child: Text('《卡口App平台隐私政策》',
                        style: TextStyle(color: HhColors.backBlueOutColor,fontSize: 12.sp*3,fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                ///注册
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    if(logic.accountController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '账号不能为空'));
                      return;
                    }
                    if(!CommonUtils().validatePassword(logic.passwordController!.text)){
                      EventBusUtil.getInstance().fire(HhToast(title: '密码必须为8-16位由字母、数字、特殊字符两种以上组成'));
                      return;
                    }
                    if(logic.phoneController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '手机号不能为空'));
                      return;
                    }
                    if(logic.phoneController!.text.length<11){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                      return;
                    }
                    if(logic.codeController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入验证码'));
                      return;
                    }
                    if (!logic.confirmStatus.value) {
                      showAgreeDialog();
                      return;
                    }
                    Future.delayed(const Duration(milliseconds: 500),(){
                      logic.register();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 44.w*3,
                    margin: EdgeInsets.fromLTRB(0, 20.w*3, 0, 50.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        "注册",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: HhColors.whiteColor, fontSize: 16.sp*3,fontWeight: FontWeight.w200),
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


  void showAgreeDialog() {
    showCupertinoDialog(
        context: logic.context,
        builder: (context) => Center(
          child: Container(
            width: 315.w*3,
            height: 162.h*3,
            decoration: BoxDecoration(
                color: HhColors.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30.h*3, 0, 0),
                        child: Text(
                          '欢迎使用浩海通行证！',
                          style: TextStyle(
                              color: HhColors.textBlackColor,
                              fontSize: 16.sp*3,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ))),
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(40.w, 69.h*3, 40.w, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '请您阅读并同意',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: HhColors.grayAATextColor,
                                  fontSize: 13.sp*3,
                                  fontWeight: FontWeight.w500),
                            ),
                            BouncingWidget(
                              duration: const Duration(milliseconds: 100),
                              scaleFactor: 1.2,
                              onPressed: () {
                                Get.to(WebViewPage(title: '隐私协议', url: 'http://117.132.5.139:18034/admin-file/iot-test/public/2024/9/24/haohai_iot_privacy_agreement.html',));
                              },
                              child: Text(
                                '《卡口App平台隐私政策》',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: HhColors.mainBlueColor,
                                    fontSize: 13.sp*3,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ))),
                Align(
                  alignment: Alignment.topRight,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 15.h*3, 23.w*3, 0),
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
                  alignment: Alignment.bottomCenter,
                  child: BouncingWidget(
                    duration: const Duration(milliseconds: 100),
                    scaleFactor: 1.2,
                    onPressed: () {
                      logic.confirmStatus.value = true;
                      Navigator.pop(context);
                      //继续
                      Future.delayed(const Duration(milliseconds: 500),(){
                        logic.register();
                      });
                    },
                    child: Container(
                      width: 275.w*3,
                      height: 44.h*3,
                      margin: EdgeInsets.only(bottom:13.h*3),
                      decoration: BoxDecoration(
                          color: HhColors.backBlueOutColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.w*3))),
                      child: Center(
                        child: Text(
                          "同意并继续",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: HhColors.whiteColor,
                              fontSize: 16.sp*3,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),barrierDismissible: true);
  }

}
