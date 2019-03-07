import 'package:flutter/material.dart';
import 'dart:math';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('animation-demo'),),
      body: AnimationDemo(),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    return sin(t * pi * 2);
  }
}

class AnimationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AnimationDemoState();
  }
}

class AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin<AnimationDemo> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}