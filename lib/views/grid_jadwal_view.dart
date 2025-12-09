import 'package:flutter/material.dart';
import '../controllers/grid_jadwal_controller.dart';
import '../models/grid_jadwal_model.dart';

// --- IMPORT NAV BAR ---
// Pastikan file-file ini ada di project Anda
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class GridJadwalView extends StatefulWidget {
  // Parameter untuk menerima data dari Daftar Kelas
  final List<Course>? incomingCourses;

  const GridJadwalView({super.key, this.incomingCourses});

  @override
  State<GridJadwalView> createState() => _GridJadwalViewState();
}

class _GridJadwalViewState extends State<GridJadwalView> {
  // Inisialisasi Controller
  final GridJadwalController controller = GridJadwalController();
  // Tidak perlu _selectedIndex karena navigasi Bottom Nav dilakukan via push/pop

  // --- WARNA & STYLE ---
  final Color cardBg = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color bgColor = const Color(0xFFE8DFCD);
  final Color cardColor = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color blockColor1 = const Color(0xFFC7B1A1);
  final Color blockColor2 = const Color(0xFFEDD2AE);

  // --- KONFIGURASI GRID ---
  static const double _hourHeight = 60.0;
  static const double _timeLabelWidth = 40.0;
  static const double _dayColumnWidth = 70.0;
  static const int _startGridHour = 7;
  static const int _endGridHour = 18;

  @override
  void initState() {
    super.initState();
    // LOGIKA UTAMA: Cek apakah ada kiriman data dari Daftar Kelas?
    // Jika ada, masukkan ke availableCourses di controller.
    if (widget.incomingCourses != null && widget.incomingCourses!.isNotEmpty) {
      setState(() {
        controller.availableCourses.addAll(widget.incomingCourses!);
      });
    }
  }

  // --- NAV BAR LOGIC ---
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
      return IconButton(
        padding: isHome ? EdgeInsets.zero : const EdgeInsets.all(8),
        icon: isHome
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.home_outlined, color: primaryGreen, size: 28),
              )
            : Icon(icon, color: Colors.white, size: 24),
        // MEMANGGIL FUNGSI NAVIGASI BARU
        onPressed: () => _onNavItemSelected(index, dest),
        tooltip: label,
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

  // --- HELPER UNTUK GRID ---
  int _dayToIndex(String day) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    return days.indexOf(day);
  }

  Widget _buildCourseBlock(Course course) {
    // Parsing Waktu (Contoh: "07:00")
    final int startHour = int.parse(course.startTime.split(':')[0]);
    final int startMinute = int.parse(course.startTime.split(':')[1]);
    final int endHour = int.parse(course.endTime.split(':')[0]);
    final int endMinute = int.parse(course.endTime.split(':')[1]);

    // Hitung Posisi Y (Top)
    final double topOffset =
        30.0 +
        (startHour - _startGridHour) * _hourHeight +
        (startMinute / 60.0) * _hourHeight;

    // Hitung Tinggi Blok
    final double durationHours =
        (endHour - startHour) + (endMinute - startMinute) / 60.0;
    final double blockHeight = durationHours * _hourHeight;

    // Hitung Posisi X (Left) berdasarkan Hari
    final int dayIndex = _dayToIndex(course.day);
    if (dayIndex == -1) return const SizedBox();

    // Warna selang-seling (Logic sederhana)
    final bool useColor1 = course.id.hashCode % 2 == 0;

    return Positioned(
      top: topOffset + 10,
      left: dayIndex * _dayColumnWidth + _timeLabelWidth,
      width: _dayColumnWidth - 4,
      height: blockHeight - 2,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: useColor1 ? blockColor1 : blockColor2,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: textDark.withOpacity(0.1), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              course.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textDark,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(course.code, style: TextStyle(color: textDark, fontSize: 8)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineGrid() {
    Widget dayHeader(String txt) => Expanded(
      child: Center(
        child: Text(
          txt,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );

    // Membuat baris jam
    List<Widget> timeLines = [];
    for (int i = 0; i < (_endGridHour - _startGridHour); i++) {
      int hour = _startGridHour + i;
      timeLines.add(
        SizedBox(
          height: _hourHeight,
          child: Row(
            children: [
              SizedBox(
                width: _timeLabelWidth,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: textGrey, fontSize: 11),
                ),
              ),
              Expanded(child: Container(height: 1, color: Colors.grey[300])),
            ],
          ),
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
        // Blok jadwal dari takenCourses ditampilkan di sini
        ...controller.takenCourses.map((c) => _buildCourseBlock(c)).toList(),
      ],
    );
  }

  // --- HELPER LIST (TERSEDIA / DIAMBIL) ---
  Widget _buildCourseListSection({
    required String title,
    required List<Course> courses,
    required IconData actionIcon,
    required Color actionColor,
    required Function(Course) onAction,
    String emptyMessage = "Tidak ada data.",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 10),
        if (courses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(color: textGrey, fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          ...courses.map((course) {
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
                          Text(
                            '${course.day}, ${course.startTime} - ${course.endTime}',
                            style: TextStyle(color: primaryGreen, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(actionIcon, color: actionColor, size: 28),
                      onPressed: () => onAction(course),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
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
        title: Text(
          "Rencana Studi",
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // 1. KARTU GRID JADWAL
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grid Jadwal',
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
                          color: primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${controller.totalSks} SKS',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineGrid(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. LIST KELAS DIAMBIL (Muncul di Grid)
            _buildCourseListSection(
              title: "Kelas Yang Diambil",
              courses: controller.takenCourses,
              actionIcon: Icons.delete_outline,
              actionColor: Colors.red,
              emptyMessage: "Belum ada kelas yang diletakkan di grid.",
              onAction: (course) {
                setState(() => controller.removeCourse(course));
              },
            ),

            const SizedBox(height: 24),

            // 3. LIST KELAS TERSEDIA (Dari Daftar Kelas)
            _buildCourseListSection(
              title: "Kelas Yang Tersedia",
              courses: controller.availableCourses,
              actionIcon: Icons.add_circle_outline,
              actionColor: primaryGreen,
              emptyMessage: "Silakan pilih kelas dari menu Daftar Kelas.",
              onAction: (course) {
                setState(() => controller.addCourse(course));
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}
