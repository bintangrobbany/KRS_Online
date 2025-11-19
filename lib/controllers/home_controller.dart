// lib/controllers/home_controller.dart

import '../models/home_model.dart';

class HomeController {
  final HomeModel _model = HomeModel();

  // Getter untuk mengakses seluruh model
  HomeModel get model => _model;

  // --- LOGIKA BISNIS ---

  /// Mengambil semua mata kuliah yang diambil (untuk "Review Kelas")
  List<Course> get coursesForReview {
    return _model.takenCourses;
  }

  /// Mengambil HANYA mata kuliah yang sudah di-approve (untuk "Grid Jadwal")
  List<Course> get approvedCoursesForSchedule {
    return _model.takenCourses.where((course) => course.status == CourseStatus.approved).toList();
  }
  
  /// Menghitung total SKS yang diambil
  int get totalSksTaken {
    // Menjumlahkan SKS dari semua mata kuliah yang diambil (tidak peduli status)
    return _model.takenCourses.fold(0, (sum, course) => sum + course.sks);
  }

  // --- Aksi Tombol ---
  void onFormKrsTapped() {
    print("Tombol Form KRS ditekan");
  }

  void onDaftarKelasTapped() {
    print("Tombol Daftar Kelas ditekan");
  }

  void onGridJadwalTapped() {
    print("Tombol Grid Jadwal ditekan");
  }
}