// lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../models/login_model.dart';

class LoginController extends ChangeNotifier {
  final LoginModel _model = LoginModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // --- Syarat Login ---
  final String requiredNimPrefix = '202210370311';
  final int requiredNimLength = 15;
  final int minPasswordLength = 8;

  bool get isPasswordObscured => _model.isPasswordObscured;

  void togglePasswordVisibility() {
    _model.isPasswordObscured = !_model.isPasswordObscured;
    notifyListeners();
  }

  /// Method login yang akan dipanggil oleh View.
  /// Ia menerima 'onSuccess' sebagai parameter, yaitu sebuah fungsi yang akan dijalankan jika login berhasil.
  Future<void> login(BuildContext context, VoidCallback onSuccess) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text;

    // --- VALIDASI LOGIN ---

    // 1. Cek apakah kolom kosong
    if (username.isEmpty || password.isEmpty) {
      _showError(context, "NIM dan Password tidak boleh kosong");
      return; // Hentikan eksekusi
    }
    
    // 2. Cek apakah NIM berisi huruf/simbol
    if (int.tryParse(username) == null) {
      _showError(context, "NIM harus berupa angka");
      return;
    }

    // 3. Cek awalan NIM
    if (!username.startsWith(requiredNimPrefix)) {
      _showError(context, "Awalan NIM tidak valid");
      return;
    }

    // 4. Cek panjang total NIM
    if (username.length != requiredNimLength) {
      _showError(context, "NIM harus terdiri dari 15 digit");
      return;
    }
    
    // 5. Cek panjang password
    if (password.length < minPasswordLength) {
      _showError(context, "Password minimal harus 8 karakter");
      return;
    }
    
    // --- JIKA SEMUA VALIDASI LOLOS ---
    print("Validasi berhasil! Menampilkan dialog sukses...");

    // 1. Jalankan fungsi 'onSuccess' yang dikirim dari LoginView.
    // Ini akan menampilkan dialog pop-up.
    onSuccess();

    // 2. Tunggu selama 2 detik untuk memberi waktu pengguna melihat dialog.
    await Future.delayed(const Duration(seconds: 2));

    // 3. Pindah ke halaman HomeView.
    // Pengecekan 'context.mounted' adalah praktik yang baik setelah 'await'.
    if (context.mounted) {
      // Tutup dialog yang sedang tampil sebelum navigasi
      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }

  /// Helper untuk menampilkan notifikasi error (SnackBar) agar tidak duplikasi kode.
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}