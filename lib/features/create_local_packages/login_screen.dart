// my_app/lib/main.dart
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: validateEmail, // <- reused from the package
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: validatePassword, // <- reused
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: validatePhone, // <- reused
          ),
        ],
      ),
    );
  }
}
