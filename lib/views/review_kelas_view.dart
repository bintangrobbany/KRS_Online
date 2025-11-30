import 'package:flutter/material.dart';
import '../controllers/home_controller.dart'; // Import Controller

// --- IMPORT UNTUK NAV BAR (PENTING!) ---
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';
// ----------------------------------------

class ReviewKelasView extends StatefulWidget {
  const ReviewKelasView({super.key});

  @override
  State<ReviewKelasView> createState() => _ReviewKelasViewState();
}

class _ReviewKelasViewState extends State<ReviewKelasView> {
  // Panggil Controller
  final HomeController _controller = HomeController();

  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardWhite = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  // Fungsi hapus item
  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Batalkan Antrean?"),
        content: const Text(
          "Anda akan menghapus kelas ini dari daftar tunggu.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // Hapus dari data controller
                _controller.removeKrsItem(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Antrean dibatalkan"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- LOGIKA BOTTOM NAV BAR ---

  Widget _buildBottomNavBar(BuildContext context) {
    // Fungsi untuk navigasi kembali ke MainPageView (rute pertama)
    void navigateToRoot() {
      // Ini akan pop semua stack hingga ke rute pertama (MainPageView)
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    // Helper Widget untuk setiap item di Bottom Navigation Bar
    Widget navItem(int index, IconData icon, String label) {
      bool isHome = index == 2;

      // Semua tombol NavBar pada halaman detail ini akan kembali ke Home/MainPageView
      void onPressedAction() {
        navigateToRoot();
      }

      if (isHome) {
        return IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
            child: Icon(Icons.home_outlined, color: primaryGreen, size: 28),
          ),
          onPressed: onPressedAction,
          tooltip: label,
        );
      }

      return IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressedAction,
        tooltip: label,
        iconSize: 24,
      );
    }

    return Container(
      height: 70,
      decoration: BoxDecoration(color: primaryGreen),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(0, Icons.chat_bubble_outline, 'Notifikasi'),
          navItem(1, Icons.bookmark_border, 'Saved Classes'),
          navItem(2, Icons.home_outlined, 'Home'), // Tombol Home (index 2)
          navItem(3, Icons.person_outline, 'Profile'),
          navItem(4, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data LIVE dari controller
    final myKrsList = _controller.myKrsList;

    // Hitung Total SKS
    int totalSks = 0;
    for (var item in myKrsList) {
      // Asumsi 'sks' adalah int, jika tidak, mungkin perlu konversi atau pengecekan tipe
      if (item['status'] == 'Aktif' && item['sks'] is int) {
        totalSks += (item['sks'] as int);
      }
    }

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // HEADER (Search)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // JUDUL & TOTAL SKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "KRS saya",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Total $totalSks SKS",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // LIST KARTU
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: BoxDecoration(
                  color: cardWhite,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daftar Matakuliah",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: myKrsList.isEmpty
                          ? const Center(child: Text("Belum ada kelas diambil"))
                          : ListView.builder(
                              itemCount: myKrsList.length,
                              itemBuilder: (context, index) {
                                final data = myKrsList[index];
                                return _buildKrsItem(data, index);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // --- PENAMBAHAN BOTTOM NAV BAR DI SINI ---
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildKrsItem(Map<String, dynamic> data, int index) {
    bool isWaiting = data['status'] == "Waiting List";

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info Kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data['time']} / ${data['sks']} sks",
                  style: TextStyle(color: textGrey, fontSize: 13),
                ),
              ],
            ),
          ),

          // Status & Tombol Kanan
          Row(
            children: [
              Text(
                data['status'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isWaiting ? warningYellow : textDark,
                ),
              ),

              // --- FITUR BARU: TOMBOL SAMPAH ---
              if (isWaiting) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _deleteItem(index),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
