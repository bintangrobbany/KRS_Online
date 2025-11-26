// lib/views/edit_profile_view.dart
import 'package:flutter/material.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller untuk mengambil teks dari setiap input field
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final socialMediaController = TextEditingController();

    // Palet warna agar konsisten
    final Color primaryGreen = const Color(0xFF054F40);
    final Color textDark = const Color(0xFF1A1A1A);
    final Color bgCanvas = const Color(0xFFE8DFCD);

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        title: Text("Atur Profil", style: TextStyle(color: textDark)),
        backgroundColor: bgCanvas,
        foregroundColor: primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field untuk Nomor Telepon
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Contoh: 081234567890',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

            // Input field untuk Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Contoh: nama@email.com',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 20),
            
            // Input field untuk Media Sosial
            TextField(
              controller: socialMediaController,
              decoration: const InputDecoration(
                labelText: 'Media Sosial',
                hintText: 'Contoh: @username_ig',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Simpan
            ElevatedButton(
              onPressed: () {
                // Kumpulkan data dari controller ke dalam sebuah Map
                final Map<String, String> updatedData = {
                  'phone': phoneController.text,
                  'email': emailController.text,
                  'social': socialMediaController.text,
                };
                
                // Kirimkan data Map ini kembali ke halaman sebelumnya (ProfileView)
                Navigator.pop(context, updatedData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Simpan Perubahan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}