import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 0),
  ));

  await remoteConfig.fetch();
  await remoteConfig.activate();

  return remoteConfig;
}
