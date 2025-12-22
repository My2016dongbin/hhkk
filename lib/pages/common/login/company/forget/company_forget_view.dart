import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/pages/common/login/company/forget/company_forget_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';

class CompanyForgetPage extends StatelessWidget {
  final logic = Get.find<CompanyForgetController>();

  CompanyForgetPage({super.key});

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
          Image.asset('assets/images/common/back_login.png',width:1.sw,height: 1.sh,fit: BoxFit.fill,),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.fromLTRB(36.w*3, 135.h*3, 36.w*3, 0),
              child: Text('忘记密码',style: TextStyle(color: HhColors.textBlackColor,fontSize: 20.sp*3,fontWeight: FontWeight.bold),)
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
              padding: EdgeInsets.all(10.w),
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
            margin: EdgeInsets.fromLTRB(36.w*3, 212.h*3, 36.w*3, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///账号
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        maxLength: 11,
                        cursorColor: HhColors.titleColor_99,
                        controller: logic.accountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          counterText: '',
                          hintText:
                          '请输入手机号码',
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
                SizedBox(height: 30.w*3,),
                ///获取验证码
                BouncingWidget(
                  duration: const Duration(milliseconds: 100),
                  scaleFactor: 1.2,
                  onPressed: (){
                    //隐藏输入法
                    FocusScope.of(logic.context).requestFocus(FocusNode());

                    ///验证码点击
                    if(logic.accountController!.text.isEmpty){
                      EventBusUtil.getInstance().fire(HhToast(title: '手机号不能为空'));
                      return;
                    }
                    if(logic.accountController!.text.length<11){
                      EventBusUtil.getInstance().fire(HhToast(title: '请输入正确的手机号'));
                      return;
                    }
                    Future.delayed(const Duration(milliseconds: 500),(){
                      logic.searchTenant();
                    });
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48.w*3,
                    margin: EdgeInsets.fromLTRB(0, 26.w, 0, 20.w),
                    decoration: BoxDecoration(
                        color: HhColors.mainBlueColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.w*3))),
                    child: Center(
                      child: Text(
                        "获取验证码",
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
