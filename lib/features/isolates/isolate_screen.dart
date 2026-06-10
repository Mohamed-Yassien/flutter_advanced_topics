import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen> {
  //it is usefull for files picked from camera or gallery, which are usually large and can take time to process. By using an isolate, we can perform the hashing in the background without blocking the main UI thread, ensuring a smooth user experience.
  Future<String> hashImageFile(String path) {
    return Isolate.run(() async {
      final file = File(path);
      final stream = file.openRead();
      final digits = await sha256.bind(stream).first;
      log('Hashing completed: $digits');
      return digits.toString();
    });
  }

  // Similar to the above method, but for assets. Since assets are bundled with the app and can also be large, using an isolate ensures that the hashing process does not block the main thread, keeping the UI responsive.
  Future<String> hashAssetImage(String assetPath) async {
    // Load asset on the main Flutter isolate
    // rootBundle depend on flutter services/platform , and it should be user in the main flutter isolate , no isolate.run.
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();

    // Hash bytes in background isolate
    return Isolate.run(() {
      final digest = sha256.convert(bytes);

      log('Hashing completed: $digest');
      return digest.toString();
    });
  }

  @override
  initState() {
    super.initState();
    hashAssetImage('assets/images/football.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate Screen'),
      ),
      body: const Center(
        child: Text('This is the Isolate Screen'),
      ),
    );
  }
}
