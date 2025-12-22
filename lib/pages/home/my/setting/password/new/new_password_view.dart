import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/my/setting/password/new/new_password_controller.dart';
import 'package:iot/pages/home/my/setting/password/password_controller.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class NewPasswordPage extends StatelessWidget {
  final logic = Get.find<NewPasswordController>();

  NewPasswordPage({super.key,required String keys,required String titles}){
    logic.keys = keys;
    logic.titles.value = titles;
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
    return SingleChildScrollView(
      child: Stack(
        children: [
          ///title
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 54.w*3),
              color: HhColors.trans,
              child: Text(
                logic.titles.value,
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

          Container(
            margin: EdgeInsets.fromLTRB(14.w*3, 108.w*3, 14.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(9.w*3, 0, 9.w*3, 0),
                  color: HhColors.trans,
                  child: Text(
                    "8-16位由字母、数字、特殊字符两种以上组成",
                    style: TextStyle(
                        color: HhColors.gray6TextColor,
                        fontSize: 14.sp*3,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16.w*3, 0, 0),
                  decoration: BoxDecoration(
                      color: HhColors.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///修改内容
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              maxLength: 11,
                              cursorColor: HhColors.titleColor_99,
                              controller: logic.passwordController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(15.w*3, 15.w*3, 15.w*3, 15.w*3),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                counterText: '',
                                hintText: '手机号',
                                hintStyle: TextStyle(
                                    color: HhColors.gray9TextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                              ),
                              style:
                              TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                              onChanged: (s){
                                logic.passwordStatus.value = s.isNotEmpty;
                              },
                            ),
                          ),
                          SizedBox(width: 15.w*3,),
                        ],
                      ),
                      Container(
                        color: HhColors.grayCCTextColor,
                        height: 0.5.w,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              maxLength: 6,
                              cursorColor: HhColors.titleColor_99,
                              controller: logic.passwordNew1Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.w*3),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                counterText: '',
                                hintText: '验证码',
                                hintStyle: TextStyle(
                                    color: HhColors.gray9TextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                              ),
                              style:
                              TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.bold),
                              onChanged: (s){
                                logic.passwordNew1Status.value = s.isNotEmpty;
                              },
                            ),
                          ),
                          logic.passwordNew1Status.value? BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: (){
                              logic.passwordNew1Controller!.clear();
                              logic.passwordNew1Status.value = false;
                            },
                            child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                            ),
                          ):const SizedBox(),
                          SizedBox(width: 20.w,),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              //隐藏输入法
                              FocusScope.of(logic.context).requestFocus(FocusNode());
                              if(logic.passwordController!.text.length<11){
                                EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                                return;
                              }
                              if(logic.passwordController!.text != logic.mobile.value){
                                EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的安全手机号'));
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
                          SizedBox(width: 15.w*3,),
                        ],
                      ),
                      Container(
                        color: HhColors.grayCCTextColor,
                        height: 0.5.w,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              maxLength: 30,
                              cursorColor: HhColors.titleColor_99,
                              controller: logic.passwordNew2Controller,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !logic.passwordShowNew2Status.value,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15.w*3),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                counterText: '',
                                hintText: '请输入新密码',
                                hintStyle: TextStyle(
                                    color: HhColors.gray9TextColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                              ),
                              style:
                              TextStyle(color: HhColors.textBlackColor, fontSize: 15.sp*3,fontWeight: FontWeight.w200),
                              onChanged: (s){
                                logic.passwordNew2Status.value = s.isNotEmpty;
                              },
                            ),
                          ),
                          logic.passwordNew2Status.value? BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: (){
                              logic.passwordNew2Controller!.clear();
                              logic.passwordNew2Status.value = false;
                            },
                            child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Image.asset('assets/images/common/ic_close.png',height:16.w*3,width: 16.w*3,fit: BoxFit.fill,)
                            ),
                          ):const SizedBox(),
                          SizedBox(width: 20.w,),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.passwordShowNew2Status.value =
                              !logic.passwordShowNew2Status.value;
                            },
                            child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Image.asset(
                                  logic.passwordShowNew2Status.value
                                      ? 'assets/images/common/icon_bi.png'
                                      : 'assets/images/common/icon_zheng.png',
                                  height: 16.w*3,
                                  width: 16.w*3,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(width: 15.w*3,),
                        ],
                      ),
                    ],
                  ),
                ),
                ///保存
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    if(logic.passwordController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入手机号'));
                      return;
                    }
                    if(logic.passwordController!.text != logic.mobile.value){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的安全手机号'));
                      return;
                    }
                    if(logic.passwordNew1Controller!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入验证码'));
                      return;
                    }
                    if(logic.passwordNew2Controller!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入新密码'));
                      return;
                    }
                    if(!CommonUtils().validatePassword(logic.passwordNew2Controller!.text)){
                      EventBusUtil.getInstance().fire(HhToast(title: '密码必须为8-16位由字母、数字、特殊字符两种以上组成'));
                      return;
                    }
                    logic.judgeCode();
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
                        "确认修改",
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

}
