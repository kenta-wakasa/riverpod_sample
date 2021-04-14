import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// autoDispose: 誰も参照しなくなるとこのproviderは自動的に廃棄される。
// family: なんらかのパラメータを渡してそれに応じたproviderを作れる。
// list -> details みたいな構造を作るときに必要になる。
final counterProvider = ChangeNotifierProvider.autoDispose.family(
  (ref, int index) => CounterController._(index),
);

class CounterController extends ChangeNotifier {
  CounterController._(this.index);

  final int index;
  int _count = 0;

  // get だけ与えれば外から中身を変更することはできなくなります。
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }


  // 誰も参照しなくなるとこいつが呼ばれる。
  @override
  void dispose() {
    print('index: $index disposed!');
    super.dispose();
  }
}
