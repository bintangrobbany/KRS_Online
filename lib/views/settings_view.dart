import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // --- PALET WARNA ---
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
            // List Menu Settings
            _buildSettingButton(
              "From KRS",
              onTap: () {
                print("Menu From KRS diklik");
              },
            ),
            _buildSettingButton(
              "Review",
              onTap: () {
                print("Menu Review diklik");
              },
            ),
            _buildSettingButton(
              "Riwayat Status",
              onTap: () {
                print("Menu Riwayat Status diklik");
              },
            ),
            _buildSettingButton(
              "Notifikasi",
              onTap: () {
                print("Menu Notifikasi diklik");
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER (Agar kodingan tidak berulang) ---
  Widget _buildSettingButton(String title, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Jarak antar tombol
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen, // Warna Hijau Tua
          foregroundColor: textWhite, // Warna Text & Icon saat ditekan
          elevation: 0, // Flat design sesuai gambar
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut membulat
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500, // Medium weight
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios, // Panah ke kanan
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
