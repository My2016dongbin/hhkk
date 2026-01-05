import 'dart:async';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:iot/pages/common/common_data.dart';
import 'package:iot/utils/HhLog.dart';

class AmapLocationService {
  static final AmapLocationService _instance = AmapLocationService._internal();
  factory AmapLocationService() => _instance;

  AmapLocationService._internal() {
    //必须在实例化前调用隐私声明
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
  }

  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  StreamSubscription<Map<String, Object>>? _locationSub;

  bool _isStarted = false;

  bool _hasResult = false;


  bool get hasResult => _hasResult;

  Future<void> init() async {
    //请求权限（防止第一次冷启动没权限导致无回调）
    final status = await Permission.location.request();
    if (!status.isGranted) {
      HhLog.d('定位权限未授权');
      return;
    }
    HhLog.d('定位服务初始化完成');
  }

  void startLocation() {
    if (_isStarted) return;
    _isStarted = true;

    final option = AMapLocationOption()
      ..onceLocation = false
      ..needAddress = true
      ..locationInterval = 10000
      ..geoLanguage = GeoLanguage.DEFAULT
      ..locationMode = AMapLocationMode.Hight_Accuracy;

    _locationPlugin.setLocationOption(option);

    //保证只有一个订阅
    _locationSub?.cancel();
    _locationSub = _locationPlugin.onLocationChanged().listen((result) {
      HhLog.d('定位结果: $result');
      _hasResult = true;

      final lat = result['latitude'];
      final lon = result['longitude'];

      if (lat != null && lon != null) {
        CommonData.latitude = lat as double?;
        CommonData.longitude = lon as double?;
      }
    });

    //延迟启动，确保原生SDK初始化完成
    Future.delayed(const Duration(milliseconds: 800), () {
      _locationPlugin.startLocation();
    });
  }

  void stopLocation() {
    _isStarted = false;
    _locationPlugin.stopLocation();
    _locationSub?.cancel();
    _locationSub = null;
  }

  void dispose() {
    _isStarted = false;
    _locationSub?.cancel();
    _locationPlugin.destroy();
  }
}
