// lib/controllers/grid_jadwal_controller.dart

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import '../models/krs_model.dart';

class GridJadwalController extends ChangeNotifier {
  List<KelasMataKuliah> _takenCourses = [];
  List<KelasMataKuliah> _availableCourses = [];
  bool _isLoading = false;
  String? _error;

  List<KelasMataKuliah> get takenCourses => _takenCourses;
  List<KelasMataKuliah> get availableCourses => _availableCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Hitung Total SKS
  int get totalSks => _takenCourses.fold(0, (sum, item) => sum + item.sks);

  // Load jadwal dari KRS yang sudah diambil
  Future<void> loadTakenCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.get(ApiConfig.krs);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        final krsList = data
            .map((json) => DaftarKelasMahasiswa.fromJson(json))
            .toList();

        // Filter courses yang benar-benar terdaftar (approved) untuk jadwal
        _takenCourses = krsList
            .where((krs) => krs.status == 'approved')
            .where((krs) => krs.kelasDetail != null)
            .map((krs) => krs.kelasDetail!)
            // Sesuai permintaan: kelas penuh tidak ditampilkan
            .where((course) => !course.isFull)
            .toList();

        // Pastikan available tidak mengandung course yang sudah taken.
        _availableCourses.removeWhere(
          (course) => _takenCourses.any((taken) => taken.id == course.id),
        );
      }
    } catch (e) {
      _error = e.toString();
      _takenCourses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load available courses
  Future<void> loadAvailableCourses({
    String? prodi,
    int? semester,
    String? hari,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String endpoint = '${ApiConfig.jadwal}?format=kelas';
      if (prodi != null) endpoint += '&prodi=$prodi';
      if (semester != null) endpoint += '&semester=$semester';
      if (hari != null) endpoint += '&hari=$hari';

      final response = await ApiService.get(endpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        _availableCourses = data
            .map((json) => KelasMataKuliah.fromJson(json))
            // Sesuai permintaan: kelas penuh tidak ditampilkan
            .where((course) => !course.isFull)
            .toList();

        // Remove courses that are already taken
        _availableCourses.removeWhere(
          (course) => _takenCourses.any((taken) => taken.id == course.id),
        );
      }
    } catch (e) {
      _error = e.toString();
      _availableCourses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set available courses (dari daftar kelas view)
  void setAvailableCourses(List<KelasMataKuliah> courses) {
    // Sesuai permintaan: kelas penuh tidak ditampilkan
    _availableCourses = courses.where((c) => !c.isFull).toList();
    // Remove courses that are already taken
    _availableCourses.removeWhere(
      (course) => _takenCourses.any((taken) => taken.id == course.id),
    );
    notifyListeners();
  }

  // Set taken courses (dari Home/Review -> Grid)
  void setTakenCourses(List<KelasMataKuliah> courses) {
    // Sesuai permintaan: kelas penuh tidak ditampilkan
    _takenCourses = courses.where((c) => !c.isFull).toList();
    // Pastikan available tidak berisi course yang sudah taken
    _availableCourses.removeWhere(
      (course) => _takenCourses.any((taken) => taken.id == course.id),
    );
    notifyListeners();
  }

  // Method Tambah (Dari Tersedia -> Grid)
  void addCourse(KelasMataKuliah course) {
    // Sesuai permintaan: kelas penuh tidak bisa ditampilkan/diambil
    if (course.isFull) return;
    if (!_takenCourses.any((c) => c.id == course.id)) {
      _availableCourses.removeWhere((c) => c.id == course.id);
      _takenCourses.add(course);
      notifyListeners();
    }
  }

  // Method Hapus (Dari Grid -> Tersedia)
  void removeCourse(KelasMataKuliah course) {
    _takenCourses.removeWhere((c) => c.id == course.id);
    // Jangan masukkan kembali ke available kalau kelas sudah penuh
    if (!course.isFull && !_availableCourses.any((c) => c.id == course.id)) {
      _availableCourses.add(course);
    }
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh({String? prodi, int? semester}) async {
    await loadTakenCourses();
    await loadAvailableCourses(prodi: prodi, semester: semester);
  }
}
