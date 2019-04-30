import 'package:flutter/material.dart';
import 'package:flutter_app/todoList/models.dart';

class TodoItem extends StatelessWidget {

  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;

  TodoItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: Key(todo.id),
          value: todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Text(todo.task, key: Key('todo_item_task_${todo.id}'), style: Theme.of(context).textTheme.title,),
        subtitle: Text(
          todo.note, 
          key: Key('todo_item_note_${todo.id}'), 
          style: Theme.of(context).textTheme.subhead,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}