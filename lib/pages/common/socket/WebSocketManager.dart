import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  late WebSocketChannel _channel;
  final String _serverUrl;
  final String _accessToken;

  bool _isConnected = false;
  bool _isManuallyDisconnected = false;

  late Timer _heartbeatTimer;
  late Timer _reconnectTimer;
  final Duration _reconnectInterval = const Duration(seconds: 5);

  // final StreamController<String> _messageController =
  // StreamController<String>();
  final StreamController<String> _messageController =
  StreamController<String>.broadcast();


  Stream<String> get messageStream => _messageController.stream;

  ///播放相关
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  StreamController<FoodData>? _playStreamController;
  bool _playerInited = false;

  ///录音相关
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  StreamSubscription? mRecordingDataSubscription;

  WebSocketManager(this._serverUrl, this._accessToken) {
    _heartbeatTimer = Timer(const Duration(seconds: 0), () {});
    _startConnection();
    initAudioSession();
  }

  ///WebSocket
  void _startConnection() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_serverUrl));
      _isConnected = true;
      HhLog.d("WebSocket 已连接");

      _channel.stream.listen(
            (data) {
          _isConnected = true;
          print('已连接$data');//TODO 测试

          ///二进制音频流
          if (data is Uint8List) {
            playPcmStream(data);
          } else {
            _onMessageReceived(data);
          }
        },
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      _onError(e);
    }
  }

  void disconnect() {
    print('断开连接');
    stopAudio();
    stopRecording();

    _isConnected = false;
    _isManuallyDisconnected = true;
    _stopHeartbeat();
    _messageController.close();
    _channel.sink.close();
  }

  ///心跳
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      sendHeartbeat();
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer.cancel();
  }

  void sendHeartbeat() {
    if (_isConnected) {
      _channel.sink.add('');
    }
  }

  ///消息
  void sendMessage(dynamic message) {
    _channel.sink.add(jsonEncode(message));
  }

  void sendStream(Uint8List data) {
    _channel.sink.add(data);
  }

  void _onMessageReceived(dynamic message) {
    try {
      final msg = jsonDecode(message);
      if (msg['SessionId'] != null) {
        _startHeartbeat();
        CommonData.sessionId = msg['SessionId'];
        chatCreate(CommonData.deviceNo);
      }
    } catch (_) {}

    _messageController.add(message);
  }

  Future<void> chatCreate(deviceNo) async {
    final res = await HhHttp().request(
      RequestUtils.chatCreate,
      method: DioMethod.post,
      data: {
        "deviceNo": deviceNo,
        "state": '1',
        "sessionId": CommonData.sessionId,
      },
    );

    if (res["code"] == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        EventBusUtil.getInstance().fire(HhToast(title: '开始对讲'));
        EventBusUtil.getInstance().fire(Record());
        recordAudio();
      });
    }
  }

  void _onError(error) {
    HhLog.e("WebSocket _onError");
    HhLog.e("WebSocket error: $error");
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) _reconnect();
    // EventBusUtil.getInstance().fire(ChatClose());
  }

  void _onDone() {
    HhLog.e("WebSocket _onDone");
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) _reconnect();
    // EventBusUtil.getInstance().fire(ChatClose());
  }

  void _reconnect() {
    _reconnectTimer = Timer(_reconnectInterval, () {
      _channel.sink.close();
      _startConnection();
    });
  }

  ///音频播放
  Future<void> initPlayer() async {
    if (_playerInited) return;

    await _player.openPlayer();
    _playStreamController = StreamController<FoodData>();

    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );

    _playStreamController!.stream.listen((food) {
      _player.foodSink?.add(food);
    });

    _playerInited = true;
    HhLog.d("播放器初始化完成");
  }

  Future<void> playPcmStream(Uint8List pcmData) async {
    if (!_playerInited) {
      await initPlayer();
    }
    _playStreamController?.add(FoodData(pcmData));
  }

  Future<void> stopAudio() async {
    await _player.stopPlayer();
    await _playStreamController?.close();
    _playStreamController = null;
    _playerInited = false;
  }

  ///录音
  Future<void> recordAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) return;

    await mRecorder!.openRecorder();

    final recordingDataController = StreamController<FoodData>();
    mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          // HhLog.d("_recordAudio 8- ${buffer.data}");//${buffer.data}");//TODO 测试
          if (_isConnected) {
            sendStream(buffer.data!);
          }
        });

    await mRecorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );
  }

  Future<void> stopRecording() async {
    await mRecorder?.stopRecorder();
    await mRecordingDataSubscription?.cancel();
    mRecordingDataSubscription = null;
  }

  ///AudioSession
  Future<void> initAudioSession() async {
    final session = await AudioSession.instance;

    await session.configure(
      const AudioSessionConfiguration(
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,

        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,

        avAudioSessionCategoryOptions:
        AVAudioSessionCategoryOptions.allowBluetooth,
      ),
    );
  }


  void dispose() {
    stopAudio();
    _player.closePlayer();
  }
}
