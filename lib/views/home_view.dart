// File: views/home_view.dart

import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../controllers/krs_controller.dart';

// --- IMPORT MODEL GRID (PENTING) ---
import '../models/grid_jadwal_model.dart'; 

// --- IMPORT HALAMAN LAIN ---
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
  final KRSController _krsController = KRSController();

  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color cardWhite = const Color(0xFFFFFFFF);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  @override
  void initState() {
    super.initState();
    _krsController.addListener(_refreshData);
    _controller.addListener(_refreshData);
  }

  @override
  void dispose() {
    _krsController.removeListener(_refreshData);
    _controller.removeListener(_refreshData);
    _controller.dispose();
    super.dispose();
  }

  void _refreshData() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  // --- LOGIKA BARU: NAVIGASI KE GRID DENGAN MEMBAWA DATA ---
  void _navigateToGrid() {
    // 1. Ambil data kelas yang statusnya 'terdaftar' dari KRS Controller
    final enrolledKRS = _krsController.getEnrolledClasses();

    // 2. Konversi ke model Course untuk Grid
    List<Course> coursesToSend = [];

    for (var krsItem in enrolledKRS) {
      // Parsing string jadwal: "Senin, 13:00-15:30"
      try {
        final splitComma = krsItem.jadwal.split(','); 
        if (splitComma.length < 2) continue;

        final day = splitComma[0].trim(); // "Senin"
        final timePart = splitComma[1].trim(); // "13:00-15:30"
        
        final splitTime = timePart.split('-');
        final startTime = splitTime[0].trim();
        final endTime = splitTime[1].trim();

        coursesToSend.add(Course(
          id: krsItem.kelasId,
          name: krsItem.namaMataKuliah,
          code: "KODE", // Kode default atau ambil dari master jika ada akses
          sks: krsItem.sks,
          day: day,
          startTime: startTime,
          endTime: endTime,
        ));
      } catch (e) {
        print("Error parsing jadwal di Home: $e");
      }
    }

    // 3. Pindah Halaman & Kirim Data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GridJadwalView(
          incomingCourses: coursesToSend, // KIRIM DATA DISINI
        ),
      ),
    );
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
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    void navigateToRoot() {
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    Widget navItem(int index, IconData icon, String label) {
      bool isHome = index == 2;
      void onPressedAction() {
        if (isHome) {
          navigateToRoot();
        } else if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const NotifikasiView()));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const SavedClassesView()));
        } else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const ProfileView()));
        } else if (index == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsView()));
        }
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
          navItem(2, Icons.home_outlined, 'Home'),
          navItem(3, Icons.person_outline, 'Profile'),
          navItem(4, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    String firstName = _controller.model.studentName.split(' ')[0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Selamat Datang, $firstName!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
        ),
        Text('See more', style: TextStyle(color: textGrey, fontSize: 12)),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileView())).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: primaryGreen,
              child: Text(
                _controller.model.studentName.isNotEmpty ? _controller.model.studentName[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_controller.model.studentName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                  const SizedBox(height: 4),
                  Text('NIM : ${_controller.model.nim}', style: TextStyle(color: textGrey, fontSize: 12)),
                  Text('Program Studi :\n${_controller.model.programStudi}', style: TextStyle(color: textGrey, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Semester', style: TextStyle(color: textGrey, fontSize: 12)),
                Text('${_controller.model.semester}\n${_controller.model.year}', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    ButtonStyle getStyle(Color bgColor) {
      return ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        elevation: bgColor == cardWhite ? 2 : 0,
        shadowColor: bgColor == cardWhite ? Colors.black.withOpacity(0.1) : Colors.transparent,
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
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FormKrsView())).then((_) => _refreshData()),
              style: getStyle(primaryGreen),
              child: const Text('Form KRS', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DaftarKelasView())).then((_) => _refreshData()),
              style: getStyle(primaryGreen),
              child: const Text('Daftar Kelas', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              // UBAH DISINI: Panggil fungsi _navigateToGrid()
              onPressed: _navigateToGrid, 
              style: getStyle(primaryGreen),
              child: const Text('Grid Jadwal', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewKelasView())).then((_) => _refreshData()),
              style: getStyle(primaryGreen),
              child: const Text('Review Kelas', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridJadwalCard(BuildContext context) {
    return GestureDetector(
      // UBAH DISINI: Panggil fungsi _navigateToGrid() saat kartu diklik
      onTap: _navigateToGrid,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grid Jadwal Kelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text('See more', style: TextStyle(color: textGrey, fontSize: 12)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: textGrey),
                  ],
                ),
              ],
            ),
            Text('SKS yang diambil : ${_controller.totalSksTaken}', style: TextStyle(color: textGrey, fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 20, color: textDark),
                const SizedBox(width: 8),
                Text('Jadwal saya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textDark)),
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
    Widget dayHeader(String txt) => Expanded(child: Center(child: Text(txt, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))));
    Widget timeRow(String time) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(children: [SizedBox(width: 40, child: Text(time, style: TextStyle(color: textGrey, fontSize: 11))), Expanded(child: Container(height: 1, color: Colors.grey[400]))]),
      );
    }
    return Column(
      children: [
        Row(children: [const SizedBox(width: 40), dayHeader('Sen'), dayHeader('Sel'), dayHeader('Rab'), dayHeader('Kam'), dayHeader('Jum')]),
        const SizedBox(height: 10),
        timeRow('07:00'), timeRow('08:00'), timeRow('09:00'), timeRow('10:00'), timeRow('11:00'),
      ],
    );
  }

  Widget _buildDaftarKelasCard() {
    final enrolledClasses = _krsController.getEnrolledClasses();
    final queuedClasses = _krsController.getQueuedClasses();
    final allClasses = [...enrolledClasses, ...queuedClasses];

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewKelasView())).then((_) => _refreshData()),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Review Kelas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    if (allClasses.isNotEmpty) Text("${allClasses.length} Kelas", style: TextStyle(fontSize: 12, color: textGrey)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12, color: textGrey),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (allClasses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Belum ada kelas diambil.", style: TextStyle(color: textGrey, fontStyle: FontStyle.italic)),
              )
            else
              Column(
                children: allClasses.map((enrollment) {
                  return _buildReviewItem(enrollment.namaMataKuliah, "${enrollment.jadwal} / ${enrollment.sks} sks", enrollment.status);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String title, String subtitle, String status) {
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: textGrey, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isWaiting ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isWaiting ? warningYellow : primaryGreen)),
          ),
        ],
      ),
    );
  }
}