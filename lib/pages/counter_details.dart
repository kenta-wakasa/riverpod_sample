import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/controllers/counter_controller.dart';

class CounterDetailsPage extends StatelessWidget {
  // ._() でコンストラクタを定義すると気軽に外部から呼べなくなる
  const CounterDetailsPage._(this.index);
  final int index;

  // 気軽に外部から呼べないので表示用の static メソッドを用意する
  // すると、用途を限定できるよ、という話。
  static void show(BuildContext context, int index) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => CounterDetailsPage._(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('index: $index'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read(counterProvider(index)).increment();
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final count = watch(counterProvider(index)).count;
          return Center(
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        },
      ),
    );
  }
}
