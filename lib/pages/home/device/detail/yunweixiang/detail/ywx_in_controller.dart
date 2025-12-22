import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class YWXInController extends GetxController {
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final Rx<bool> testStatus = true.obs;
  late dynamic item = {};
  final PagingController<int, dynamic> warnController = PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  ///TODO 测试数据
  void initData() {
    List<dynamic> newItems = [];
    newItems.add({
      "type1":"内部告警",
      "type2":"设备链路告警",
      "content":"设备与平台连接...",
      "time":"2025-01-11 18:18:02",
    });
    newItems.add({
      "type1":"内部告警",
      "type2":"设备链路告警",
      "content":"设备与平台连接...",
      "time":"2025-01-11 18:18:02",
    });
    warnController.itemList = [];
    warnController.appendLastPage(newItems);
  }
}
