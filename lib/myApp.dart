import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valkyrie/services/device_manager.dart';
import 'package:valkyrie/services/path_manager.dart';
import 'package:valkyrie/services/remote_config_service.dart';
import 'package:valkyrie/services/storage_manager.dart';
import 'package:valkyrie/services/theme_manager.dart';

import 'dummy_page.dart';
import 'in_app_browser_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, PathNotifier>(
        builder: (context, theme, path, _) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: theme.getTheme(),
        //! First condition
        home: path.localUrl.isEmpty
            ? loadFire(context)
            : buildWebView(path.localUrl),
      );
    });
  }

  //----------------------------------------------------------------------------

  // it's better to call another class rather than return widget
  // this is done just to save time
  Widget loadFire(
    BuildContext context,
  ) {
    return Consumer<DeviceInfoNotifier>(
      builder: (context, device, _) {
        return FutureBuilder<FirebaseRemoteConfig>(
          future: setupRemoteConfig(),
          builder: (
            BuildContext context,
            AsyncSnapshot<FirebaseRemoteConfig> snapshot,
          ) {
            if (snapshot.hasData) {
              //! Second condition
              var rawData = snapshot.requireData.getAll()['en'];
              final data = json.decode(rawData!.asString());
              debugPrint("DEBUGPRINT - data: $data");
              String getUrl = data['url'] ?? "";

              if ((getUrl.isEmpty || device.brandDevice.contains("google")) ||
                  !device.simDevice! ||
                  !device.physicalPhone!) {
                return GamesPage();
              } else {
                StorageManager.saveData("url", getUrl);
                return buildWebView(getUrl);
              }
            } else {
              return buildLoading();
            }
          },
        );
      },
    );
  }

  //----------------------------------------------------------------------------

  Widget buildWebView(String path) {
    return InAppBrowserPage(url: path);
  }

  //----------------------------------------------------------------------------

  Widget buildLoading() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
