import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valkyrie/services/json_manager.dart';
import 'package:valkyrie/services/storage_manager.dart';

import 'myApp.dart';
import 'services/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(),
      ),
      ChangeNotifierProvider<DataManager>(
        create: (_) => DataManager(),
      ),
    ],
    child: MyApp(),
  ));
}
