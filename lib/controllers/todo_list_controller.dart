import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/models/todo.dart';

final todoListProvider = ChangeNotifierProvider<TodoListController>(
  (ref) {
    // 他の provider の値を参照する場合の書き方
    final color = ref.watch(settingsProvider).color;

    // 初期化処理を書く場合の書き方
    return TodoListController(color: color).._init();
  },
);

class TodoListController extends ChangeNotifier {
  TodoListController({required this.color}) {
    // 初期化処理はこっちに書いてもよい
    // _init();
  }

  final Color color;
  final List<Todo> todoList = <Todo>[];

  /// 初期化処理。Todo リストを fetch してくる。
  Future<void> _init() async {
    todoList.addAll(await TodoRepository.instance.fetchTodoList());
    notifyListeners();
  }

  Future<void> addTodo(BuildContext context) async {
    String? description;

    // お行儀が悪いですがコントローラーの中で
    // context をつかってダイアログを表示しています。
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
      todoList.add(Todo.create(description: description!));
      notifyListeners();
    }
  }

  void removeTodo(Todo todo) {
    todoList.remove(todo);
    notifyListeners();
  }
}
