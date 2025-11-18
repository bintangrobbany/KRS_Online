// lib/views/forgot_password_view.dart

import 'package:flutter/material.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordController _controller = ForgotPasswordController();

  // Definisikan warna sesuai permintaan Anda
  final Color backgroundColor = const Color.fromARGB(255, 255, 232, 197);
  final Color primaryColor = const Color(0xFF006A4E);
  final Color textColor = const Color(
    0xFF333333,
  ); // Warna teks yang lebih lembut

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Kembali (Back Button)
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _controller.goBack(context),
                ),
              ),
              const SizedBox(height: 30),

              // Judul
              Text(
                'Forgot password ?',
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),

              // Subjudul Deskripsi
              Text(
                'Don\'t worry! It happens. Please enter the email associated with your account.',
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 16,
                  height: 1.5, // Jarak antar baris
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 40),

              // Label Email
              Text(
                'Email address',
                style: TextStyle(color: textColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),

              // TextField Email
              TextField(
                controller: _controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol "Send code"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _controller.sendCode(context),
                  child: const Text(
                    'Send code',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const Spacer(), // Mendorong widget berikutnya ke bawah
              // Teks "Remember password? Log in" di bawah
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => _controller.goBack(context),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                      children: [
                        const TextSpan(text: 'Remember password? '),
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
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
