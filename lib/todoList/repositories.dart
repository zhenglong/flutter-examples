import 'dart:async';

import 'dart:io';

import 'dart:convert';

import 'package:flutter_app/todoList/models.dart';
import 'package:meta/meta.dart';

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

    final todos = (json['todos'])
      .map<TodoEntity>((todo) => TodoEntity.fromJson(todo))
      .toList();

    return todos;
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

class TodosRepository {
  final FileStorage fileStorage;
  final WebClient webClient;

  const TodosRepository({
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