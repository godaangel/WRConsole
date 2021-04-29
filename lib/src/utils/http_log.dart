import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/provider/global_provider.dart';

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
    print("WRConsole: <-- ${response.statusCode} ${response.request.method} ${response.request.path}");
    print('WRConsole: ${response.data.toString()}');
    print("WRConsole: <-- END HTTP");
    if(WRConsoleStatic.context != null) {
      try {
        Provider.of<WRConsoleGlobalProvider>(WRConsoleStatic.context, listen: false).setNetworkLog(response);
      } catch (e) {
        print(e);
      }
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    print("WRConsole: <-- Error -->");
    print(err.error);
    print(err.message);
    return super.onError(err);
  }
}