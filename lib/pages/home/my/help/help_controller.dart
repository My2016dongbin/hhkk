import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iot/pages/common/model/model_class.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:pinput/pinput.dart';

class HelpController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<int> tabIndex = 0.obs;
  final Rx<bool> testStatus = true.obs;
  final PagingController<int, Device> deviceController = PagingController(firstPageKey: 0);
  static const pageSize = 20;

  @override
  void onInit() {
    deviceController.addPageRequestListener((pageKey) {
      fetchPageDevice(pageKey);
    });
    super.onInit();
  }

  void fetchPageDevice(int pageKey) {
    List<Device> newItems = [
      Device("怎么删除已添加的设备", "", "", "",true,true),
      Device("怎么删除已添加的设备", "", "", "",false,true),
      Device("远程控制用4G或者5G可以吗", "", "", "",false,false),
      Device("怎么设置自动修复设备", "", "", "",false,false),
    ];
    final isLastPage = newItems.length < pageSize;
    if (isLastPage) {
      deviceController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + newItems.length;
      deviceController.appendPage(newItems, nextPageKey);
    }
  }
}
