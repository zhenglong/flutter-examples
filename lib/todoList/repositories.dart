import 'dart:async';

import 'dart:io';

import 'dart:convert';

import 'package:flutter_app/todoList/models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

///
/// 把TodoList存储在本地文件系统
///
class FileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;
  const FileStorage(
      this.tag,
      this.getDirectory
   );

  Future<List<TodoEntity>> loadTodos() async {
    final file = await _getLocalFile();

    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);

    final todoes = (json['todos'])
      .map<TodoEntity>((todo) => TodoEntity.fromJson(todo))
      .toList();

    return todoes;
  }

  Future<File> saveTodos(List<TodoEntity> todos) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({'todos': todos.map((todo) => todo.toJson()).toList()}));
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/temp_$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}

///
/// Mock服务端存储TodoList
///
class WebClient {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  Future<List<TodoEntity>> fetchTodos() async {
    return Future.delayed(
        delay,
            () => [
          TodoEntity(
            'Buy food for da kitty',
            '1',
            'With the chickeny bits!',
            false,
          ),
          TodoEntity(
            'Find a Red Sea dive trip',
            '2',
            'Echo vs MY Dream',
            false,
          ),
          TodoEntity(
            'Book flights to Egypt',
            '3',
            '',
            true,
          ),
          TodoEntity(
            'Decide on accommodation',
            '4',
            '',
            false,
          ),
          TodoEntity(
            'Sip Margaritas',
            '5',
            'on the beach',
            true,
          ),
        ]);
  }

  Future<bool> postTodos(List<TodoEntity> todos) async {
    return Future.value(true);
  }
}

abstract class TodosRepository {
  Future<List<TodoEntity>> loadTodos();

  Future saveTodos(List<TodoEntity> todos);
}

abstract class ReactiveTodosRepository {
  Future<void> addNewTodo(TodoEntity todo);
  Future<void> deleteTodo(List<String> idList);
  Stream<List<TodoEntity>> todos();
  Future<void> updateTodo(TodoEntity todo);
}

///
/// TodoList的持久化类
///
class TodosRepositoryFlutter implements TodosRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TodosRepositoryFlutter({
    @required this.fileStorage,
    this.webClient = const WebClient()
  });

  Future<List<TodoEntity>> loadTodos() async {
    try {
      return await fileStorage.loadTodos();
    } catch (e) {
      final todos = await webClient.fetchTodos();

      fileStorage.saveTodos(todos);

      return todos;
    }
  }

  Future saveTodos(List<TodoEntity> todos) {
    return Future.wait<dynamic>([
      fileStorage.saveTodos(todos),
      webClient.postTodos(todos)
    ]);
  }
}

class ReactiveTodosRepositoryFlutter implements ReactiveTodosRepository {
  final TodosRepository _repository;
  final BehaviorSubject<List<TodoEntity>> _subject;
  bool _loaded = false;

  ReactiveTodosRepositoryFlutter({
    @required TodosRepository repository,
    List<TodoEntity> seedValue
  }) : this._repository = repository,
       this._subject = BehaviorSubject<List<TodoEntity>>.seeded(seedValue);

  @override
  Future<void> addNewTodo(TodoEntity todo) async {
    _subject.add(List.unmodifiable([]
      ..addAll(_subject.value ?? [])
      ..add(todo)));
    await _repository.saveTodos((_subject.value));
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    _subject.add(
      List<TodoEntity>.unmodifiable(_subject.value.fold<List<TodoEntity>>(<TodoEntity>[], (prev, entity) {
        return idList.contains(entity.id) ? prev : (prev..add(entity));
      }))
    );
    await _repository.saveTodos(_subject.value);
  }

  @override
  Stream<List<TodoEntity>> todos() {
    if (!_loaded) {
      _loadTodos();
    }
    return _subject.stream;
  }

  void _loadTodos() {
    _loaded = true;
    _repository.loadTodos().then((entities) {
      _subject.add(List<TodoEntity>.unmodifiable(
        []..addAll(_subject.value ?? [])..addAll(entities)
      ));
    });
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    _subject.add(
      List<TodoEntity>.unmodifiable(_subject.value.fold<List<TodoEntity>>(<TodoEntity>[], (prev, entity) {
        return prev..add(entity.id == todo.id ? todo : entity);
      }))
    );
    return _repository.saveTodos(_subject.value);
  }
}