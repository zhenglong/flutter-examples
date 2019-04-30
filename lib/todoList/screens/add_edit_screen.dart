

import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/models.dart';

class AddEditScreen extends StatefulWidget {

  final Todo todo;
  final Function(Todo) addTodo;
  final Function(Todo) updateTodo;

  AddEditScreen({
    Key key,
    this.todo,
    this.addTodo,
    this.updateTodo
  }) : super(key: key ?? Key('add todo screen'));

  @override
  State<StatefulWidget> createState() {
    return _AddEditScreenState();
  }
}

class _AddEditScreenState extends State<AddEditScreen> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}