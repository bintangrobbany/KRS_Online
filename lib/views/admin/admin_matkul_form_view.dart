import 'package:flutter/material.dart';
import '../../models/matkul_model.dart';

class AdminMatkulFormView extends StatefulWidget {
  final MataKuliah? matkulEdit;

  const AdminMatkulFormView({super.key, this.matkulEdit});

  @override
  State<AdminMatkulFormView> createState() => _AdminMatkulFormViewState();
}

class _AdminMatkulFormViewState extends State<AdminMatkulFormView> {
  late TextEditingController _kodeController;
  late TextEditingController _namaController;
  late TextEditingController _sksController;
  late TextEditingController _jadwalController;

  final Color primaryColor = const Color(0xFF006A4E);
  final Color backgroundColor = const Color(0xFFF0EBE3);

  @override
  void initState() {
    super.initState();
    _kodeController = TextEditingController(
      text: widget.matkulEdit?.kode ?? '',
    );
    _namaController = TextEditingController(
      text: widget.matkulEdit?.nama ?? '',
    );
    _sksController = TextEditingController(
      text: widget.matkulEdit?.sks.toString() ?? '',
    );
    _jadwalController = TextEditingController(
      text: widget.matkulEdit?.jadwal ?? '',
    );
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _sksController.dispose();
    _jadwalController.dispose();
    super.dispose();
  }

  void _saveMatkul() {
    if (_kodeController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _sksController.text.isEmpty ||
        _jadwalController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    final sks = int.tryParse(_sksController.text);
    if (sks == null || sks < 1 || sks > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SKS harus berupa angka 1-4")),
      );
      return;
    }

    final newMatkul = MataKuliah(
      kode: _kodeController.text,
      nama: _namaController.text,
      sks: sks,
      jadwal: _jadwalController.text,
    );

    Navigator.pop(context, newMatkul);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.matkulEdit != null ? "Edit Mata Kuliah" : "Tambah Mata Kuliah",
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kode Mata Kuliah
            TextField(
              controller: _kodeController,
              decoration: InputDecoration(
                labelText: "Kode Mata Kuliah",
                hintText: "Contoh: TI001",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.code),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Nama Mata Kuliah
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Mata Kuliah",
                hintText: "Contoh: Algoritma Pemrograman",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.book),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // SKS dan Jadwal
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sksController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "SKS",
                      hintText: "2/3/4",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.numbers),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _jadwalController,
                    decoration: InputDecoration(
                      labelText: "Jadwal",
                      hintText: "Senin, 08:00",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.access_time),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _saveMatkul,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.matkulEdit != null
                    ? "Perbarui Mata Kuliah"
                    : "Tambah Mata Kuliah",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Batal
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Batal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
