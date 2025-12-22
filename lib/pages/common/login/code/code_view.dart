import 'dart:ui';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/login/code/code_controller.dart';
import 'package:iot/pages/home/home_binding.dart';
import 'package:iot/pages/home/home_view.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class CodePage extends StatelessWidget {
  final logic = Get.find<CodeController>();

  CodePage(String mobile, {super.key}){
    logic.mobile = mobile;
  }

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
        () => Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.zero,
          child: logic.testStatus.value ? codeView() : const SizedBox(),
        ),
      ),
    );
  }

  codeView() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/common/back_login.png',
          width: 1.sw,
          height: 1.sh,
          fit: BoxFit.fill,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(0.04.sw, 0.06.sh, 0, 0),
                  padding: EdgeInsets.all(20.w),
                  color: HhColors.trans,
                  child: Image.asset(
                    'assets/images/common/back.png',
                    height: 17.w*3,
                    width: 10.w*3,
                    fit: BoxFit.fill,
                  )),
            )),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh, 0, 0),
            child: Text(
              '请输入验证码',
              style: TextStyle(
                  color: HhColors.blackColor,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh + 66.w, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '已发送验证码至',
                    style: TextStyle(
                      color: HhColors.gray6TextColor,
                      fontSize: 23.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    CommonUtils().mobileString(logic.mobile),
                    style: TextStyle(
                      color: HhColors.gray6TextColor,
                      fontSize: 23.sp,
                    ),
                  ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh + 110.w, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '如未收到，请',
                    style: TextStyle(
                      color: HhColors.gray6TextColor,
                      fontSize: 23.sp,
                    ),
                  ),
                  logic.time.value == 0
                      ? const SizedBox()
                      : Text(
                          '${logic.time.value}s',
                          style: TextStyle(
                            color: HhColors.titleColorRed,
                            fontSize: 23.sp,
                          ),
                        ),
                  logic.time.value == 0
                      ? BouncingWidget(
                          duration: const Duration(milliseconds: 100),
                          scaleFactor: 1.2,
                          onPressed: () {
                            logic.sendCode();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10.w, 3.w, 10.w, 3.w),
                            child: Text(
                              '重新获取',
                              style: TextStyle(
                                color: HhColors.mainBlueColor,
                                fontSize: 23.sp,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          '后获取',
                          style: TextStyle(
                            color: HhColors.gray6TextColor,
                            fontSize: 23.sp,
                          ),
                        ),
                ],
              )),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.fromLTRB(0.1.sw, 0.16.sh + 180.w, 0.1.sw, 0),
            height: 300.w,
            child: Pinput(
              length: 4,
              onCompleted: (pin) {
                HhLog.e("pin $pin");
                logic.code = pin;
                if (pin.length == 4) {
                  ///验证
                  /*EventBusUtil.getInstance().fire(HhToast(title: '登录成功'));
                  Future.delayed(const Duration(seconds: 1), () {
                    Get.offAll(HomePage(), binding: HomeBinding());
                  });*/
                  logic.sendLogin();
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
