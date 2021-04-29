enum LogType {
  log,
  error,
}

class LogModel {
  /// 时间戳
  int timestamp;
  /// 日志类型
  LogType logType;
  /// 日志内容
  String conetent;
  /// 错误堆栈
  StackTrace stackTrace;
  LogModel({this.logType = LogType.log, this.conetent, this.stackTrace}) {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    stackTrace = StackTrace.current;
  }
}