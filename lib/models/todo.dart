import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({
    required this.description,
    required this.createdAt,
    required this.done,
  });

  Todo.create({required this.description})
      : createdAt = DateTime.now(),
        done = false;

  final DateTime createdAt;
  final String description;
  final bool done;

  Todo copyWith({DateTime? createdAt, String? description, bool? done}) {
    return Todo(
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      done: done ?? this.done,
    );
  }
}

class TodoRepository {
  
  // 簡単なシングルトンを作る方法
  TodoRepository._();
  static TodoRepository instance = TodoRepository._();

  final List<Todo> _todoList = [
    Todo.create(description: '掃除'),
    Todo.create(description: '洗濯'),
    Todo.create(description: 'flutter'),
  ];

  void addTodo(Todo todo) {
    _todoList.add(todo);
  }

  void removeTodo(Todo todo) {
    _todoList.remove(todo);
  }

  // 擬似的な通信を表現するために、あえて時間のかかる処理にしています
  Future<List<Todo>> fetchTodoList() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    return _todoList;
  }
}
