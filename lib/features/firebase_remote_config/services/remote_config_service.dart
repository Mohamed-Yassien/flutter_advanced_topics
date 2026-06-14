import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService _instance = RemoteConfigService._();

  static RemoteConfigService get instance => _instance;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 0),
    ));

    await _remoteConfig.setDefaults({
      RemoteConfigKeys.showForceUpdate: false,
    });
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log('FirebaseRemoteConfig: fetchAndActivate failed: $e');
    }
  }

  bool get showForceUpdate {
    log('FirebaseRemoteConfig: showForceUpdate: ${_remoteConfig.getBool(RemoteConfigKeys.showForceUpdate)}');
    return _remoteConfig.getBool(RemoteConfigKeys.showForceUpdate);
  }
}

class RemoteConfigKeys {
  static const String showForceUpdate = 'showForceUpdate';
}
