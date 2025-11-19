// lib/models/home_model.dart

// Enum untuk Status Mata Kuliah agar lebih aman dari salah ketik
enum CourseStatus { pending, approved, rejected }

// Model untuk merepresentasikan satu mata kuliah
class Course {
  final String name;
  final String schedule; // contoh: "08.00 - 10.00"
  final String day;      // contoh: "Senin", "Selasa"
  final int sks;
  final CourseStatus status;

  Course({
    required this.name,
    required this.schedule,
    required this.day,
    required this.sks,
    required this.status,
  });
}

// Model utama untuk data di halaman home
class HomeModel {
  // Data Mahasiswa
  final String studentName = "Edra Edogawa";
  final String nim = "2022103703256";
  final String programStudi = "Informatika";
  final String profileImageUrl = "assets/images/profile_picture.jpg";
  final String semester = "Genap";
  final String year = "2025";

  // --- SUMBER DATA UTAMA ---
  // Ini adalah daftar semua mata kuliah yang diambil dalam KRS
  final List<Course> takenCourses = [
    Course(name: 'Pemrograman Berorientasi Objek', schedule: '08.00 - 10.00', day: 'Senin', sks: 3, status: CourseStatus.approved),
    Course(name: 'Struktur Data', schedule: '10.00 - 12.00', day: 'Selasa', sks: 3, status: CourseStatus.pending),
    Course(name: 'Basis Data', schedule: '08.00 - 10.00', day: 'Rabu', sks: 3, status: CourseStatus.approved),
    Course(name: 'Jaringan Komputer', schedule: '13.00 - 15.00', day: 'Kamis', sks: 3, status: CourseStatus.rejected),
  ];
}