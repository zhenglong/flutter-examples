import 'package:flutter/material.dart';

const width = 80.0;
const height = 60.0;

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: FlowDemo(),
      ),
    );
  }
}

class FlowDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flow(
      children: <Widget>[
        new Container(width: width, height: height, color: Colors.yellow,),
        new Container(width: width, height: height, color: Colors.green,),
        new Container(width: width, height: height, color: Colors.red,),
        new Container(width: width, height: height, color: Colors.black,),
        new Container(width: width, height: height, color: Colors.blue,),
        new Container(width: width, height: height, color: Colors.lightGreenAccent,),
      ],
      delegate: TestFlowDelegate(margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0)),
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;

  TestFlowDelegate({this.margin});

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i, transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        context.paintChild(i, transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}