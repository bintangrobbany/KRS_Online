// lib/views/ktm_view.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import plugin QR
import '../controllers/home_controller.dart'; // Import controller untuk ambil data

class KtmView extends StatefulWidget {
  const KtmView({super.key});

  @override
  State<KtmView> createState() => _KtmViewState();
}

class _KtmViewState extends State<KtmView> {
  // Panggil controller untuk data dummy
  final HomeController _controller = HomeController();

  // Warna tema
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color secondaryGreen = const Color(0xFF006A4E);

  @override
  Widget build(BuildContext context) {
    // Ambil data dari controller
    final String name = _controller.currentUser?.studentName ?? 'User';
    final String nim = _controller.currentUser?.nim ?? "000000000000000";
    final String prodi =
        _controller.currentUser?.programStudi ?? "Program Studi";
    final String? imageUrl = _controller.currentUser?.profileImageUrl;

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        title: const Text("KTM Digital"),
        backgroundColor: bgCanvas,
        foregroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- KARTU KTM ---
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                // Gradient warna hijau agar terlihat elegan
                gradient: LinearGradient(
                  colors: [primaryGreen, secondaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Hiasan Background (Lingkaran transparan)
                  Positioned(
                    right: -30,
                    top: -30,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -20,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),

                  // Konten Kartu
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Kartu
                        Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "UNIVERSITAS KRS ONLINE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "KARTU TANDA MAHASISWA",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Bagian Tengah: Foto & Data
                        Row(
                          children: [
                            // Foto Profil
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: imageUrl != null
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: imageUrl == null
                                    ? Icon(Icons.person, size: 40)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Data Teks
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    nim,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    prodi,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),

                  // QR Code (Diposisikan di kanan bawah)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // LIBRARY QR CODE
                      child: QrImageView(
                        data: nim, // Data yang diubah jadi QR (NIM Mahasiswa)
                        version: QrVersions.auto,
                        size: 60,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- KETERANGAN ---
            Text(
              "Tunjukkan QR Code ini untuk scan presensi atau akses perpustakaan.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Tombol Simulasi Scan (Hiasan saja)
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Fitur download kartu belum tersedia."),
                  ),
                );
              },
              icon: Icon(Icons.download, color: primaryGreen),
              label: Text("Unduh Kartu", style: TextStyle(color: primaryGreen)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
