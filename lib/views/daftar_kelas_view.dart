// lib/views/daftar_kelas_view.dart

import 'package:flutter/material.dart';
import '../controllers/krs_controller.dart';
import '../controllers/saved_classes_controller.dart';
import '../models/krs_model.dart';

// Import Integrasi
import 'grid_jadwal_view.dart';

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
  final SavedClassesController _savedController = SavedClassesController();
  final TextEditingController _searchController = TextEditingController();

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

  // Source of truth untuk daftar kelas adalah backend (/jadwal?format=kelas)
  // List ini akan diisi dari KRSController.availableClasses
  List<KelasMataKuliah> _masterClassList = [];

  List<KelasMataKuliah> _displayClassList = [];

  @override
  void initState() {
    super.initState();
    _krsController.addListener(_onKrsUpdated);
    _savedController.addListener(_onSavedUpdated);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _krsController.removeListener(_onKrsUpdated);
    _savedController.removeListener(_onSavedUpdated);
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Load daftar kelas + status KRS user agar tombol "Terdaftar/Dalam Antrean" akurat
    await Future.wait([
      _krsController.loadMyKrs(),
      _krsController.loadAvailableClasses(),
      _savedController.loadSavedClasses(),
    ]);

    if (!mounted) return;
    _syncClassesFromControllerAndReapply();
  }

  void _onSavedUpdated() {
    if (mounted) setState(() {});
  }

  void _onKrsUpdated() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Jika availableClasses berubah, sinkronkan & re-apply filter.
      // Jika hanya myKrsList yang berubah, cukup rebuild agar status tombol berubah.
      final next = _krsController.availableClasses;
      final changed = !_listEqualsById(_masterClassList, next);

      if (changed) {
        _syncClassesFromControllerAndReapply();
      } else {
        setState(() {});
      }
    });
  }

  bool _listEqualsById(List<KelasMataKuliah> a, List<KelasMataKuliah> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  void _syncClassesFromControllerAndReapply() {
    _masterClassList = List<KelasMataKuliah>.from(
      _krsController.availableClasses,
    );
    _filterAndSortClasses();
  }

  void _filterAndSortClasses() {
    List<KelasMataKuliah> temp = List.from(_masterClassList);

    // Filter by search query
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      temp = temp.where((item) {
        final namaMk = item.namaMataKuliah.toLowerCase();
        final kodeMk = item.kodeMataKuliah.toLowerCase();
        final dosen = (item.dosen ?? '').toLowerCase();
        return namaMk.contains(searchQuery) ||
            kodeMk.contains(searchQuery) ||
            dosen.contains(searchQuery);
      }).toList();
    }

    // Filter by SKS
    if (_selectedSks != "Semua SKS") {
      int targetSks = int.parse(_selectedSks.split(' ')[0]);
      temp = temp.where((item) => item.sks == targetSks).toList();
    }

    // Sort
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
    // TODO: Get current semester and tahun ajaran from user or settings
    final currentSemester = kelas.semester?.toString() ?? '7';
    final currentTahunAjaran = '2023/2024';

    try {
      final success = await _krsController.enrollClass(
        kelas.id,
        currentSemester,
        currentTahunAjaran,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                kelas.isFull
                    ? "Berhasil masuk antrean: ${kelas.namaMataKuliah}"
                    : "Kelas ${kelas.namaMataKuliah} berhasil didaftarkan!",
              ),
              backgroundColor: kelas.isFull ? alertRed : primaryGreen,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _krsController.error ?? "Anda sudah terdaftar untuk kelas ini",
            ),
            backgroundColor: Colors.grey,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _toggleSave(KelasMataKuliah kelas) async {
    final isSaved = _savedController.isSaved(kelas.id);

    final success = await _savedController.toggleSaveClass(kelas.id);

    if (success && mounted) {
      // Reload saved classes to update the list
      await _savedController.loadSavedClasses();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSaved
                  ? "Dihapus dari Saved Classes: ${kelas.namaMataKuliah}"
                  : "Disimpan ke Saved Classes: ${kelas.namaMataKuliah}",
            ),
            backgroundColor: isSaved ? Colors.grey : warningYellow,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_savedController.error ?? "Gagal menyimpan kelas"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  // --- LOGIKA UTAMA: NAVIGASI KE GRID JADWAL ---
  void _navigateToGrid() {
    // 1. Ambil data KRS yang statusnya 'approved' (yang benar-benar terdaftar)
    final enrolledKRS = _krsController.myKrsList
        .where((krs) => krs.status == 'approved')
        .toList();

    if (enrolledKRS.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih minimal satu kelas untuk menyusun jadwal!"),
        ),
      );
      return;
    }

    // 2. Extract KelasMataKuliah from enrolled KRS
    List<KelasMataKuliah> coursesToSend = enrolledKRS
        .where((krs) => krs.kelasDetail != null)
        .map((krs) => krs.kelasDetail!)
        .toList();

    // 3. Pindah Halaman & Kirim Data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GridJadwalView(incomingCourses: coursesToSend),
      ),
    );
  }

  // --- LOGIKA NAV BAR: Sudah diperbaiki untuk Routing ---
  void _onNavItemSelected(int index, Widget destinationView) {
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destinationView), // HomeView
      );
    } else {
      // Pindah ke halaman fitur lain
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationView),
      );
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    Widget navItem(int index, IconData icon, String label, Widget dest) {
      bool isHome = index == 2;
      void onPressedAction() {
        _onNavItemSelected(index, dest);
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
          navItem(
            0,
            Icons.chat_bubble_outline,
            'Notifikasi',
            const NotifikasiView(),
          ),
          navItem(
            1,
            Icons.bookmark_border,
            'Saved Classes',
            const SavedClassesView(),
          ),
          navItem(2, Icons.home_outlined, 'Home', const HomeView()),
          navItem(3, Icons.person_outline, 'Profile', const ProfileView()),
          navItem(4, Icons.settings_outlined, 'Settings', const SettingsView()),
        ],
      ),
    );
  }
  // --- END LOGIKA NAV BAR ---

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
    final allKrs = _krsController.myKrsList;
    final enrolledClasses = allKrs
        .where((e) => e.status == 'approved')
        .toList();
    final queuedClasses = allKrs
        .where((e) => e.status == 'pending' || e.status == 'antrian')
        .toList();

    final isEnrolled = enrolledClasses.any((e) => e.kelasId == kelas.id);
    final isQueued = queuedClasses.any((e) => e.kelasId == kelas.id);
    final isAlreadyEnrolled = isEnrolled || isQueued;

    final buttonColor = isEnrolled
        ? Colors.grey
        : (isQueued || kelas.isFull)
        ? alertRed
        : primaryGreen;

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
                kelas.isFull ? "Penuh" : "Sisa ${kelas.slotsAvailable} Slot",
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
                      color: _savedController.isSaved(kelas.id)
                          ? warningYellow
                          : warningYellow.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: warningYellow.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _savedController.isSaved(kelas.id)
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
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
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        // <-- Solusi 3: Perbaikan Typo boxBoxShadow
                        if (!isAlreadyEnrolled)
                          BoxShadow(
                            color: buttonColor.withOpacity(0.4),
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
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _filterAndSortClasses();
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: "Search nama, kode, atau dosen",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
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
                      child: _krsController.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _krsController.error != null
                          ? Center(
                              child: Text(
                                _krsController.error!,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _displayClassList.length,
                              itemBuilder: (context, index) {
                                return _buildClassCard(
                                  _displayClassList[index],
                                );
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
}
