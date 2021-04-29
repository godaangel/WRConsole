import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/provider/global_provider.dart';
import 'package:wrconsole/src/widget/panel.dart';

class SuspenSionButton extends StatefulWidget {
  /// 悬浮按钮
  SuspenSionButton({Key key}) : super(key: key);

  @override
  _SuspenSionButtonState createState() => _SuspenSionButtonState();
}

class _SuspenSionButtonState extends State<SuspenSionButton> {
  WRConsoleGlobalProvider _globalProvider;

  @override
  void initState() {
    Future.delayed(Duration(microseconds: 0)).then((value) {
      if(mounted) {
        _globalProvider = Provider.of<WRConsoleGlobalProvider>(context, listen: false);
      }
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: FlatButton(
        child: Text('WR', style: TextStyle(color: Colors.white,),),
        onPressed: () async {
          OverlayEntry entry = OverlayEntry(builder: (ctx) {
            return ChangeNotifierProvider.value(value: _globalProvider, child: Container(
              child: WRConsolePanel(),
            ),);
          });
          Overlay.of(context).insert(entry);
          _globalProvider.panelEntry = entry;
        },
      ),
    );
  }
}