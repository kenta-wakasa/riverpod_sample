import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/controllers/settings_controller.dart';
import '/controllers/todo_list_controller.dart';

class TodoListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(todoListProvider);
    final settings = watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        backgroundColor: settings.color,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addTodo(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: controller.todoList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: controller.todoList.length,
              itemBuilder: (context, index) {
                final todo = controller.todoList[index];
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
              }),
    );
  }
}
