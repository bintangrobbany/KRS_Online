import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/admin/admin_dashboard_view.dart'; // <--- JANGAN LUPA IMPORT INI
import '../models/login_model.dart';

class LoginController extends ChangeNotifier {
  final LoginModel _model = LoginModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // --- Syarat Login Mahasiswa ---
  // (Pastikan nilai ini sesuai kebutuhan, misal panjang NIM 10 atau 15)
  final String requiredNimPrefix = '';
  final int requiredNimLength = 15; // Contoh saya ubah ke 15 sesuai pesan error
  final int minPasswordLength = 6; // Contoh standar password

  bool get isPasswordObscured => _model.isPasswordObscured;

  void togglePasswordVisibility() {
    _model.isPasswordObscured = !_model.isPasswordObscured;
    notifyListeners();
  }

  Future<void> login(BuildContext context, VoidCallback onSuccess) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text;

    // ---------------------------------------------------------
    // 1. CEK ADMIN (JALUR KHUSUS)
    // Pengecekan ini ditaruh PALING ATAS agar tidak kena validasi angka NIM
    // ---------------------------------------------------------
    if (username == 'admin@krs.com' && password == '12345678') {
      print("Login sebagai Admin");

      // Admin biasanya tidak butuh animasi dialog 'Success' yang lama,
      // Langsung pindah ke Dashboard Admin.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardView()),
      );

      return; // PENTING: Hentikan fungsi agar validasi NIM di bawah tidak dijalankan
    }

    // ---------------------------------------------------------
    // 2. VALIDASI LOGIN MAHASISWA
    // Jika bukan admin, baru kita cek syarat-syarat NIM
    // ---------------------------------------------------------

    // A. Cek kosong
    if (username.isEmpty || password.isEmpty) {
      _showError(context, "Username dan Password tidak boleh kosong");
      return;
    }

    // B. Cek apakah NIM berisi Angka saja (Validasi Mahasiswa)
    // Karena username admin sudah lolos di atas, yang sampai sini pasti mahasiswa
    if (int.tryParse(username) == null) {
      _showError(context, "NIM harus berupa angka");
      return;
    }

    // C. Cek awalan NIM (Jika ada aturan tahun angkatan)
    if (requiredNimPrefix.isNotEmpty &&
        !username.startsWith(requiredNimPrefix)) {
      _showError(context, "Awalan NIM tidak valid");
      return;
    }

    // D. Cek panjang karakter NIM
    // (Anda bisa sesuaikan requiredNimLength di bagian deklarasi variabel di atas)
    if (username.length != requiredNimLength) {
      _showError(context, "NIM harus terdiri dari $requiredNimLength digit");
      return;
    }

    // E. Cek panjang password
    if (password.length < minPasswordLength) {
      _showError(context, "Password minimal harus $minPasswordLength karakter");
      return;
    }

    // ---------------------------------------------------------
    // 3. JIKA LOLOS SEMUA VALIDASI MAHASISWA
    // ---------------------------------------------------------
    print("Validasi Mahasiswa berhasil!");

    // Jalankan callback dialog sukses dari View
    onSuccess();

    // Tunggu animasi
    await Future.delayed(const Duration(seconds: 2));

    // Pindah ke Home Mahasiswa
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Tutup Dialog

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
