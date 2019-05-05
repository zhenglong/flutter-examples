import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/dependency_injection.dart';
import 'package:flutter_app/todoList/sampleTheme.dart';
import 'package:flutter_app/todoList/screens/add_edit_screen.dart';
import 'package:flutter_app/todoList/screens/home_screen.dart';
import 'package:flutter_app/todoList/widgets/todos_bloc_provider.dart';

void main({
  @required TodosInteractor todosInteractor
}) {
  runApp(Injector(
    todosInteractor: todosInteractor,
    child: TodosBlocProvider(
      bloc: TodosListBloc(todosInteractor),
      child: MaterialApp(
        title: 'todo list',
        theme: SampleTheme.theme,
        routes: {
          '/': (context) {
            return HomeScreen();
          },
          '/addTodo': (context) {
            return AddEditScreen(
              addTodo: TodosBlocProvider.of(context).addTodo,
            );
          },
        },
      ),
    ),
  ));
}