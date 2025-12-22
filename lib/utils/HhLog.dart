
import 'package:event_bus/event_bus.dart';
import 'package:logger/logger.dart';
export 'dart:async';
class HhLog {///
  static Logger logger = Logger();

  // static t(String msg){
  //   logger.t(msg);
  // }
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
  // static f(String msg){
  //   logger.f(msg);
  // }
}