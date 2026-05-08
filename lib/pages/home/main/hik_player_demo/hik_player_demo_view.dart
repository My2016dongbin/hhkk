import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/pages/home/main/hik_player_demo/hik_player_demo_controller.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:qc_hik_player/qc_hik_player.dart';

class HikPlayerDemoPage extends StatelessWidget {
  final logic = Get.find<HikPlayerDemoController>();

  HikPlayerDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HhColors.backColorF5,
      appBar: AppBar(
        title: const Text('海康视频流播放'),
        backgroundColor: HhColors.whiteColor,
        foregroundColor: HhColors.blackColor,
        elevation: 0,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.w * 3, 20.w * 3, 14.w * 3, 20.w * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BouncingWidget(
                duration: const Duration(milliseconds: 100),
                scaleFactor: 1.2,
                onPressed: logic.mockFetchAndPlay,
                child: Container(
                  height: 46.w * 3,
                  decoration: BoxDecoration(
                    color: HhColors.mainBlueColor,
                    borderRadius: BorderRadius.circular(10.w * 3),
                  ),
                  child: Center(
                    child: Text(
                      '模拟接口返回并开始播放',
                      style: TextStyle(
                        color: HhColors.whiteColor,
                        fontSize: 15.sp * 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.w * 3),
              Container(
                height: 220.w * 3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.w * 3),
                ),
                clipBehavior: Clip.antiAlias,
                child: logic.playParams.value == null
                    ? Center(
                        child: Text(
                          '点击上方按钮后开始播放',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp * 3,
                          ),
                        ),
                      )
                    : QcHikPlayerView(
                        key: ValueKey(logic.playerSeed.value),
                        params: logic.playParams.value!,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
