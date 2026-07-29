import 'package:flutter/material.dart';

/// Primary screen for the Profile feature area.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: const Center(child: Text('Profile')),
    );
  }
}
