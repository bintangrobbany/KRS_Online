import 'package:flutter/material.dart';

class SavedClassesView extends StatefulWidget {
  const SavedClassesView({super.key});

  @override
  State<SavedClassesView> createState() => _SavedClassesViewState();
}

class _SavedClassesViewState extends State<SavedClassesView> {
  // --- PALET WARNA (Sama dengan Profile & DaftarKelas) ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardContainerBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  // --- DATA DUMMY (Simulasi data yang sudah di-save) ---
  // Dalam aplikasi nyata, data ini diambil dari HomeController atau Database
  List<Map<String, dynamic>> _savedClasses = [
    {
      "code": "IF320",
      "sks": 3,
      "name": "Pemrograman Web",
      "schedule": "13:00-15:30",
      "day": "Senin",
      "slot": 0, // Full
    },
    {
      "code": "IF350",
      "sks": 3,
      "name": "Jaringan Komputer",
      "schedule": "13:00-15:30",
      "day": "Rabu",
      "slot": 5, // Available
    },
  ];

  void _removeClassName(int index) {
    String removedName = _savedClasses[index]['name'];
    setState(() {
      _savedClasses.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$removedName dihapus dari daftar simpan"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mata Kuliah Disimpan",
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _savedClasses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: textGrey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada mata kuliah disimpan",
                    style: TextStyle(color: textGrey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _savedClasses.length,
              itemBuilder: (context, index) {
                final data = _savedClasses[index];
                return _buildSavedCard(data, index);
              },
            ),
    );
  }

  Widget _buildSavedCard(Map<String, dynamic> data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardContainerBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Informasi Kelas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${data['code']} • ${data['sks']} SKS",
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: textDark,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: textGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${data['day']}, ${data['schedule']}",
                      style: TextStyle(color: textGrey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bagian Tombol Hapus (Unsave)
          const SizedBox(width: 12),
          Column(
            children: [
              GestureDetector(
                onTap: () => _removeClassName(index),
                child: Container(
                  height: 40,
                  width: 40,
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
                    Icons.bookmark_remove_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
