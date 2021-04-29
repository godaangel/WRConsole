part of 'global_provider.dart';

class WRConsoleGlobalProviderImpl extends WRConsoleGlobalProvider {
  @override
  void setConsoleLog(LogModel value){
    if(!_disposed) {
      _consoleLog.add(value);
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
      _httpLog.add(value);
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
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
