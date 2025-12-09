// File: main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/welcome_view.dart';
import 'controllers/krs_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences untuk KRSController
  final prefs = await SharedPreferences.getInstance();
  KRSController().initialize(prefs);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: WelcomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
