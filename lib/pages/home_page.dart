import 'package:flutter/material.dart';

import '/pages/counter_list_page.dart';
import '/pages/todo_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => CounterListPage.show(context),
              child: const Text('カウンター'),
            ),
            ElevatedButton(
              onPressed: () => TodoListPage.show(context),
              child: const Text('TODO'),
            ),
          ],
        ),
      ),
    );
  }
}
