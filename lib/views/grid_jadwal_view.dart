// lib/views/grid_jadwal_view.dart

import 'package:flutter/material.dart';
import '../controllers/grid_jadwal_controller.dart';
import '../models/grid_jadwal_model.dart';

// --- IMPORT UNTUK NAV BAR ---
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';
// ----------------------------

class GridJadwalView extends StatefulWidget {
  const GridJadwalView({super.key});

  @override
  State<GridJadwalView> createState() => _GridJadwalViewState();
}

class _GridJadwalViewState extends State<GridJadwalView> {
  // Inisialisasi Controller
  final GridJadwalController controller = GridJadwalController();
  int _selectedIndex = 2;

  // Palet Warna
  final Color cardBg = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color bgColor = const Color(0xFFE8DFCD);
  final Color cardColor = const Color.fromARGB(255, 255, 255, 255);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);

  // Warna blok mata kuliah
  final Color blockColor1 = const Color(0xFFC7B1A1);
  final Color blockColor2 = const Color(0xFFEDD2AE);

  // Konstanta layout
  static const double _hourHeight = 60.0;
  static const double _timeLabelWidth = 40.0;
  static const double _dayColumnWidth = 70.0;
  static const int _startGridHour = 7;
  static const int _endGridHour = 18;
  static const int _numDays = 5;

  // --- LOGIKA BOTTOM NAV BAR ---
  void _onNavItemSelected(int index, Widget destinationView) {
    if (index == 2) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationView),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavBar(BuildContext context) {
    Widget navItem(
      int index,
      IconData icon,
      String label,
      Widget destinationView,
    ) {
      bool isHome = index == 2;
      void onPressedAction() => _onNavItemSelected(index, destinationView);

      if (isHome) {
        return IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: cardBg, shape: BoxShape.circle),
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

  // --- WIDGET HELPER GRID ---
  int _dayToIndex(String day) {
    switch (day) {
      case 'Senin':
        return 0;
      case 'Selasa':
        return 1;
      case 'Rabu':
        return 2;
      case 'Kamis':
        return 3;
      case 'Jumat':
        return 4;
      default:
        return -1;
    }
  }

  Widget _buildCourseBlock(Course course) {
    final int startHour = int.parse(course.startTime.split(':')[0]);
    final int startMinute = int.parse(course.startTime.split(':')[1]);
    final int endHour = int.parse(course.endTime.split(':')[0]);
    final int endMinute = int.parse(course.endTime.split(':')[1]);

    final double topOffset =
        30.0 +
        (startHour - _startGridHour) * _hourHeight +
        (startMinute / 60.0) * _hourHeight;

    // Tinggi Blok
    final double durationHours =
        (endHour - startHour) + (endMinute - startMinute) / 60.0;
    final double blockHeight = durationHours * _hourHeight;

    //Posisi X (left) berdasarkan index hari
    final int dayIndex = _dayToIndex(course.day);
    if (dayIndex == -1) return Container();

    final double totalHorizontalPadding = 40.0;
    final double gridContentWidth =
        MediaQuery.of(context).size.width -
        totalHorizontalPadding -
        _timeLabelWidth;
    final double dayColumnWidth = gridContentWidth / _numDays;

    final Color courseBlockColor = course.code == 'IF210'
        ? blockColor1
        : blockColor2;

    return Positioned(
      top: topOffset + 10,
      left: dayIndex * _dayColumnWidth,
      width: _dayColumnWidth - 4,
      height: blockHeight - 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: courseBlockColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: textDark.withOpacity(0.1), width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${course.name.substring(0, 4)}..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textDark,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                course.code,
                textAlign: TextAlign.center,
                style: TextStyle(color: textDark, fontSize: 9),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineGrid(Color textGrey) {
    Widget dayHeader(String txt) => Expanded(
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );

    Widget timeRow(String time) {
      return Row(
        children: [
          SizedBox(
            width: _timeLabelWidth,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: TextStyle(color: textGrey, fontSize: 11),
            ),
          ),
          Expanded(child: Container(height: 1, color: Colors.grey[300])),
        ],
      );
    }

    final int numHours = _endGridHour - _startGridHour;
    final List<Widget> timeLines = [];
    for (int i = 0; i < numHours; i++) {
      int hour = _startGridHour + i;
      timeLines.add(
        SizedBox(
          height: _hourHeight,
          child: timeRow('${hour.toString().padLeft(2, '0')}:00'),
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(width: _timeLabelWidth),
                dayHeader('Sen'),
                dayHeader('Sel'),
                dayHeader('Rab'),
                dayHeader('Kam'),
                dayHeader('Jum'),
              ],
            ),
            const SizedBox(height: 10),
            ...timeLines,
          ],
        ),
        ...controller.takenCourses
            .map((course) => _buildCourseBlock(course))
            .toList(),
      ],
    );
  }

  // --- 1. DAFTAR MATA KULIAH YANG DI-AMBIL (DELETE) ---
  Widget _buildTakenCourseList() {
    if (controller.takenCourses.isEmpty) {
      return Center(
        child: Text(
          'Belum ada kelas yang dipilih.',
          style: TextStyle(color: textGrey, fontSize: 14),
        ),
      );
    }

    return Column(
      children: controller.takenCourses.map((course) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course.code} - ${course.sks} SKS',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      controller.removeCourse(course);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- 2. FITUR BARU: DAFTAR MATA KULIAH TERSEDIA (ADD) ---
  Widget _buildAvailableCourseList() {
    // Pastikan controller Anda memiliki list 'availableCourses'
    if (controller.availableCourses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "- Tidak ada kelas tersedia -",
          style: TextStyle(color: textGrey),
        ),
      );
    }

    return Column(
      children: controller.availableCourses.map((course) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: cardColor, // Menggunakan style putih agar konsisten
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${course.code} - ${course.sks} SKS',
                        style: TextStyle(color: textGrey, fontSize: 14),
                      ),
                      // Menampilkan info waktu di list tersedia agar user tahu jadwalnya
                      Text(
                        '${course.day}, ${course.startTime} - ${course.endTime}',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  // Icon Tambah (Plus) berwarna hijau
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: primaryGreen,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      // Pastikan method addCourse ada di controller
                      controller.addCourse(course);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KARTU JADWAL ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Rencana Studi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKS yang diambil : ${controller.totalSks}',
                    style: TextStyle(color: textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 22,
                        color: textDark,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Jadwal saya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineGrid(textGrey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SECTION 1: KELAS YANG DIAMBIL ---
            Text(
              'Kelas Yang diambil (${controller.takenCourses.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildTakenCourseList(),

            const SizedBox(height: 24),

            // --- SECTION 2: KELAS YANG TERSEDIA (FITUR TAMBAHAN) ---
            Text(
              'Kelas yang Tersedia (${controller.availableCourses.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),
            _buildAvailableCourseList(), // Widget baru ditambahkan di sini

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}
