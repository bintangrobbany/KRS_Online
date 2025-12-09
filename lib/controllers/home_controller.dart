// lib/controllers/home_controller.dart

import 'package:flutter/material.dart';
import '../models/home_model.dart';

class HomeController extends ChangeNotifier {
  // --- CONSTRUCTOR ---
  // Kita menggunakan constructor biasa, bukan Singleton.
  // Ini memastikan setiap kali HomeView dibuka, controller baru dibuat
  // dan mencegah error "ChangeNotifier disposed".
  HomeController() {
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
  // Data dummy untuk contoh jadwal yang sudah aktif
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

  // Getter untuk mendapatkan list kelas yang statusnya 'Aktif'
  List<Map<String, dynamic>> get approvedCoursesForSchedule {
    return myKrsList.where((course) => course['status'] == 'Aktif').toList();
  }

  // Getter untuk menghitung total SKS
  int get totalSksTaken {
    if (myKrsList.isEmpty) return 0;
    return myKrsList.fold(0, (sum, course) => sum + (course['sks'] as int));
  }

  // --- LOGIC / ACTIONS ---

  // Menambahkan kelas baru (dipanggil dari form KRS jika diperlukan)
  void addActiveKrs(String name, String schedule, int sks, String day) {
    // Cek apakah kelas sudah ada agar tidak duplikat
    bool exists = myKrsList.any(
      (item) => item['name'] == name && item['status'] == 'Aktif',
    );

    if (!exists) {
      myKrsList.add({
        "name": name,
        "time": schedule,
        "sks": sks,
        "status": "Aktif",
        "day": day,
      });
      notifyListeners(); // Memberi tahu UI untuk update
    }
  }

  // Menambahkan ke waiting list
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

  // Menghapus item KRS berdasarkan index
  void removeKrsItem(int index) {
    if (index >= 0 && index < myKrsList.length) {
      myKrsList.removeAt(index);
      notifyListeners();
    }
  }

  // Update data profil pengguna
  void updateProfile({String? phone, String? email, String? social}) {
    if (phone != null) _model.phoneNumber = phone;
    if (email != null) _model.email = email;
    if (social != null) _model.socialMedia = social;

    notifyListeners();
  }
}