// lib/views/home_view.dart

import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart'; // Import model untuk mengakses Enum dan Class Course

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController _controller = HomeController();

  // Definisikan palet warna agar konsisten
  final Color backgroundColor = const Color(0xFFFAEFE3);
  final Color cardColor = const Color(0xFFF0EBE3);
  final Color primaryColor = const Color(0xFF006A4E);
  final Color accentColor = const Color(0xFFE4E6E5);
  final Color textColor = const Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildSectionHeader("Grid Jadwal Kelas"),
              const SizedBox(height: 10),
              _buildScheduleCard(),
              const SizedBox(height: 20),
              _buildSectionHeader("Review Kelas"),
              const SizedBox(height: 10),
              _buildReviewListCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- WIDGET BUILDER HELPER ---

  /// Membangun teks sapaan "Selamat Datang, [Nama]!"
  Widget _buildHeader() {
    return Text(
      'Selamat Datang, ${_controller.model.studentName.split(' ')[0]}!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  /// Membangun kartu yang berisi informasi profil mahasiswa dan semester.
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        // <-- TAMBAHKAN INI untuk shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4), // Posisi shadow (x, y)
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(_controller.model.profileImageUrl),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _controller.model.studentName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM : ${_controller.model.nim}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Program Studi : ${_controller.model.programStudi}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text('Semester'),
              Text(
                _controller.model.semester,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                _controller.model.year,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Membangun tiga tombol aksi: Form KRS, Daftar Kelas, dan Grid Jadwal.
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _controller.onFormKrsTapped,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Form KRS',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _controller.onDaftarKelasTapped,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Daftar Kelas', style: TextStyle(color: textColor)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _controller.onGridJadwalTapped,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Grid Jadwal', style: TextStyle(color: textColor)),
          ),
        ),
      ],
    );
  }

  /// Membangun header untuk setiap seksi (misal: "Grid Jadwal Kelas").
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('See more', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// Membangun kartu jadwal yang menampilkan total SKS dan daftar mata kuliah yang sudah disetujui.
  Widget _buildScheduleCard() {
    final approvedCourses = _controller.approvedCoursesForSchedule;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        // <-- TAMBAHKAN INI untuk shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SKS yang diambil : ${_controller.totalSksTaken} SKS'),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Jadwal saya',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (approvedCourses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: Text("Belum ada jadwal yang disetujui.")),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: approvedCourses
                  .map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "- ${course.name} (${course.day}, ${course.schedule})",
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  /// Membangun kartu yang berisi daftar semua mata kuliah yang diambil beserta statusnya.
  Widget _buildReviewListCard() {
    final courses = _controller.coursesForReview;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        // <-- TAMBAHKAN INI untuk shadow
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: courses
            .map((course) => _buildCourseReviewItem(course))
            .toList(),
      ),
    );
  }

  /// Membangun satu baris item mata kuliah untuk daftar "Review Kelas".
  Widget _buildCourseReviewItem(Course course) {
    String statusText;
    Color statusColor;
    switch (course.status) {
      case CourseStatus.approved:
        statusText = 'Approved';
        statusColor = Colors.green;
        break;
      case CourseStatus.pending:
        statusText = 'Pending';
        statusColor = Colors.orange;
        break;
      case CourseStatus.rejected:
        statusText = 'Rejected';
        statusColor = Colors.red;
        break;
    }

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
                  course.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '${course.schedule} / ${course.sks} sks',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            statusText,
            style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
          ),
        ],
      ),
    );
  }

  /// Membangun Bottom Navigation Bar custom.
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: primaryColor,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {},
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 3),
            ),
            child: Icon(Icons.home_outlined, color: primaryColor, size: 30),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
