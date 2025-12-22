import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/home/device/add/device_add_binding.dart';
import 'package:iot/pages/home/device/add/device_add_view.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanController extends GetxController {
  final index = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final Rx<bool> lightStatus = false.obs;
  final Rx<bool> test = false.obs;
  final Rx<String> testFile = ''.obs;
  final double maxHeight = 294.w*3;
  late double scanHeight = 0;
  final Rx<double> scanHeightRx = 0.0.obs;
  late BuildContext context;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late Barcode? result;
  late QRViewController? controller;

  @override
  void onInit() {
    runScanTimer();
    super.onInit();
  }

  @override
  void dispose() {
    try{
      controller!.dispose();
    }catch(e){
      //
    }
    super.dispose();
  }
  @override
  void onClose() {
    try{
      controller!.dispose();
    }catch(e){
      //
    }
    super.onClose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;

      String? barcodeScanRes = '';
      try{
        barcodeScanRes = result!.code;
        dynamic model = jsonDecode(barcodeScanRes!);
        if(model["type"] == "share"){
          //String requestUrl = RequestUtils.base + model["shareUrl"];
          // logic.getShareDetail(requestUrl);
        }else{
          Get.to(()=>DeviceAddPage(snCode: barcodeScanRes!,),binding: DeviceAddBinding());
        }
      }catch(e){
        Get.to(()=>DeviceAddPage(snCode: barcodeScanRes!,),binding: DeviceAddBinding());
      }
    });
  }

  void runScanTimer() {
    scanHeight+=(maxHeight/100);
    if(scanHeight > maxHeight){
      scanHeight = 0;
    }
    scanHeightRx.value = scanHeight;
    Future.delayed(const Duration(milliseconds: 30),(){
      runScanTimer();
    });
  }

}
