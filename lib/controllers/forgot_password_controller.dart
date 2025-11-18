import 'package:flutter/material.dart';
import '../views/otp_view.dart'; 

class ForgotPasswordController {
  // Controller untuk mengambil input teks dari field email di View
  final TextEditingController emailController = TextEditingController();

  /// Menangani logika saat tombol "Send code" ditekan.
  /// Method ini akan memvalidasi email dan menavigasikan ke halaman OTP.
  void sendCode(BuildContext context) {
    // Ambil nilai teks dari input field
    final String email = emailController.text;

    // Lakukan validasi sederhana: pastikan tidak kosong dan mengandung karakter '@'
    if (email.isNotEmpty && email.contains('@')) {
      print('Email valid, menavigasi ke halaman OTP untuk: $email');

      // Navigasi ke halaman OtpView dan kirim data email sebagai argumen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpView(email: email)),
      );
    } else {
      // Jika email tidak valid, tampilkan pesan error menggunakan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Mohon masukkan alamat email yang valid'),
        ),
      );
    }
  }

  /// Fungsi untuk kembali ke halaman sebelumnya (pop navigator)
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }


  void dispose() {
    emailController.dispose();
  }
}
