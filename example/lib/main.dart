import 'package:flutter/material.dart';
import 'package:wrconsole/wrconsole.dart';

import 'second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Test Page'),
    );
  }
}

class MySelfModel {
  String name;
  String nickname;
  int age;

  MySelfModel(this.name, this.nickname, this.age);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool showConsole = true;

  @override
  void initState() {
    WRConsole.show(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                WRPrint.log('点击跳转二级页面');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(),
                  ),
                );
              },
              child: Text(
                '点击去二级页面',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showConsole = !showConsole;
                if(!showConsole) {
                  WRConsole.dispose();
                }else{
                  WRConsole.show(context);
                }
                setState(() {
                  
                });
              },
              child: Text(
                showConsole ? '关闭' : '打开',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
