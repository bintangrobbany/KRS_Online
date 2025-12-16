import 'package:flutter/material.dart';

// Import views yang Anda sediakan
import 'form_krs_view.dart';
import 'review_kelas_view.dart';
import 'notifikasi_view.dart';
import 'daftar_kelas_view.dart'; // Digunakan untuk 'From KRS' dan/atau 'Saved Classes'
import 'saved_classes_view.dart'; // Tetap diimpor, tetapi tidak digunakan untuk navigasi

// Ganti RiwayatStatusView ke SavedClassesView (menggunakan DaftarKelasView sebagai placeholder logis)
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // --- PALET WARNA (Gunakan yang sudah didefinisikan) ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color textWhite = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            // 1. From KRS -> DaftarKelasView (sesuai implementasi Anda)
            _buildSettingButton(
              "From KRS",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaftarKelasView()),
                );
              },
            ),

            // 2. Review -> ReviewKelasView
            _buildSettingButton(
              "Review",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReviewKelasView()),
                );
              },
            ),

            // 3. Saved Classes (Mengganti Riwayat Status)
            _buildSettingButton(
              "Saved Classes", // Teks diganti
              onTap: () {
                // Diasumsikan Saved Classes menggunakan DaftarKelasView/SavedClassesView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DaftarKelasView()),
                );
              },
            ),

            // 4. Notifikasi -> NotifikasiView
            _buildSettingButton(
              "Notifikasi",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotifikasiView()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Menggunakan textWhite secara konsisten) ---
  Widget _buildSettingButton(String title, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: textWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                // Menggunakan TextStyle non-const agar bisa menggunakan textWhite
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textWhite, // *** PERBAIKAN: Menggunakan textWhite ***
              ),
            ),
            Icon(
              // Menggunakan Icon non-const agar bisa menggunakan textWhite
              Icons.arrow_forward_ios,
              size: 16,
              color: textWhite, // *** PERBAIKAN: Menggunakan textWhite ***
            ),
          ],
        ),
      ),
    );
  }
}
