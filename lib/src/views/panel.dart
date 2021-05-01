import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wrconsole/src/provider/global_provider.dart';
import 'package:wrconsole/src/widget/panel/panel_theme.dart';
import 'package:wrconsole/src/widget/panel/system_info.dart';

import '../widget/panel/log.dart';
import '../widget/panel/network.dart';

class WRConsolePanel extends StatefulWidget {
  final WRConsoleGlobalProvider globalProvider;

  /// 调试工具展示界面
  WRConsolePanel({Key key, this.globalProvider}) : super(key: key);

  @override
  _WRConsolePanelState createState() => _WRConsolePanelState();
}

class _WRConsolePanelState extends State<WRConsolePanel> {
  TabController _tabController;
  WRConsoleGlobalProvider _globalProvider;

  @override
  void initState() {
    _globalProvider = Provider.of<WRConsoleGlobalProvider>(context, listen: false);
    _tabController = TabController(
      length: 3,
      vsync: ScrollableState(),
    );
    _tabController.addListener(() {
      setState(() {});
    });
    _globalProvider.insertInitLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
        child: PanelTheme(
          child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  _globalProvider
                      ?.panelEntry
                      ?.remove();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                color: Colors.white,
                child: DefaultTabController(
                  length: _tabController.length,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                          color: Colors.blue,
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: "console",
                              ),
                              Tab(
                                text: "network",
                              ),
                              Tab(
                                text: "system",
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            WRConsoleLogPanel(),
                            WRConsoleNetworkPanel(),
                            WRConsoleSystemInfo(),
                          ],
                        ),
                      ),
                      _tabController.index != 2 ? Expanded(
                        flex: 0,
                        child: TextButton(
                          onPressed: () {
                            if(_tabController.index == 0) {
                              _globalProvider?.clearConsoleLog();
                            }else{
                              _globalProvider?.clearNetworkLog();
                            }
                          },
                          child:  Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).padding.bottom + 20,
                            padding: EdgeInsets.only(top: 5, bottom: MediaQuery.of(context).padding.bottom),
                            child: Icon(Icons.delete_forever),
                          ),
                        ),
                      ) : Container(),
                    ],
                  ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
