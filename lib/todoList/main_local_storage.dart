import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/todoList/blocs.dart';
import 'package:flutter_app/todoList/main.dart' as app;
import 'package:flutter_app/todoList/repositories.dart';

void main() {
  app.main(todosInteractor: TodosInteractor(
    ReactiveTodosRepositoryFlutter(
      repository: TodosRepositoryFlutter(
        fileStorage: FileStorage('__bloc_local_storage', getApplicationDocumentsDirectory)
      )
    )
  ));
}