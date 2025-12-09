import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/krs_controller.dart';
import '../models/krs_model.dart';
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';

class FormKrsView extends StatefulWidget {
  const FormKrsView({super.key});

  @override
  State<FormKrsView> createState() => _FormKrsViewState();
}

class _FormKrsViewState extends State<FormKrsView> {
  final KRSController _krsController = KRSController();

  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color errorRed = const Color(0xFF8B0000);

  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _dosenController = TextEditingController();
  final TextEditingController _ruanganController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _jadwalController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _dosenController.dispose();
    _ruanganController.dispose();
    _sksController.dispose();
    _jadwalController.dispose();
    super.dispose();
  }

  Future<void> _showFailureDialog(String message) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: errorRed,
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
                child: const Icon(Icons.close, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                "Unsuccessfull",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardBg,
                  foregroundColor: errorRed,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Data gagal tersimpan.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSimpan() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create KelasMataKuliah from form data
        final newClass = KelasMataKuliah(
          kodeMataKuliah: _kodeController.text,
          namaMataKuliah: _namaController.text,
          sks: int.parse(_sksController.text),
          dosen: _dosenController.text,
          ruangan: _ruanganController.text,
          jadwal: _jadwalController.text,
          kapasitas: 0, // Default capacity
          pendaftarSaat: 0,
        );

        // Add to KRS
        await _krsController.enrollClass(newClass, isQueue: false);

        // Show success dialog
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
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "SAVED WITH SUCCESS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sukses: data berhasil tersimpan.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pop(context);
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } catch (e) {
        await _showFailureDialog("Gagal menambah kelas: $e");
      }
    } else {
      if (mounted) {
        await _showFailureDialog("Kolom harus terisi semua.");
      }
    }
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
      body: SafeArea(
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
              child: Text(
                "Tambah Kelas Manual",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormField(
                          label: "Kode Mata Kuliah",
                          controller: _kodeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Kode mata kuliah harus diisi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: "Nama Mata Kuliah",
                          controller: _namaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nama mata kuliah harus diisi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: "Dosen",
                          controller: _dosenController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Dosen harus diisi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: "Ruangan",
                          controller: _ruanganController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ruangan harus diisi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: "SKS",
                          controller: _sksController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "SKS harus diisi";
                            }
                            final sks = int.tryParse(value);
                            if (sks == null || sks < 1 || sks > 4) {
                              return "SKS harus antara 1-4";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildFormField(
                          label: "Jadwal (hari, jam-jam)",
                          controller: _jadwalController,
                          hintText: "Contoh: Senin, 13:00-15:30",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Jadwal harus diisi";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSimpan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Simpan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
