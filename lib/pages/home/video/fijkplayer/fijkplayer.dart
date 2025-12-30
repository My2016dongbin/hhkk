import 'dart:math';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhColors.dart';
import 'package:iot/utils/HhLog.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool? autoPlay;
  final FijkFit? fit;
  final FijkFit? fsFit;
  final VoidCallback onOuterTap;

  const VideoPlayerWidget({
    Key? key,
    required this.url,
    this.autoPlay = true,
    this.fit = FijkFit.contain,
    this.fsFit = FijkFit.fill,
    required this.onOuterTap,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late FijkPlayer player;
  late bool errorStatus = false;

  @override
  void initState() {
    super.initState();
    player = FijkPlayer();
    _initPlayer();
  }

  void _initPlayer() async {
    player.release();
    player = FijkPlayer();
    player.setOption(FijkOption.playerCategory, "mediacodec-hevc", 1);
    player.setOption(FijkOption.playerCategory, "framedrop", 1);
    player.setOption(FijkOption.playerCategory, "start-on-prepared", 0);
    player.setOption(FijkOption.playerCategory, "opensles", 0);
    player.setOption(FijkOption.playerCategory, "mediacodec", 0);
    player.setOption(FijkOption.playerCategory, "start-on-prepared", 1);
    player.setOption(FijkOption.playerCategory, "packet-buffering", 0);
    player.setOption(
        FijkOption.playerCategory, "mediacodec-auto-rotate", 0);
    player.setOption(FijkOption.playerCategory,
        "mediacodec-handle-resolution-change", 0);
    player.setOption(FijkOption.playerCategory, "min-frames", 2);
    player.setOption(FijkOption.playerCategory, "max_cached_duration", 3);
    player.setOption(FijkOption.playerCategory, "infbuf", 1);
    player.setOption(FijkOption.playerCategory, "reconnect", 5);
    player.setOption(FijkOption.playerCategory, "framedrop", 5);
    player.setOption(FijkOption.formatCategory, "rtsp_transport", 'tcp');
    player.setOption(
        FijkOption.formatCategory, "http-detect-range-support", 0);
    player.setOption(FijkOption.formatCategory, "analyzeduration", 1);
    player.setOption(FijkOption.formatCategory, "rtsp_flags", "prefer_tcp");
    player.setOption(FijkOption.formatCategory, "buffer_size", 1024);
    player.setOption(FijkOption.formatCategory, "max-fps", 0);
    player.setOption(FijkOption.formatCategory, "analyzemaxduration", 50);
    player.setOption(FijkOption.formatCategory, "dns_cache_clear", 1);
    player.setOption(FijkOption.formatCategory, "flush_packets", 1);
    player.setOption(FijkOption.formatCategory, "max-buffer-size", 0);
    player.setOption(FijkOption.formatCategory, "fflags", "nobuffer");
    player.setOption(FijkOption.formatCategory, "probesize", 200);
    player.setOption(
        FijkOption.formatCategory, "http-detect-range-support", 0);
    player.setOption(FijkOption.codecCategory, "skip_loop_filter", 48);
    player.setOption(FijkOption.codecCategory, "skip_frame", 0);
    // 添加播放器状态变化监听
    player.addListener(() async {
      HhLog.e("player.state ${player.state}");
      if (player.state == FijkState.started) {
        // 播放成功开始
        setState(() {
          errorStatus = false;
        });
        HhLog.d('Playback started successfully ${player.state}');
      }
      if (player.state == FijkState.error || player.state == FijkState.completed) {
        setState(() {
          errorStatus = true;
        });
        // 播放失败
        restartPlay(widget.url);
      }
    });
    await player.setDataSource(widget.url, autoPlay: widget.autoPlay??true);
  }

  late int time = 0;
  late int count = 0;
  Future<void> restartPlay(String url) async {
    if(DateTime.now().millisecondsSinceEpoch - time < 5000){
      Future.delayed(const Duration(milliseconds: 5000),(){
        restartPlay(url);
      });
      return;
    }
    time = DateTime.now().millisecondsSinceEpoch;
    count++;
    if(count > 3){
      HhLog.e("重播失败 重连次数已达上限");
      setState(() {
        errorStatus = true;
      });
      return;
    }
    setState(() {
      errorStatus = false;
    });
    try {
      await player.reset();
      await player.setDataSource(url, autoPlay: true);
    } catch (e) {
      HhLog.e("重播失败 => $e");
    }
  }

  late TransformationController transformationController = TransformationController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          return InteractiveViewer(
            panEnabled: true, // 是否允许拖动
            minScale: 1.0,
            maxScale: 10.0,
            onInteractionEnd:(a){
              transformationController.value = Matrix4.identity();
            },
            transformationController: transformationController,
            child: Stack(
              children: [
                FijkView(
                  player: player,
                  color: HhColors.blackRealColor,
                  fit: widget.fit??FijkFit.contain,
                  fsFit: widget.fsFit??FijkFit.contain,
                  panelBuilder: (player, data, context, viewSize, texturePos) {
                    return _AdaptiveFijkPanel(
                      player: player,
                      buildContext: context,
                      viewSize: viewSize,
                      texturePos: texturePos,
                      onOuterTap: widget.onOuterTap,
                    );
                  },
                ),
                errorStatus?Container(color: HhColors.blackRealColor,):const SizedBox(),
                errorStatus?Align(
                  alignment:Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: height*0.06,),
                      Image.asset(
                        "assets/images/common/ic_video_error.png",
                        width: width*0.15,
                        height: width*0.15,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: height*0.02,),
                      Text(
                        '视频加载错误，请重试',
                        style: TextStyle(
                            color: HhColors.gray6TextColor,
                            fontSize: width*0.07,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      ),
                      BouncingWidget(
                        duration: const Duration(milliseconds: 300),
                        scaleFactor: 1.2,
                        onPressed: () {
                          setState(() {
                            count = 0;
                            restartPlay(widget.url);
                            Future.delayed(const Duration(milliseconds: 1000),(){
                              errorStatus = false;
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: height*0.05),
                          padding: EdgeInsets.fromLTRB(height*0.06, height*0.01, height*0.06, height*0.015),
                          decoration: BoxDecoration(
                              color: HhColors.gray9TextColor.withAlpha(130),
                              borderRadius: BorderRadius.circular(height*0.02)
                          ),
                          child:
                          Text(
                            '重试',
                            style: TextStyle(
                                color: HhColors.whiteColorD5,
                                fontSize: width*0.07,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    ],
                  ),
                ):const SizedBox()
              ],
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    player.release();
    super.dispose();
  }
}

class _AdaptiveFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;
  final VoidCallback onOuterTap;

  const _AdaptiveFijkPanel({
    required this.player,
    required this.buildContext,
    required this.viewSize,
    required this.texturePos,
    required this.onOuterTap,
  });

  @override
  _AdaptiveFijkPanelState createState() => _AdaptiveFijkPanelState();
}

class _AdaptiveFijkPanelState extends State<_AdaptiveFijkPanel> {
  FijkPlayer get player => widget.player;

  Duration _duration = Duration();
  Duration _currentPos = Duration();
  Duration _bufferPos = Duration();

  bool _playing = false;
  bool _prepared = false;
  String? _exception;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;
  StreamSubscription? _bufferPosSubs;

  Timer? _hideTimer;
  bool _hideStuff = true;

  double _volume = 1.0;

  bool upStatus = false;
  bool downStatus = false;
  bool leftStatus = false;
  bool rightStatus = false;

  @override
  void initState() {
    super.initState();

    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;

    player.addListener(_playerValueChanged);

    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      setState(() {
        _currentPos = v;
      });
    });

    _bufferPosSubs = player.onBufferPosUpdate.listen((v) {
      setState(() {
        _bufferPos = v;
      });
    });
  }

  void _playerValueChanged() {
    FijkValue value = player.value;
    if (value.duration != _duration) {
      setState(() {
        _duration = value.duration;
      });
    }

    bool playing = (value.state == FijkState.started);
    bool prepared = value.prepared;
    String? exception = value.exception.message;
    if (playing != _playing ||
        prepared != _prepared ||
        exception != _exception) {
      setState(() {
        _playing = playing;
        _prepared = prepared;
        _exception = exception;
      });
    }
  }

  void _playOrPause() {
    if (_playing == true) {
      player.pause();
    } else {
      player.start();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _hideTimer?.cancel();

    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
    _bufferPosSubs?.cancel();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _cancelAndRestartTimer() {
    widget.onOuterTap.call();///外部点击
    if (_hideStuff == true) {
      _startHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  String _duration2String(Duration duration) {
    if (duration.inMilliseconds < 0) return "-: negtive";

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    int inHours = duration.inHours;
    return inHours > 0
        ? "$inHours:$twoDigitMinutes:$twoDigitSeconds"
        : "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildVolumeButton(double scaleFactor) {
    IconData iconData;
    if (_volume <= 0) {
      iconData = Icons.volume_off;
    } else {
      iconData = Icons.volume_up;
    }
    return IconButton(
      icon: Icon(iconData, size: 16.w*5 * scaleFactor),
      padding: EdgeInsets.only(left: 5.w * scaleFactor, right: 5.w * scaleFactor),
      onPressed: () {
        setState(() {
          _volume = _volume > 0 ? 0.0 : 1.0;
          player.setVolume(_volume);
        });
      },
    );
  }

  AnimatedOpacity _buildBottomBar(BuildContext context, double scaleFactor) {
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue =
    _seekPos > 0 ? _seekPos : _currentPos.inMilliseconds.toDouble();
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.7,
      duration: const Duration(milliseconds: 400),
      child: Container(
        height: 20.w*5 * scaleFactor,
        color: Theme.of(context).dialogBackgroundColor.withOpacity(0.8),
        child: Row(
          children: <Widget>[
            _buildVolumeButton(scaleFactor),
            Padding(
              padding: EdgeInsets.only(
                  right: 2.w * scaleFactor, left: 2.w * scaleFactor),
              child: Text(
                _duration2String(_currentPos),
                style: TextStyle(
                    fontSize: 9.sp*5 * scaleFactor,
                    color: Colors.white),
              ),
            ),
            _duration.inMilliseconds == 0
                ? const Expanded(child: Center())
                : Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 2.0 * scaleFactor, left: 2.0 * scaleFactor),
                child: FijkSlider(
                  value: currentValue,
                  cacheValue: _bufferPos.inMilliseconds.toDouble(),
                  min: 0.0,
                  max: duration,
                  onChanged: (v) {
                    _startHideTimer();
                    setState(() {
                      _seekPos = v;
                    });
                  },
                  onChangeEnd: (v) {
                    setState(() {
                      player.seekTo(v.toInt());
                      _currentPos =
                          Duration(milliseconds: _seekPos.toInt());
                      _seekPos = -1;
                    });
                  },
                ),
              ),
            ),
            _duration.inMilliseconds == 0
                ? Text("LIVE",
                    style: TextStyle(
                        fontSize: 9.sp*5 * scaleFactor,
                        color: Colors.white))
                : Padding(
              padding: EdgeInsets.only(
                  right: 2.0 * scaleFactor, left: 2.0 * scaleFactor),
              child: Text(
                _duration2String(_duration),
                style: TextStyle(
                    fontSize: 10.w*5 * scaleFactor,
                    color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                widget.player.value.fullScreen
                    ? player.exitFullScreen()
                    : player.enterFullScreen();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10.w*5*scaleFactor, 3.w*5*scaleFactor, 10.w*5*scaleFactor, 5.w*5*scaleFactor),
                child: Icon(
                    widget.player.value.fullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    size: 16.w*5 * scaleFactor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 根据组件大小计算缩放因子
    double componentWidth = player.value.fullScreen?widget.viewSize.height:widget.viewSize.width;
    double scaleFactor = componentWidth / 1.sw;

    /*Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height)
        : Rect.fromLTRB(
        max(0.0, widget.texturePos.left),
        max(0.0, widget.texturePos.top),
        min(widget.viewSize.width, widget.texturePos.right),
        min(widget.viewSize.height, widget.texturePos.bottom));*/
    Rect rect = Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height);

    return Positioned.fromRect(
      rect: rect,
      child: GestureDetector(
        /*onVerticalDragUpdate: !widget.player.value.fullScreen
            ? null
            : (details) {
          if (details.delta.dy > 0) {
            HhLog.d("滑动控制 下");
            EventBusUtil.getInstance().fire(Move(action: 0, code: "DOWN"));
            setState(() {
              downStatus = true;
              upStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          }
          if (details.delta.dy < 0) {
            HhLog.d("滑动控制 上");
            EventBusUtil.getInstance().fire(Move(action: 0, code: "UP"));
            setState(() {
              upStatus = true;
              downStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          }
        },
        onVerticalDragEnd: !widget.player.value.fullScreen
            ? null
            : (details) {
          Future.delayed(const Duration(milliseconds: 500), () {
            EventBusUtil.getInstance().fire(Move(action: 1, code: ""));
            setState(() {
              upStatus = false;
              downStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          });
        },
        onHorizontalDragUpdate: !widget.player.value.fullScreen
            ? null
            : (details) {
          if (details.delta.dx > 0) {
            HhLog.d("滑动控制 右");
            EventBusUtil.getInstance()
                .fire(Move(action: 0, code: "RIGHT"));
            setState(() {
              rightStatus = true;
              upStatus = false;
              downStatus = false;
              leftStatus = false;
            });
          }
          if (details.delta.dx < 0) {
            HhLog.d("滑动控制 左");
            EventBusUtil.getInstance()
                .fire(Move(action: 0, code: "LEFT"));
            setState(() {
              leftStatus = true;
              upStatus = false;
              downStatus = false;
              rightStatus = false;
            });
          }
        },
        onHorizontalDragEnd: !widget.player.value.fullScreen
            ? null
            : (details) {
          Future.delayed(const Duration(milliseconds: 500), () {
            EventBusUtil.getInstance().fire(Move(action: 1, code: ""));
            setState(() {
              upStatus = false;
              downStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          });
        },*/
        onTap: _cancelAndRestartTimer,
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Column(
            children: <Widget>[
              Container(height: 20.w*5 * scaleFactor),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _cancelAndRestartTimer();
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Center(
                            child: _exception != null
                                ? Text(
                              _exception!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.w*5 * scaleFactor,
                              ),
                            )
                                : (_prepared ||
                                player.state == FijkState.initialized)
                                ? AnimatedOpacity(
                                opacity: _hideStuff ? 0.0 : 0.7,
                                duration: Duration(milliseconds: 400),
                                child: IconButton(
                                    iconSize: 30.w*5 * scaleFactor,
                                    icon: Icon(
                                        _playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white),
                                    padding: EdgeInsets.only(
                                        left: 10.0 * scaleFactor,
                                        right: 10.0 * scaleFactor),
                                    onPressed: _playOrPause))
                                : SizedBox(
                              width: 20.w*5 * scaleFactor,
                              height: 20.w*5 * scaleFactor,
                              child: const CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation(
                                      Colors.white)),
                            )),
                        upStatus
                            ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin:
                            EdgeInsets.only(top: 2.w*5 * scaleFactor),
                            child: Image.asset(
                              "assets/images/common/move_up.png",
                              width: 20.w*5 * scaleFactor,
                              height: 20.w*5 * scaleFactor,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            : const SizedBox(),
                        downStatus
                            ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 2.w*5 * scaleFactor),
                            child: Image.asset(
                              "assets/images/common/move_down.png",
                              width: 20.w*5 * scaleFactor,
                              height: 20.w*5 * scaleFactor,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            : const SizedBox(),
                        leftStatus
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10.w*5 * scaleFactor),
                            child: Image.asset(
                              "assets/images/common/move_left.png",
                              width: 20.w*5 * scaleFactor,
                              height: 20.w*5 * scaleFactor,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            : const SizedBox(),
                        rightStatus
                            ? Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: 10.w*5 * scaleFactor),
                            child: Image.asset(
                              "assets/images/common/move_right.png",
                              width: 20.w*5 * scaleFactor,
                              height: 20.w*5 * scaleFactor,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(context, scaleFactor),
            ],
          ),
        ),
      ),
    );
  }
}
