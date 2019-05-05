import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/dependency_injection.dart';
import 'package:flutter_app/todoList/models.dart';
import 'package:flutter_app/todoList/screens/detail_screen.dart';
import 'package:flutter_app/todoList/widgets/loading.dart';
import 'package:flutter_app/todoList/widgets/todo_item.dart';
import 'package:flutter_app/todoList/widgets/todos_bloc_provider.dart';

class TodoList extends StatelessWidget {

  TodoList({Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: TodosBlocProvider.of(context).visibleTodos,
      builder: (context, snapshot) => snapshot.hasData 
        ? _buildList(snapshot.data) : LoadingSpinner(key: Key('todosloading')),
    );
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
    _showUndoSnackbar(context, todo);
  }

  void _showUndoSnackbar(BuildContext context, Todo todo) {
    final snackBar = SnackBar(
      key: Key('snackBar'),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(
        'deleted ${todo.task}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      action: SnackBarAction(
        key: Key('snackbaraction_${todo.id}'),
        label: 'Undo',
        onPressed: () {
          TodosBlocProvider.of(context).addTodo(todo);
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}