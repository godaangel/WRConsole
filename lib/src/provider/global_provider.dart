import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wrconsole/src/models/log_model.dart';

part 'global_provider_impl.dart';

abstract class WRConsoleGlobalProvider extends ChangeNotifier {
  bool _disposed = false;

  /// 面板的entry
  OverlayEntry panelEntry;

  List<LogModel> _consoleLog = [];
  /// console日志
  List<LogModel> get consoleLog => _consoleLog;
  /// 插入一条日志
  void setConsoleLog(LogModel value);
  /// 清空console面板
  void clearConsoleLog();

  List<Response> _httpLog = [];
  /// network日志
  List<Response> get httpLog => _httpLog;
  /// 插入一条network日志
  void setNetworkLog(Response value);
  /// 清空network面板
  void clearNetworkLog();

}