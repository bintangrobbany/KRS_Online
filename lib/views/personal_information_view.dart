// lib/views/personal_information_view.dart
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class PersonalInformationView extends StatefulWidget {
  const PersonalInformationView({super.key});

  @override
  State<PersonalInformationView> createState() =>
      _PersonalInformationViewState();
}

class _PersonalInformationViewState extends State<PersonalInformationView> {
  // Panggil instance Singleton
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    // Daftarkan listener agar halaman ini juga reaktif
    _controller.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onProfileChanged);
    super.dispose();
  }

  // Fungsi refresh UI
  void _onProfileChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan controller yang ada di dalam State
    final model = _controller.model;
    const belumDiaturText = 'Belum diatur';
    final Color textDark = const Color(0xFF1A1A1A);
    final Color bgCanvas = const Color(0xFFE8DFCD);
    final Color primaryGreen = const Color(0xFF054F40);

    Widget infoCard(IconData icon, String label, String value) {
      final bool isNotSet = value.isEmpty;

      return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryGreen, size: 24),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  isNotSet ? belumDiaturText : value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textDark,
                    fontStyle: isNotSet ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        title: Text("Informasi Personal", style: TextStyle(color: textDark)),
        backgroundColor: bgCanvas,
        foregroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            infoCard(
              Icons.badge_outlined,
              'Nama Lengkap',
              model?.studentName ?? '-',
            ),
            infoCard(Icons.numbers_outlined, 'NIM', model?.nim ?? '-'),
            infoCard(
              Icons.school_outlined,
              'Program Studi',
              model?.programStudi ?? '-',
            ),
            infoCard(Icons.email_outlined, 'Email', model?.email ?? '-'),
            infoCard(
              Icons.phone_outlined,
              'Nomor Telepon',
              model?.phoneNumber ?? '-',
            ),
            infoCard(
              Icons.group_outlined,
              'Media Sosial',
              model?.socialMedia ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}
