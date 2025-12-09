// lib/views/daftar_kelas_view.dart

import 'package:flutter/material.dart';
import '../controllers/krs_controller.dart';
import '../models/krs_model.dart';

// Import Integrasi
import 'grid_jadwal_view.dart';
import '../models/grid_jadwal_model.dart'; 

// Import Nav Bar Items
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class DaftarKelasView extends StatefulWidget {
  const DaftarKelasView({super.key});

  @override
  State<DaftarKelasView> createState() => _DaftarKelasViewState();
}

class _DaftarKelasViewState extends State<DaftarKelasView> {
  final KRSController _krsController = KRSController();

  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardContainerBg = const Color(0xFFFFFFFF);
  final Color cardItemBg = const Color(0xFFFFFFFF);
  final Color dropdownBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color alertRed = const Color(0xFFD32F2F);
  final Color warningYellow = const Color(0xFFF57F17);

  String _selectedSks = "Semua SKS";
  String _selectedSort = "Terbaru";

  // Data Dummy Master
  final List<KelasMataKuliah> _masterClassList = [
    KelasMataKuliah(
      kodeMataKuliah: 'IF320',
      namaMataKuliah: 'Pemrograman Web',
      sks: 3,
      dosen: 'Dr. Budi',
      ruangan: 'R401',
      jadwal: 'Senin, 13:00-15:30',
      kapasitas: 30,
      pendaftarSaat: 30,
    ),
    KelasMataKuliah(
      kodeMataKuliah: 'IF402',
      namaMataKuliah: 'Algoritma & Struktur Data',
      sks: 4,
      dosen: 'Prof. Ahmad',
      ruangan: 'R402',
      jadwal: 'Selasa, 07:00-10:20',
      kapasitas: 40,
      pendaftarSaat: 25,
    ),
    KelasMataKuliah(
      kodeMataKuliah: 'IF410',
      namaMataKuliah: 'Kalkulus Lanjut',
      sks: 4,
      dosen: 'Dr. Siti',
      ruangan: 'R403',
      jadwal: 'Senin, 07:00-10:20',
      kapasitas: 35,
      pendaftarSaat: 30,
    ),
    KelasMataKuliah(
      kodeMataKuliah: 'IF350',
      namaMataKuliah: 'Jaringan Komputer',
      sks: 3,
      dosen: 'Dr. Roni',
      ruangan: 'R404',
      jadwal: 'Rabu, 13:00-15:30',
      kapasitas: 25,
      pendaftarSaat: 25,
    ),
  ];

  List<KelasMataKuliah> _displayClassList = [];

  @override
  void initState() {
    super.initState();
    _krsController.setAvailableClasses(_masterClassList);
    _filterAndSortClasses();
    _krsController.addListener(_onKrsUpdated);
  }

  @override
  void dispose() {
    _krsController.removeListener(_onKrsUpdated);
    super.dispose();
  }

  void _onKrsUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _filterAndSortClasses() {
    List<KelasMataKuliah> temp = List.from(_masterClassList);

    if (_selectedSks != "Semua SKS") {
      int targetSks = int.parse(_selectedSks.split(' ')[0]);
      temp = temp.where((item) => item.sks == targetSks).toList();
    }

    if (_selectedSort == "Nama A-Z") {
      temp.sort((a, b) => a.namaMataKuliah.compareTo(b.namaMataKuliah));
    } else if (_selectedSort == "Slot Terbanyak") {
      temp.sort((a, b) => b.slotsAvailable.compareTo(a.slotsAvailable));
    }

    setState(() {
      _displayClassList = temp;
    });
  }

  void _enrollClass(KelasMataKuliah kelas) async {
    final isQueue = kelas.isFull;

    try {
      final success = await _krsController.enrollClass(kelas, isQueue: isQueue);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isQueue
                  ? "Berhasil masuk antrean untuk ${kelas.namaMataKuliah}"
                  : "Kelas ${kelas.namaMataKuliah} berhasil didaftarkan!",
            ),
            backgroundColor: isQueue ? warningYellow : primaryGreen,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda sudah terdaftar untuk kelas ini"),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- LOGIKA UTAMA: NAVIGASI KE GRID JADWAL ---
  // Fungsi ini mengonversi data KRS ke data Grid
  void _navigateToGrid() {
    // 1. Ambil data KRS yang statusnya 'terdaftar'
    final enrolledKRS = _krsController.getEnrolledClasses();

    if (enrolledKRS.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Pilih minimal satu kelas untuk menyusun jadwal!")),
      );
      return;
    }

    // 2. Konversi ke model Course untuk Grid
    List<Course> coursesToSend = [];

    for (var krsItem in enrolledKRS) {
      // Parsing string jadwal: "Senin, 13:00-15:30"
      try {
        final splitComma = krsItem.jadwal.split(','); 
        if (splitComma.length < 2) continue;

        final day = splitComma[0].trim(); // "Senin"
        final timePart = splitComma[1].trim(); // "13:00-15:30"
        
        final splitTime = timePart.split('-');
        final startTime = splitTime[0].trim();
        final endTime = splitTime[1].trim();

        // Cari kode MK asli dari master list (karena model Enroll mungkin tidak simpan kode)
        String code = "KODE";
        try {
          final master = _masterClassList
              .firstWhere((m) => m.namaMataKuliah == krsItem.namaMataKuliah);
          code = master.kodeMataKuliah;
        } catch (_) {}

        coursesToSend.add(Course(
          id: krsItem.kelasId,
          name: krsItem.namaMataKuliah,
          code: code,
          sks: krsItem.sks,
          day: day,
          startTime: startTime,
          endTime: endTime,
        ));
      } catch (e) {
        print("Error parsing jadwal: $e");
      }
    }

    // 3. Pindah Halaman & Kirim Data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GridJadwalView(
          incomingCourses: coursesToSend,
        ),
      ),
    );
  }

  void _toggleSave(KelasMataKuliah kelas) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${kelas.namaMataKuliah} disimpan!"),
        backgroundColor: warningYellow,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    void navigateToRoot() {
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    Widget navItem(int index, IconData icon, String label) {
      bool isHome = index == 2;
      void onPressedAction() {
        navigateToRoot();
      }

      if (isHome) {
        return IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
            child: Icon(Icons.home_outlined, color: primaryGreen, size: 28),
          ),
          onPressed: onPressedAction,
          tooltip: label,
        );
      }
      return IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressedAction,
        tooltip: label,
        iconSize: 24,
      );
    }

    return Container(
      height: 70,
      decoration: BoxDecoration(color: primaryGreen),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navItem(0, Icons.chat_bubble_outline, 'Notifikasi'),
          navItem(1, Icons.bookmark_border, 'Saved Classes'),
          navItem(2, Icons.home_outlined, 'Home'),
          navItem(3, Icons.person_outline, 'Profile'),
          navItem(4, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      // BUTTON MELAYANG UNTUK KE GRID
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calendar_month),
        label: const Text("Susun Jadwal"),
        onPressed: _navigateToGrid,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildFunctionalDropdown(
                    value: _selectedSks,
                    items: const ["Semua SKS", "3 SKS", "4 SKS"],
                    onChanged: (val) {
                      setState(() {
                        _selectedSks = val!;
                      });
                      _filterAndSortClasses();
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildFunctionalDropdown(
                    value: _selectedSort,
                    items: const ["Terbaru", "Nama A-Z", "Slot Terbanyak"],
                    onChanged: (val) {
                      setState(() {
                        _selectedSort = val!;
                      });
                      _filterAndSortClasses();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                decoration: BoxDecoration(
                  color: cardContainerBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daftar Kelas (${_displayClassList.length})",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _displayClassList.length,
                        itemBuilder: (context, index) {
                          return _buildClassCard(_displayClassList[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildFunctionalDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: dropdownBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: textDark.withOpacity(0.8),
          ),
          style: TextStyle(
            color: textDark.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          onChanged: onChanged,
          items: items
              .map<DropdownMenuItem<String>>(
                (String value) =>
                    DropdownMenuItem<String>(value: value, child: Text(value)),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildClassCard(KelasMataKuliah kelas) {
    final enrolledClasses = _krsController.getEnrolledClasses();
    final queuedClasses = _krsController.getQueuedClasses();

    final isEnrolled = enrolledClasses.any((e) => e.kelasId == kelas.id);
    final isQueued = queuedClasses.any((e) => e.kelasId == kelas.id);
    final isAlreadyEnrolled = isEnrolled || isQueued;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardItemBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${kelas.kodeMataKuliah} - ${kelas.sks} SKS",
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  kelas.namaMataKuliah,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: textDark,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  kelas.jadwal,
                  style: TextStyle(color: textGrey, fontSize: 13),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kelas.isFull ? alertRed : primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Sisa ${kelas.slotsAvailable} Slot",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _toggleSave(kelas),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: warningYellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: warningYellow.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isAlreadyEnrolled ? null : () => _enrollClass(kelas),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isAlreadyEnrolled ? Colors.grey : primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (!isAlreadyEnrolled)
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Text(
                      isEnrolled
                          ? "Terdaftar"
                          : isQueued
                              ? "Dalam Antrean"
                              : kelas.isFull
                                  ? "Daftar Antrean"
                                  : "Daftar",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}