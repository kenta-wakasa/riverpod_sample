import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = ChangeNotifierProvider(
  (ref) => SettingsController._(),
);

class SettingsController extends ChangeNotifier {
  SettingsController._();
  Color color = Colors.green;

  /// ランダムな色を生成する
  void changeColor() {
    final random = Random();
    color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    notifyListeners();
  }
}
