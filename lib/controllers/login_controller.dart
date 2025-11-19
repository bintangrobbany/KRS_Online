// lib/controllers/login_controller.dart

import 'package:flutter/material.dart';

// HAPUS SEMUA IMPORT NOTIFIKASI LAIN (motion_toast, dll)
import '../views/home_view.dart';
import '../models/login_model.dart';

class LoginController extends ChangeNotifier {
  final LoginModel _model = LoginModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get isPasswordObscured => _model.isPasswordObscured;

  void togglePasswordVisibility() {
    _model.isPasswordObscured = !_model.isPasswordObscured;
    notifyListeners();
  }

  // Method login yang disederhanakan
  Future<void> login(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // 1. TAMPILKAN SNACKBAR SUKSES (CARA STANDAR FLUTTER)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Berhasil! Selamat datang."),
          backgroundColor: Colors.green, // Warna hijau untuk sukses
          duration: Duration(seconds: 2), // Tampilkan selama 2 detik
        ),
      );

      // 2. TUNGGU 2 DETIK
      // Ini untuk memberi waktu kepada pengguna untuk membaca notifikasi
      await Future.delayed(const Duration(seconds: 2));

      // 3. PINDAH KE HALAMAN HOME
      // Pemeriksaan 'context.mounted' adalah praktik yang baik
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } else {
      // Tampilkan notifikasi error jika kolom kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong"),
          backgroundColor: Colors.red, // Warna merah untuk error
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
