import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class DaftarKelasView extends StatefulWidget {
  const DaftarKelasView({super.key});

  @override
  State<DaftarKelasView> createState() => _DaftarKelasViewState();
}

class _DaftarKelasViewState extends State<DaftarKelasView> {
  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardContainerBg = const Color(0xFFFFFFFF);
  final Color cardItemBg = const Color(0xFFFFFFFF);
  final Color dropdownBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color alertRed = const Color(0xFFD32F2F);
  final Color warningYellow = const Color(
    0xFFF57F17,
  ); // Warna Kuning untuk tombol Save

  // --- STATE FILTER & SORT ---
  String _selectedSks = "Semua SKS";
  String _selectedSort = "Terbaru";

  // --- DATA MASTER ---
  // (Updated: Menambahkan properti 'isSaved')
  final List<Map<String, dynamic>> _masterClassList = [
    {
      "code": "IF320",
      "sks": 3,
      "name": "Pemrograman Web",
      "schedule": "13:00-15:30",
      "day": "Senin",
      "slot": 0,
      "queueCount": 12,
      "isJoined": false,
      "isSaved": false, // Status simpan
    },
    {
      "code": "IF402",
      "sks": 4,
      "name": "Algoritma & Struktur Data",
      "schedule": "07:00-10:20",
      "day": "Selasa",
      "slot": 15,
      "queueCount": 0,
      "isJoined": false,
      "isSaved": false,
    },
    {
      "code": "IF410",
      "sks": 4,
      "name": "Kalkulus Lanjut",
      "schedule": "07:00-10:20",
      "day": "Senin",
      "slot": 0,
      "queueCount": 0,
      "isJoined": false,
      "isSaved": false,
    },
    {
      "code": "IF350",
      "sks": 3,
      "name": "Jaringan Komputer",
      "schedule": "13:00-15:30",
      "day": "Rabu",
      "slot": 0,
      "queueCount": 5,
      "isJoined": false,
      "isSaved": false,
    },
  ];

  List<Map<String, dynamic>> _displayClassList = [];

  @override
  void initState() {
    super.initState();
    _filterAndSortClasses();
  }

  void _filterAndSortClasses() {
    List<Map<String, dynamic>> temp = List.from(_masterClassList);

    if (_selectedSks != "Semua SKS") {
      int targetSks = int.parse(_selectedSks.split(' ')[0]);
      temp = temp.where((item) => item['sks'] == targetSks).toList();
    }

    if (_selectedSort == "Nama A-Z") {
      temp.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_selectedSort == "Slot Terbanyak") {
      temp.sort((a, b) => b['slot'].compareTo(a['slot']));
    }

    setState(() {
      _displayClassList = temp;
    });
  }

  // --- LOGIC: JOIN QUEUE ---
  void _joinQueue(Map<String, dynamic> classData) {
    setState(() {
      classData['isJoined'] = true;
      classData['queueCount'] = classData['queueCount'] + 1;
    });

    final controller = HomeController();
    controller.addWaitingList(
      classData['name'],
      classData['schedule'],
      classData['sks'],
      classData['day'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil masuk antrean untuk ${classData['name']}"),
        backgroundColor: warningYellow,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --- LOGIC: TOGGLE SAVE/BOOKMARK (BARU) ---
  void _toggleSave(Map<String, dynamic> classData) {
    setState(() {
      classData['isSaved'] = !classData['isSaved'];
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          classData['isSaved']
              ? "${classData['name']} disimpan!"
              : "${classData['name']} dihapus dari simpanan.",
        ),
        backgroundColor: classData['isSaved'] ? warningYellow : Colors.grey,
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 24),
            // --- SEARCH BAR ---
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
            // --- FILTER SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daftar Kelas Tersedia",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildFunctionalDropdown(
                        value: _selectedSks,
                        items: ["Semua SKS", "3 SKS", "4 SKS"],
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
                        items: ["Terbaru", "Nama A-Z", "Slot Terbanyak"],
                        onChanged: (val) {
                          setState(() {
                            _selectedSort = val!;
                          });
                          _filterAndSortClasses();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // --- LIST VIEW ---
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
    );
  }

  // Helper Widget Dropdown
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

  // --- CARD ITEM BUILDER ---
  Widget _buildClassCard(Map<String, dynamic> data) {
    bool isFull = data['slot'] <= 0;
    bool isJoined = data['isJoined'] == true;
    bool isSaved = data['isSaved'] == true; // Cek status saved
    int currentQueue = data['queueCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          // 1. Content Card Utama
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
                  "${data['code']} - ${data['sks']} SKS",
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: textDark,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${data['day']}, ${data['schedule']}",
                  style: TextStyle(color: textGrey, fontSize: 13),
                ),
                // Spacer agar text tidak tertutup tombol di bawah
                const SizedBox(height: 40),
              ],
            ),
          ),

          // 2. Badge Slot (Kanan Atas)
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isFull ? alertRed : primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFull ? "Sisa 0 Slot" : "Sisa ${data['slot']} Slot",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // 3. Action Buttons (Kanan Bawah)
          Positioned(
            right: 12,
            bottom: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- TOMBOL SAVE (KUNING) ---
                GestureDetector(
                  onTap: () => _toggleSave(data),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: warningYellow, // Warna kuning sesuai request
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
                      isSaved ? Icons.bookmark : Icons.bookmark_border_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

                // --- TOMBOL DAFTAR (Jika Kelas Penuh) ---
                if (isFull) ...[
                  const SizedBox(width: 8), // Jarak antar tombol
                  GestureDetector(
                    onTap: isJoined ? null : () => _joinQueue(data),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      height: 36, // Tinggi disamakan dengan tombol save
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isJoined ? Colors.grey : primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (!isJoined)
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isJoined)
                            const Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.hourglass_bottom_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          Text(
                            isJoined
                                ? "Antrean #${data['queueCount']}"
                                : "Daftar Antrean",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
