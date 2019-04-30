import 'dart:async';
import 'package:flutter_app/todoList/models.dart';
import 'package:flutter_app/todoList/repositories.dart';
import 'package:rxdart/rxdart.dart';

class TodosInteractor {
  final ReactiveTodosRepository repository;

  TodosInteractor(this.repository);

  Stream<List<Todo>> get todos {
    return repository.todos().map((entities) => entities.map(Todo.fromEntity).toList());
  }

  Stream<Todo> todo(String id) {
    return todos.map((todos) {
      return todos.firstWhere(
          (todo) => todo.id == id,
        orElse: () => null
      );
    }).where((todo) => todo != null);
  }

  Stream<bool> get allComplete => todos.map(_allComplete);

  Stream<bool> get hasCompletedTodos => todos.map(_hasCompletedTodos);

  Future<void> updateTodo(Todo todo) => repository.updateTodo(todo.toEntity());

  Future<void> addNewTodo(Todo todo) => repository.addNewTodo((todo.toEntity()));

  Future<void> deleteTodo(String id) => repository.deleteTodo([id]);

  Future<void> clearCompleted([_]) async =>
    repository.deleteTodo(await todos.map(_completedTodoIds).first);

  Future<List<dynamic>> toggleAll([_]) async {
    final updates = await todos.map(_todosToUpdate).first;

    return Future.wait(
      updates.map((update) => repository.updateTodo(update.toEntity()))
    );
  }

  static List<Todo> _todosToUpdate(List<Todo> todos) {
    final allComplete = _allComplete(todos);
    
    return todos.fold<List<Todo>>([], (prev, todo) {
      if (allComplete) {
        return prev..add(todo.copyWith(complete: false));
      } else if (!allComplete && !todo.complete) {
        return prev..add(todo.copyWith(complete: true));
      } else {
        return prev;
      }
    });
  }

  static List<String> _completedTodoIds(List<Todo> todos) {
    return todos.fold<List<String>>([], (prev, todo) {
      if (todo.complete) {
        return prev..add(todo.id);
      } else {
        return prev;
      }
    });
  }

  static bool _hasCompletedTodos(List<Todo> todos) {
    return todos.any((todo) => todo.complete);
  }


  static bool _allComplete(List<Todo> todos) => todos.every((todo) => todo.complete);
}

class TodoBloc {
  final TodosInteractor _interactor;

  TodoBloc(TodosInteractor interactor) : _interactor = interactor;

  void deleteTodo(String id) => _interactor.deleteTodo(id);

  void updateTodo(Todo todo) => _interactor.updateTodo(todo);

  Stream<Todo> todo(String id) => _interactor.todo(id);
}

class StatsBloc {
  final TodosInteractor _interactor;

  StatsBloc(TodosInteractor interactor) : _interactor = interactor;

  Stream<int> get numActive => _interactor.todos.map(
          (List<Todo> todos) => todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum));

  Stream<int> get numComplete => _interactor.todos.map(
      (List<Todo> todos) => todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum)
  );
}

class TodosListBloc {
  final TodosInteractor _interactor;
  final _visibilityFilterController = BehaviorSubject<VisibilityFilter>.seeded(VisibilityFilter.all, sync: true);

  TodosListBloc(TodosInteractor interator) : _interactor = interator;

  void addTodo(Todo todo) => _interactor.addNewTodo(todo);

  void deleteTodo(String id) => _interactor.deleteTodo(id);

  void updateFilter(VisibilityFilter visibilityFilter) => _visibilityFilterController.add(visibilityFilter);

  void clearCompleted() => _interactor.clearCompleted();

  void toggleAll() => _interactor.toggleAll();

  void updateTodo(Todo todo) => _interactor.updateTodo(todo);

  Stream<VisibilityFilter> get activeFilter => _visibilityFilterController.stream;

  Stream<bool> get allComplete => _interactor.allComplete;

  Stream<bool> get hasCompletedTodos => _interactor.hasCompletedTodos;

  Stream<List<Todo>> get visibleTodos => Observable.combineLatest2<List<Todo>, VisibilityFilter, List<Todo>>(
    _interactor.todos,
    _visibilityFilterController.stream,
    _filterTodos
  );

  static List<Todo> _filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      switch(filter) {
        case VisibilityFilter.all:
          return true;
        case VisibilityFilter.active:
          return !todo.complete;
        case VisibilityFilter.completed:
          return todo.complete;
      }
    }).toList();
  }

  void close() {
    _visibilityFilterController.close();
  }
}