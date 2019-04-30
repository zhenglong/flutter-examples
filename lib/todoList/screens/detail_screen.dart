import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/models.dart';
import 'package:flutter_app/todoList/screens/add_edit_screen.dart';
import 'package:flutter_app/todoList/widgets/loading.dart';

class DetailScreen extends StatefulWidget {
  final String todoId;
  final TodoBloc Function() initBloc;

  DetailScreen({
    @required this.todoId,
    @required this.initBloc
  }) : super(key: Key('todo_detail_screen'));

  @override
  State<StatefulWidget> createState() {
    
    return DetailScreenState();
  }
}

class DetailScreenState extends State<DetailScreen> {

  TodoBloc todoBloc;

  @override
  void initState() {
    super.initState();
    todoBloc = widget.initBloc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Todo>(
      stream: todoBloc.todo(widget.todoId).where((todo) => todo != null),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoadingSpinner();

        final todo = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('todo details'),
            actions: <Widget>[
              IconButton(
                key: Key('delete todo button'), 
                icon: Icon(Icons.delete),
                onPressed: () {
                  todoBloc.deleteTodo(todo.id);
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Checkbox(
                        value: todo.complete,
                        key: Key('details todo item checkbox'),
                        onChanged: (complete) {
                          todoBloc.updateTodo(todo.copyWith(complete: !todo.complete));
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 16.0
                            ),
                            child: Text(
                              todo.task,
                              key: Key('details todo item task'),
                              style: Theme.of(context).textTheme.headline,
                            ),
                          ),
                          Text(
                            todo.note,
                            key: Key('details todo item note'),
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            key: Key('edit todo tab'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddEditScreen(
                      todo: todo,
                      updateTodo: todoBloc.updateTodo,
                      key: Key('edit todo screen')
                    );
                  }
                )
              );
            },
          ),
        );
      },
    );
  }
}