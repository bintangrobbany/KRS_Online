// lib/models/home_model.dart

// 1. Enum untuk Status Mata Kuliah
enum CourseStatus { approved, pending, rejected }

// 2. Class kerangka data untuk satu Mata Kuliah
class Course {
  final String name;
  final int sks;
  final String schedule; // Misal: "08.00 - 10.00"
  final String day; // Misal: "Senin"
  final CourseStatus status;

  Course({
    required this.name,
    required this.sks,
    required this.schedule,
    required this.day,
    required this.status,
  });
}

// 3. Class Model Utama untuk data Mahasiswa
class HomeModel {
  // --- SEMUA 'final' DIHAPUS AGAR NILAI BISA DIUBAH ---
  String studentName;
  String nim;
  String programStudi;
  String semester;
  String year;
  String profileImageUrl;
  String email;
  String phoneNumber;
  String socialMedia;
  List<Course> takenCourses;

  // Constructor untuk model
  HomeModel({
    this.studentName = "",
    this.nim = "",
    this.programStudi = "",
    this.semester = "",
    this.year = "",
    this.profileImageUrl = "",
    this.email = "",
    this.phoneNumber = "",
    this.socialMedia = "",
    this.takenCourses = const [],
  });
  
  /// Penanda apakah profil sudah lengkap.
  /// Logikanya: jika nomor telepon atau sosmed masih kosong, maka belum lengkap.
  bool get isProfileComplete {
    return phoneNumber.isNotEmpty && socialMedia.isNotEmpty;
  }
}