import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/models/todo.dart';

final todoListProvider = ChangeNotifierProvider<TodoListController>(
  (ref) {
    // 他の provider の値を参照する場合の書き方
    // settingsProvider から通知が来たらその変更を反映する
    final color = ref.watch(settingsProvider).color;

    // 初期化処理を書く場合の書き方
    return TodoListController(color: color);
  },
);

class TodoListController extends ChangeNotifier {
  TodoListController({required this.color});

  final Color color;
  Future<List<Todo>> get todoList => TodoRepository.instance.fetchTodoList();

  Future<void> addTodo(BuildContext context) async {
    String? description;

    // お行儀が悪いですがコントローラーの中で
    // context をつかってダイアログをひらいています。
    final ret = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextFormField(
            autofocus: true,
            onChanged: (value) => description = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('追加する'),
            ),
          ],
        );
      },
    );
    if (ret == true) {
      TodoRepository.instance.addTodo(Todo.create(description: description!));
      notifyListeners();
    }
  }

  void removeTodo(Todo todo) {
    TodoRepository.instance.removeTodo(todo);
    notifyListeners();
  }
}
