import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/controllers/todo_list_controller.dart';
import '/models/todo.dart';

class TodoListPage extends ConsumerWidget {
  // ._() でコンストラクタを定義すると気軽に外部から呼べなくなる
  const TodoListPage._();

  // 気軽に外部から呼べないので表示用の static メソッドを用意する
  // すると、用途を限定できるよ、という話。
  static void show(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => const TodoListPage._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final todoListController = watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('TODO')),
      bottomSheet: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              // メソッドを使いたいだけなら context.read で呼ぶとよい。
              // read を使うと変更があっても rebuild されなくなる。
              // パフォーマンスの向上につながるが、わからないうちは watch すればいいと思う。
              onPressed: context.read(settingsProvider).changeColor,
              child: const Text('いろを変える'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => todoListController.addTodo(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder(
        future: todoListController.fetchTodoList(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Todo>> snapshot,
        ) {
          // 値が取得できていない間はこれが呼ばれる
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // 値が取得できるとこれ以降の処理が自動的に呼ばれる
          final todoList = snapshot.data!;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];

              // Dismissible の使い方の例にもなっているかなと思います。
              return Dismissible(
                // key は一意に定まる値であればなんでもよい
                key: Key(todo.createdAt.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  todoListController.removeTodo(todo);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('[${todo.description}]を完了しました！'),
                  ));
                },
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.delete_rounded, color: Colors.white),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                child: ListTile(
                  title: Text(
                    todo.description,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: todoListController.color,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
