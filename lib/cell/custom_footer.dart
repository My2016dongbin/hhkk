import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class CustomFooter extends Footer {
  CustomFooter({required super.triggerOffset, required super.clamping});

  @override
  Widget build(BuildContext context, IndicatorState state) {
    Widget content;
    switch (state.result) {
      case IndicatorResult.none: // 空闲状态
        content = const Text("上拉加载更多");
        break;
      case IndicatorResult.fail: // 正在加载状态
        content = const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(width: 10),
            Text("正在加载..."),
          ],
        );
        break;
      case IndicatorResult.success: // 完成状态
        content = const Text("加载完成");
        break;
      case IndicatorResult.noMore: // 没有更多数据状态
        content = const Text("没有更多数据");
        break;
      default:
        content = const SizedBox.shrink();
        break;
    }
    return Center(child: content);
  }
  /*CustomFooter() : super(builder: (context, state) {
    Widget content;
    switch (state) {
      case IndicatorState.idle: // 空闲状态
        content = const Text("上拉加载更多");
        break;
      case IndicatorState.processing: // 正在加载状态
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(width: 10),
            Text("正在加载..."),
          ],
        );
        break;
      case IndicatorState.finished: // 完成状态
        content = const Text("加载完成");
        break;
      case IndicatorState.noMore: // 没有更多数据状态
        content = const Text("没有更多数据");
        break;
      default:
        content = const SizedBox.shrink();
        break;
    }
    return Center(child: content);
  });*/
}
