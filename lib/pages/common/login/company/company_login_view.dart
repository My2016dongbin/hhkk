import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/company_login_controller.dart';
import 'package:iot/pages/common/login/company/forget/company_forget_binding.dart';
import 'package:iot/pages/common/login/company/forget/company_forget_view.dart';
import 'package:iot/pages/common/web/WebViewPage.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class CompanyLoginPage extends StatelessWidget {
  final logic = Get.find<CompanyLoginController>();

  CompanyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.dark, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: HhColors.backColor,
        body: Obx(
          () => Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.zero,
            child: logic.testStatus.value ? loginView() : const SizedBox(),
          ),
        ),
      ),
    );
  }

  loginView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/common/back_login.png',
            width: 1.sw,
            height: 1.sh,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(36.w*3, 135.h*3, 0, 0),
              child: Text(
                '欢迎登录浩海卡口',
                style: TextStyle(
                    color: HhColors.blackColor,
                    fontSize: 20.sp*3,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.fromLTRB(36.w*3, 200.h*3, 36.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ///手机号
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        maxLength: 11,
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.accountController,
                        keyboardType: logic.pageStatus.value
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          counterText: '',
                          hintText:
                              '手机号',
                          hintStyle: TextStyle(
                              color: HhColors.grayCCTextColor,
                              fontSize: 16.sp*3,
                              fontWeight: FontWeight.w200),
                        ),
                        style: TextStyle(
                            color: HhColors.textBlackColor,
                            fontSize: 16.sp*3,
                            fontWeight: FontWeight.bold),
                        onChanged: (s) {
                          logic.accountStatus.value = s.isNotEmpty;
                        },
                      ),
                    ),
                    logic.accountStatus.value
                        ? BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.accountController!.clear();
                              logic.accountStatus.value = false;
                            },
                            child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Image.asset(
                                  'assets/images/common/ic_close.png',
                                  height: 16.w*3,
                                  width: 16.w*3,
                                  fit: BoxFit.fill,
                                )),
                          )
                        : const SizedBox()
                  ],
                ),
                Container(
                  color: HhColors.grayCCTextColor,
                  height: 0.5.w,
                ),
                SizedBox(
                  height: 30.w,
                ),

                ///密码
                logic.pageStatus.value
                    ? const SizedBox()
                    : Row(
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
                                    color: HhColors.grayCCTextColor,
                                    fontSize: 16.sp*3,
                                    fontWeight: FontWeight.w200),
                              ),
                              style: TextStyle(
                                  color: HhColors.textBlackColor,
                                  fontSize: 16.sp*3,
                                  fontWeight: FontWeight.w300),
                              onChanged: (s) {
                                logic.passwordStatus.value = s.isNotEmpty;
                              },
                            ),
                          ),
                          logic.passwordStatus.value
                              ? BouncingWidget(
                                  duration: const Duration(milliseconds: 100),
                                  scaleFactor: 1.2,
                                  onPressed: () {
                                    logic.passwordController!.clear();
                                    logic.passwordStatus.value = false;
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5.w),
                                      child: Image.asset(
                                        'assets/images/common/ic_close.png',
                                        height: 16.w*3,
                                        width: 16.w*3,
                                        fit: BoxFit.fill,
                                      )),
                                )
                              : const SizedBox(),
                          SizedBox(
                            width: 7.w*3,
                          ),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              logic.passwordShowStatus.value =
                                  !logic.passwordShowStatus.value;
                            },
                            child: Container(
                                padding: EdgeInsets.all(5.w),
                                child: Image.asset(
                                  logic.passwordShowStatus.value
                                      ? 'assets/images/common/icon_bi.png'
                                      : 'assets/images/common/icon_zheng.png',
                                  height: 16.w*3,
                                  width: 16.w*3,
                                  fit: BoxFit.fill,
                                )),
                          )
                        ],
                      ),
                logic.pageStatus.value
                    ? const SizedBox()
                    : Container(
                        color: HhColors.grayCCTextColor,
                        height: 0.5.w,
                      ),
                SizedBox(
                  height: 22.h*3,
                ),

                ///协议
                Row(
                  children: [
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        logic.confirmStatus.value = !logic.confirmStatus.value;
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.w),
                          child: Image.asset(
                            logic.confirmStatus.value
                                ? 'assets/images/common/yes.png'
                                : 'assets/images/common/no.png',
                            height: 12.w*3,
                            width: 12.w*3,
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizedBox(width: 2.w*3,),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        logic.confirmStatus.value = !logic.confirmStatus.value;
                      },
                      child: Text(
                        '我已阅读并同意',
                        style: TextStyle(
                            color: HhColors.grayBBTextColor,
                            fontSize: 12.sp*3,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    BouncingWidget(
                      duration: const Duration(milliseconds: 100),
                      scaleFactor: 1.2,
                      onPressed: () {
                        Get.to(WebViewPage(title: '隐私协议', url: CommonData.html));
                      },
                      child: Text(
                        '《浩海卡口平台隐私政策》',
                        style: TextStyle(
                            color: HhColors.backBlueOutColor,
                            fontSize: 12.sp*3,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),

                ///登录
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());

                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (logic.pageStatus.value) {
                        ///验证码点击
                        codeClick();
                      } else {
                        ///登录点击
                        loginClick();
                      }
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48.w*3,
                    margin: EdgeInsets.fromLTRB(0, 16.w*3, 0, 0),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        logic.pageStatus.value ? "获取验证码" : "登录",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 16.sp*3,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ),

                /*///切换
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: () {
                    logic.pageStatus.value = !logic.pageStatus.value;
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());
                    logic.accountController!.text = '';
                    if (!logic.pageStatus.value) {
                      logic.accountController!.text = logic.account!;
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 5.w, 0, 0),
                      padding: EdgeInsets.all(5.w),
                      color: HhColors.trans,
                      child: Text(
                        logic.pageStatus.value ? '密码登录' : '验证码登录',
                        style: TextStyle(
                          color: HhColors.gray9TextColor,
                          fontSize: 26.sp,
                        ),
                      )),
                ),
                SizedBox(
                  height: 30.w,
                ),*/

                ///忘记密码
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    Get.to(()=>CompanyForgetPage(),binding: CompanyForgetBinding());
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20.w*3, 0, 0),
                      padding: EdgeInsets.all(5.w),
                      color: HhColors.trans,
                      child: Text('忘记密码',style: TextStyle(color: HhColors.gray9TextColor,fontSize: 14.sp*3,),)
                  ),
                ),
                SizedBox(height: 30.w,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int timeForExit = 0;

  //复写返回监听
  Future<bool> onBackPressed() {
    bool exit = false;
    int time_ = DateTime.now().millisecondsSinceEpoch;
    if (time_ - timeForExit > 2000) {
      EventBusUtil.getInstance().fire(HhToast(title: '再按一次退出程序'));
      timeForExit = time_;
      exit = false;
    } else {
      exit = true;
    }
    return Future.value(exit);
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
                                Get.to(WebViewPage(title: '隐私协议', url: CommonData.html));
                              },
                              child: Text(
                                '《浩海卡口平台隐私政策》',
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
                      if (logic.pageStatus.value) {
                        ///验证码点击
                        codeClick();
                      } else {
                        ///登录点击
                        loginClick();
                      }
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

  void loginClick() {
    if (logic.accountController!.text.isEmpty) {
      EventBusUtil.getInstance().fire(HhToast(title: '账号不能为空'));
      return;
    }
    if(logic.passwordController!.text.isEmpty){
      EventBusUtil.getInstance().fire(HhToast(title: '密码不能为空'));
      return;
    }
    // if(!CommonUtils().validatePassword(logic.passwordController!.text)){
    //   EventBusUtil.getInstance().fire(HhToast(title: '密码必须为8-16位由字母、数字、特殊字符两种以上组成'));
    //   return;
    // }
    if (!logic.confirmStatus.value) {
      // EventBusUtil.getInstance().fire(HhToast(title: '请阅读并同意隐私协议'));
      showAgreeDialog();
      return;
    }
    logic.searchTenant();
  }

  void codeClick() {
    if (logic.accountController!.text.isEmpty) {
      EventBusUtil.getInstance().fire(HhToast(title: '手机号不能为空'));
      return;
    }
    if (logic.accountController!.text.length < 11) {
      EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
      return;
    }
    if (!logic.confirmStatus.value) {
      // EventBusUtil.getInstance().fire(HhToast(title: '请阅读并同意隐私协议'));
      showAgreeDialog();
      return;
    }
    logic.getTenantId();
  }
}
