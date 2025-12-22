import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot/utils/HhColors.dart';

class BatteryWidget extends StatelessWidget {
  final double width;
  final double height;
  final int batteryLevel; // 0~100

  const BatteryWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.batteryLevel,
  })  : assert(batteryLevel >= 0 && batteryLevel <= 100),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 内边距比例（更稳）
    final double paddingRatio = 0.08;
    final double padding = width * paddingRatio;

    // 电池头高度、宽度比例
    final double capWidth = width * 0.4;
    final double capHeight = height * 0.08;

    // 主体内部尺寸
    final double innerWidth = width - padding * 2;
    final double innerHeight = height - padding * 2;

    final double levelHeight = innerHeight * (batteryLevel / 100);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 电池头
        Container(
          width: capWidth,
          height: capHeight,
          decoration: BoxDecoration(
            color: HhColors.whiteColor,
            borderRadius: BorderRadius.circular(capHeight / 2),
          ),
        ),
        // 主体
        Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(top: capHeight * 0.2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: width * 0.1),
            borderRadius: BorderRadius.circular(width * 0.2),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: innerWidth,
                    height: levelHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(innerWidth * 0.15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
