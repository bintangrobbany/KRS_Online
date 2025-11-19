// lib/views/welcome_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  // Buat instance dari controller

  final WelcomeController _controller = WelcomeController();

  // Definisikan warna agar mudah diubah
  final Color backgroundColor = const Color(0xFFF0EBE3);
  final Color primaryColor = const Color(0xFF006A4E); // Warna hijau tua
  final Color textColor = const Color(0xFF004D38);

  WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Bagian Atas: Logo dan Spacer
              const Spacer(),
              SvgPicture.asset(
                'assets/images/welcome_logo.svg', // Pastikan path ini benar
                height: 300,
              ),
              const SizedBox(height: 50),

              // Bagian Tengah: Teks Judul dan Subjudul
              Text(
                'KRS app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins', // Opsional: Ganti dengan font Anda
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login untuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins', // Opsional
                ),
              ),
              const Spacer(),
              const Spacer(), // Beri lebih banyak ruang
              // Bagian Bawah: Tombol Sign In
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Panggil method dari controller saat tombol ditekan
                onPressed: () => _controller.navigateToLogin(context),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins', // Opsional
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
