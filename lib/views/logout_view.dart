import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart'; // <--- 1. WAJIB IMPORT INI

class LogoutView extends StatelessWidget {
  const LogoutView({super.key});

  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardWhite = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ... (Kode UI Ikon dan Teks di atas TETAP SAMA) ...
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.door_back_door_outlined,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Oh no! You’re Leaving...\nAre you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // --- TOMBOL YES YANG SUDAH DIPERBAIKI ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    // 2. INI LOGIKA NAVIGASINYA
                    // pushAndRemoveUntil: Menghapus semua riwayat halaman sebelumnya (Home, Profile)
                    // Jadi user tidak bisa tekan tombol 'Back' di HP

                    // Hapus data SharedPreferences saat logout
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) =>
                            false, // false artinya: hapus semua rute di belakang
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryGreen, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Yes, Log Me Out",
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- TOMBOL NAH (TETAP SAMA) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Nah, Still here",
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
