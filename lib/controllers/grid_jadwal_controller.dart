// lib/controllers/grid_jadwal_controller.dart

import 'package:flutter/material.dart';
import '../models/grid_jadwal_model.dart';

class GridJadwalController {
  final GridJadwalModel _model = GridJadwalModel();

  // Getter untuk data kelas yang diambil
  List get takenCourses => _model.takenCourses;

  // Getter untuk menghitung total SKS
  int get totalSks {
    if (_model.takenCourses.isEmpty) {
      return 0;
    }
    // Menjumlahkan SKS dari semua mata kuliah yang diambil
    return _model.takenCourses.fold(0, (sum, course) => sum + course.sks);
  }
}