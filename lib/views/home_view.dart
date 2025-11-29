// File: views/home_view.dart

import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
// import '../models/home_model.dart';

// --- IMPORT HALAMAN LAIN (Path relatif tetap sama, karena masih di folder views/) ---
import 'daftar_kelas_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';
import 'form_krs_view.dart';
import 'review_kelas_view.dart';
import 'grid_jadwal_view.dart';
import 'saved_classes_view.dart';
import 'notifikasi_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();

  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color cardWhite = const Color(0xFFFFFFFF);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  // Fungsi refresh saat kembali ke home
  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildProfileCard(context),
              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 24),
              _buildGridJadwalCard(context),
              const SizedBox(height: 24),
              _buildDaftarKelasCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // bottomNavigationBar dihapus dari sini!
    );
  }

  // --- SEMUA WIDGET BUILDERS LAINNYA TETAP SAMA ---
  Widget _buildTopHeader() {
    // ... (Isi widget)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Selamat Datang, ${_controller.model.studentName.split(' ')[0]}!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        Text('See more', style: TextStyle(color: textGrey, fontSize: 12)),
      ],
    );
  }

  // ... (Widget _buildProfileCard, _buildActionButtons, dll. dihilangkan untuk ringkasan)

  // CATATAN: HAPUS FUNGSI _buildBottomNavBar() SELURUHNYA DARI FILE INI
  // Widget _buildBottomNavBar(BuildContext context) { ... } <- HAPUS INI

  // ... (Lanjutkan dengan semua widget builders lainnya seperti _buildProfileCard, _buildActionButtons, dll.)
  // (Pastikan semua widget builders yang tersisa ada di dalam file)

  Widget _buildProfileCard(BuildContext context) {
    // ... isi _buildProfileCard
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileView()),
        ).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(_controller.model.profileImageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.model.studentName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM : ${_controller.model.nim}',
                    style: TextStyle(color: textGrey, fontSize: 12),
                  ),
                  Text(
                    'Program Studi :\n${_controller.model.programStudi}',
                    style: TextStyle(color: textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Semester',
                  style: TextStyle(color: textGrey, fontSize: 12),
                ),
                Text(
                  '${_controller.model.semester}\n${_controller.model.year}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... (Semua widget builders lainnya)
  Widget _buildActionButtons(BuildContext context) {
    // ... isi _buildActionButtons
    ButtonStyle getStyle(Color bgColor) {
      return ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: bgColor == cardWhite ? 2 : 0,
        shadowColor: bgColor == cardWhite
            ? Colors.black.withOpacity(0.1)
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormKrsView()),
                ).then((_) => _refreshData());
              },
              style: getStyle(primaryGreen),
              child: const Text(
                'Form KRS',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DaftarKelasView(),
                  ),
                ).then((_) => _refreshData());
              },
              style: getStyle(primaryGreen),
              child: const Text(
                'Daftar Kelas',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GridJadwalView(),
                  ),
                );
              },
              style: getStyle(primaryGreen),
              child: const Text(
                'Grid Jadwal',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewKelasView(),
                  ),
                ).then((_) => _refreshData());
              },
              style: getStyle(primaryGreen),
              child: const Text(
                'Review Kelas',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridJadwalCard(BuildContext context) {
    // ... isi _buildGridJadwalCard
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GridJadwalView()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Grid Jadwal Kelas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      'See more',
                      style: TextStyle(color: textGrey, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: textGrey),
                  ],
                ),
              ],
            ),
            Text(
              'SKS yang diambil :',
              style: TextStyle(color: textGrey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 20, color: textDark),
                const SizedBox(width: 8),
                Text(
                  'Jadwal saya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimelineGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineGrid() {
    // ... isi _buildTimelineGrid
    Widget dayHeader(String txt) => Expanded(
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
    Widget timeRow(String time) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                time,
                style: TextStyle(color: textGrey, fontSize: 11),
              ),
            ),
            Expanded(child: Container(height: 1, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            dayHeader('Sen'),
            dayHeader('Sel'),
            dayHeader('Rab'),
            dayHeader('Kam'),
            dayHeader('Jum'),
          ],
        ),
        const SizedBox(height: 10),
        timeRow('07:00'),
        timeRow('08:00'),
        timeRow('09:00'),
        timeRow('10:00'),
        timeRow('11:00'),
      ],
    );
  }

  Widget _buildDaftarKelasCard() {
    // ... isi _buildDaftarKelasCard
    final myClasses = _controller.myKrsList;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReviewKelasView()),
        ).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Review Kelas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (myClasses.isNotEmpty)
                      Text(
                        "${myClasses.length} Kelas",
                        style: TextStyle(fontSize: 12, color: textGrey),
                      ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: textGrey),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (myClasses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Belum ada kelas diambil.",
                  style: TextStyle(
                    color: textGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children: myClasses.map((data) {
                  return _buildReviewItem(
                    data['name'],
                    "${data['time']} / ${data['sks']} sks",
                    data['status'],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String title, String subtitle, String status) {
    // ... isi _buildReviewItem
    bool isWaiting = status == "Waiting List";
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: textGrey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isWaiting
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isWaiting ? warningYellow : primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
