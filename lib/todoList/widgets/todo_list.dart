import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/dependency_injection.dart';
import 'package:flutter_app/todoList/models.dart';
import 'package:flutter_app/todoList/screens/detail_screen.dart';
import 'package:flutter_app/todoList/widgets/todo_item.dart';
import 'package:flutter_app/todoList/widgets/todos_bloc_provider.dart';

class TodoList extends StatelessWidget {

  TodoList({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  ListView _buildList(List<Todo> todos) {
    return ListView.builder(
      key: Key('todo-list'),
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = todos[index];

        return TodoItem(
          todo: todo,
          onDismissed: (direction) {
            _removeTodo(context, todo);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return DetailScreen(
                    todoId: todo.id,
                    initBloc: () => TodoBloc(Injector.of(context).todosInteractor),
                  );
                }
              )
            ).then((todo) {
              if (todo is Todo) {
                _showUndoSnackbar(context, todo);
              }
            });
          },
        );
      },
    );
  }

  void _removeTodo(BuildContext context, Todo todo) {
    TodosBlocProvider.of(context).deleteTodo(todo.id);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    
  }
}