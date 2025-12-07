// lib/models/grid_jadwal_model.dart

class Course {
  final String id;
  final String name;
  final String code;
  final int sks;
  final String day; // Contoh: "Senin"
  final String startTime; // Contoh: "07:00"
  final String endTime; // Contoh: "09:30"

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.sks,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}
