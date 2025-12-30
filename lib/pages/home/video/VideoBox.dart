import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoBox extends StatefulWidget {
  final double? width;
  final double? height;

  /// 回调：矩形四个点（左下、左上、右上、右下）+ 宽高（单位：像素）
  final void Function(
      Offset bottomLeft,
      Offset topLeft,
      Offset topRight,
      Offset bottomRight,
      double width,
      double height,
      ) onSelect;

  const VideoBox({
    Key? key,
    this.width,
    this.height,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  final GlobalKey _boxKey = GlobalKey();

  bool _isSelecting = false;
  Offset? _startLocal; // 起点（控件局部坐标）
  Offset? _endLocal;   // 终点（控件局部坐标）

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultWidth = widget.width ?? constraints.maxWidth;
        final defaultHeight = widget.height ?? constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _isSelecting ? _handlePanStart : null,
          onPanUpdate: _isSelecting ? _handlePanUpdate : null,
          onPanEnd: _isSelecting ? (_) => _handlePanEnd() : null,
          child: Container(
            key: _boxKey,
            width: defaultWidth.isFinite ? defaultWidth : null,
            height: defaultHeight.isFinite ? defaultHeight : null,
            color: Colors.grey[200],
            child: Stack(
              children: [
                // 绘制矩形
                if (_startLocal != null && _endLocal != null)
                  Positioned(
                    left: (_startLocal!.dx < _endLocal!.dx)
                        ? _startLocal!.dx
                        : _endLocal!.dx,
                    top: (_startLocal!.dy < _endLocal!.dy)
                        ? _startLocal!.dy
                        : _endLocal!.dy,
                    width: (_endLocal!.dx - _startLocal!.dx).abs(),
                    height: (_endLocal!.dy - _startLocal!.dy).abs(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.22),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),

                // 按钮区域
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // 横屏全屏
                          await SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight,
                          ]);

                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) => FullScreenBox(
                                child: VideoBox(onSelect: widget.onSelect),
                              ),
                            ),
                          );

                          // 恢复竖屏
                          await SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                        },
                        child: const Text("全屏"),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isSelecting = true;
                            _startLocal = null;
                            _endLocal = null;
                          });
                        },
                        child: const Text("框选"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  RenderBox? _getRenderBox() {
    final context = _boxKey.currentContext;
    if (context == null) return null;
    final renderObject = context.findRenderObject();
    return renderObject is RenderBox ? renderObject : null;
  }

  void _handlePanStart(DragStartDetails details) {
    final renderBox = _getRenderBox();
    if (renderBox == null) return;

    final size = renderBox.size;
    Offset local = renderBox.globalToLocal(details.globalPosition);
    local = Offset(
      local.dx.clamp(0.0, size.width),
      local.dy.clamp(0.0, size.height),
    );

    setState(() {
      _startLocal = local;
      _endLocal = null;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final renderBox = _getRenderBox();
    if (renderBox == null) return;
    final size = renderBox.size;

    Offset local = renderBox.globalToLocal(details.globalPosition);
    local = Offset(
      local.dx.clamp(0.0, size.width),
      local.dy.clamp(0.0, size.height),
    );

    setState(() {
      _endLocal = local;
    });
  }

  void _handlePanEnd() {
    final renderBox = _getRenderBox();
    if (renderBox == null || _startLocal == null || _endLocal == null) {
      _resetSelection();
      return;
    }

    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // 将局部坐标转换为屏幕坐标
    final boxTopLeft = renderBox.localToGlobal(Offset.zero);

    double startX = _startLocal!.dx + boxTopLeft.dx;
    double startY = _startLocal!.dy + boxTopLeft.dy;
    double endX = _endLocal!.dx + boxTopLeft.dx;
    double endY = _endLocal!.dy + boxTopLeft.dy;

    // clamp 到屏幕范围
    startX = startX.clamp(0.0, screenWidth);
    endX = endX.clamp(0.0, screenWidth);
    startY = startY.clamp(0.0, screenHeight);
    endY = endY.clamp(0.0, screenHeight);

    final left = startX < endX ? startX : endX;
    final right = startX > endX ? startX : endX;
    final top = startY < endY ? startY : endY;
    final bottom = startY > endY ? startY : endY;

    final rectWidth = right - left;
    final rectHeight = bottom - top;

    // 转换为左下角原点
    final bottomLeft = Offset(left, screenHeight - bottom);
    final topLeft = Offset(left, screenHeight - top);
    final topRight = Offset(right, screenHeight - top);
    final bottomRight = Offset(right, screenHeight - bottom);

    widget.onSelect(
      bottomLeft,
      topLeft,
      topRight,
      bottomRight,
      rectWidth,
      rectHeight,
    );

    _resetSelection();
  }

  void _resetSelection() {
    setState(() {
      _isSelecting = false;
      _startLocal = null;
      _endLocal = null;
    });
  }
}

class FullScreenBox extends StatelessWidget {
  final Widget child;
  const FullScreenBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(
              top: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("退出全屏"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
