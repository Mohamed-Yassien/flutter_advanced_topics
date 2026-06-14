import 'package:flutter/material.dart';
import 'package:flutter_advanced_topics/features/firebase_remote_config/services/remote_config_service.dart';

class FirebaseRemoteConfigScreen extends StatefulWidget {
  const FirebaseRemoteConfigScreen({super.key});

  @override
  State<FirebaseRemoteConfigScreen> createState() =>
      _FirebaseRemoteConfigScreenState();
}

class _FirebaseRemoteConfigScreenState
    extends State<FirebaseRemoteConfigScreen> {
  final bool showForceUpdate = RemoteConfigService.instance.showForceUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Remote Config'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Firebase Remote Config Screen'),
            if (showForceUpdate)
              const Text(
                'Force Update is enabled',
                style: TextStyle(color: Colors.red),
              )
            else
              const Text(
                'Force Update is disabled',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
