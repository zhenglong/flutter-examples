import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/repositories.dart';
import './models.dart';
import 'package:path_provider/path_provider.dart';

typedef TodoUpdater(Todo todo, {
  bool complete,
  String id,
  String note,
  String task
});

class StateContainer extends StatefulWidget {
  final AppState state;
  final TodosRepository repository;
  final Widget child;

  StateContainer({
    @required this.child,
    this.repository = const TodosRepositoryFlutter(
      fileStorage: const FileStorage(
        'inherited_widget_sample',
        getApplicationDocumentsDirectory
      )
    ),
    this.state
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer) as _InheritedStateContainer).data;
  }

  @override
  State createState() {
    return StateContainerState();
  }
}

class StateContainerState extends State<StateContainer> {
  AppState state;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = AppState.loading();
    }

    widget.repository.loadTodos().then((loadedTodos) {
      setState(() {
        state = AppState(
          todos: loadedTodos.map(Todo.fromEntity).toList()
        );
      });
    }).catchError((err) {
      setState(() {
        state.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}