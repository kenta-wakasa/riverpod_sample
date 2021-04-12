import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/controllers/todo_list_controller.dart';
import '/models/todo.dart';

class TodoListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
      ),
      bottomSheet: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: context.read(settingsProvider).changeColor,
              child: const Text('いろを変える'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addTodo(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder(
          future: controller.todoList,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Todo>> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final todoList = snapshot.data;
            return ListView.builder(
              itemCount: todoList!.length,
              itemBuilder: (context, index) {
                final todo = todoList[index];
                return Dismissible(
                  key: Key(todo.description),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.removeTodo(todo);
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
                        color: controller.color,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
