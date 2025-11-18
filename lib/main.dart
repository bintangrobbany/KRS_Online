import 'package:flutter/material.dart';
import 'views/welcome_view.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Anda bisa mendefinisikan font default di sini jika mau
        // fontFamily: 'Poppins',
      ),
      home: WelcomeView(), // Atur WelcomeView sebagai halaman utama
      debugShowCheckedModeBanner: false,
    );
  }
}