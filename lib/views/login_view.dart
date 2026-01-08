// lib/views/login_view.dart

import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final Color backgroundColor = const Color(0xFFF0EBE3);
  final Color primaryColor = const Color(0xFF006A4E);
  final Color textColor = const Color(0xFF004D38);

  /// Method untuk membuat dan menampilkan dialog pop-up saat login berhasil.
  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // User tidak bisa menutup dialog dengan klik di luar
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 250, // Sesuaikan tinggi dialog
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor, // Menggunakan warna hijau primer Anda
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ikon ceklis di dalam lingkaran hijau muda
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.greenAccent,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                SizedBox(height: 20),
                // Teks "Login Successful"
                Text(
                  "Login Successful",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Log in',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Username / NIM',
                style: TextStyle(color: textColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _controller.usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter username/nim',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Password',
                style: TextStyle(color: textColor, fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 8),

              ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  return TextField(
                    controller: _controller.passwordController,
                    obscureText: _controller.isPasswordObscured,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Enter password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _controller.isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: _controller.togglePasswordVisibility,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: textColor, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _controller.isLoading
                          ? null
                          : () {
                              // Kirim method _showLoginSuccessDialog sebagai callback
                              _controller.login(
                                context,
                                _showLoginSuccessDialog,
                              );
                            },
                      child: _controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
