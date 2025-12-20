// lib/views/information_view.dart

import 'package:flutter/material.dart';

class InformationView extends StatelessWidget {
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema aplikasimu
    final Color primaryGreen = const Color(0xFF054F40);
    final Color bgCanvas = const Color(0xFFE8DFCD);

    return DefaultTabController(
      length: 3, // Ada 3 Tab: Alur, Jadwal, Peta
      child: Scaffold(
        backgroundColor: bgCanvas,
        appBar: AppBar(
          title: const Text("Pusat Informasi"),
          backgroundColor: bgCanvas,
          foregroundColor: primaryGreen,
          elevation: 0,
          bottom: TabBar(
            labelColor: primaryGreen,
            indicatorColor: primaryGreen,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: "Alur KRS"),
              Tab(text: "Jadwal"),
              Tab(text: "Peta"),
            ],
          ),
        ),
        body: TabBarView(
          physics:
              const NeverScrollableScrollPhysics(), // Agar map tidak geser tab
          children: [
            // --- TAB 1: ALUR ---
            _buildAlurTab(primaryGreen),

            // --- TAB 2: JADWAL ---
            _buildJadwalTab(primaryGreen),

            // --- TAB 3: PETA KAMPUS (SUDAH DIPERBAIKI) ---
            _buildPetaTab(),
          ],
        ),
      ),
    );
  }

  // WIDGET UNTUK TAB 1 (ALUR)
  Widget _buildAlurTab(Color color) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          "Langkah Pengisian KRS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildStep(1, "Bayar UKT", "Pastikan lunas semester ini.", true, color),
        _buildStep(
          2,
          "Konsultasi Dosen",
          "Minta persetujuan matkul.",
          true,
          color,
        ),
        _buildStep(
          3,
          "Isi KRS Online",
          "Pilih kelas di menu 'Daftar Kelas'.",
          false,
          color,
        ),
        _buildStep(
          4,
          "Cetak KRS",
          "Download PDF dan simpan.",
          false,
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildStep(
    int no,
    String title,
    String sub,
    bool isDone,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDone ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      "$no",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET UNTUK TAB 2 (JADWAL)
  Widget _buildJadwalTab(Color color) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: color),
                    const SizedBox(width: 10),
                    Text(
                      "Kalender Akademik",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30),
                _buildDateRow("Pembayaran UKT", "1 - 10 Agt 2025"),
                _buildDateRow("Pengisian KRS", "11 - 15 Agt 2025"),
                _buildDateRow("Perubahan KRS", "16 - 18 Agt 2025"),
                _buildDateRow("Masa Perkuliahan", "1 Sep - 20 Des 2025"),
                _buildDateRow("UAS", "5 - 10 Jan 2026"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(String label, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            date,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK TAB 3 (PETA) YANG SUDAH DIPERBAIKI ---
  Widget _buildPetaTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          constrained: false, // Biarkan gambar sesuai ukuran aslinya
          boundaryMargin: const EdgeInsets.all(100),
          child: Stack(
            children: [
              // 1. MEMUAT GAMBAR DARI ASET LOKAL (OFFLINE)
              Image.asset(
                "assets/images/peta_kampus.jpg", // Pastikan file ini ada
                width: 1000,
                fit: BoxFit.cover,

                // ERROR HANDLER: Jika kamu lupa menaruh gambar/salah nama file
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 1000,
                    height: 800,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Gambar tidak ditemukan!\nCek folder assets/images/",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 2. PIN LOKASI (Contoh: Perpustakaan)
              Positioned(
                top: 400, // Atur posisi vertikal sesuai gambarmu
                left: 550, // Atur posisi horizontal sesuai gambarmu
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Ini adalah Perpustakaan Pusat"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.black26),
                          ],
                        ),
                        child: const Icon(
                          Icons.library_books,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Perpustakaan",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
