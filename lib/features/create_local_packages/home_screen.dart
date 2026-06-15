// my_app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart'; // <- our Flutter package

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = []; // pretend this is an empty list

    return Scaffold(
      body: items.isEmpty
          ? const EmptyState(message: 'No transactions yet') // <- reused widget
          : ListView(/* ... */),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          // <- reused widget
          label: 'Add transaction',
          onPressed: () {
            // do something
          },
        ),
      ),
    );
  }
}
