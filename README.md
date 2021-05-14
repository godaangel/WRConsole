# wrconsole

一款能够在手机端进行基础调试的小工具. 解决了调试网络请求需要接入代理，调试很麻烦的问题。同时测试版也可以带上这个调试工具，如果测试人员发现问题，可以及时跟进查看日志信息。

## 开始使用

### 安装

首先在pubspec.yaml文件里面配置  

### 使用

#### 1 基础使用方式

##### 1.1 初始化

在`main.dart`里面调用`WRConsole.init(context);`，可以参考`example`里面的代码，这个方法主要是在界面显示调试按钮，点击按钮唤起调试窗口

##### 1.2 网络请求监听

如果想要在调试窗口输出网络请求，请传入`dio`实例，如`WRConsole.init(context, dio: ApiManager.openapi.dio);`，其中`ApiManager.openapi.dio`就是你的工程里面的`dio`实例，这样在窗口中就可以看到网络请求了，此处请求设计跟chrome调试工具尽量保持了一致

##### 1.3 打印参数到调试界面

如果想要在调试窗口输出信息，可以使用`WRPrint.log(line);`或者`WRPrint.error(error);`输出

##### 1.4 关闭调试

调用`WRConsole.dispose();`来关闭调试

#### 2 高级使用方式

`main`函数里面不用`runApp`，而用`WRConsole.runApp(MyApp());`，这个会将系统`print`调试转发到`WRConsole`，网络请求还是需要单独初始化.
