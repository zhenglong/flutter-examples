
import 'package:flutter/material.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> a;
    return Scaffold(
      appBar: AppBar(
        title: Text('route demo'),
      ),
      body: Text('route demo'),
    );
  }
}