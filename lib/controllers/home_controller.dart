// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../models/home_model.dart';

class HomeController extends ChangeNotifier {
  // --- SINGLETON PATTERN ---
  static final HomeController _instance = HomeController._internal();
  factory HomeController() => _instance;

  HomeController._internal() {
    _model = HomeModel(
      studentName: "Edra Edogawa",
      nim: "2022103703256",
      programStudi: "Informatika",
      semester: "Genap",
      year: "2025",
      profileImageUrl: "https://i.pravatar.cc/300",
      email: "edra.edogawa@email.com",
      phoneNumber: "", // Awalnya kosong
      socialMedia: "", // Awalnya kosong
    );
  }

  // --- DATA PROFILE ---
  late final HomeModel _model;
  HomeModel get model => _model;

  // --- DATA KRS SAYA (SHARED DATA) ---
  List<Map<String, dynamic>> myKrsList = [
    {
      "name": "Pemrograman Web",
      "time": "13.00 - 15.30",
      "sks": 3,
      "status": "Aktif",
      "day": "Senin",
    },
    {
      "name": "Logika Komputasi",
      "time": "08.40 - 09.30",
      "sks": 2,
      "status": "Aktif",
      "day": "Selasa",
    },
    {
      "name": "Kalkulus Lanjut",
      "time": "08.00 - 18.00",
      "sks": 3,
      "status": "Aktif",
      "day": "Rabu",
    },
  ];

  List<Map<String, dynamic>> get approvedCoursesForSchedule {
    return myKrsList.where((course) => course['status'] == 'Aktif').toList();
  }

  int get totalSksTaken {
    if (myKrsList.isEmpty) return 0;
    return myKrsList.fold(0, (sum, course) => sum + (course['sks'] as int));
  }

  // --- FUNGSI MANIPULASI DATA ---
  void addWaitingList(String name, String schedule, int sks, String day) {
    myKrsList.add({
      "name": name,
      "time": schedule,
      "sks": sks,
      "status": "Waiting List",
      "day": day,
    });
    notifyListeners();
  }

  void removeKrsItem(int index) {
    myKrsList.removeAt(index);
    notifyListeners();
  }

  void updateProfile({String? phone, String? email, String? social}) {
    if (phone != null) _model.phoneNumber = phone;
    if (email != null) _model.email = email;
    if (social != null) _model.socialMedia = social;

    // Memberi tahu semua 'listener' (seperti ProfileView) bahwa data telah berubah.
    notifyListeners();
  }

  // --- NAVIGASI ---
  void onFormKrsTapped() {}
  void onGridJadwalTapped() {}
}
