import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/models/log_model.dart';
import 'package:wrconsole/src/provider/global_provider.dart';

class WRConsoleLogPanel extends StatefulWidget {
  WRConsoleLogPanel({Key key}) : super(key: key);

  @override
  _WRConsoleLogPanelState createState() => _WRConsoleLogPanelState();
}

class _WRConsoleLogPanelState extends State<WRConsoleLogPanel> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 300),
          () => _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeInOut));
    return Container(
      alignment: Alignment.topLeft,
      child: Selector<WRConsoleGlobalProvider, List<LogModel>>(
        selector: (_, p) => p.consoleLog,
        shouldRebuild: (previous, next) => true,
        builder: (context, value, child) {
          if(value.length == 0) {
            return Center(
              child: Text('No Log Data', style: Theme.of(context).textTheme.headline1,),
            );
          }
          return ListView.builder(
              padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10 + MediaQuery.of(context).padding.bottom,
                  right: 0,
                  left: 0),
              controller: _controller,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return WRConsoleLogPanelLogItem(
                  item: value[index],
                );
              });
        },
      ),
    );
  }
}

class WRConsoleLogPanelLogItem extends StatelessWidget {
  final LogModel item;
  const WRConsoleLogPanelLogItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.logType == LogType.error
          ? Colors.red.withOpacity(0.3)
          : Colors.white,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '[${DateTime.fromMillisecondsSinceEpoch(item.timestamp).toString().split(" ").last.split(".").first}]: ',
            style: Theme.of(context).textTheme.headline1,
          ),
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                text: '${item.conetent}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
