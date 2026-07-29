import 'package:flutter/material.dart';

/// Primary screen for the Auth feature area.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auth')),
      body: const Center(child: Text('Auth')),
    );
  }
}
