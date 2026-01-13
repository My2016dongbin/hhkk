import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot/utils/HhColors.dart';

///弹窗方向
enum HhMenuDirection {
  top,
  bottom,
  left,
  right,
}
///菜单方向
enum HhItemDirection {
  horizontal,
  vertical,
}

class HhActionMenu {
  static OverlayEntry? _entry;

  /// 用于记录弹窗尺寸
  static Size _menuSize = Size.zero;

  static void show({
    required BuildContext context,
    required Offset offset,
    required List<Widget> items,
    EdgeInsets ?margin,
    HhMenuDirection direction = HhMenuDirection.bottom,
    HhItemDirection itemDirection = HhItemDirection.horizontal,
    String? backgroundImage,
    EdgeInsets padding =
    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    double gap = 8, //弹窗与点击点间距
    double dy = 0,
    double dx = 0,
  }) {
    dismiss();
    _menuSize = Size.zero;

    _entry = OverlayEntry(
      builder: (context) {
        final position = _calculatePosition(
          offset: offset,
          direction: direction,
          gap: gap,
          dy: dy,
          dx: dx,
        );

        return Stack(
          children: [
            /// 点击空白关闭
            Positioned.fill(
              child: Container(
                color: HhColors.transBlack,
                child: GestureDetector(
                  onTap: dismiss,
                  behavior: HitTestBehavior.translucent,
                ),
              ),
            ),

            /// 菜单主体
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                color: Colors.transparent,
                child: _MeasureSize(
                  onChange: (size) {
                    if (_menuSize != size) {
                      _menuSize = size;
                      _entry?.markNeedsBuild();
                    }
                  },
                  child: Container(
                    padding: padding,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        /// 背景图自动铺满
                        (backgroundImage != null)?
                          Positioned.fill(
                            child: Image.asset(
                              backgroundImage,
                              fit: BoxFit.fill,
                            ),
                          ):Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HhColors.whiteColor,
                              borderRadius: BorderRadius.circular(8.w*3),
                            ),
                          ),
                        ),

                        /// 内容决定尺寸
                        Container(
                          margin: margin??EdgeInsets.zero,
                          child: itemDirection==HhItemDirection.horizontal?Row(
                            mainAxisSize: MainAxisSize.min,
                            children: items,
                          ):Column(
                            mainAxisSize: MainAxisSize.min,
                            children: items,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  /// 计算弹窗位置（关键）
  static Offset _calculatePosition({
    required Offset offset,
    required HhMenuDirection direction,
    required double gap,
    double dy = 0,
    double dx = 0,
  }) {
    switch (direction) {
      case HhMenuDirection.top:
        return Offset(
          offset.dx - _menuSize.width / 1 + dx,
          offset.dy - _menuSize.height - gap + dy,
        );
      case HhMenuDirection.bottom:
        return Offset(
          offset.dx - _menuSize.width / 1 + dx,
          offset.dy + gap + dy,
        );
      case HhMenuDirection.left:
        return Offset(
          offset.dx - _menuSize.width - gap + dx,
          offset.dy - _menuSize.height / 1 + dy,
        );
      case HhMenuDirection.right:
        return Offset(
          offset.dx + gap + dx,
          offset.dy - _menuSize.height / 1 + dy,
        );
    }
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({
    required this.child,
    required this.onChange,
  });

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_notifySize);
  }

  void _notifySize(_) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      widget.onChange(renderBox.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

