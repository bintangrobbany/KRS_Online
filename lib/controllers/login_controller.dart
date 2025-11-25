// lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../models/login_model.dart'; // Tetap pakai ini sesuai kodemu

class LoginController extends ChangeNotifier {
  final LoginModel _model = LoginModel();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Warna Hijau Tua sesuai tema aplikasimu
  final Color primaryGreen = const Color(0xFF054F40);

  bool get isPasswordObscured => _model.isPasswordObscured;

  void togglePasswordVisibility() {
    _model.isPasswordObscured = !_model.isPasswordObscured;
    notifyListeners();
  }

  // --- FUNGSI LOGIN YANG SUDAH DI-UPDATE ---
  Future<void> login(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // 1. TAMPILKAN DIALOG POPUP HIJAU (Gantikan SnackBar lama)
      showDialog(
        context: context,
        barrierDismissible: false, // User gabisa klik luar buat tutup
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor:
                Colors.transparent, // Transparan biar sudutnya bulat
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: 250,
              width: 300,
              decoration: BoxDecoration(
                color: primaryGreen, // Warna kotak jadi Hijau Tua
                borderRadius: BorderRadius.circular(30), // Sudut membulat
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon Ceklis dalam lingkaran transparan
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Teks "Login Successful"
                  const Text(
                    "Login Successful",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // 2. TUNGGU 2 DETIK (Biar user lihat popup hijaunya)
      await Future.delayed(const Duration(seconds: 2));

      // 3. TUTUP DIALOG & PINDAH KE HOME
      if (context.mounted) {
        Navigator.pop(context); // Tutup Dialognya dulu
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } else {
      // Jika GAGAL (Kosong), tetap pakai SnackBar Merah (Ini UX yang bagus)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
