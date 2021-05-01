import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WRConsoleWidgetsFlutterBinding extends WidgetsFlutterBinding {

  static WRConsoleWidgetsFlutterBinding get instance {
    return (WidgetsBinding.instance is WRConsoleWidgetsFlutterBinding) ? WidgetsBinding.instance : null;
  }

  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      WRConsoleWidgetsFlutterBinding();
    }
    return WidgetsBinding.instance;
  }

  void runApp(Widget app) {
    scheduleAttachRootWidget(app);
    scheduleWarmUpFrame();
  }
}