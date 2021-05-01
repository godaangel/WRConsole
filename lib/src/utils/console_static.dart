import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wrconsole/src/models/log_model.dart';

class WRConsoleStatic {
  static OverlayEntry overlayEntry;
  static BuildContext context;
  
  /// 初始化之前可能遗漏的日志
  static List<LogModel> _beforeInitConsoleList = [];
  /// 初始化之前可能遗漏的请求
  static List<Response> _beforeInitNetworkList = [];

  /// 初始化之前可能遗漏的日志
  static List<LogModel> get beforeInitConsoleList => _beforeInitConsoleList;
  /// 初始化之前可能遗漏的请求
  static List<Response> get beforeInitNetworkList => _beforeInitNetworkList;


  /// 设置console
  static setBeforeConsole(LogModel value) {
    _beforeInitConsoleList.add(value);
  }

  /// 设置network
  static setBeforeNetwork(Response value) {
    _beforeInitNetworkList.add(value);
  }

  /// 清空console
  static clearBeforeConsole() {
    _beforeInitConsoleList.clear();
  }

  /// 清空network
  static clearBeforeNetwork() {
    _beforeInitNetworkList.clear();
  }
}