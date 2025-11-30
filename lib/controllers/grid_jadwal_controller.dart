// lib/controllers/grid_jadwal_controller.dart

import '../models/grid_jadwal_model.dart';

class GridJadwalController {
  final GridJadwalModel _model = GridJadwalModel();

  GridJadwalController() {
    // --- DATA DUMMY SESUAI DENGAN SCREENSHOT ---
    _model.takenCourses.addAll([
      Course(
        name: 'Pemrograman Dasar',
        code: 'IF210',
        sks: 4,
        day: 'Senin',
        startTime: '08:00',
        endTime: '09:00', // Dari screenshot, blok sekitar 1 jam
        room: 'Lab-A', // Opsional
      ),
      Course(
        name: 'Kalkulus Lanjut',
        code: 'MA221',
        sks: 3,
        day: 'Rabu',
        startTime: '13:00',
        endTime: '15:00', // Dari screenshot, blok sekitar 2 jam
        room: 'R.C101', // Opsional
      ),
    ]);
    // --- AKHIR DATA DUMMY ---
  }

  List<Course> get takenCourses => _model.takenCourses;

  int get totalSks {
    if (_model.takenCourses.isEmpty) {
      return 0;
    }
    return _model.takenCourses.fold(0, (sum, course) => sum + course.sks);
  }

  // Fungsi untuk menghapus mata kuliah
  void removeCourse(Course course) {
    _model.takenCourses.remove(course);
  }
}
