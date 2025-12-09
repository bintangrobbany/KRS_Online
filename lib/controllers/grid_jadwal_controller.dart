// lib/controllers/grid_jadwal_controller.dart

import '../models/grid_jadwal_model.dart';

class GridJadwalController {
  // 1. List Jadwal (Timeline) -> AWALNYA KOSONG
  List<Course> takenCourses = [];

  // 2. List Pilihan Kelas (Tersedia) -> AWALNYA KOSONG
  // Data akan diisi saat navigasi dari Daftar Kelas
  List<Course> availableCourses = [];

  // Hitung Total SKS
  int get totalSks => takenCourses.fold(0, (sum, item) => sum + item.sks);

  // Method Tambah (Dari Tersedia -> Grid)
  void addCourse(Course course) {
    if (!takenCourses.contains(course)) {
      availableCourses.remove(course);
      takenCourses.add(course);
    }
  }

  // Method Hapus (Dari Grid -> Tersedia)
  void removeCourse(Course course) {
    takenCourses.remove(course);
    availableCourses.add(course);
  }
}   