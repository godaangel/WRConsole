import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/provider/global_provider.dart';
import 'package:wrconsole/wrconsole.dart';

import 'console_static.dart';

/// dio拦截 https://juejin.cn/post/6844904169833234440
/// 拦截并打印对应的请求信息
class WRConsoleLoggingInterceptor extends Interceptor{
  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    if(WRConsoleStatic.context != null) {
      try {
        Provider.of<WRConsoleGlobalProvider>(WRConsoleStatic.context, listen: false).setNetworkLog(response);
      } catch (e) {
        print(e);
      }
    }else {
      WRConsoleStatic.setBeforeNetwork(response);
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    WRPrint.error("WRConsole: <-- Error -->");
    WRPrint.error(err.error);
    WRPrint.error(err.message);
    try {
      Response _res = err.response ?? Response(request: err.request);
      Provider.of<WRConsoleGlobalProvider>(WRConsoleStatic.context, listen: false).setNetworkLog(_res);
    } catch (e) {
      // print(e);
    }
    return super.onError(err);
  }
}