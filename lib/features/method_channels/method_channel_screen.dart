import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelScreen extends StatefulWidget {
  const MethodChannelScreen({super.key});

  @override
  State<MethodChannelScreen> createState() => _MethodChannelScreenState();
}

class _MethodChannelScreenState extends State<MethodChannelScreen> {
  Future<bool> isDeveloperModeEnabled() async {
    var channel = MethodChannel('com.company.app/device_security');

    final result = await channel.invokeMethod<bool>('isDeveloperModeEnabled');
    return result ?? false;
  }

  @override
  void initState() {
    isDeveloperModeEnabled().then((enabled) {
      log('Developer mode enabled: $enabled');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Method Channel Screen'),
      ),
      body: const Center(
        child: Text('This is the Method Channel Screen'),
      ),
    );
  }
}
