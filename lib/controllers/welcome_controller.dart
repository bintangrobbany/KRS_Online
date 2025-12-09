import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/login_view.dart';

class WelcomeController {
  // Method untuk menangani event saat tombol sign in ditekan
  Future<void> navigateToLogin(BuildContext context) async {
    // Simpan flag bahwa welcome sudah ditampilkan
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcome_seen', true);

    // Navigasi ke LoginView yang sesungguhnya
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ), // <- Ganti tujuannya
      );
    }
  }
}

// Ini adalah halaman dummy/placeholder. Ganti dengan halaman login Anda.
class LoginPagePlaceholder extends StatelessWidget {
  const LoginPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: const Center(child: Text("Ini adalah halaman login.")),
    );
  }
}
