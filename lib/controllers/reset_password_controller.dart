// lib/controllers/reset_password_controller.dart

import 'package:flutter/material.dart';
import '../models/reset_password_model.dart';
import '../views/password_changed_view.dart'; // Import halaman sukses

class ResetPasswordController extends ChangeNotifier {
  final ResetPasswordModel _model = ResetPasswordModel();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Getter untuk View
  bool get isNewPasswordObscured => _model.isNewPasswordObscured;
  bool get isConfirmPasswordObscured => _model.isConfirmPasswordObscured;

  // Toggle visibilitas password
  void toggleNewPasswordVisibility() {
    _model.isNewPasswordObscured = !_model.isNewPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _model.isConfirmPasswordObscured = !_model.isConfirmPasswordObscured;
    notifyListeners();
  }

  // Logika utama untuk mereset password
  void resetPassword(BuildContext context) {
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Validasi
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError(context, 'Password tidak boleh kosong');
      return;
    }
    if (newPassword.length < 8) {
      _showError(context, 'Password minimal harus 8 karakter');
      return;
    }
    if (newPassword != confirmPassword) {
      _showError(context, 'Password tidak cocok');
      return;
    }

    // Jika semua validasi lolos
    print('Password berhasil direset!');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PasswordChangedView()),
      (Route<dynamic> route) => false, // Hapus semua rute sebelumnya
    );
  }

  // Helper untuk menampilkan error
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}