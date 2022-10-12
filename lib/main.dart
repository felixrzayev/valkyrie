import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valkyrie/services/data_manager.dart';
import 'package:valkyrie/services/device_manager.dart';
import 'package:valkyrie/services/path_manager.dart';

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
      ChangeNotifierProvider<DataNotifier>(
        create: (_) => DataNotifier(),
      ),
      ChangeNotifierProvider<PathNotifier>(
        create: (_) => PathNotifier(),
      ),
      ChangeNotifierProvider<DeviceInfoNotifier>(
        create: (_) => DeviceInfoNotifier(),
      )
    ],
    child: MyApp(),
  ));
}
