import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iot/utils/HhColors.dart';

class TopAlarmNotificationData {
  const TopAlarmNotificationData({
    required this.title,
    required this.timeText,
    required this.message,
    this.dedupeKey,
    this.onTap,
    this.displayDuration = const Duration(seconds: 5),
  });

  final String title;
  final String timeText;
  final String message;
  final String? dedupeKey;
  final VoidCallback? onTap;
  final Duration displayDuration;
}

class TopAlarmNotificationService extends GetxService {
  static TopAlarmNotificationService get to =>
      Get.find<TopAlarmNotificationService>();

  final Queue<TopAlarmNotificationData> _queue =
      Queue<TopAlarmNotificationData>();
  final Map<String, DateTime> _dedupeMap = <String, DateTime>{};

  OverlayEntry? _currentEntry;
  bool _isShowing = false;

  static const int _maxQueueLength = 50;
  static const Duration _dedupeWindow = Duration(milliseconds: 1500);
  static const Duration _overlayRetryDelay = Duration(milliseconds: 120);

  void showNotification(TopAlarmNotificationData data) {
    _clearExpiredDedupe();

    final String dedupeKey = (data.dedupeKey ?? '').trim();
    if (dedupeKey.isNotEmpty) {
      final DateTime? lastAt = _dedupeMap[dedupeKey];
      if (lastAt != null && DateTime.now().difference(lastAt) < _dedupeWindow) {
        return;
      }
      _dedupeMap[dedupeKey] = DateTime.now();
    }

    if (_queue.length >= _maxQueueLength) {
      _queue.removeFirst();
    }
    _queue.addLast(data);
    _showNext();
  }

  void clearAllNotifications() {
    _queue.clear();
    _dedupeMap.clear();
  }

  void _showNext() {
    if (_isShowing || _queue.isEmpty) {
      return;
    }

    final BuildContext? overlayContext = Get.overlayContext;
    if (overlayContext == null) {
      Future<void>.delayed(_overlayRetryDelay, _showNext);
      return;
    }

    final OverlayState overlay = Overlay.of(overlayContext, rootOverlay: true);

    _isShowing = true;
    final TopAlarmNotificationData data = _queue.removeFirst();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopAlarmNotificationOverlay(
        data: data,
        onClearAll: clearAllNotifications,
        onClosed: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
          _isShowing = false;
          Future<void>.microtask(_showNext);
        },
      ),
    );
    _currentEntry = entry;
    overlay.insert(entry);
  }

  void _clearExpiredDedupe() {
    if (_dedupeMap.isEmpty) {
      return;
    }
    final DateTime now = DateTime.now();
    final List<String> expiredKeys = <String>[];
    _dedupeMap.forEach((String key, DateTime value) {
      if (now.difference(value) >= _dedupeWindow) {
        expiredKeys.add(key);
      }
    });
    for (final String key in expiredKeys) {
      _dedupeMap.remove(key);
    }
  }
}

class _TopAlarmNotificationOverlay extends StatefulWidget {
  const _TopAlarmNotificationOverlay({
    required this.data,
    required this.onClearAll,
    required this.onClosed,
  });

  final TopAlarmNotificationData data;
  final VoidCallback onClearAll;
  final VoidCallback onClosed;

  @override
  State<_TopAlarmNotificationOverlay> createState() =>
      _TopAlarmNotificationOverlayState();
}

class _TopAlarmNotificationOverlayState
    extends State<_TopAlarmNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _opacityAnimation;

  Timer? _autoCloseTimer;
  bool _closing = false;
  double _dragOffsetY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacityAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _autoCloseTimer ??= Timer(widget.data.displayDuration, _dismiss);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_closing) {
      return;
    }
    _closing = true;
    _autoCloseTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onClosed();
    }
  }

  Future<void> _handleTap() async {
    widget.data.onTap?.call();
    await _dismiss();
  }

  Future<void> _handleClearAll() async {
    widget.onClearAll();
    await _dismiss();
  }

  void _handleVerticalDragStart(DragStartDetails details) {
    _autoCloseTimer?.cancel();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_closing) {
      return;
    }
    final double nextOffset = (_dragOffsetY + details.delta.dy).clamp(-140, 0);
    if (nextOffset == _dragOffsetY) {
      return;
    }
    setState(() {
      _dragOffsetY = nextOffset;
    });
  }

  Future<void> _handleVerticalDragEnd(DragEndDetails details) async {
    if (_closing) {
      return;
    }
    final double velocity = details.primaryVelocity ?? 0;
    if (_dragOffsetY <= -48 || velocity <= -500) {
      await _dismiss();
      return;
    }
    setState(() {
      _dragOffsetY = 0;
    });
    _autoCloseTimer ??= Timer(widget.data.displayDuration, _dismiss);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              12.w * 3, Platform.isAndroid ? 8.w * 3 : 0, 12.w * 3, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: _handleVerticalDragStart,
            onVerticalDragUpdate: _handleVerticalDragUpdate,
            onVerticalDragEnd: _handleVerticalDragEnd,
            child: Transform.translate(
              offset: Offset(0, _dragOffsetY),
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: HhColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.w * 3),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withAlpha(18),
                            blurRadius: 18.w * 3,
                            offset: Offset(0, 6.w * 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.w * 3),
                              onTap: _handleTap,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    14.w * 3, 14.w * 3, 10.w * 3, 14.w * 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 20.w * 3,
                                          height: 20.w * 3,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFF1F1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.warning_rounded,
                                            size: 15.w * 3,
                                            color: HhColors.mainRedNoticeColor,
                                          ),
                                        ),
                                        SizedBox(width: 6.w * 3),
                                        Expanded(
                                          child: Text(
                                            widget.data.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: HhColors.blackColor,
                                              fontSize: 16.sp * 3,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(14.w * 3),
                                          onTap: _handleClearAll,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 4.w * 3,
                                              vertical: 3.w * 3,
                                            ),
                                            child: Text(
                                              '一键关闭',
                                              style: TextStyle(
                                                color: HhColors.mainBlueColor,
                                                fontSize: 13.sp * 3,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w * 3),
                                      ],
                                    ),
                                    SizedBox(height: 10.w * 3),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: <Widget>[
                                        Text(
                                          '时间:',
                                          style: TextStyle(
                                            color: HhColors.gray6TextColor,
                                            fontSize: 13.sp * 3,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 4.w * 3),
                                        Expanded(
                                          child: Text(
                                            widget.data.timeText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: HhColors.gray6TextColor,
                                              fontSize: 13.sp * 3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.w * 3),
                                    Text(
                                      widget.data.message,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: HhColors.gray3TextColor,
                                        fontSize: 14.sp * 3,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(18.w * 3),
                            onTap: _dismiss,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  4.w * 3, 18.w * 3, 20.w * 3, 0),
                              child: Icon(
                                Icons.close,
                                size: 18.w * 3,
                                color: HhColors.gray8TextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
