import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot/utils/HhColors.dart';

class DonutChart extends StatelessWidget {
  final double total;        // 总数
  final double blueValue;    // 蓝色数
  final double orangeValue;  // 橙色数
  final double width;        // 图表宽度
  final double height;       // 图表高度

  const DonutChart({
    Key? key,
    required this.total,
    required this.blueValue,
    required this.orangeValue,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: DonutChartPainter(
        total: total,
        blueValue: blueValue,
        orangeValue: orangeValue,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "报警总数",
              style: TextStyle(fontSize: 12.5.sp*3, color: HhColors.textInColor),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25.w*3, 0, 25.w*3, 0),
              child: Text(
                total.toInt().toString(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 22.sp*3,
                  overflow: TextOverflow.ellipsis,
                  color: HhColors.textBlackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double total;
  final double blueValue;
  final double orangeValue;

  DonutChartPainter({
    required this.total,
    required this.blueValue,
    required this.orangeValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeBlue = 14;   // 蓝色环宽度（细）
    double strokeOrange = 20; // 橙色环宽度（粗）

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    double blueAngle = (blueValue / total) * 2 * pi;
    double orangeAngle = (orangeValue / total) * 2 * pi;

    // 统一用橙色粗环的半径，保证细环居中
    Rect arcRect = Rect.fromCircle(center: center, radius: radius - strokeOrange / 2);

    // 蓝色环
    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeBlue
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      arcRect,
      -pi / 2,   // 从顶部开始
      blueAngle,
      false,
      bluePaint,
    );

    // 橙色环
    Paint orangePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeOrange
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      arcRect,
      -pi / 2 + blueAngle, // 接着蓝色环之后画
      orangeAngle,
      false,
      orangePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
