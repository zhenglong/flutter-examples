import 'package:uuid/uuid.dart';

class TodoEntity {
  String task;
  String id;
  String note;
  bool complete;

  TodoEntity(this.task, this.id, this.note, this.complete);

  @override
  int get hashCode => complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator==(Object other) =>
    identical(this, other) || (other is TodoEntity &&
        runtimeType == other.runtimeType &&
        complete == other.complete &&
        task == other.task && note == other.note
        && id == other.id);

  Map<String, Object> toJson() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
      'id': id
    };
  }

  @override
  String toString() {
    return 'TodoEntity{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static TodoEntity fromJson(Map<String, Object> json) {
    return TodoEntity(
      json['task'] as String,
      json['id'] as String,
      json['note'] as String,
      json['complete'] as bool
    );
  }
}

class Todo {
  bool complete;
  String id;
  String note;
  String task;

  Todo(this.task, {this.complete = false, this.note = '', String id})
    : this.id = id ?? Uuid().v4();

  @override
  int get hashCode => complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Todo &&
      runtimeType == other.runtimeType &&
      complete == other.complete &&
      task == other.task &&
      note == other.note &&
      id == other.id;

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  TodoEntity toEntity() {
    return TodoEntity(task, id, note, complete);
  }

  static Todo fromEntity(TodoEntity entity) {
    return Todo(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id ?? Uuid().v4()
    );
  }
}



enum AppTab { todos, state }

enum ExtraAction { toggleAllComplete, clearCompleted }

enum VisibilityFilter {
  all,
  active,
  completed
}

class AppState {
  bool isLoading;
  List<Todo> todos;
  VisibilityFilter activeFilter = VisibilityFilter.all;

  AppState({
    this.isLoading = false,
    this.todos = const [],
    this.activeFilter = VisibilityFilter.all
  });

  factory AppState.loading() => AppState(isLoading: true);

  bool get allComplete => todos.every((todo) => todo.complete);

  List<Todo> get filteredTodos => todos.where((todo) {
    if (activeFilter == VisibilityFilter.all) {
      return true;
    } else if (activeFilter == VisibilityFilter.active) {
      return !todo.complete;
    } else if (activeFilter == VisibilityFilter.completed) {
      return todo.complete;
    }
  }).toList();

  bool get hasCompletedTodos => todos.any((todo) => todo.complete);

  @override
  int get hashCode => todos.hashCode ^ isLoading.hashCode;

  int get numActive => todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  int get numCompleted => todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is AppState && runtimeType == other.runtimeType &&
      todos == other.todos && isLoading == other.isLoading;

  void clearCompleted() {
    todos.removeWhere((todo) => todo.complete);
  }

  void toggleAll() {
    final allCompleted = this.allComplete;
    todos.forEach((todo) => todo.complete = !allCompleted);
  }

  @override
  String toString() {
    return 'AppState{todos:$todos, isLoading: $isLoading}';
  }


}