// lib/models/grid_jadwal_model.dart

class Course {
  final String name;
  final String code;
  final int sks;
  final String day; // Contoh: 'Senin', 'Selasa', dll.
  final String startTime; // Format: 'HH:MM'
  final String endTime; // Format: 'HH:MM'
  final String room; // Bisa diabaikan jika tidak ditampilkan di grid

  Course({
    required this.name,
    required this.code,
    required this.sks,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.room = '', // Default kosong jika tidak selalu ada
  });
}

class GridJadwalModel {
  final List<Course> takenCourses = [];
}
