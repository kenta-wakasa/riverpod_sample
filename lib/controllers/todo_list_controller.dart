import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/models/todo.dart';

/// riverpod での provider 宣言部分
final todoListProvider = ChangeNotifierProvider<TodoListController>(
  (ref) {
    // 他の provider の値を参照する場合の書き方
    // settingsProvider から通知が来たらその変更を反映する
    // 無理矢理ねじ込んだ例なので本当はこんなことをする必要はなく
    // settingsProvider を直接みた方がよいです。
    final color = ref.watch(settingsProvider).color;

    return TodoListController._(color: color);
  },
);

class TodoListController extends ChangeNotifier {
  TodoListController._({required this.color});

  /// 文字色を決めるための変数
  final Color color;

  /// リポジトリから todoList を取得する。
  /// ページ側ではついでに FutureBuilder のサンプルも書いています。
  Future<List<Todo>> fetchTodoList() async {
    return TodoRepository.instance.fetchTodoList();
  }

  /// ダイアログに入力された内容で[Todo]を追加する。
  Future<void> addTodo(BuildContext context) async {
    var description = '';

    // お行儀が悪いですがコントローラーの中で
    // context をつかってダイアログをひらいています。
    // ダイアログの中で TextFormField を使う参考になればと思います。
    final result = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextFormField(
            cursorColor: color,
            autofocus: true,
            onChanged: (value) => description = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('追加', style: TextStyle(color: color)),
            ),
          ],
        );
      },
    );
    if (result == true && description.isNotEmpty) {
      TodoRepository.instance.add(Todo.create(description: description));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('[$description]を追加しました！'),
      ));
      notifyListeners();
    }
  }

  /// 指定した[Todo]をリストから取り除く。
  void removeTodo(Todo todo) {
    TodoRepository.instance.remove(todo);
    notifyListeners();
  }
}
