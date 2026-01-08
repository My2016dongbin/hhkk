import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/pages/home/my/scan/scan_controller.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class ScanPage extends StatelessWidget {
  final logic = Get.find<ScanController>();

  ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    // 在这里设置状态栏字体为深色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景色
      statusBarBrightness: Brightness.light, // 状态栏字体亮度
      statusBarIconBrightness: Brightness.light, // 状态栏图标亮度
    ));
    return Scaffold(
      backgroundColor: HhColors.backColor,
      body: Obx(
            () => Container(
          height: 1.sh,
          width: 1.sw,
          color: HhColors.backColorScan,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              ///title
              InkWell(
                onTap: (){
                  Get.back();
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.w*3, 53.w*3, 0, 0),
                  padding: EdgeInsets.all(10.w),
                  color: HhColors.trans,
                  child: Image.asset(
                    "assets/images/common/back_white.png",
                    height: 17.w*3,
                    width: 10.w*3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top:51.w*3),
                  color: HhColors.trans,
                  child: Text(
                    "设备添加",
                    style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 18.sp*3,fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 212.h*3),
                  height: 294.w*3,
                  width: 294.w*3,
                  child: Stack(
                    children: [
                      QRView(
                        key: logic.qrKey,
                        onQRViewCreated: logic.onQRViewCreated,
                      ),
                      /*CustomPaint(
                        painter: ParticlePainter(),
                        child: Container(), // 需要一个 child 以占据整个分组
                      ),*/
                      SizedBox(
                        width: 294.w*3,
                        height: logic.scanHeightRx.value,
                        child: Image.asset(
                          "assets/images/common/icon_scan.png",
                          width: 294.w*3,
                          height: logic.scanHeightRx.value,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Container(
                        color: HhColors.whiteColor,
                        height: 3.w,
                        width: 294.w*3,
                        margin: EdgeInsets.only(top: logic.scanHeightRx.value),
                      ),
                      Image.asset(
                        "assets/images/common/scan_top_left.png",
                        width: 14.w*3,
                        height: 14.w*3,
                        fit: BoxFit.fill,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/common/scan_top_right.png",
                          width: 14.w*3,
                          height: 14.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Image.asset(
                          "assets/images/common/scan_bottom_left.png",
                          width: 14.w*3,
                          height: 14.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Image.asset(
                          "assets/images/common/scan_bottom_right.png",
                          width: 14.w*3,
                          height: 14.w*3,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(40.w*3, 0, 40.w*3, 40.w*3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '添加设备时，请扫描设备标签/机身上的二维码',
                        style: TextStyle(
                            color: HhColors.whiteColor,
                            fontSize: 13.sp*3,
                            fontWeight: FontWeight.w300),
                      ),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 100),
                        scaleFactor: 1.2,
                        onPressed: () {
                          Get.off(()=>DeviceAddPage(snCode: '',),binding: DeviceAddBinding());
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(40.w*3, 24.w*3, 40.w*3, 38.w*3),
                          padding: EdgeInsets.fromLTRB(20.w*3, 13.w*3, 26.w*3, 13.w*3),
                          decoration: BoxDecoration(
                            color: HhColors.black2Color,
                            borderRadius: BorderRadius.circular(22.w*3)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '没有二维码？手动添加',
                                style: TextStyle(
                                    color: HhColors.whiteColor,
                                    fontSize: 13.sp*3,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(width: 10.w*3,),
                              Image.asset(
                                "assets/images/common/back_role.png",
                                width: 13.w*3,
                                height: 13.w*3,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              checkAndTurnOnFlash();
                            },
                            child: Image.asset(
                              "assets/images/common/scan_light.png",
                              width: 58.w*3,
                              height: 58.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          BouncingWidget(
                            duration: const Duration(milliseconds: 100),
                            scaleFactor: 1.2,
                            onPressed: () {
                              pickImage();
                            },
                            child: Image.asset(
                              "assets/images/common/scan_image.png",
                              width: 58.w*3,
                              height: 58.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              logic.index.value==0?const SizedBox():const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkAndTurnOnFlash() async {
    logic.lightStatus.value = !logic.lightStatus.value;
    if (logic.lightStatus.value) {
      // 开
      logic.controller!.toggleFlash();
    } else {
      // 关
      logic.controller!.toggleFlash();
    }
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    late String? result;
    if (pickedFile != null) {
      // 使用 QRCodeTools 从图片中读取二维码
      try{
        result = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);
      }catch(e){
        EventBusUtil.getInstance().fire(HhToast(title: '请选择清晰的二维码图片'));
      }

      String? barcodeScanRes = '';
      try{
        barcodeScanRes = result;
        dynamic model = jsonDecode(barcodeScanRes!);
        if(model["type"] == "share"){
          //String requestUrl = RequestUtils.base + model["shareUrl"];
          // logic.getShareDetail(requestUrl);
        }else{
          Get.off(()=>DeviceAddPage(snCode: barcodeScanRes!,),binding: DeviceAddBinding());
        }
      }catch(e){
        Get.off(()=>DeviceAddPage(snCode: barcodeScanRes!,),binding: DeviceAddBinding());
      }
    }
  }

}
