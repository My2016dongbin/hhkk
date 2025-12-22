import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioDotsVisualizer extends StatefulWidget {
  final double width;
  final double height;
  final int barCount;
  final Color color;

  const AudioDotsVisualizer({
    Key? key,
    required this.width,
    required this.height,
    this.barCount = 14,
    this.color = Colors.blueAccent,
  }) : super(key: key);

  @override
  State<AudioDotsVisualizer> createState() => AudioDotsVisualizerState();
}

class AudioDotsVisualizerState extends State<AudioDotsVisualizer> {
  final Random _random = Random();
  late List<double> _heights;
  Timer? _timer;
  bool _isRunning = false;

  double get barWidth =>
      (widget.width - widget.barCount * 2) / widget.barCount;

  @override
  void initState() {
    super.initState();
    _heights = List.filled(widget.barCount, 8.w*3);
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      setState(() {
        _heights = List.generate(widget.barCount, (index) {
          return _random
              .nextDouble() *
              widget.height *
              0.9 + // max height
              widget.height * 0.1; // min height
        });
      });
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    setState(() {
      _heights = List.filled(widget.barCount, 8.w*3);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.symmetric(horizontal: 1),
            width: barWidth,
            height: _heights[index],
            decoration: BoxDecoration(
              color: widget.color.withAlpha(_getAlpha(index)),
              borderRadius: BorderRadius.circular(barWidth / 3),
            ),
          );
        }),
      ),
    );
  }

  int _getAlpha(int index) {
    int center = widget.barCount ~/ 2;
    int distance = (index - center).abs();

    // 控制最大透明度和衰减速度
    const int maxAlpha = 255;
    const int minAlpha = 80;

    int alpha = maxAlpha - distance * 20;
    return alpha.clamp(minAlpha, maxAlpha);
  }

}