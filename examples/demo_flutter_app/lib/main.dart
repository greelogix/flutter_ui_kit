import 'package:flutter/material.dart';

void main() {
  runApp(const DemoApp());
}

/// Demo shell for trying Flutter Feature Kit scaffolding in this example app.
class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Feature Kit Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Feature Kit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text(
            'Example app',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'From this directory, run the Feature Kit CLI:\n\n'
            '  feature init\n'
            '  feature create profile\n'
            '  feature add screen settings --feature profile',
          ),
          SizedBox(height: 24),
          Text(
            'Generated code appears under lib/features/.',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
