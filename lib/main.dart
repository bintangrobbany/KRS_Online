// File: main.dart

import 'package:flutter/material.dart';
import 'main_page_view.dart'; // Import MainPageView yang baru
// import 'views/welcome_view.dart'; // Tidak diperlukan jika langsung ke MainPageView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS App',
      theme: ThemeData(primarySwatch: Colors.green),
      home:
          const MainPageView(), // Sekarang menunjuk ke kerangka utama dengan NavBar
      debugShowCheckedModeBanner: false,
    );
  }
}
