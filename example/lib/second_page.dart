import 'package:flutter/material.dart';
import 'package:wrconsole/wrconsole.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    WRPrint.error('跳到二级页面，啥都没有');
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: Text('二级页面'),
        ),
      ),
    );
  }
}