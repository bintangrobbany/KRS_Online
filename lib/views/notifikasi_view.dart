import 'package:flutter/material.dart';

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna yang sama dengan HomeView
    final Color bgCanvas = const Color(0xFFE8DFCD);
    final Color textDark = const Color(0xFF1A1A1A);
    final Color textGrey = const Color(0xFF555555);

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: bgCanvas, // Warna sama dengan background
        elevation: 0, // Hilangkan bayangan agar terlihat menyatu
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle:
            false, // Judul di sebelah kiri (sesuai standar Android/iOS terkini)
      ),
      body: Center(
        child: Text(
          'Anda belum ada notifikasi terbaru.',
          style: TextStyle(color: textGrey, fontSize: 14),
        ),
      ),
    );
  }
}
