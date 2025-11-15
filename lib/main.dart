import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Only initialize Firebase on supported platforms
  if (!Platform.isLinux) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    print('⚠️ Firebase not initialized on Linux (unsupported platform)');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Scaffold(
        body: Center(
          child: Text(
            '🚀 Flutter running successfully!\nFirebase disabled on Linux.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
