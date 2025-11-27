// lib/controllers/forgot_password_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordController {
  final String adminPhoneNumber =
      '6285249723441'; // Ganti dengan nomor yang benar
  final String defaultMessage =
      'Halo Admin, saya mengalami kendala lupa password untuk akun KRS saya. Mohon bantuannya.';

  Future<void> launchWhatsApp(BuildContext context) async {
    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$adminPhoneNumber?text=${Uri.encodeComponent(defaultMessage)}',
    );

    try {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } on PlatformException catch (e) {
      print('Gagal membuka URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat membuka WhatsApp. Pastikan aplikasi sudah terinstall.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
