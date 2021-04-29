import 'package:provider/provider.dart';
import 'package:wrconsole/src/models/log_model.dart';
import 'package:wrconsole/src/provider/global_provider.dart';
import 'package:wrconsole/src/utils/console_static.dart';

class WRPrint {
  /// 打印普通日志
  static log(dynamic value) async {
    String text = value.toString();
    LogModel _logModel = LogModel(
      conetent: text,
    );
    _doPrint(_logModel);
  }

  /// 打印错误日志
  static error(dynamic value) async {
    String text = value.toString();
    LogModel _logModel = LogModel(
      conetent: text,
      logType: LogType.error,
    );
    _doPrint(_logModel);
  }

  static _doPrint(LogModel _logModel) async {
    print('WRConsole: [${_logModel.logType}] ${_logModel.conetent}');
    if(WRConsoleStatic.context != null) {
      try {
        Provider.of<WRConsoleGlobalProvider>(WRConsoleStatic.context, listen: false).setConsoleLog(_logModel);
      } catch (e) {
        print(e);
      }
    }
  }
}