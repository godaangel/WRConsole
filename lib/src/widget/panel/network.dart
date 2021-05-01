import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/provider/global_provider.dart';

import '../json_viewer.dart';

class WRConsoleNetworkPanel extends StatefulWidget {
  WRConsoleNetworkPanel({Key key}) : super(key: key);

  @override
  _WRConsoleNetworkPanelState createState() => _WRConsoleNetworkPanelState();
}

class _WRConsoleNetworkPanelState extends State<WRConsoleNetworkPanel> with WidgetsBindingObserver {
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(_controller.hasClients) {
        Timer(Duration(milliseconds: 300),
          () => _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeInOut));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.topLeft,
      child: Selector<WRConsoleGlobalProvider, List<Response>>(
        selector: (_, p) => p.httpLog,
        shouldRebuild: (previous, next) => true,
        builder: (context, value, child) {
          if(value.length == 0) {
            return Center(
              child: Text('No Network Data', style: Theme.of(context).textTheme.headline1,),
            );
          }
          return ListView.builder(
              controller: _controller,
              padding: EdgeInsets.only(
                  top: 0,
                  bottom: 10 + MediaQuery.of(context).padding.bottom,
                  right: 0,
                  left: 0),
              itemCount: value.length,
              itemBuilder: (context, index) {
                return WRConsoleNetworkPanelItem(
                  item: value[index],
                  index: index,
                );
              });
        },
      ),
    );
  }
}

class WRConsoleNetworkPanelItem extends StatelessWidget {
  final Response item;
  final int index;
  const WRConsoleNetworkPanelItem({Key key, this.item, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _url = item.request.path;
    String _urlFirst = _url.substring(0, _url.lastIndexOf('/'));
    String _urlLast = _url.substring(_url.lastIndexOf('/') + 1, _url.length);
    String _method = item.request.method;
    
    return Container(
      color: item.statusCode != 200 ? Colors.red[100] : (index.isOdd ? Colors.grey.withOpacity(0.1) : Colors.white),
      child: ExpansionTile(
        leading: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          color: Colors.grey.withOpacity(0.5),
          child: Text('$_method', style: Theme.of(context).textTheme.headline2,),
        ),
        title: Text('$_urlLast', style: Theme.of(context).textTheme.bodyText1,),
        subtitle: Text('$_urlFirst', style: Theme.of(context).textTheme.headline2,),
        expandedAlignment: Alignment.topLeft,
        childrenPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        children: <Widget>[
          ExpansionTile(
            childrenPadding: EdgeInsets.only(bottom: 10),
            title: Text('General', style: Theme.of(context).textTheme.subtitle1,),
            children: [
              NetWorkItem(
                title: 'Request Url',
                content: item.request.uri.toString(),
              ),
              NetWorkItem(
                title: 'Method',
                content: item.request.method,
              ),
              NetWorkItem(
                title: 'Status Code',
                content: item.statusCode.toString(),
              )
            ],
          ),
          ExpansionTile(
            title: Text('Response Header', style: Theme.of(context).textTheme.subtitle1,),
            children: genResponseHeader(),
          ),
          ExpansionTile(
            title: Text('Request Header', style: Theme.of(context).textTheme.subtitle1,),
            children: genRequestHeader(),
          ),
          ExpansionTile(
            title: Text('Request Payload', style: Theme.of(context).textTheme.subtitle1,),
            children: [
              NetWorkItem(
                child: JsonViewerWidget(_method == 'GET' ? item.request.queryParameters : item.request.data),
              ),
              SizedBox(height: 5,),
            ],
          ),
          ExpansionTile(
            title: Text('Response Preview', style: Theme.of(context).textTheme.subtitle1,),
            children: [
              NetWorkItem(
                child: JsonViewerWidget(item.data),
              ),
              SizedBox(height: 5,),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> genResponseHeader() {
    List<Widget> _list = [];
    item.headers.map.forEach((key, value) {
      _list.add(NetWorkItem(
        title: '$key',
        content: value.toString(),
      ));
    });
    return _list;
  }

  List<Widget> genRequestHeader() {
    List<Widget> _list = [];
    item.request.headers.forEach((key, value) {
      _list.add(NetWorkItem(
        title: '$key',
        content: value.toString(),
      ));
    });
    return _list;
  }
}

class NetWorkItem extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;
  const NetWorkItem({Key key, this.title, this.content, this.child}) : super(key: key);

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