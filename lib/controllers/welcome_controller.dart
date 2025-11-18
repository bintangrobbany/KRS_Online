import 'package:flutter/material.dart';
import '../views/login_view.dart';

class WelcomeController {
  // Method untuk menangani event saat tombol sign in ditekan
  void navigateToLogin(BuildContext context) {
    // Navigasi ke LoginView yang sesungguhnya
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()), // <- Ganti tujuannya
    );
  }
}

// Ini adalah halaman dummy/placeholder. Ganti dengan halaman login Anda.
class LoginPagePlaceholder extends StatelessWidget {
  const LoginPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: const Center(
        child: Text("Ini adalah halaman login."),
      ),
    );
  }
}