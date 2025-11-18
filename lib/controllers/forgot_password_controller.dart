// lib/controllers/forgot_password_controller.dart

import 'package:flutter/material.dart';

class ForgotPasswordController {
  final TextEditingController emailController = TextEditingController();

  /// Menangani logika saat tombol "Send code" ditekan
  void sendCode(BuildContext context) {
    final String email = emailController.text;

    // Logika validasi email sederhana
    if (email.isNotEmpty && email.contains('@')) {
      print('Mengirim kode reset ke: $email');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode terkirim ke email Anda (Placeholder)'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Mohon masukkan alamat email yang valid'),
        ),
      );
    }
  }

  /// Fungsi untuk kembali ke halaman sebelumnya
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Membersihkan resource saat halaman tidak lagi digunakan
  void dispose() {
    emailController.dispose();
  }
}
