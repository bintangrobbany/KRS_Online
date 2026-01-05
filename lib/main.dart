// File: main.dart

import 'package:flutter/material.dart';
import 'views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
