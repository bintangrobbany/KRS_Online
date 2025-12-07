// lib/views/reset_password_view.dart

import 'package:flutter/material.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final ResetPasswordController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ResetPasswordController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final Color backgroundColor = const Color(0xFFF0EBE3);
  final Color primaryColor = const Color(0xFF006A4E);
  final Color textColor = const Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          // 1. TAMBAHKAN SingleChildScrollView DI SINI
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Kembali
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

                // Judul dan Subjudul
                Text(
                  'Reset password',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please type something you\'ll remember',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // Field Password Baru
                Text('New password', style: TextStyle(color: textColor)),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) => _buildPasswordField(
                    controller: _controller.newPasswordController,
                    hint: 'must be 8 characters',
                    isObscured: _controller.isNewPasswordObscured,
                    onToggle: _controller.toggleNewPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 20),

                // Field Konfirmasi Password
                Text(
                  'Confirm new password',
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) => _buildPasswordField(
                    controller: _controller.confirmPasswordController,
                    hint: 'repeat password',
                    isObscured: _controller.isConfirmPasswordObscured,
                    onToggle: _controller.toggleConfirmPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol Reset
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
                    onPressed: () => _controller.resetPassword(context),
                    child: const Text(
                      'Reset password',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // 2. HAPUS Spacer() DAN TAMBAHKAN SizedBox SEBAGAI PENGGANTI JARAK
                const SizedBox(height: 40),

                // Teks Log in
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[600],
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
