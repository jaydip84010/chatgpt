import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigHelper {
  FirebaseRemoteConfig _remoteConfig;
  RemoteConfigHelper({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<FirebaseRemoteConfig> setupRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(seconds: 5),
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print(e);
    }
    return _remoteConfig;
  }
}
