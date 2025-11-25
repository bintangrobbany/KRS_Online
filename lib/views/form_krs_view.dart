import 'package:flutter/material.dart';

class FormKrsView extends StatefulWidget {
  const FormKrsView({super.key});

  @override
  State<FormKrsView> createState() => _FormKrsViewState();
}

class _FormKrsViewState extends State<FormKrsView> {
  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);

  // UBAH JADI PUTIH BERSIH
  final Color cardBg = const Color(0xFFFFFFFF);

  final Color textDark = const Color(0xFF1A1A1A);

  // --- CONTROLLER INPUT ---
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _ketController = TextEditingController();

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _kelasController.dispose();
    _sksController.dispose();
    _ketController.dispose();
    super.dispose();
  }

  // --- LOGIKA SIMPAN ---
  Future<void> _handleSimpan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                "Data Berhasil Disimpan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pop(context); // Tutup Dialog
      Navigator.pop(context); // Kembali ke Home
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
          icon: Icon(Icons.arrow_back_ios_new, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Form KRS",
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg, // SEKARANG SUDAH PUTIH BERSIH
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Kelas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 24),

              // --- INPUT FIELDS ---
              _buildLabeledInput("Kode MK", _kodeController),
              _buildLabeledInput("Nama MK", _namaController),
              _buildLabeledInput("Kelas", _kelasController),
              _buildLabeledInput("SKS", _sksController, isNumber: true),
              _buildLabeledInput("Keterangan", _ketController),

              const SizedBox(height: 10),

              // --- TOMBOL SIMPAN ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSimpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER INPUT ---
  Widget _buildLabeledInput(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textDark.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white, // Input field juga putih
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              // Border Abu-abu tipis saat tidak diklik
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              // Border Hijau saat diklik
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryGreen, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
