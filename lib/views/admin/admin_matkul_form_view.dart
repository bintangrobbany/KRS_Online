import 'package:flutter/material.dart';
import '../../models/matkul_model.dart';
import '../../services/api_service.dart';

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
  late TextEditingController _semesterController;
  late TextEditingController _prodiController;
  late TextEditingController _descriptionController;

  bool _isSubmitting = false;

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
    _semesterController = TextEditingController(
      text: widget.matkulEdit?.semester?.toString() ?? '',
    );
    _prodiController = TextEditingController(
      text: widget.matkulEdit?.prodi ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.matkulEdit?.description ?? '',
    );
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _sksController.dispose();
    _semesterController.dispose();
    _prodiController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveMatkul() async {
    if (_kodeController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _sksController.text.isEmpty ||
        _semesterController.text.isEmpty ||
        _prodiController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
    }

    final sks = int.tryParse(_sksController.text);
    if (sks == null || sks < 1 || sks > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SKS harus berupa angka 1-6")),
      );
      return;
    }

    final semester = int.tryParse(_semesterController.text);
    if (semester == null || semester < 1 || semester > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semester harus berupa angka 1-8")),
      );
      return;
    }

    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = MataKuliah(
        id: widget.matkulEdit?.id,
        kode: _kodeController.text.trim(),
        nama: _namaController.text.trim(),
        sks: sks,
        semester: semester,
        prodi: _prodiController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      ).toJson();

      // Backend akan generate id saat create
      if (widget.matkulEdit == null) {
        payload.remove('id');
      }

      final dynamic response;
      if (widget.matkulEdit == null) {
        response = await ApiService.post(
          '/mata-kuliah',
          payload,
          requiresAuth: true,
        );
      } else {
        if (widget.matkulEdit?.id == null) {
          throw ApiException('Mata kuliah ID tidak ditemukan untuk update');
        }
        response = await ApiService.put(
          '/mata-kuliah/${widget.matkulEdit!.id}',
          payload,
          requiresAuth: true,
        );
      }

      if (response is Map && response['success'] == true) {
        final mk = MataKuliah.fromJson(
          (response['data'] ?? {}) as Map<String, dynamic>,
        );
        if (mounted) {
          Navigator.pop(context, mk);
        }
      } else {
        final message = (response is Map)
            ? (response['error'] ??
                  response['message'] ??
                  'Gagal menyimpan mata kuliah')
            : 'Gagal menyimpan mata kuliah';
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.toString())));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
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
                      hintText: "1-6",
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
                    controller: _semesterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Semester",
                      hintText: "1-8",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.school),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Prodi
            TextField(
              controller: _prodiController,
              decoration: InputDecoration(
                labelText: "Prodi",
                hintText: "Contoh: Teknik Informatika",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.account_balance),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi (opsional)
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Deskripsi (opsional)",
                hintText: "Tambahkan deskripsi singkat mata kuliah",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _isSubmitting ? null : _saveMatkul,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
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
