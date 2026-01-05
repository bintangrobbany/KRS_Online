import 'package:flutter/material.dart';
import '../controllers/saved_classes_controller.dart';
import '../models/krs_model.dart';

class SavedClassesView extends StatefulWidget {
  const SavedClassesView({super.key});

  @override
  State<SavedClassesView> createState() => _SavedClassesViewState();
}

class _SavedClassesViewState extends State<SavedClassesView> {
  final SavedClassesController _controller = SavedClassesController();

  // --- PALET WARNA (Sama dengan Profile & DaftarKelas) ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardContainerBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF888888);
  final Color warningYellow = const Color(0xFFF57F17);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onUpdate);
    _loadData();
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    await _controller.loadSavedClasses();
  }

  void _removeClassName(KelasMataKuliah kelas) async {
    final success = await _controller.toggleSaveClass(kelas.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${kelas.namaMataKuliah} dihapus dari daftar simpan"),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.savedClasses.isEmpty
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
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: _controller.savedClasses.length,
                itemBuilder: (context, index) {
                  final kelas = _controller.savedClasses[index];
                  return _buildSavedCard(kelas);
                },
              ),
            ),
    );
  }

  Widget _buildSavedCard(KelasMataKuliah kelas) {
    // Slot calculation
    final int available = kelas.kapasitas - kelas.pendaftarSaat;
    final bool isFull = available <= 0;

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
                    "${kelas.kodeMataKuliah} • ${kelas.sks} SKS",
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kelas.namaMataKuliah,
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
                      "${kelas.hari}, ${kelas.jamMulai}-${kelas.jamSelesai}",
                      style: TextStyle(color: textGrey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 14,
                      color: isFull ? Colors.red : textGrey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isFull ? "Kelas Penuh" : "$available Slot Tersedia",
                      style: TextStyle(
                        color: isFull ? Colors.red : textGrey,
                        fontSize: 13,
                        fontWeight: isFull
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
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
                onTap: () => _removeClassName(kelas),
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
