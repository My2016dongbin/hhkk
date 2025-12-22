import 'package:flutter/cupertino.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  static final CustomNavigatorObserver _instance = CustomNavigatorObserver();

  static CustomNavigatorObserver getInstance() {
    return _instance;
  }
}
