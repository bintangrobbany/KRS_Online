import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk TextInputFormatter (keyboardType number)

// --- IMPORT HALAMAN NAV BAR (Diperlukan agar tombol bisa diakses) ---
import 'notifikasi_view.dart';
import 'saved_classes_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'settings_view.dart';
// -------------------------------------------------------------------

class FormKrsView extends StatefulWidget {
  const FormKrsView({super.key});

  @override
  State<FormKrsView> createState() => _FormKrsViewState();
}

class _FormKrsViewState extends State<FormKrsView> {
  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color cardBg = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);
  // Warna tambahan untuk GAGAL
  final Color errorRed = const Color(0xFF8B0000);

  // --- CONTROLLER INPUT ---
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _sksController = TextEditingController();
  final TextEditingController _ketController = TextEditingController();

  // --- 🆕 KEY UNTUK FORM VALIDASI ---
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _kelasController.dispose();
    _sksController.dispose();
    _ketController.dispose();
    super.dispose();
  }

  // --- 🆕 LOGIKA TAMPILKAN DIALOG GAGAL ---
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
            color: errorRed, // Warna Merah untuk Gagal
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
                message, // Pesan error dari parameter
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardBg, // Latar Putih
                  foregroundColor: errorRed, // Teks Merah
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

  // --- 🔄 LOGIKA SIMPAN DENGAN VALIDASI ---
  Future<void> _handleSimpan() async {
    // Cek apakah semua field dalam Form valid
    if (_formKey.currentState!.validate()) {
      // --------------------------------------
      // LOGIKA SUKSES (Data Tervalidasi)
      // --------------------------------------

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
                  onPressed: () {}, // Tidak perlu fungsi, hanya sebagai label
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
        Navigator.pop(context); // Tutup Dialog Sukses

        // Untuk kembali ke MainPageView/HomeView (rute pertama)
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } else {
      // --------------------------------------
      // LOGIKA GAGAL (Ada Field Kosong)
      // --------------------------------------

      // Tampilkan dialog gagal jika validasi tidak lolos
      if (mounted) {
        await _showFailureDialog("Kolom harus terisi semua.");
      }
    }
  }

  // --- LOGIKA BOTTOM NAV BAR (Tidak Berubah) ---
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
            decoration: BoxDecoration(color: cardBg, shape: BoxShape.circle),
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
          navItem(2, Icons.home_outlined, 'Home'), // Tombol Home (index 2)
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
        // 🆕 Membungkus konten formulir dengan widget Form
        child: Form(
          key: _formKey, // Mengaitkan key Form
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
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
                // 🔄 Menggunakan _buildLabeledInput baru (yang berisi TextFormField)
                _buildLabeledInput("Kode MK", _kodeController),
                _buildLabeledInput("Nama MK", _namaController),
                _buildLabeledInput("Kelas", _kelasController),
                _buildLabeledInput("SKS", _sksController, isNumber: true),
                _buildLabeledInput("Keterangan", _ketController),
                const SizedBox(height: 10),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- 🔄 WIDGET HELPER INPUT BARU (TextFormField dengan Validator) ---
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
          // 🆕 Menggunakan TextFormField (bukan TextField)
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            // 🆕 Menambahkan input formatter untuk SKS
            inputFormatters: isNumber
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,

            // 🆕 Validator untuk pengecekan data kosong/null
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Kolom $label wajib diisi.';
              }
              return null; // Input valid
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              // Styling standar
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryGreen, width: 2),
              ),
              // 🆕 Styling untuk Error
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorRed, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorRed, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
