import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnBuildNode = Widget Function(
  JsonNode parent,
  String nodeName,
  dynamic nodeValue,
);

class JsonViewerRoot extends StatefulWidget {
  JsonViewerRoot({
    /// json object
    /// 要展示的对象
    @required this.jsonObj,

    /// Auto-expand level
    /// 自动展开层级
    this.expandDeep = 2,

    /// Build node callback
    /// 构建节点的回调
    this.onBuildNode,
  }) {
    if (this.onBuildNode == null) {
      this.onBuildNode = this.onBuildNodeDefault;
    }
  }

  final dynamic jsonObj;
  final int expandDeep;
  OnBuildNode onBuildNode;

  /// 默认的构建节点的回调, 当需要创建新的节点时触发
  Widget onBuildNodeDefault(
    JsonNode parent,
    String nodeName,
    dynamic nodeValue,
  ) {
    JsonNode node;
    double leftOffset;
    if (nodeValue == null) {
      node = JsonViewerNode();
    } else if (nodeValue is Map) {
      node = JsonViewerMapNode();
      leftOffset = 10;
    } else if (nodeValue is List) {
      node = JsonViewerListNode();
      leftOffset = 10;
    } else {
      node = JsonViewerNode();
      leftOffset = 0;
    }
    node.root = parent != null ? parent.root : this;
    node.parent = parent;
    node.nodeName = nodeName;
    node.nodeValue = nodeValue;
    node.leftOffset = leftOffset;
    node.expandDeep = parent != null ? parent.expandDeep - 1 : this.expandDeep;
    return node;
  }

  @override
  State<StatefulWidget> createState() => JsonViewerRootState();
}

class JsonViewerRootState extends State<JsonViewerRoot> {
  JsonViewerRootState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.onBuildNode(null, "[root]", this.widget.jsonObj);
  }
}

abstract class JsonNode<T> implements Widget {
  /// 最顶级的
  JsonViewerRoot root;

  /// 上一个节点
  JsonNode parent;

  /// 当前节点名
  String nodeName;

  /// 当前节点值
  T nodeValue;

  /// 左边偏移值
  double leftOffset;

  /// 自动展开层次, 每次构建节点减1
  int expandDeep;
}

abstract class JsonOpenNode implements Widget {
  bool isOpen = false;

  List<Widget> buildChild();
}

class JsonViewerMapNode extends StatefulWidget
    implements JsonNode<Map<String, dynamic>>, JsonOpenNode {
  @override
  State<StatefulWidget> createState() => JsonViewerMapNodeState();

  @override
  JsonViewerRoot root;
  @override
  JsonNode parent;
  @override
  String nodeName;
  @override
  Map<String, dynamic> nodeValue;

  @override
  bool isOpen = false;

  @override
  double leftOffset;

  @override
  List<Widget> buildChild() {
    List<Widget> result = <Widget>[];
    nodeValue.forEach((k, v) {
      result.add(root.onBuildNode(this, k, v));
    });
    return result;
  }

  @override
  int expandDeep;
}

/// map类型的节点
/// 如: {"key":value}
class JsonViewerMapNodeState extends State<JsonViewerMapNode> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isOpen = widget.expandDeep > 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = GestureDetector(
        onTap: () {
          this.setState(() {
            widget.isOpen = !widget.isOpen;
          });
        },
        child: Row(
          children: <Widget>[
            Icon(widget.isOpen ? Icons.arrow_drop_down : Icons.arrow_right),
            Text(
              widget.nodeName,
              style: TextStyle(color: Colors.indigo),
            )
          ],
        ));
    if (widget.isOpen) {
      result = Column(
        children: <Widget>[
          result,
          Padding(
            padding: EdgeInsets.only(left: widget.leftOffset),
            child: Column(
              children: widget.buildChild(),
            ),
          )
        ],
      );
    }

    return result;
  }
}

/// list类型的节点
/// 如: [value1,value2]
class JsonViewerListNode extends StatefulWidget
    implements JsonNode<List<dynamic>>, JsonOpenNode {
  @override
  State<StatefulWidget> createState() => JsonViewerListNodeState();

  @override
  JsonViewerRoot root;
  @override
  JsonNode parent;
  @override
  String nodeName;
  @override
  List<dynamic> nodeValue;

  @override
  bool isOpen = false;

  @override
  double leftOffset;

  @override
  List<Widget> buildChild() {
    List<Widget> result = <Widget>[];
    var i = 0;
    nodeValue.forEach((v) {
      result.add(root.onBuildNode(this, "[$i]", v));
      i++;
    });
    return result;
  }

  @override
  int expandDeep;
}

class JsonViewerListNodeState extends State<JsonViewerListNode> {
  @override
  void initState() {
    super.initState();
    widget.isOpen = widget.expandDeep > 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = GestureDetector(
        onTap: () {
          this.setState(() {
            widget.isOpen = !widget.isOpen;
          });
        },
        child: Row(
          children: <Widget>[
            Icon(widget.isOpen ? Icons.arrow_drop_down : Icons.arrow_right),
            Text(
              widget.nodeName,
              style: TextStyle(color: Colors.deepPurple),
            ),
            Text(
              " [${widget.nodeValue.length}]",
              style: TextStyle(color: Colors.indigoAccent),
            ),
          ],
        ));
    if (widget.isOpen) {
      result = Column(
        children: <Widget>[
          result,
          Padding(
            padding: EdgeInsets.only(left: widget.leftOffset),
            child: Column(
              children: widget.buildChild(),
            ),
          )
        ],
      );
    }

    return result;
  }
}

class JsonViewerNode extends StatelessWidget implements JsonNode {
  @override
  Widget build(BuildContext context) {
    var color = Colors.black;
    if (this.nodeValue == null) {
      color = Colors.redAccent;
    } else {
      switch (this.nodeValue.runtimeType) {
        case bool:
          color = Colors.teal;
          break;
        case int:
          color = Colors.lightGreen;
          break;
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: 24),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: '${this.nodeValue.toString()}'));
          return;
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.nodeName,
              style: TextStyle(color: Colors.black54),
            ),
            Text(" : "),
            Expanded(child: Text(
              this.nodeValue == null ? "null" : this.nodeValue.toString(),
              style: TextStyle(color: color),
            ),),
          ],
        ),
      ),
    );
  }

  @override
  JsonViewerRoot root;
  @override
  JsonNode parent;
  @override
  String nodeName;

  @override
  var nodeValue;

  @override
  double leftOffset;

  @override
  int expandDeep;
}
