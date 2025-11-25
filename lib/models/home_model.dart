// lib/models/home_model.dart

// 1. Kita buat Status Matkul (Approved/Pending)
enum CourseStatus { approved, pending, rejected }

// 2. Kita buat kerangka data untuk satu Mata Kuliah
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

// 3. Kita update Model Utama Mahasiswa
class HomeModel {
  final String studentName;
  final String nim;
  final String programStudi;
  final String semester;
  final String year;
  final String profileImageUrl; // Foto Profil
  final List<Course> takenCourses; // Daftar matkul yang diambil

  HomeModel({
    this.studentName = "",
    this.nim = "",
    this.programStudi = "",
    this.semester = "",
    this.year = "",
    this.profileImageUrl = "",
    this.takenCourses = const [], // Defaultnya list kosong biar gak error
  });
}
