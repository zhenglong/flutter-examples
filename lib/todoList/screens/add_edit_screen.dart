

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

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _task;
  String _note;

  bool get isEditing => widget.todo != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'edit todo' : 'add todo')
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: widget.todo != null ? widget.todo.task : '',
                key: Key('taskfield'),
                autofocus: !isEditing,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: 'new todo hint'
                ),
                validator: (val) => val.trim().isEmpty ? 'empty todo error' : null,
                onSaved: (value) => _task = value,
              ),
              TextFormField(
                initialValue: widget.todo != null ? widget.todo.note : '',
                key: Key('notefield'),
                maxLength: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: 'notes hint'
                ),
                onSaved: (value) => _note = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: isEditing ? Key('saveTodoFab') : Key('saveNewTodo'),
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();

            if (isEditing) {
              widget.updateTodo(widget.todo.copyWith(task: _task, note: _note));
            } else {
              widget.addTodo(Todo(_task, note: _note));
            }

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}