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

  Future<List<Todo>> fetchTodoList() async {
    final todoList = <Todo>[]..add(Todo.create(description: '掃除'));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    todoList.add(Todo.create(description: '洗濯'));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    todoList.add(Todo.create(description: 'flutter'));
    return todoList;
  }
}
