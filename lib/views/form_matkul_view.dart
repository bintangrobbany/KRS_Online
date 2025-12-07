import 'package:flutter/material.dart';
import '../../models/matkul_model.dart';

class FormMatkulView extends StatefulWidget {
  final MataKuliah?
  matkulEdit; // Jika null = Mode Tambah, Jika ada isi = Mode Edit

  const FormMatkulView({super.key, this.matkulEdit});

  @override
  State<FormMatkulView> createState() => _FormMatkulViewState();
}

class _FormMatkulViewState extends State<FormMatkulView> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _sksController = TextEditingController();
  final _jadwalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Jika mode edit, isi form dengan data lama
    if (widget.matkulEdit != null) {
      _kodeController.text = widget.matkulEdit!.kode;
      _namaController.text = widget.matkulEdit!.nama;
      _sksController.text = widget.matkulEdit!.sks.toString();
      _jadwalController.text = widget.matkulEdit!.jadwal;
    }
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      // Bungkus data ke Model
      MataKuliah newData = MataKuliah(
        kode: _kodeController.text,
        nama: _namaController.text,
        sks: int.tryParse(_sksController.text) ?? 0,
        jadwal: _jadwalController.text,
      );

      // Kirim balik ke Dashboard
      Navigator.pop(context, newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.matkulEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Mata Kuliah" : "Tambah Mata Kuliah"),
        backgroundColor: const Color(0xFF006A4E),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildInput(
              controller: _kodeController,
              label: "Kode Mata Kuliah",
              hint: "Contoh: TI-001",
              icon: Icons.code,
            ),
            const SizedBox(height: 16),
            _buildInput(
              controller: _namaController,
              label: "Nama Mata Kuliah",
              hint: "Contoh: Pemrograman Mobile",
              icon: Icons.book,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    controller: _sksController,
                    label: "SKS",
                    hint: "2/3/4",
                    icon: Icons.numbers,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInput(
                    controller: _jadwalController,
                    label: "Jadwal",
                    hint: "Senin, 08:00",
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006A4E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isEdit ? "PERBARUI DATA" : "SIMPAN DATA",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF006A4E)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
