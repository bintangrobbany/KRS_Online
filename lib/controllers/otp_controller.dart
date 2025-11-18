// lib/controllers/otp_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/otp_model.dart';

class OtpController extends ChangeNotifier {
  final OtpModel _model = OtpModel();
  Timer? _timer;

  // Getter untuk View
  int get countdown => _model.countdown;
  bool get canResend => _model.canResend;

  // Constructor untuk memulai timer
  OtpController() {
    startTimer();
  }

  void startTimer() {
    _model.canResend = false;
    _model.countdown = 20; // Reset waktu
    _timer?.cancel(); // Batalkan timer lama jika ada

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_model.countdown > 0) {
        _model.countdown--;
      } else {
        _model.canResend = true;
        timer.cancel();
      }
      notifyListeners();
    });
  }

  void resendCode() {
    if (_model.canResend) {
      print("Mengirim ulang kode...");
      startTimer(); // Mulai ulang timer
      notifyListeners();
    }
  }

  void verifyCode(BuildContext context, String code) {
    print("Kode yang dimasukkan: $code");
    // Di sini logika verifikasi kode yang sebenarnya
    if (code.length == 4 && code == "1234") { // Contoh kode benar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifikasi Berhasil!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Kode salah!')),
      );
    }
  }

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Pastikan timer berhenti saat controller dibuang
    super.dispose();
  }
}