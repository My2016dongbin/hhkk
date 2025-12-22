import 'package:flutter/material.dart';
import 'dart:async';

class BatteryWidget extends StatefulWidget {
  final double width;
  final double height;
  final int batteryLevel; // 0~100
  final bool charging; // 是否显示充电动画

  const BatteryWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.batteryLevel,
    this.charging = false,
  })  : assert(batteryLevel >= 0 && batteryLevel <= 100),
        super(key: key);

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  late int _animatedLevel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animatedLevel = widget.batteryLevel;
    if (widget.charging) {
      _startChargingAnimation();
    }
  }

  void _startChargingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _animatedLevel += 5;
        if (_animatedLevel > 100) _animatedLevel = 0;
      });
    });
  }

  @override
  void didUpdateWidget(covariant BatteryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.charging) {
      _timer?.cancel();
      _animatedLevel = widget.batteryLevel;
    } else if (widget.charging && !_timer!.isActive == true) {
      _startChargingAnimation();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double capHeight = widget.height * 0.08; // 电池触点高度
    final double bodyHeight = widget.height - capHeight;
    final double padding = widget.width * 0.08;
    final double innerHeight = bodyHeight - padding * 2;
    final double innerWidth = widget.width - padding * 2;
    final double levelHeight = innerHeight * (_animatedLevel / 100);

    return Column(
      children: [
        // 顶部凸点
        Container(
          width: widget.width * 0.4,
          height: capHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.width * 0.1),
          ),
        ),
        // 电池主体
        Container(
          width: widget.width,
          height: bodyHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(widget.width * 0.2),
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: innerWidth,
                height: levelHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(innerWidth * 0.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
