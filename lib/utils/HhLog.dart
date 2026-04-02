import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
export 'dart:async';
class HhLog {
  static Logger logger = Logger();

  static d(String msg){
    logger.d(msg);
  }
  static i(String msg){
    logger.i(msg);
  }
  static w(String msg){
    logger.w(msg);
  }
  static e(String msg){
    logger.e(msg);
  }


  static void l(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      debugPrint(text.substring(i, end));
    }
  }
}