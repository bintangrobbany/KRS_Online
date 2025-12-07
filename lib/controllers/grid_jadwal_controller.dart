// lib/controllers/grid_jadwal_controller.dart

import 'package:flutter/material.dart';
import '../models/grid_jadwal_model.dart';

class CourseModel {
  final String id;
  final String name;
  final String code;
  final int sks;
  final int dayIndex; // 0=Sen, 1=Sel, 2=Rab, 3=Kam, 4=Jum
  final double startHour; // misal 7.0 (jam 7), 10.5 (10:30)
  final double endHour;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.sks,
    required this.dayIndex,
    required this.startHour,
    required this.endHour,
  });

  // Durasi dalam jam (untuk hitung tinggi kotak)
  double get duration => endHour - startHour;
}

class GridJadwalController {
  // List kelas yang SUDAH diambil (My Schedule)
  List<Course> takenCourses = [
    Course(
      id: '1',
      name: 'Pemrograman Mobile',
      code: 'IF210',
      sks: 3,
      day: 'Senin',
      startTime: '07:00',
      endTime: '09:30',
    ),
    Course(
      id: '2',
      name: 'Kalkulus II',
      code: 'MA102',
      sks: 4,
      day: 'Rabu',
      startTime: '10:00',
      endTime: '12:00',
    ),
  ];

  List<Course> availableCourses = [
    Course(
      id: '3',
      name: 'Algoritma Pemrograman',
      code: 'IF100',
      sks: 4,
      day: 'Selasa',
      startTime: '08:00',
      endTime: '11:00',
    ),
    Course(
      id: '4',
      name: 'Jaringan Komputer',
      code: 'IF300',
      sks: 3,
      day: 'Kamis',
      startTime: '13:00',
      endTime: '15:30',
    ),
    Course(
      id: '5',
      name: 'Basis Data',
      code: 'IF220',
      sks: 3,
      day: 'Jumat',
      startTime: '09:00',
      endTime: '11:30',
    ),
  ];

  // Hitung Total SKS
  int get totalSks => takenCourses.fold(0, (sum, item) => sum + item.sks);

  // Method Tambah
  void addCourse(Course course) {
    // Cek apakah sudah ada
    if (!takenCourses.contains(course)) {
      takenCourses.add(course);
      availableCourses.remove(course);
    }
  }

  // Method Hapus
  void removeCourse(Course course) {
    takenCourses.remove(course);
    availableCourses.add(course);
  }
}
