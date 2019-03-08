import 'package:flutter/material.dart';
import 'dart:convert';
import './model/mail.dart';
import './model/user.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var xx = jsonEncode(Email('邮件正文', '邮件标题', User('Jack', 'jack@test.com'), [User('Lucy', 'lucy@test.com')], sendTime: DateTime.now(), priority: 10));
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
