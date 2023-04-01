import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigHelper {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {

    try {
      await remoteConfig.ensureInitialized();
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(seconds: 5),
      ));
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      print(e);
    }
    return remoteConfig;
  }
}
