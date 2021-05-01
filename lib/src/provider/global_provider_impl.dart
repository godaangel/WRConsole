part of 'global_provider.dart';

class WRConsoleGlobalProviderImpl extends WRConsoleGlobalProvider {
  WRConsoleGlobalProviderImpl() {
    
  }

  @override
  void setConsoleLog(LogModel value){
    if(!_disposed) {
      _consoleLog = [..._consoleLog, value];
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        if(!_disposed) {
          notifyListeners();
        }
      });
    }
  }

  @override
  void clearConsoleLog() {
    _consoleLog.clear();
    if(!_disposed) {
      notifyListeners();
    }
  }

  @override
  void setNetworkLog(Response value){
    if(!_disposed) {
      _httpLog = [..._httpLog, value];
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        if(!_disposed) {
          notifyListeners();
        }
      });
    }
  }

  @override
  void clearNetworkLog() {
    _httpLog = [];
    if(!_disposed) {
      notifyListeners();
    }
  }

  @override
  void insertInitLog() {
    /// 初始化时读取遗漏的日志和请求信息
    try {
      if(WRConsoleStatic.beforeInitConsoleList.length != 0) {
        _consoleLog = [...WRConsoleStatic.beforeInitConsoleList, ..._consoleLog,];
        WRConsoleStatic.clearBeforeConsole();
      }
      if(WRConsoleStatic.beforeInitNetworkList.length != 0) {
        _httpLog = [...WRConsoleStatic.beforeInitNetworkList, ..._httpLog];
        WRConsoleStatic.clearBeforeNetwork();
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
