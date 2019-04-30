import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/blocs.dart';

class Injector extends InheritedWidget {
  final TodosInteractor todosInteractor;
  
  Injector({
    Key key,
    @required this.todosInteractor,
    @required Widget child
  }) : super(key: key, child: child);

  static Injector of(BuildContext context) => context.inheritFromWidgetOfExactType(Injector);

  @override
  bool updateShouldNotify(Injector oldWidget) {
    return todosInteractor != oldWidget.todosInteractor;
  }
}