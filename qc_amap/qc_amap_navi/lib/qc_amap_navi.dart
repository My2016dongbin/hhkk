import 'package:flutter/services.dart';

class QcAmapNavi {
  static const MethodChannel _channel = MethodChannel('flutter_amap_navi');

  static Future<void> startNavigation({
    required double fromLat,
    required double fromLng,
    required String fromName,
    required double toLat,
    required double toLng,
    required String toName,
  }) async {
    await _channel.invokeMethod('startNavi', {
      'fromLat': fromLat,
      'fromLng': fromLng,
      'fromName': fromName,
      'toLat': toLat,
      'toLng': toLng,
      'toName': toName,
    });
  }

  static Future<void> openOfflineMap() async {
    await _channel.invokeMethod('openOfflineMap');
  }
}
