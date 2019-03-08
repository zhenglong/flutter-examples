import 'package:flutter/material.dart';
import 'dart:convert';
import './model/user.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var xx = jsonEncode(User('Jack', 'jack@test.com'));
    return Scaffold(
      appBar: AppBar(title: Text('parse json demo')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(xx),
        ),
      ),
    );
  }
}
