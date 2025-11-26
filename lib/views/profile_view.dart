// lib/views/profile_view.dart

import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'settings_view.dart';
import 'logout_view.dart';
import 'edit_profile_view.dart';
import 'personal_information_view.dart';
import 'saved_classes_view.dart'; // <-- 1. IMPORT FILE BARU

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final HomeController _controller = HomeController();

  // --- PALET WARNA ---
  final Color bgCanvas = const Color(0xFFE8DFCD);
  final Color primaryGreen = const Color(0xFF054F40);
  final Color textWhite = const Color(0xFFFFFFFF);
  final Color textDark = const Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isProfileComplete = _controller.model.isProfileComplete;

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Hello, ${_controller.model.studentName.split(' ')[0]}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileImage(_controller.model.profileImageUrl),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileView(),
                  ),
                );

                if (result != null && result is Map<String, String>) {
                  _controller.updateProfile(
                    phone: result['phone'],
                    email: result['email'],
                    social: result['social'],
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryGreen,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: Text(
                isProfileComplete ? "Edit Profile" : "Atur Profile",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _buildStatsRow(),
            const SizedBox(height: 30),

            // MENU OPTIONS
            _buildMenuOption(
              Icons.person_outline,
              "Personal Information",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalInformationView(),
                  ),
                );
              },
            ),
            _buildMenuOption(
              Icons.settings_outlined,
              "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
                );
              },
            ),

            // --- 2. UPDATE BAGIAN SAVES DISINI ---
            _buildMenuOption(
              Icons.bookmark_border,
              "Saves",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedClassesView(),
                  ),
                );
              },
            ),

            // -------------------------------------
            _buildMenuOption(
              Icons.logout,
              "Logout",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogoutView()),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS (Tetap Sama) ---

  Widget _buildProfileImage(String imageUrl) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(Icons.camera_alt_outlined, color: primaryGreen, size: 20),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard("45", "Sisa SKS"),
        const SizedBox(width: 12),
        _buildStatCard("200", "Total SKS"),
        const SizedBox(width: 12),
        _buildStatCard("216", "Total Mata\nKuliah"),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: textWhite.withOpacity(0.9),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: primaryGreen, size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textDark,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ), // Tambahan panah kecil agar lebih manis
      ),
    );
  }
}
