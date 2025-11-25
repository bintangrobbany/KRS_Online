import 'package:flutter/material.dart';
import '../models/home_model.dart';

class HomeController {
  // --- SINGLETON PATTERN ---
  // Agar datanya tidak hilang saat pindah-pindah halaman
  static final HomeController _instance = HomeController._internal();
  factory HomeController() => _instance;
  HomeController._internal();

  // --- DATA PROFILE ---
  final HomeModel _model = HomeModel(
    studentName: "Edra Edogawa",
    nim: "2022103703256",
    programStudi: "Informatika",
    semester: "Genap",
    year: "2025",
    profileImageUrl: "https://i.pravatar.cc/300",
    takenCourses: [],
  );

  HomeModel get model => _model;

  // --- DATA KRS SAYA (SHARED DATA) ---
  // Ini list yang akan menampung kelas Aktif DAN Waiting List
  List<Map<String, dynamic>> myKrsList = [
    {
      "name": "Pemrograman Web",
      "time": "13.00 - 15.30",
      "sks": 3,
      "status": "Aktif",
    },
    {
      "name": "Logika Komputasi",
      "time": "08.40 - 09.30",
      "sks": 2,
      "status": "Aktif",
    },
    {
      "name": "Kalkulus Lanjut",
      "time": "08.00 - 18.00",
      "sks": 3,
      "status": "Aktif",
    },
    // Nanti Waiting List akan masuk ke sini
  ];

  // Fungsi tambah ke KRS (Dipanggil dari DaftarKelasView)
  void addWaitingList(String name, String schedule, int sks) {
    myKrsList.add({
      "name": name,
      "time": schedule,
      "sks": sks,
      "status": "Waiting List",
    });
  }

  // Fungsi hapus dari KRS (Dipanggil dari ReviewKelasView/Tombol Sampah)
  void removeKrsItem(int index) {
    myKrsList.removeAt(index);
  }

  // --- NAVIGASI ---
  void onFormKrsTapped() {}
  void onGridJadwalTapped() {}
}
