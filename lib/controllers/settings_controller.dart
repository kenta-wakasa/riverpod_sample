import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = ChangeNotifierProvider(
  (ref) => SettingsController._(),
);

/// 色を変えるためだけのコントローラー
class SettingsController extends ChangeNotifier {
  SettingsController._();

  Color color = Colors.red;
  final random = Random();
  int get randomByte => random.nextInt(256);

  /// ランダムな色を生成する
  void changeColor() {
    color = Color.fromARGB(255, randomByte, randomByte, randomByte);
    notifyListeners();
  }
}
