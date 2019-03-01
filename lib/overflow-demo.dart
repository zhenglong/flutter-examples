import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('overflow-demo'),),
      body: OverflowDemo4(),
    );
  }
}

class OverflowDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          color: Colors.red,
          width: 100.0,
        ),
        LimitedBox(
          maxWidth: 10.0,
          child: Container(
            color: Colors.blue,
            width: 250.0,
          ),
        )
      ],
    );
  }
}

class OverflowDemo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      width: 200.0,
      height: 200.0,
      padding: const EdgeInsets.all(5.0),
      child: OverflowBox(
        alignment: Alignment.topLeft,
        maxWidth: 300.0,
        maxHeight: 500.0,
        child: Container(
          color: Color(0x33FF00FF),
          width: 400,
          height: 400,
        ),
      ),
    );
  }
}

class OverflowDemo3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: Container(
          color: Colors.red,
          width: 10,
          height: 300,
        ),
      ),
    );
  }
}

class OverflowDemo4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxWidth: 200,
      maxHeight: 200,
      child: Container(
        color: Colors.green,
        padding: const EdgeInsets.all(5.0),
        child: SizedOverflowBox(
            size: Size(200, 200),
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.red,
              width: 100,
              height: 300,
            ),
        )
      ),
    );
  }
}