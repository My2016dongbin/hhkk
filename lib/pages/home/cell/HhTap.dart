import 'package:flutter/material.dart';

class HhTap extends StatefulWidget {
  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final Color overlayColor;
  final BorderRadius? borderRadius;

  final void Function()? onTapDown;
  final void Function()? onTapUp;
  final void Function()? onTapCancel;

  const HhTap({
    Key? key,
    required this.child,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.overlayColor = const Color(0x33000000), // 半透明黑
    this.borderRadius,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  }) : super(key: key);

  @override
  State<HhTap> createState() => _HhTapState();
}

class _HhTapState extends State<HhTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _pressed = true);
    _controller.forward();
    widget.onTapDown?.call();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _pressed = false);
    _controller.reverse();
    widget.onTapUp?.call();
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
    _controller.reverse();
    widget.onTapCancel?.call();
    widget.onTapUp?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                child!,
                if (_pressed)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: widget.borderRadius ?? BorderRadius.zero,
                      child: Container(color: widget.overlayColor),
                    ),
                  ),
              ],
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
