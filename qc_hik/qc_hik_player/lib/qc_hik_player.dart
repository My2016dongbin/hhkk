import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum QcHikPlayerMoveDirection { up, down, left, right }

typedef QcHikPlayerMoveCallback = void Function(
    QcHikPlayerMoveDirection direction);

class QcHikPlayerController {
  MethodChannel? _methodChannel;

  void _attach(MethodChannel? methodChannel) {
    _methodChannel = methodChannel;
  }

  void _detach(MethodChannel? methodChannel) {
    if (_methodChannel == methodChannel) {
      _methodChannel = null;
    }
  }

  Future<Uint8List?> capturePicture() async {
    if (_methodChannel == null) {
      return null;
    }
    try {
      final dynamic result = await _methodChannel!.invokeMethod(
        'capturePicture',
      );
      if (result is Uint8List) {
        return result;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> startLocalRecord(String filePath) async {
    if (_methodChannel == null) {
      return false;
    }
    try {
      final dynamic result = await _methodChannel!.invokeMethod(
        'startLocalRecord',
        {'filePath': filePath},
      );
      return result == true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> stopLocalRecord() async {
    if (_methodChannel == null) {
      return false;
    }
    try {
      final dynamic result = await _methodChannel!.invokeMethod(
        'stopLocalRecord',
      );
      return result == true;
    } catch (_) {
      return false;
    }
  }
}

class QcHikPlayerParams {
  final String tokenAppKey;
  final String httpUrlToken;
  final String deviceSerial;
  final int channelNo;
  final String deviceToken;
  final String deviceGlobalToken;
  final String deviceVideoToken;
  final String streamLiveToken;

  const QcHikPlayerParams({
    required this.tokenAppKey,
    required this.httpUrlToken,
    required this.deviceSerial,
    required this.channelNo,
    required this.deviceToken,
    required this.deviceGlobalToken,
    required this.deviceVideoToken,
    required this.streamLiveToken,
  });

  factory QcHikPlayerParams.fromSdkParams(Map<String, dynamic> params) {
    return QcHikPlayerParams(
      tokenAppKey: '${params['tokenAppKey'] ?? ''}',
      httpUrlToken: '${params['httpUrlToken'] ?? ''}',
      deviceSerial: '${params['deviceSerial'] ?? ''}',
      channelNo: (params['channelNo'] ?? 1) as int,
      deviceToken: '${params['deviceToken'] ?? ''}',
      deviceGlobalToken: '${params['deviceGlobalToken'] ?? ''}',
      deviceVideoToken: '${params['deviceVideoToken'] ?? ''}',
      streamLiveToken: '${params['streamLiveToken'] ?? ''}',
    );
  }

  static Map<String, dynamic> extractSdkParamsFromBusinessResponse(
      Map<String, dynamic> response) {
    final Map<String, dynamic> data =
        (response['data'] as Map?)?.cast<String, dynamic>() ?? {};
    final Map<String, dynamic> ezvizData =
        ((data['ezvizData'] as Map?)?['data'] as Map?)
                ?.cast<String, dynamic>() ??
            {};
    final Map<String, dynamic> resourceDetail =
        ((data['resourceDetail'] as Map?)?['data'] as Map?)
                ?.cast<String, dynamic>() ??
            {};
    final List<dynamic> tokenList =
        ((data['deviceTokens'] as Map?)?['data'] as List?) ?? [];
    final Map<String, dynamic> deviceToken =
        tokenList.isNotEmpty && tokenList.first is Map
            ? (tokenList.first as Map).cast<String, dynamic>()
            : {};
    return {
      'tokenAppKey': '${ezvizData['tokenAppKey'] ?? ''}',
      'httpUrlToken': '${ezvizData['httpUrlToken'] ?? ''}',
      'deviceSerial':
          '${data['deviceSerial'] ?? resourceDetail['deviceSerial'] ?? ''}',
      'channelNo':
          (data['channelNo'] ?? resourceDetail['channelNum'] ?? 1) as int,
      'deviceToken': '${deviceToken['deviceToken'] ?? ''}',
      'deviceGlobalToken': '${deviceToken['deviceGlobalToken'] ?? ''}',
      'deviceVideoToken': '${deviceToken['deviceVideoToken'] ?? ''}',
      'streamLiveToken': '${deviceToken['streamLiveToken'] ?? ''}',
    };
  }

  factory QcHikPlayerParams.fromBusinessResponse(
      Map<String, dynamic> response) {
    return QcHikPlayerParams.fromSdkParams(
      extractSdkParamsFromBusinessResponse(response),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tokenAppKey': tokenAppKey,
      'httpUrlToken': httpUrlToken,
      'deviceSerial': deviceSerial,
      'channelNo': channelNo,
      'deviceToken': deviceToken,
      'deviceGlobalToken': deviceGlobalToken,
      'deviceVideoToken': deviceVideoToken,
      'streamLiveToken': streamLiveToken,
    };
  }
}

class QcHikPlayerView extends StatefulWidget {
  final QcHikPlayerParams params;
  final VoidCallback? onOuterTap;
  final VoidCallback? onPlaySuccess;
  final QcHikPlayerMoveCallback? onMoveStart;
  final VoidCallback? onMoveEnd;
  final QcHikPlayerController? controller;
  final bool enablePanel;
  final bool autoPlay;
  final bool isFullScreenMode;

  const QcHikPlayerView({
    super.key,
    required this.params,
    this.onOuterTap,
    this.onPlaySuccess,
    this.onMoveStart,
    this.onMoveEnd,
    this.controller,
    this.enablePanel = true,
    this.autoPlay = true,
    this.isFullScreenMode = false,
  });

  @override
  State<QcHikPlayerView> createState() => _QcHikPlayerViewState();
}

class _QcHikPlayerViewState extends State<QcHikPlayerView> {
  static const _viewType = 'qc_hik_player_view';

  MethodChannel? _methodChannel;
  StreamSubscription<dynamic>? _eventSubscription;
  Timer? _hideTimer;

  bool _hideStuff = true;
  bool _playing = false;
  bool _prepared = false;
  bool _muted = false;
  bool _isDisposed = false;
  String? _exception;

  bool upStatus = false;
  bool downStatus = false;
  bool leftStatus = false;
  bool rightStatus = false;

  @override
  void dispose() {
    _isDisposed = true;
    _hideTimer?.cancel();
    _eventSubscription?.cancel();
    widget.controller?._detach(_methodChannel);
    _methodChannel?.invokeMethod('disposePlayer');
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant QcHikPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(_methodChannel);
      widget.controller?._attach(_methodChannel);
    }
  }

  Future<void> _onPlatformViewCreated(int id) async {
    _methodChannel = MethodChannel('qc_hik_player_view_$id/method');
    widget.controller?._attach(_methodChannel);
    const eventCodec = StandardMethodCodec();
    final eventChannel = EventChannel(
      'qc_hik_player_view_$id/event',
      eventCodec,
    );
    _eventSubscription?.cancel();
    _eventSubscription = eventChannel.receiveBroadcastStream().listen(
      _handlePlayerEvent,
      onError: (dynamic error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _prepared = false;
          _playing = false;
          _exception = '$error';
        });
      },
    );
    if (!widget.autoPlay) {
      await _invokeBoolMethod('stopRealPlay');
    }
  }

  void _handlePlayerEvent(dynamic event) {
    if (_isDisposed || !mounted) {
      return;
    }
    if (event is! Map) {
      return;
    }
    final Map<dynamic, dynamic> rawMap = event;
    final String state = '${rawMap['state'] ?? ''}';
    final String message = '${rawMap['message'] ?? ''}'.trim();
    final bool wasPlaying = _playing;
    setState(() {
      if (state == 'playing') {
        _prepared = true;
        _playing = true;
        _exception = null;
      } else if (state == 'connecting') {
        _prepared = false;
        _playing = false;
        _exception = null;
      } else if (state == 'stopped') {
        _playing = false;
      } else if (state == 'error') {
        _prepared = false;
        _playing = false;
        _exception = message.isEmpty ? '视频加载错误，请重试' : message;
      }
    });
    if (state == 'playing' && !wasPlaying) {
      widget.onPlaySuccess?.call();
    }
  }

  Future<bool> _invokeBoolMethod(
    String method, {
    Map<String, dynamic>? arguments,
  }) async {
    if (_methodChannel == null) {
      return false;
    }
    try {
      final dynamic result = await _methodChannel!.invokeMethod(
        method,
        arguments,
      );
      return result == true;
    } catch (_) {
      return false;
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _cancelAndRestartTimer() {
    widget.onOuterTap?.call();
    if (_hideStuff) {
      _startHideTimer();
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  Future<void> _playOrPause() async {
    if (_playing) {
      final bool success = await _invokeBoolMethod('stopRealPlay');
      if (!mounted || !success) {
        return;
      }
      setState(() {
        _playing = false;
      });
      return;
    }
    setState(() {
      _exception = null;
      _prepared = false;
    });
    await _invokeBoolMethod('startRealPlay');
  }

  Future<void> _toggleVolume() async {
    final bool enabled = _muted;
    final bool success = await _invokeBoolMethod(
      'setSoundEnabled',
      arguments: {'enabled': enabled},
    );
    if (!mounted || !success) {
      return;
    }
    setState(() {
      _muted = !_muted;
    });
  }

  Future<void> _restartPlay() async {
    setState(() {
      _exception = null;
      _prepared = false;
      _playing = false;
    });
    await _invokeBoolMethod('restartPlay');
  }

  Future<void> _openFullScreen() async {
    if (widget.isFullScreenMode) {
      Navigator.of(context).pop();
      return;
    }
    final bool wasPlaying = _playing;
    if (wasPlaying) {
      await _invokeBoolMethod('stopRealPlay');
    }
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await navigator.push(
      MaterialPageRoute(
        builder: (_) => _QcHikPlayerFullScreenPage(
          params: widget.params,
          onMoveStart: widget.onMoveStart,
          onMoveEnd: widget.onMoveEnd,
        ),
      ),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (!mounted || !wasPlaying) {
      return;
    }
    setState(() {
      _exception = null;
      _prepared = false;
    });
    await _invokeBoolMethod('startRealPlay');
  }

  void _onMoveUpdate(QcHikPlayerMoveDirection direction) {
    if (!widget.isFullScreenMode) {
      return;
    }
    widget.onMoveStart?.call(direction);
    setState(() {
      upStatus = direction == QcHikPlayerMoveDirection.up;
      downStatus = direction == QcHikPlayerMoveDirection.down;
      leftStatus = direction == QcHikPlayerMoveDirection.left;
      rightStatus = direction == QcHikPlayerMoveDirection.right;
    });
  }

  void _onMoveEnd() {
    if (!widget.isFullScreenMode) {
      return;
    }
    widget.onMoveEnd?.call();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      setState(() {
        upStatus = false;
        downStatus = false;
        leftStatus = false;
        rightStatus = false;
      });
    });
  }

  Widget _buildVolumeButton(double scaleFactor) {
    return IconButton(
      icon: Icon(
        _muted ? Icons.volume_off : Icons.volume_up,
        size: 24 * scaleFactor,
      ),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
      onPressed: _toggleVolume,
    );
  }

  Widget _buildBottomBar(double scaleFactor) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.7,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: 42 * scaleFactor,
        color: Colors.black.withOpacity(0.55),
        child: Row(
          children: [
            _buildVolumeButton(scaleFactor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4 * scaleFactor),
              child: Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 12 * scaleFactor,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            InkWell(
              onTap: _openFullScreen,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  12 * scaleFactor,
                  6 * scaleFactor,
                  12 * scaleFactor,
                  6 * scaleFactor,
                ),
                child: Icon(
                  widget.isFullScreenMode
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                  color: Colors.white,
                  size: 24 * scaleFactor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterLayer(double scaleFactor) {
    if (!_prepared) {
      return SizedBox(
        width: 26 * scaleFactor,
        height: 26 * scaleFactor,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2.6,
        ),
      );
    }
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.7,
      duration: const Duration(milliseconds: 400),
      child: IconButton(
        iconSize: 42 * scaleFactor,
        icon: Icon(
          _playing ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: _playOrPause,
      ),
    );
  }

  Widget _buildErrorLayer(Size viewSize) {
    final double width = viewSize.width;
    final double height = viewSize.height;
    final double iconSize = min(
      width * 0.15,
      height * 0.24,
    );
    final double textSize = min(width * 0.07, 16.0);
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height * 0.06),
          Image.asset(
            'assets/images/common/ic_video_error.png',
            width: iconSize,
            height: iconSize,
            fit: BoxFit.fill,
          ),
          SizedBox(height: height * 0.02),
          Text(
            '视频加载错误，请重试',
            style: TextStyle(
              color: const Color(0xFF666666),
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: _restartPlay,
            child: Container(
              margin: EdgeInsets.only(
                top: height * 0.05,
              ),
              padding: EdgeInsets.fromLTRB(
                height * 0.06,
                height * 0.01,
                height * 0.06,
                height * 0.015,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF999999).withAlpha(130),
                borderRadius: BorderRadius.circular(height * 0.02),
              ),
              child: Text(
                '重试',
                style: TextStyle(
                  color: const Color(0xFFD5D5D5),
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionTips(double scaleFactor) {
    return IgnorePointer(
      child: Stack(
        children: [
          if (upStatus)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 10 * scaleFactor),
                child: Image.asset(
                  'assets/images/common/move_up.png',
                  width: 36 * scaleFactor,
                  height: 36 * scaleFactor,
                ),
              ),
            ),
          if (downStatus)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10 * scaleFactor),
                child: Image.asset(
                  'assets/images/common/move_down.png',
                  width: 36 * scaleFactor,
                  height: 36 * scaleFactor,
                ),
              ),
            ),
          if (leftStatus)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 14 * scaleFactor),
                child: Image.asset(
                  'assets/images/common/move_left.png',
                  width: 36 * scaleFactor,
                  height: 36 * scaleFactor,
                ),
              ),
            ),
          if (rightStatus)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 14 * scaleFactor),
                child: Image.asset(
                  'assets/images/common/move_right.png',
                  width: 36 * scaleFactor,
                  height: 36 * scaleFactor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _isErrorState => _exception != null && _exception!.isNotEmpty;

  Widget _buildPlatformPlayerView() {
    final Map<String, dynamic> creationParams = widget.params.toMap();
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return const Center(child: Text('当前平台暂不支持'));
  }

  @override
  Widget build(BuildContext context) {
    final double componentWidth = MediaQuery.of(context).size.width;
    final double scaleFactor = widget.isFullScreenMode ? 1.15 : 1.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size viewSize = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTap: widget.enablePanel && !_isErrorState
              ? _cancelAndRestartTimer
              : null,
          onVerticalDragUpdate:
              widget.enablePanel && widget.isFullScreenMode && !_isErrorState
                  ? (details) {
                      if (details.delta.dy > 0) {
                        _onMoveUpdate(QcHikPlayerMoveDirection.down);
                      } else if (details.delta.dy < 0) {
                        _onMoveUpdate(QcHikPlayerMoveDirection.up);
                      }
                    }
                  : null,
          onVerticalDragEnd:
              widget.enablePanel && widget.isFullScreenMode && !_isErrorState
                  ? (_) => _onMoveEnd()
                  : null,
          onHorizontalDragUpdate:
              widget.enablePanel && widget.isFullScreenMode && !_isErrorState
                  ? (details) {
                      if (details.delta.dx > 0) {
                        _onMoveUpdate(QcHikPlayerMoveDirection.right);
                      } else if (details.delta.dx < 0) {
                        _onMoveUpdate(QcHikPlayerMoveDirection.left);
                      }
                    }
                  : null,
          onHorizontalDragEnd:
              widget.enablePanel && widget.isFullScreenMode && !_isErrorState
                  ? (_) => _onMoveEnd()
                  : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPlatformPlayerView(),
              if (widget.enablePanel && !_isErrorState)
                AbsorbPointer(
                  absorbing: _hideStuff,
                  child: Column(
                    children: [
                      SizedBox(height: 20 * scaleFactor),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Center(child: _buildCenterLayer(scaleFactor)),
                              _buildDirectionTips(scaleFactor),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomBar(scaleFactor),
                    ],
                  ),
                ),
              if (_isErrorState) Container(color: Colors.black),
              if (_isErrorState) _buildErrorLayer(viewSize),
              if (componentWidth == 0) const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

class _QcHikPlayerFullScreenPage extends StatefulWidget {
  final QcHikPlayerParams params;
  final QcHikPlayerMoveCallback? onMoveStart;
  final VoidCallback? onMoveEnd;

  const _QcHikPlayerFullScreenPage({
    required this.params,
    this.onMoveStart,
    this.onMoveEnd,
  });

  @override
  State<_QcHikPlayerFullScreenPage> createState() =>
      _QcHikPlayerFullScreenPageState();
}

class _QcHikPlayerFullScreenPageState
    extends State<_QcHikPlayerFullScreenPage> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: QcHikPlayerView(
                params: widget.params,
                onMoveStart: widget.onMoveStart,
                onMoveEnd: widget.onMoveEnd,
                isFullScreenMode: true,
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
