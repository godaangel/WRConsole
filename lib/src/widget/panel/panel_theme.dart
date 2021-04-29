import 'package:flutter/material.dart';

class PanelTheme extends StatelessWidget {
  final Widget child;
  PanelTheme({this.child});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          /// log日志样式
          bodyText1: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            height: 19.6 / 14,
            color: Colors.black,
          ),
          /// log时间样式
          headline1: TextStyle(
            fontSize: 14,
            height: 19.6 / 14,
            color: Colors.black,
          ),
          /// network子标题样式
          headline2: TextStyle(
            fontSize: 12,
            height: 16.8 / 12,
            color: Colors.black87,
          ),
          /// 单条请求block title样式
          subtitle1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 19.6 / 14,
            color: Colors.black,
          ),
          /// 单条请求label样式
          headline3: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16.8 / 12,
            color: Colors.black,
          ),
          /// 单条请求content样式
          bodyText2: TextStyle(
            fontSize: 12,
            height: 16.8 / 12,
            color: Colors.black,
          )
        ),
      ),
      child: child
    );
  }
}