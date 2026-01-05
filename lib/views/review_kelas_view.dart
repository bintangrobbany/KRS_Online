import 'package:flutter/material.dart';
import '../controllers/krs_controller.dart';
import '../models/krs_model.dart';
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class ReviewKelasView extends StatefulWidget {
  const ReviewKelasView({super.key});

  @override
  State<ReviewKelasView> createState() => _ReviewKelasViewState();
}

class _ReviewKelasViewState extends State<ReviewKelasView> {
  final KRSController _krsController = KRSController();

  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardWhite = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  @override
  void initState() {
    super.initState();
    _krsController.addListener(_onKrsUpdated);

    // Load KRS saat halaman dibuka agar list selalu sinkron.
    _krsController.loadMyKrs();
  }

  @override
  void dispose() {
    _krsController.removeListener(_onKrsUpdated);
    _krsController.dispose();
    super.dispose();
  }

  void _onKrsUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _deleteEnrollment(String krsId, bool isQueued) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pendaftaran?"),
        content: Text(
          isQueued
              ? "Anda akan menghapus kelas ini dari antrean."
              : "Anda akan menghapus kelas ini dari pendaftaran.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final ok = await _krsController.removeEnrollment(krsId);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? (isQueued
                                ? "Dihapus dari antrean"
                                : "Pendaftaran dibatalkan")
                          : (_krsController.error ??
                                "Gagal menghapus pendaftaran"),
                    ),
                    backgroundColor: ok ? Colors.red : Colors.orange,
                  ),
                );

                // Hindari UI "kosong" karena error state menimpa list.
                if (!ok) {
                  _krsController.clearError();
                } else {
                  // Sync ulang agar list benar-benar sesuai data backend.
                  await _krsController.loadMyKrs();
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- START PERBAIKAN NAV BAR ---
  void _onNavItemSelected(int index, Widget destinationView) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destinationView), // HomeView
      );
    } else {
      // Pindah ke halaman fitur lain
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationView),
      );
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    Widget navItem(int index, IconData icon, String label, Widget dest) {
      bool isHome = index == 2;
      void onPressedAction() {
        _onNavItemSelected(index, dest);
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
          navItem(
            0,
            Icons.chat_bubble_outline,
            'Notifikasi',
            const NotifikasiView(),
          ),
          navItem(
            1,
            Icons.bookmark_border,
            'Saved Classes',
            const SavedClassesView(),
          ),
          navItem(2, Icons.home_outlined, 'Home', const HomeView()),
          navItem(3, Icons.person_outline, 'Profile', const ProfileView()),
          navItem(4, Icons.settings_outlined, 'Settings', const SettingsView()),
        ],
      ),
    );
  }
  // --- END PERBAIKAN NAV BAR ---

  Widget _buildKrsItem(DaftarKelasMahasiswa enrollment, int index) {
    final bool isQueued =
        enrollment.status == 'pending' || enrollment.status == 'antrian';

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollment.namaMataKuliah ?? '-',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${enrollment.jadwal ?? '-'} / ${enrollment.sks ?? 0} sks",
                  style: TextStyle(color: textGrey, fontSize: 13),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                isQueued ? "Antrean" : "Terdaftar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isQueued ? warningYellow : textDark,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _deleteEnrollment(enrollment.id, isQueued),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jangan pakai getEnrolledClasses + getQueuedClasses karena keduanya bisa
    // sama-sama mengandung status 'pending' sehingga item tampil dobel.
    final allKrs = _krsController.myKrsList;
    final enrolledClasses = allKrs
        .where((e) => e.status == 'approved')
        .toList();
    final queuedClasses = allKrs
        .where((e) => e.status == 'pending' || e.status == 'antrian')
        .toList();
    final allEnrollments = [...enrolledClasses, ...queuedClasses];

    // Total SKS hanya dari yang terdaftar (approved). Pending = antrean.
    final totalSks = enrolledClasses.fold<int>(
      0,
      (sum, e) => sum + (e.sks ?? 0),
    );

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
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
                      child: _krsController.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : allEnrollments.isEmpty
                          ? Center(
                              child: Text(
                                _krsController.error ??
                                    "Belum ada kelas diambil",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _krsController.error != null
                                      ? Colors.red
                                      : textDark,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: allEnrollments.length,
                              itemBuilder: (context, index) {
                                final enrollment = allEnrollments[index];
                                return _buildKrsItem(enrollment, index);
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
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}
