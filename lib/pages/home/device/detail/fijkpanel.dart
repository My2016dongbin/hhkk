//MIT License
//
//Copyright (c) [2019] [Befovy]
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

// part of fijkplayer;

import 'dart:async';
import 'dart:math';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhLog.dart';

/// Default builder generate default [FijkPanel] UI
Widget hhFijkPanelBuilder(FijkPlayer player, FijkData data,
    BuildContext context, Size viewSize, Rect texturePos) {
  return _DefaultFijkPanel(
      player: player,
      buildContext: context,
      viewSize: viewSize,
      texturePos: texturePos);
}

/// Default Panel Widget
class _DefaultFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;

  const _DefaultFijkPanel({
    required this.player,
    required this.buildContext,
    required this.viewSize,
    required this.texturePos,
  });

  @override
  _DefaultFijkPanelState createState() => _DefaultFijkPanelState();
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

class _DefaultFijkPanelState extends State<_DefaultFijkPanel> {
  FijkPlayer get player => widget.player;

  Duration _duration = Duration();
  Duration _currentPos = Duration();
  Duration _bufferPos = Duration();

  bool _playing = false;
  bool _prepared = false;
  String? _exception;

  // bool _buffering = false;

  double _seekPos = -1.0;

  StreamSubscription? _currentPosSubs;

  StreamSubscription? _bufferPosSubs;
  //StreamSubscription _bufferingSubs;

  Timer? _hideTimer;
  bool _hideStuff = true;

  double _volume = 1.0;

  final barHeight = 40.0;

  bool upStatus = false;
  bool downStatus = false;
  bool leftStatus = false;
  bool rightStatus = false;

  double _scale = 1.0; // 当前的缩放比例
  double _previousScale = 1.0; // 上一次的缩放比例
  double _dx = 0.0; // 当前的水平偏移量
  double _dy = 0.0; // 当前的垂直偏移量

  bool _isScaling = false;  // 用于区分是否正在缩放
  int scaleTime = 0;

  @override
  void initState() {
    super.initState();

    _duration = player.value.duration;
    _currentPos = player.currentPos;
    _bufferPos = player.bufferPos;
    _prepared = player.state.index >= FijkState.prepared.index;
    _playing = player.state == FijkState.started;
    _exception = player.value.exception.message;
    // _buffering = player.isBuffering;

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
    if (_hideStuff == true) {
      _startHideTimer();
    }
    setState(() {
      _hideStuff = !_hideStuff;
    });
  }

  Widget _buildVolumeButton() {
    IconData iconData;
    if (_volume <= 0) {
      iconData = Icons.volume_off;
    } else {
      iconData = Icons.volume_up;
    }
    return IconButton(
      icon: Icon(iconData),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      onPressed: () {
        setState(() {
          _volume = _volume > 0 ? 0.0 : 1.0;
          player.setVolume(_volume);
        });
      },
    );
  }

  AnimatedOpacity _buildBottomBar(BuildContext context) {
    double duration = _duration.inMilliseconds.toDouble();
    double currentValue =
    _seekPos > 0 ? _seekPos : _currentPos.inMilliseconds.toDouble();
    currentValue = min(currentValue, duration);
    currentValue = max(currentValue, 0);
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 0.8,
      duration: Duration(milliseconds: 400),
      child: Container(
        height: barHeight,
        color: Theme.of(context).dialogBackgroundColor,
        child: Row(
          children: <Widget>[
            _buildVolumeButton(),
            Padding(
              padding: EdgeInsets.only(right: 5.0, left: 5),
              child: Text(
                '${_duration2String(_currentPos)}',
                style: TextStyle(fontSize: 14.0),
              ),
            ),

            _duration.inMilliseconds == 0
                ? Expanded(child: Center())
                : Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 0, left: 0),
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
                      print("seek to $v");
                      _currentPos =
                          Duration(milliseconds: _seekPos.toInt());
                      _seekPos = -1;
                    });
                  },
                ),
              ),
            ),

            // duration / position
            _duration.inMilliseconds == 0
                ? Container(child: const Text("LIVE"))
                : Padding(
              padding: EdgeInsets.only(right: 5.0, left: 5),
              child: Text(
                '${_duration2String(_duration)}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),

            IconButton(
              icon: Icon(widget.player.value.fullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen),
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
//              color: Colors.transparent,
              onPressed: () {
                widget.player.value.fullScreen
                    ? player.exitFullScreen()
                    : player.enterFullScreen();
              },
            )
            //
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Rect rect = player.value.fullScreen
        ? Rect.fromLTWH(0, 0, widget.viewSize.width, widget.viewSize.height)
        : Rect.fromLTRB(
        max(0.0, widget.texturePos.left),
        max(0.0, widget.texturePos.top),
        min(widget.viewSize.width, widget.texturePos.right),
        min(widget.viewSize.height, widget.texturePos.bottom));
    return Positioned.fromRect(
      rect: rect,
      child: GestureDetector(
        onVerticalDragUpdate: !widget.player.value.fullScreen
            ? null // 如果正在缩放，则不处理水平拖动
            : (details) {
          // 上下滑动控制 <0:上  >0:下
          if(details.delta.dy > 0){
            HhLog.d("滑动控制 下");
            EventBusUtil.getInstance().fire(Move(action: 0, code: "DOWN"));
            setState(() {
              downStatus = true;
              upStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          }
          if(details.delta.dy < 0){
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
            ? null // 如果正在缩放，则不处理水平拖动
            : (details){
          //终止滑动控制
          HhLog.d("滑动控制 终止");
          Future.delayed(const Duration(milliseconds: 500),(){
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
            ? null // 如果正在缩放，则不处理水平拖动
            : (details) {
          // 左右滑动控制 <0:左  >0:右
          if(details.delta.dx > 0){
            HhLog.d("滑动控制 右");
            EventBusUtil.getInstance().fire(Move(action: 0, code: "RIGHT"));
            setState(() {
              rightStatus = true;
              upStatus = false;
              downStatus = false;
              leftStatus = false;
            });
          }
          if(details.delta.dx < 0){
            HhLog.d("滑动控制 左");
            EventBusUtil.getInstance().fire(Move(action: 0, code: "LEFT"));
            setState(() {
              leftStatus = true;
              upStatus = false;
              downStatus = false;
              rightStatus = false;
            });
          }
        },
        onHorizontalDragEnd: !widget.player.value.fullScreen
            ? null // 如果正在缩放，则不处理水平拖动
            : (details){
          //终止滑动控制
          HhLog.d("滑动控制 终止");
          Future.delayed(const Duration(milliseconds: 500),(){
            EventBusUtil.getInstance().fire(Move(action: 1, code: ""));
            setState(() {
              upStatus = false;
              downStatus = false;
              leftStatus = false;
              rightStatus = false;
            });
          });
        },
        /*onScaleStart: (ScaleStartDetails details) {
          _isScaling = true; // 开始缩放
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          int time = DateTime.now().millisecondsSinceEpoch;
          if (time - scaleTime > 100) {
            scaleTime = time;

            // 处理缩放
            _scale = max(_previousScale * details.scale, 1.0);
            // 计算平移的偏移量
            _dx = details.focalPoint.dx - _dx;
            _dy = details.focalPoint.dy - _dy;
            EventBusUtil.getInstance().fire(Scale(scale: _scale,dx: _dx,dy: _dy));
          }
        },
        onScaleEnd: (ScaleEndDetails details) {
          _scale = 1.0;
          _dx = 0;
          _dy = 0;
          EventBusUtil.getInstance().fire(Scale(scale: _scale,dx: _dx,dy: _dy));

          _previousScale = _scale; // 保存当前缩放比例
          _isScaling = false; // 停止缩放
        },*/
        onTap: _cancelAndRestartTimer,
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child: Column(
            children: <Widget>[
              Container(height: barHeight),
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
                                fontSize: 25,
                              ),
                            )
                                : (_prepared ||
                                player.state == FijkState.initialized)
                                ? AnimatedOpacity(
                                opacity: _hideStuff ? 0.0 : 0.7,
                                duration: Duration(milliseconds: 400),
                                child: IconButton(
                                    iconSize: barHeight * 1.5,
                                    icon: Icon(
                                        _playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white),
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    onPressed: _playOrPause))
                                : SizedBox(
                              width: barHeight * 1,
                              height: barHeight * 1,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white)),
                            )),

                        upStatus?Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 2.w*3),
                            child: Image.asset(
                              "assets/images/common/move_up.png",
                              width: 30.w*3,
                              height: 30.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ):const SizedBox(),
                        downStatus?Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2.w*3),
                            child: Image.asset(
                              "assets/images/common/move_down.png",
                              width: 30.w*3,
                              height: 30.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ):const SizedBox(),
                        leftStatus?Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 20.w*3),
                            child: Image.asset(
                              "assets/images/common/move_left.png",
                              width: 30.w*3,
                              height: 30.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ):const SizedBox(),
                        rightStatus?Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 20.w*3),
                            child: Image.asset(
                              "assets/images/common/move_right.png",
                              width: 30.w*3,
                              height: 30.w * 3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ):const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }
}
