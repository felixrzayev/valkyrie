import 'package:flutter/material.dart';
import 'package:valkyrie/services/storage_manager.dart';

class PathNotifier with ChangeNotifier {
  String _localUrl = "";
  String get localUrl => _localUrl;

  PathNotifier() {
    StorageManager.readData("url").then((value) {
      debugPrint('URL value read from storage: $value');
      _localUrl = value ?? '';
      notifyListeners();
    });
  }
}
