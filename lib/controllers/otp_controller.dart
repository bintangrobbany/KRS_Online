// lib/controllers/otp_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/otp_model.dart';
import '../views/reset_password_view.dart'; // <-- 1. Import halaman reset password

class OtpController extends ChangeNotifier {
  final OtpModel _model = OtpModel();
  Timer? _timer;

  // Getter yang akan diakses oleh View untuk mendapatkan data terbaru
  int get countdown => _model.countdown;
  bool get canResend => _model.canResend;

  // Constructor ini akan dipanggil saat instance OtpController dibuat.
  // Kita langsung memulai timer di sini.
  OtpController() {
    startTimer();
  }

  /// Memulai atau mereset timer hitung mundur.
  void startTimer() {
    _model.canResend = false;
    _model.countdown = 20; // Atur ulang waktu hitung mundur ke 20 detik
    _timer?.cancel(); // Batalkan timer yang mungkin sedang berjalan

    // Buat timer baru yang berjalan setiap 1 detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_model.countdown > 0) {
        _model.countdown--; // Kurangi waktu hitung mundur
      } else {
        _model.canResend = true; // Aktifkan tombol resend
        timer.cancel(); // Hentikan timer
      }
      notifyListeners(); // Beri tahu View untuk update UI (khususnya teks timer)
    });
  }

  /// Mengirim ulang kode OTP dan memulai ulang timer.
  void resendCode() {
    // Hanya jalankan jika tombol resend sudah aktif
    if (_model.canResend) {
      print("Mengirim ulang kode OTP...");
      startTimer(); // Mulai ulang timer dari awal
      notifyListeners();
    }
  }

  /// Memverifikasi kode yang diinput oleh pengguna.
  void verifyCode(BuildContext context, String code) {
    print("Kode yang dimasukkan oleh pengguna: $code");
    
    // --- Di sini adalah tempat untuk logika verifikasi Anda yang sebenarnya ---
    // Untuk tujuan contoh, kita anggap kode yang benar adalah "1234".
    if (code.length == 4 && code == "1234") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Verifikasi Berhasil!'),
        ),
      );
      
      // 2. Navigasi ke halaman ResetPasswordView setelah verifikasi berhasil
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Kode verifikasi salah!'),
        ),
      );
    }
  }

  /// Fungsi untuk kembali ke halaman sebelumnya.
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Membersihkan resource (dalam hal ini, timer) saat controller tidak lagi digunakan.
  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
    print("OtpController has been disposed.");
  }
}