import 'package:flutter/material.dart';
import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NeuConnectApp());
}

/// NeuConnect — Week 4 Task: API Integration & Networking.
///
/// Demonstrates:
///   • HTTP requests + JSON parsing (GET /posts) rendered in a ListView
///   • A User Profile screen (GET /users, GET /users/:id)
///   • Robust error handling with typed exceptions + loading indicators
class NeuConnectApp extends StatelessWidget {
  const NeuConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RootShell(),
    );
  }
}
