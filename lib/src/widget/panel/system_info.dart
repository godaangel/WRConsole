import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

class WRConsoleSystemInfo extends StatefulWidget {
  WRConsoleSystemInfo({Key key}) : super(key: key);

  @override
  _WRConsoleSystemInfoState createState() => _WRConsoleSystemInfoState();
}

class _WRConsoleSystemInfoState extends State<WRConsoleSystemInfo> {

  int megaByte = 1024 * 1024;

  List<Widget> _systemInfo = [];

  Timer _timer;

  @override
  void initState() {
    // _timer = Timer.periodic(Duration(milliseconds: 1000), (_) {
    //   getSystemInfoItem();
    // });
    getDeviceInfo();
    super.initState();
  }

  void getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;    
      getSystemInfoItem(_readAndroidBuildData(androidInfo));
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      getSystemInfoItem(_readIosDeviceInfo(iosInfo));
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  /// 转换系统设置
  void getSystemInfoItem(Map<String, dynamic> infoMap) {
    try {
      infoMap.forEach((key, value) {
        _systemInfo.add(SystemInfoItem(
          title: key,
          content: value.toString(),
        ));
      });
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView(
         children: _systemInfo,
       ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class SystemInfoItem extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;
  const SystemInfoItem({Key key, this.title, this.content, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null ? Expanded(
            flex: 0,
            child: Container(
              width: 120,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 10),
              child: Text('$title', style: Theme.of(context).textTheme.headline3, softWrap: false),
            ),
          ) : Container(),
          content != null ? Expanded(
            flex: 1,
            child: SelectableText('$content', style: Theme.of(context).textTheme.bodyText2,),
          ) : Container(),
          child != null ? Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: child,
            ),
          ) : Container(),
        ],
      ),
    );
  }
}