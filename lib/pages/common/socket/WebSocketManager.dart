import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:iot/bus/bus_bean.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/CommonUtils.dart';
import 'package:iot/utils/EventBusUtils.dart';
import 'package:iot/utils/HhHttp.dart';
import 'package:iot/utils/HhLog.dart';
import 'package:iot/utils/RequestUtils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  late WebSocketChannel _channel;
  final String _serverUrl; //ws连接路径
  final String _accessToken; //登录携带的token
  bool _isConnected = false; //连接状态
  bool _isManuallyDisconnected = false; //是否为主动断开
  late Timer _heartbeatTimer; //心跳定时器
  late Timer _reconnectTimer; //重新连接定时器
  late AudioRecorder audioRecord = AudioRecorder();
  final Duration _reconnectInterval = const Duration(seconds: 5); //重新连接间隔时间
  final StreamController<String> _messageController =
      StreamController<String>();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final List<int> _audioBuffer = [];
  bool _isPlaying = false;

  StreamSubscription? mRecordingDataSubscription;
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();

  Stream<String> get messageStream => _messageController.stream; //监听的消息

  //初始化
  WebSocketManager(this._serverUrl, this._accessToken) {
    print('初始化');
    _heartbeatTimer = Timer(const Duration(seconds: 0), () {});
    _startConnection();

    init();
  }

  //建立连接
  void _startConnection() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_serverUrl));
      print('建立连接');
      _isConnected = true;
      ///打开音频播放器
      await _player.openPlayer();
      _channel.stream.listen(
        (data) {
          _isConnected = true;
          // print('已连接$data');
          if("$data".startsWith('[')){
            // print('已连接 Stream');
            // playStream(data);
            addAudioData(data);
          }else{
            // print('已连接 message');
            _onMessageReceived(data); // 其他消息转发出去
          }
        },
        onError: (error) {
          // 处理连接错误
          print('连接错误: $error');
          _onError(error);
        },
        onDone: _onDone,
      );
      // _sendInitialData(); // 连接成功后发送登录信息();
    } catch (e) {
      // 连接错误处理
      print('连接异常错误: $e');
      _onError(e);
    }
  }

  //断开连接
  void disconnect() {
    stopAudio();
    print('断开连接');
    _isConnected = false;
    _isManuallyDisconnected = true;
    _stopHeartbeat();
    _messageController.close();
    _channel.sink.close();

    // flutterSound.thePlayer.stopPlayer();
    // flutterSound.thePlayer.closePlayer();
  }

  //开始心跳
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      sendHeartbeat();
    });
  }

  //停止心跳
  void _stopHeartbeat() {
    _heartbeatTimer.cancel();
  }

  //重置心跳
  void _resetHeartbeat() {
    _stopHeartbeat();
    _startHeartbeat(); //开始心跳
  }

  // 发送心跳消息到服务器
  void sendHeartbeat() {
    if (_isConnected) {
      final message = {};
      final jsonString = jsonEncode(message); // 将消息对象转换为 JSON 字符串
      _channel.sink.add('' /*jsonString*/); // 发送心跳
      print('连接成功发送心跳消息到服务器$message');
    }
  }

  //发送信息
  void sendMessage(dynamic message) {
    final jsonString = jsonEncode(message); // 将消息对象转换为 JSON 字符串
    _channel.sink.add(jsonString); // 发送 JSON 字符串
  }

  //发送语音流
  void sendStream(dynamic message) {
    _channel.sink.add(message); // 发送blob
  }

  // 处理接收到的消息
  void _onMessageReceived(dynamic message) {
    // HhLog.d('socket 处理接收到的消息 : $message');
    try {
      dynamic messageDecode = jsonDecode(message);
      // HhLog.d('socket 处理接收到的消息 : $messageDecode');
      // HhLog.d('socket 处理接收到的消息 : ${messageDecode["SessionId"]}');
      if (messageDecode['SessionId'] != null) {
        _startHeartbeat();
        CommonData.sessionId = messageDecode['SessionId'];
        HhLog.d('socket SessionId = ${CommonData.sessionId}');
        chatCreate(CommonData.deviceNo);
      }
    } catch (e) {
      HhLog.e(e.toString());
    }
    _messageController.add(message);
  }

  Future<void> chatCreate(deviceNo) async {
    var tenantResult = await HhHttp()
        .request(RequestUtils.chatCreate, method: DioMethod.post, data: {
      "deviceNo": deviceNo,
      "state": '1',
      "sessionId": CommonData.sessionId,
    });
    HhLog.d("chatCreate socket -- $tenantResult");
    if (tenantResult["code"] == 0 && tenantResult["data"] != null) {
      Future.delayed(const Duration(seconds: 2),(){
        EventBusUtil.getInstance().fire(HhToast(title: '开始对讲'));
        EventBusUtil.getInstance().fire(Record());
        recordAudio();//TODO
      });
    } else {
      EventBusUtil.getInstance()
          .fire(HhToast(title: CommonUtils().msgString(tenantResult["msg"])));
    }
  }

  //异常
  void _onError(dynamic error) {
    // 处理错误
    print('Error: $error');
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) {
      // 如果不是主动断开连接，则尝试重连
      _reconnect();
    }
  }

  //关闭
  void _onDone() {
    print('WebSocket 连接已关闭');
    _isConnected = false;
    _stopHeartbeat();
    if (!_isManuallyDisconnected) {
      // 如果不是主动断开连接，则尝试重连
      _reconnect();
    }
  }

  // 重连
  void _reconnect() {
    // 避免频繁重连，启动重连定时器
    _reconnectTimer = Timer(_reconnectInterval, () {
      _isConnected = false;
      _channel.sink.close(); // 关闭之前的连接
      print('重连====================$_serverUrl===$_accessToken');
      _startConnection();
    });
  }

  FlutterSound flutterSound = FlutterSound();

  Future<void> recordAudio() async {
    HhLog.d("_recordAudio 0");
    /*late Stream<Uint8List> stream;
    if (await audioRecord.hasPermission()) {
      stream = await audioRecord.startStream(const RecordConfig(
          encoder: AudioEncoder.pcm16bits,*//* echoCancel: true, noiseSuppress: true*//*));
      stream.listen((data) async {
        HhLog.d("_recordAudio $data");
        sendMessage(data);//发送语音
        // _playAudio(data);
      },
          onDone: () async {
            // HhLog.d("_recordAudio ${await stream.first}");
            // _playAudio(await stream.first);
          },
          onError: (e) => HhLog.e(e.toString()));
    }

    // _playAudio(data);//处理并播放音频流*/




    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await mRecorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.record,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    //sampleRate = await _mRecorder!.getSampleRate();


    // assert(_mRecorderIsInited && _mPlayer!.isStopped);
    // var sink = await createFile();
    var recordingDataController = StreamController<FoodData>();
    mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          HhLog.d("_recordAudio 8- ");//${buffer.data}");
          if(_isConnected){
            sendStream(buffer.data);
          }
        });
    await mRecorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      bitRate: 16,
      sampleRate: 16000,
      // bufferSize: 8192,
    );
  }

  Uint16List uint8ListToUint16List(Uint8List uint8List) {
    final Uint16List uint16List = Uint16List(uint8List.length ~/ 2);
    for (int i = 0, j = 0; i < uint8List.length; i += 2, j++) {
      uint16List[j] = uint8List[i] << 8 | uint8List[i + 1];
    }
    return uint16List;
  }

  Future<void> stopRecording() async {
    // try {
    //   await audioRecord.stop();
    //   // onRecordDone();
    // } catch (e) {
    //   HhLog.e(e.toString());
    //
    // }


    await mRecorder!.stopRecorder();
    if (mRecordingDataSubscription != null) {
      await mRecordingDataSubscription!.cancel();
      mRecordingDataSubscription = null;
    }
  }

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> playStream(data) async {
    try {
      Uint8List soundBytes = Uint8List.fromList(data);
      // HhLog.d("Uint8List $soundBytes");
      print("playStream$data");
      _player.startPlayer(
          fromDataBuffer: soundBytes,
          codec: Codec.pcm16,
          // numChannels: 1,
          // sampleRate: 16000,
          // whenFinished: () {
          //   //next
          // }
          );
    } catch (e) {
      HhLog.e(e.toString());
    }
  }

  Future<void> playAudio() async {
    if (_audioBuffer.isEmpty) return;

    // 将 List<int> 转换为 Uint8List
    Uint8List audioBytes = Uint8List.fromList(_audioBuffer);

    // 播放音频数据
    await _player.startPlayer(
      fromDataBuffer: audioBytes,
      codec: Codec.pcm16, // 根据你的音频格式选择合适的 codec
      whenFinished: () {
        _isPlaying = false;
      },
    );

    _isPlaying = true;
  }

  void addAudioData(List<int> audioData) {
    _audioBuffer.addAll(audioData);

    // 如果未播放，开始播放
    if (!_isPlaying) {
      playAudio();
    }
  }

  void stopAudio() async {
    await _player.stopPlayer();
    _isPlaying = false;
    _audioBuffer.clear(); // 清空缓冲区
  }

  @override
  void dispose() {
    _player.closePlayer();
  }
}
