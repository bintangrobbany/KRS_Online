// lib/views/forgot_password_view.dart

import 'package:flutter/material.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = ForgotPasswordController();

    // --- PALET WARNA (Sesuai tema Anda) ---
    final Color bgCanvas = const Color(0xFFE8DFCD);
    final Color primaryGreen = const Color(0xFF054F40);
    final Color textDark = const Color(0xFF1A1A1A);
    final Color textGrey = const Color(0xFF888888);

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () => controller.goBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Ikon Besar yang Menarik
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withOpacity(0.1),
              ),
              child: Icon(
                Icons.support_agent_outlined,
                color: primaryGreen,
                size: 80,
              ),
            ),
            const SizedBox(height: 32),

            // 2. Judul
            Text(
              'Lupa Password?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),

            // 3. Deskripsi
            Text(
              'Jangan khawatir! Silakan hubungi admin akademik untuk mendapatkan bantuan reset password Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textGrey,
                height: 1.5, // Jarak antar baris
              ),
            ),
            const Spacer(),

            // 4. Tombol Aksi "Chat Admin"
            ElevatedButton.icon(
              onPressed: () => controller.launchWhatsApp(context),
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              label: const Text(
                'Chat Admin via WhatsApp',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: primaryGreen.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}