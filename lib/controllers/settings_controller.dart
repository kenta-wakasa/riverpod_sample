import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = ChangeNotifierProvider(
  (ref) => SettingsController(),
);

class SettingsController extends ChangeNotifier {
  SettingsController();
  Color color = Colors.green;
}
