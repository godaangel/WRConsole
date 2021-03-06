import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/wrconsole.dart';

import 'provider/global_provider.dart';
import 'utils/console_static.dart';
import 'widget/suspension_button.dart';
import 'package:flutter/widgets.dart';

class WRConsole {
  static OverlayEntry _overlayEntry;
  static WRConsoleGlobalProvider _wrConsoleGlobalProvider;
  static BuildContext _context;
  static Dio _dio;
  static Size _screenSize;

  /// 启动app和日志监控
  static void runApp(Widget app) {
    runZonedGuarded(
      () {
        WRConsoleWidgetsFlutterBinding.ensureInitialized();
        WRConsoleWidgetsFlutterBinding.instance.runApp(app);
      },
      // 处理Zone中的未捕获异常
      (Object error, StackTrace stack) async {
        WRPrint.error(error);
      },
      // 拦截日志输出
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) async {
          WRPrint.log(line);
        },
      ),
    );
  }

  /// 初始化调试工具
  static Future<void> init(BuildContext context, {Dio dio}) async {
    Completer<void> consoleCompleter = Completer();
    _context = context;
    _wrConsoleGlobalProvider = WRConsoleGlobalProviderImpl();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// 初始化按钮位置
      _screenSize = MediaQuery.of(context).size;
      double right = _screenSize.width - 70;
      double bottom = (_screenSize.height + 60) * 2 / 3;
      _addOverlayEntry(right, bottom);
      /// 如果有dio，则加入dio监听
      if(dio != null) {
        _dio = dio;
        dio.interceptors.add(WRConsoleLoggingInterceptor());
      }
      consoleCompleter.complete();
    });
    return consoleCompleter.future;
  }

  /// 关闭和销毁调试工具
  static dispose() {
    _dio?.interceptors?.clear();
    _overlayEntry?.remove();
    _overlayEntry = null;
    WRConsoleStatic.context = null;
  }

  /// 添加悬浮按钮
  static _addOverlayEntry(double left, double top) {
    try {
      _overlayEntry?.remove();
      _overlayEntry = OverlayEntry(
        builder: (BuildContext ctx) {
          return ChangeNotifierProvider.value(
            value: _wrConsoleGlobalProvider,
            builder: (context, child) {
              WRConsoleStatic.context = context;
              return Positioned(
                top: top,
                left: left,
                child: Draggable(
                  onDragEnd: (DraggableDetails details) {
                    double left = _screenSize.width - 70;
                    double top = details.offset.dy;
                    if(top + 80 > _screenSize.height) {
                      top = _screenSize.height - 80;
                    }else if(top < 20) {
                      top = 20;
                    }

                    if(details.offset.dx < (_screenSize.width + 60)/2) {
                      left = 10;
                    }
                    ///拖动结束
                    _addOverlayEntry(left, top);
                  },
                  onDragStarted: () {
                    
                  },
                  ///feedback是拖动时跟随手指滑动的Widget。
                  feedback: SuspenSionButton(),
                  childWhenDragging: Container(),
                  ///child是静止时显示的Widget，
                  child: SuspenSionButton(),
                ),
              );
            },
          );
        },
      );

      Overlay.of(_context).insert(_overlayEntry);
    } catch (e) {
      print(e);
    }
    
  }
}